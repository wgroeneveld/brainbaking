
import static java.lang.Character.isLetter;
import java.util.Scanner;
import java.util.stream.Collectors;

public class EncryptionSolution {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		var amountOfLines = sc.nextInt();
		sc.nextLine();

		for(int i = 0; i < amountOfLines; i++) {
			var toEncrypt = sc.nextLine();
			System.out.println((i + 1) + " " + encrypt(toEncrypt));
		}
	}

	private static String rot3(String s) {
		return s.chars()
			.mapToObj(c -> {
				int pos = 65;
				if(c >= 65 && c <= 90) {
					// uppercase - default
				} else if(c >= 97 && c <= 122) {
					// lowercase
					pos = 97;
				} else {
					return "" + (char) c;
				}

				return "" + (char) (((c - pos + 3) % 26) + pos);
			})
			.collect(Collectors.joining(""));		
	}

	private static String switchPairs(String s) {
		var result = "";
		int i = 0;
		for(i = 0; i <= s.length() - 2; i += 2) {
			var pair1 = "" + s.charAt(i);
			var pair2 = "" + s.charAt(i + 1);

			result += pair2 + pair1;
		}
		if(i < s.length()) {
			result += s.charAt(s.length() - 1);
		}
		return result;		
	}

	private static String encrypt(String s) {
		return switchPairs(rot3(s));
	}
}