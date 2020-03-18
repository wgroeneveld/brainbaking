
import java.util.*;

public class SchoenenSolution {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		var aantalKasten = sc.nextInt();

		for(int i = 0; i < aantalKasten; i++) {
			var aantalSchoenen = sc.nextInt();
			var kast = new ArrayList<Integer>();

			for(int j = 0; j < aantalSchoenen; j++) {
				kast.add(sc.nextInt());
			}

			System.out.println((i + 1) + " " + berekenKast(kast));
		}
	}

	private static String berekenKast(List<Integer> kast) {
		var map = new HashMap<Integer, Integer>();
		for(Integer schoen : kast) {
			if(!map.containsKey(schoen)) {
				map.put(schoen, 1);
			} else {
				int aantal = map.get(schoen);
				map.put(schoen, aantal + 1);
			}
		}

		int hoogte = 10;
		int lengte = 0;
		for(Integer schoen : map.keySet()) {
			var aantal = map.get(schoen);
			if(schoen < 38 && aantal <= 2) {
				lengte += schoen;
				if(aantal > 1) hoogte = 15;
			} else {
				lengte += (schoen * aantal);
			}
		}
		return hoogte + "x" + lengte;
	}
}