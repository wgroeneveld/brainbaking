
import java.util.*;
import java.io.IOException;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class SchoenenGenerate {

	private static int rand(int Low, int High) {
		Random r = new Random();
		return r.nextInt(High-Low) + Low;
	}

	public static void main(String[] args) {
		try {
			List<String> lines = new ArrayList<>();
			lines.add("100");
			Path file = Paths.get("schoenen-input.txt");

			for(int i = 1; i <= 100; i++) {
				int aantalSchoenen = rand(1, 10);
				lines.add(aantalSchoenen + "");

				for(int j = 1; j <= aantalSchoenen; j++) {
					lines.add(rand(30, 50) + "");					
				}
			}

			Files.write(file, lines, StandardCharsets.UTF_8);
		} catch(IOException ex) {
			throw new RuntimeException(ex);
		}

	}
}