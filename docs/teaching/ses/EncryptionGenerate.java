
import java.util.*;
import java.io.IOException;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class EncodingGenerate {

	private static List<String> randomWoorden = Arrays.asList("braaf", "ben", "eten", "boom", "ezel", "hout", "tafel", "wandelen", "aan", "het", "studeren", "moeilijk", "?", "!", "nietsnut", "welles", "Goedemorgen!", "Lowie", "Jos", "Marie", "vereren", "verliefd", "zijn", "poes", "hond", "struik");

	private static int rand(int min, int max) {
		Random r = new Random();
		int Low = min;
		int High = max;
		return r.nextInt(High-Low) + Low;
	}

	private static String randomZin() {
		var aantalWoorden = rand(1, randomWoorden.size());

		List<String> woorden = new ArrayList<>();
		for(int i = 0; i < aantalWoorden; i++) {
			var pos = rand(0, randomWoorden.size());
			woorden.add(randomWoorden.get(pos));
		}
		return String.join(" ", woorden);
	}

	public static void main(String[] args) {
		try {
			List<String> lines = new ArrayList<>();
			lines.add("100");
			Path file = Paths.get("encryption-input.txt");

			for(int i = 1; i <= 100; i++) {
				lines.add(randomZin());
			}

			Files.write(file, lines, StandardCharsets.UTF_8);
		} catch(IOException ex) {
			throw new RuntimeException(ex);
		}

	}
}