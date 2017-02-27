+++
title = "oraclegeometry"
draft = false
tags = [
    "code",
    "java",
    "oraclegeometry"
]
date = "2013-03-12"
+++
# Oracle Geometries 

## SDO_GEOMETRY Mappen in de DB 

Via Hibernate: met een `UserType` implementatie

```java
    public Object nullSafeGet(ResultSet resultSet, String[] strings, Object o) throws HibernateException, SQLException {
        STRUCT geometry = (STRUCT) resultSet.getObject(strings[0]);

        if (resultSet.wasNull() || geometry ###### null) {
            return null;
        }
        return new Geometry(JGeometry.load(geometry));
    }

    /**
     * setNull(i, Types.OTHER or Types.STRUCT) results in "unknown column type" exceptions!
     */
    public void nullSafeSet(PreparedStatement preparedStatement, Object o, int i) throws HibernateException, SQLException {
        if (o ###### null) {
            preparedStatement.setNull(i, Types.STRUCT, OracleSpatialDialect.MSYS + "." + OracleSpatialDialect.SDO_GEOM_TYPE_COLUMN);
        } else {
            if (o instanceof Geometry) {
                Connection oracleConnection = ((DelegatingConnection) preparedStatement.getConnection()).getInnermostDelegate();
                STRUCT struct = JGeometry.store(((Geometry) o).getInnerGeometry(), oracleConnection);
                preparedStatement.setObject(i, struct);
            }
        }
    }
```

Merk op dat de `store()` method op `JGeometry` effectief een oracle connectie object nodig heeft (harde cast gebeurt in de implementatie). een struct object kan dan omgevormd worden naar `JGeometry` (te downloaden: *sdoapi* jar, Oracle Spatial Java API). Het `Geometry` object is iets dat hierrond gewrapped is. Dit heeft een aantal voordelen:

  1. Afscheiden spatial api dependency rest van de code
  2. Makkelijk converteren van `SDO_GEOMETRY('...') String` waarde naar object en omgekeerd

############= Van String naar Object en omgekeerd ############=

```java
public class Geometry implements Cloneable, Serializable {

	private static final String MDSYS_POINT_TYPE = "MDSYS.SDO_POINT_TYPE";
	private static final String MDSYS_ORDINATE_ARR = "MDSYS.SDO_ORDINATE_ARRAY";
	private static final String MDSYS_ELEMENT_ARR = "MDSYS.SDO_ELEM_INFO_ARRAY";
	private static final String MDSYS_GEOM = "MDSYS.SDO_GEOMETRY";

	final static int SRID = 327680;

	private final JGeometry geometry;

	public Geometry() {
		this.geometry = null;
	}

	public Geometry(String sdoGeometry) throws GeometryConversionException {
		try {
			this.geometry = disassembleSdoGeometry(sdoGeometry);
		} catch (Exception disassemblingEx) {
			throw new GeometryConversionException(disassemblingEx);
		}
	}

	public Geometry(JGeometry jGeometry) {
		this.geometry = jGeometry;
	}

	public JGeometry getInnerGeometry() {
		return geometry;
	}

	@Override
	public String toString() {
		return toSDOGeometryString();
	}

	private JGeometry disassembleSdoGeometry(String sdoGeometry) {
		return new JGeometry(retrieveGeometryType(sdoGeometry), //
				retrieveSRID(sdoGeometry), //
				retrievePointTypeX(sdoGeometry), //
				retrievePointTypeY(sdoGeometry), //
				retrievePointTypeZ(sdoGeometry), //
				retrieveElemInfo(sdoGeometry), //
				retrieveOrdinatesArray(sdoGeometry) //
		);
	}

	private int retrieveGeometryType(String sdoGeometry) {
		String geometryType = StringUtils.substringBetween(sdoGeometry, "(", ",");
		return Integer.parseInt(geometryType.trim());
	}

	private int retrieveSRID(String sdoGeometry) {
		String sridString = StringUtils.substringBetween(sdoGeometry, ",", ",");
		return Integer.parseInt(sridString.trim());
	}

	private double retrievePointTypeX(String sdoGeometry) {
		return retrievePointTypes(sdoGeometry)[0];
	}

	private double retrievePointTypeY(String sdoGeometry) {
		return retrievePointTypes(sdoGeometry)[1];
	}

	private double retrievePointTypeZ(String sdoGeometry) {
		return retrievePointTypes(sdoGeometry)[2];
	}

	private double[] retrievePointTypes(String sdoGeometry) {
		double[] result = new double[3];
		String pointTypesAsString = StringUtils.substringBetween(sdoGeometry, MDSYS_POINT_TYPE + "(", ")");
		if (pointTypesAsString != null) {
			result = toDoubleArray(pointTypesAsString);
		}
		return result;
	}

	private int[] retrieveElemInfo(String sdoGeometry) {
		String elemInfoArray = StringUtils.substringBetween(sdoGeometry, MDSYS_ELEMENT_ARR + "(", ")");
		return toIntArray(elemInfoArray);
	}

	private double[] retrieveOrdinatesArray(String sdoGeometry) {
		String ordinatesArray = StringUtils.substringBetween(sdoGeometry, MDSYS_ORDINATE_ARR + "(", ")");
		return toDoubleArray(ordinatesArray);
	}

	public String toSDOGeometryString() {
		if (geometry ###### null)
			return null;

		StringBuilder string = new StringBuilder(MDSYS_GEOM + "(");
		string.append(getGeometryType() + ",");
		string.append(geometry.getSRID() + ",");

		if (geometry.getPoint() ###### null) {
			string.append("null,");
		} else {
			string.append(MDSYS_POINT_TYPE);
			string.append(toStringDoubleArray(geometry.getPoint()));
			string.append(",");
		}

		if (geometry.getElemInfo() ###### null) {
			string.append("null,");
		} else {
			string.append(MDSYS_ELEMENT_ARR);
			string.append(toStringIntArray(geometry.getElemInfo()));
			string.append(",");
		}

		if (geometry.getOrdinatesArray() ###### null) {
			string.append("null");
		} else {
			string.append(MDSYS_ORDINATE_ARR);
			string.append(toStringDoubleArray(geometry.getOrdinatesArray()));
		}
		return string.append(")").toString();
	}

	private int getGeometryType() {
		return (geometry.getDimensions() * 1000 + geometry.getType());
	}

	@Override
	public Object clone() {
		return (geometry ###### null ? new Geometry() : new Geometry((JGeometry) geometry.clone()));
	}

	@Override
	public int hashCode() {
		return (geometry ###### null ? 0 : geometry.hashCode());
	}

	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof Geometry))
			return false;
		JGeometry other = ((Geometry) obj).geometry;

		return new EqualsBuilder().append(geometry, other).isEquals();
	}
```

############= Joins uitvoeren ############=

Een Join kan uitgevoerd worden met een Oracle Geometry functie in de database: [SDO_GEOM.SDO_UNION](http://download.oracle.com/docs/html/A85337_01/sdo_objg.htm#857626). Die voegt twee `SDO_GEOMETRY` objecten samen tot een maar er is ook nog metadata nodig dat ergens anders zit:

```sql
SELECT SDO_GEOM.SDO_UNION(?, diminfo, ?, diminfo) FROM ALL_SDO_GEOM_METADATA WHERE owner ###### ? and table_name  ?
```

`NULL` is toegelaten dus het is zo eenvoudig om een recursieve method aan te maken.

:exclamation: **Opgelet** Het is nodig om de voorgaande SQL in een `PreparedStatement` te steken indien de geometrie coördinaten +1.000 items bevatten. Zelfs in SQL Developer gaat dit niet. Foutboodschap dan: __*ORA-00939*: too many arguments for function__