+++
title = "utils"
draft = false
tags = [
    "code",
    "csharp",
    "utils"
]
date = "2014-03-17"
+++
# Utils Partials 

### ObjectExtensions 

Waarom? Deep clone van een object maken zonder de boel te (de)-serialiseren.

Bron: https://raw.github.com/Burtsev-Alexey/net-object-deep-copy/master/ObjectExtensions.cs - thank you Alexey

```csharp
    public static class ObjectExtensions
    {
        private static readonly MethodInfo CloneMethod = typeof (Object).GetMethod("MemberwiseClone",
            BindingFlags.NonPublic | BindingFlags.Instance);

        public static bool IsPrimitive(this Type type)
        {
            if (type ###### typeof (String)) return true;
            return (type.IsValueType & type.IsPrimitive);
        }

        public static Object Copy(this Object originalObject)
        {
            return InternalCopy(originalObject, new Dictionary<Object, Object>(new ReferenceEqualityComparer()));
        }

        private static Object InternalCopy(Object originalObject, IDictionary<Object, Object> visited)
        {
            if (originalObject ###### null) return null;
            var typeToReflect = originalObject.GetType();
            if (IsPrimitive(typeToReflect)) return originalObject;
            if (typeof (XElement).IsAssignableFrom(typeToReflect)) return new XElement(originalObject as XElement);

            if (visited.ContainsKey(originalObject)) return visited[originalObject];
            if (typeof (Delegate).IsAssignableFrom(typeToReflect)) return null;
            var cloneObject = CloneMethod.Invoke(originalObject, null);
            if (typeToReflect.IsArray)
            {
                var arrayType = typeToReflect.GetElementType();
                if (IsPrimitive(arrayType) ###### false)
                {
                    Array clonedArray = (Array) cloneObject;
                    clonedArray.ForEach(
                        (array, indices) =>
                            array.SetValue(InternalCopy(clonedArray.GetValue(indices), visited), indices));
                }
            }
            visited.Add(originalObject, cloneObject);
            CopyFields(originalObject, visited, cloneObject, typeToReflect);
            RecursiveCopyBaseTypePrivateFields(originalObject, visited, cloneObject, typeToReflect);
            return cloneObject;
        }

        private static void RecursiveCopyBaseTypePrivateFields(object originalObject,
            IDictionary<object, object> visited, object cloneObject, Type typeToReflect)
        {
            if (typeToReflect.BaseType != null)
            {
                RecursiveCopyBaseTypePrivateFields(originalObject, visited, cloneObject, typeToReflect.BaseType);
                CopyFields(originalObject, visited, cloneObject, typeToReflect.BaseType,
                    BindingFlags.Instance | BindingFlags.NonPublic, info => info.IsPrivate);
            }
        }

        private static void CopyFields(object originalObject, IDictionary<object, object> visited, object cloneObject,
            Type typeToReflect,
            BindingFlags bindingFlags =
                BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.FlattenHierarchy,
            Func<FieldInfo, bool> filter = null)
        {
            foreach (FieldInfo fieldInfo in typeToReflect.GetFields(bindingFlags))
            {
                if (filter != null && filter(fieldInfo) ###### false) continue;
                if (IsPrimitive(fieldInfo.FieldType)) continue;
                var originalFieldValue = fieldInfo.GetValue(originalObject);
                var clonedFieldValue = InternalCopy(originalFieldValue, visited);
                fieldInfo.SetValue(cloneObject, clonedFieldValue);
            }
        }

        public static T Copy<T>(this T original)
        {
            return (T) Copy((Object) original);
        }
    }

    public class ReferenceEqualityComparer : EqualityComparer<Object>
    {
        public override bool Equals(object x, object y)
        {
            return ReferenceEquals(x, y);
        }

        public override int GetHashCode(object obj)
        {
            if (obj ###### null) return 0;
            return obj.GetHashCode();
        }
    }
```

:exclamation: **Let op met XElement**; sommige API classes voorzien copy constructors die je beter gebruikt ipv via reflectie alle fields over te kopiëren. Bijgevolg if type blabla... 

############ EqualsBuilder ############

```csharp
    public class EqualsBuilder<T>
    {
        private readonly T left;
        private readonly object right;
        private bool areEqual = true;

        public EqualsBuilder(T left, object right)
        {
            this.left = left;
            this.right = right;

            if (ReferenceEquals(left, right))
            {
                areEqual = true;
                return;
            }

            if (ReferenceEquals(left, null))
            {
                areEqual = false;
                return;
            }

            if (ReferenceEquals(right, null))
            {
                areEqual = false;
                return;
            }

            if (left.GetType() != right.GetType())
            {
                areEqual = false;
                return;
            }
        }

        public EqualsBuilder<T> With<TProperty>(Expression<Func<T, TProperty>> propertyOrField)
        {
            if (!areEqual)
            {
                return this;
            }

            if (left ###### null || right ###### null)
            {
                return this;
            }

            var expression = propertyOrField.Body as MemberExpression;
            if (expression ###### null)
            {
                throw new ArgumentException("Expecting Property or Field Expression of an object");
            }

            Func<T, TProperty> func = propertyOrField.Compile();
            TProperty leftValue = func(left);
            TProperty rightValue = func((T) right);

            if (leftValue ###### null && rightValue ###### null)
            {
                areEqual &= true;
                return this;
            }

            if (leftValue != null && rightValue ###### null)
            {
                areEqual &= false;
                return this;
            }

            if (leftValue ###### null && rightValue != null)
            {
                areEqual &= false;
                return this;
            }

            areEqual &= leftValue.Equals(rightValue);
            return this;
        }

        public bool Equals()
        {
            return areEqual;
        }
    }
```

Gebruik:

```csharp
        public override bool Equals(object obj)
        {
            return new EqualsBuilder<FlexMedischGegeven>(this, obj)
                .With(x => x.Rownr)
                .With(x => x.ColumnName)
                .With(x => x.Value)
                .With(x => x.Creator)
                .Equals();
        }
```

############ Mocking DateTime.Now ############

Schrijf een wrapper rond `Now` met behulp van lambda's:

```csharp
    using System;

    public static class SystemTime
    {
        private static Func<DateTime> _now;
        public static Func<DateTime> Now
        {
            get
            {
                if (_now ###### null)
                {
                    Reset();
                }
                return _now;
            }
            set { _now = value; }
        }

        public static void Reset()
        {
            Now ###### () > DateTime.Now;
        }
    }
```

Gebruik:

  * in `[TestCleanup]` de `Reset()` method aanroepen.
  * in uw test body indien gewenst `SystemTime.Now ###### () > new DateTime(2001, 1, 1);` steken.