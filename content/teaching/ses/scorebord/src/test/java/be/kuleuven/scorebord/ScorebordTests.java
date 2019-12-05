package be.kuleuven.scorebord;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class ScorebordTests {

    @Before
    @After
    public void cleanUpFiles() throws IOException {
        if(Files.exists(Paths.get("score.json"))) {
            Files.delete(Paths.get("score.json"));
        }
    }

    @Test
    public void voegToe_samePlayer_addsScore() {
        var bord = new Scorebord();
        bord.voegToe("jos", 10);
        bord.voegToe("jos", 20);

        assertThat(bord.getTotaleScore("jos"), is(30));
    }

    @Test
    public void fileExists_continuesFromThatOne() throws IOException {
        var json = "[{\"naam\":\"jos\",\"score\":10}]";
        Files.write(Paths.get("score.json"), json.getBytes());

        var bord = new Scorebord();
        assertThat(bord.getWinnaar(), is("jos"));
        assertThat(bord.getTotaleScore("jos"), is(10));
    }

    @Test
    public void noFileExists_NewBord_AddPlayers_SavesToFile() {
        var bord = new Scorebord();
        bord.voegToe("jos", 10);

        assertThat(Files.exists(Paths.get("score.json")), is(true));
    }
}
