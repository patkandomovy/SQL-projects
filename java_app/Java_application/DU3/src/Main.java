import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Connection connection = null;
        Scanner scanner = new Scanner(System.in);
        try {
            //Napajanie na databazu
            Class.forName("org.postgresql.Driver");
            connection = DriverManager
                    .getConnection("jdbc:postgresql://localhost:5432/testy",
                            "postgres", "123");
            System.out.println("Si prihlaseny do databazy!");

            //Prihlasovanie uzivatela
            String login;
            System.out.println("Napis svoje prihlasovacie meno:");
            while (true) {
                login = scanner.nextLine();
                if (loginCheck(connection, login)) {
                    System.out.println("Prihlaseny!");
                    break;
                } else {
                    System.out.println("Uzivatel nebol najdeny!");
                }
            }

            //Vypisanie testov
            printTests(connection, login);
            System.out.println("Vyber si ID testu:");
            int testID;
            while (true) {
                testID = scanner.nextInt();
                if (testCheck(connection, login, testID)) {
                    System.out.println("Test " + testID + ":");
                    break;
                } else {
                    System.out.println("Tento test nebol prideleny tebe!");
                }
            }

            //Vypracovanie testu
            takeTest(connection, login, testID);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void takeTest(Connection connection, String login, int testID) throws SQLException {
        String sql = "SELECT otazkaid, text, spravne, nespravne1, nespravne2, nespravne3 "
                + "FROM otazka "
                + "WHERE testid = ?";

        int count = 0;
        int correctCount = 0;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();
            int pridelenieID = getPridelenieID(connection, login, testID);
            int vysledokID = createTestAttempt(connection, pridelenieID);

            Scanner scannerTest = new Scanner(System.in);
            while(rs.next()) {
                count++;
                String correctAnswer = rs.getString("spravne");

                List<String> answers = new ArrayList<>();
                answers.add(rs.getString("spravne"));
                answers.add(rs.getString("nespravne1"));
                answers.add(rs.getString("nespravne2"));
                answers.add(rs.getString("nespravne3"));

                Collections.shuffle(answers);

                System.out.println(rs.getString("text"));
                System.out.println("a) " + answers.get(0));
                System.out.println("b) " + answers.get(1));
                System.out.println("c) " + answers.get(2));
                System.out.println("d) " + answers.get(3));

                System.out.println("Vyber svoju odpoved(a/b/c/d):");
                while (true) {
                    String answer = scannerTest.nextLine();
                    if (answer.equals("a") || answer.equals("b") || answer.equals("c") || answer.equals("d")) {
                        String answerText = answers.get(answer.charAt(0) - 'a');
                        if(answerText.equals(correctAnswer)) correctCount++;
                        saveAnswer(connection, rs.getInt("otazkaid"), answerText, login, vysledokID);
                        break;
                    } else {
                        System.out.println("Vyberaj iba odpovede a/b/c/d !");
                    }
                }



            }
            double skore = ((double) correctCount / count) * 100;
            System.out.printf("Tvoje skore je: %.2f%%\n", skore);

            updateTestScore(connection, vysledokID, skore);
        }
    }

    private static void updateTestScore(Connection connection, int vysledokID, double score) throws SQLException {
        String sql = "UPDATE vysledok SET skore = ? WHERE vysledokid = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, score);
            ps.setInt(2, vysledokID);
            ps.executeUpdate();
        }
    }

    private static void saveAnswer(Connection connection, int otazkaID, String text_odpovede, String login, int vysledokID) throws SQLException {
        String sql = "INSERT INTO odpoved (vysledokid, otazkaid, text_odpovede) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, vysledokID);
            ps.setInt(2, otazkaID);
            ps.setString(3, text_odpovede);
            ps.executeUpdate();
        }
    }

    private static int createTestAttempt(Connection connection, int pridelenieID) throws SQLException {
        int vysledokId = getVysledokId(connection, pridelenieID);
        if (vysledokId != -1) {
            return vysledokId;
        }

        String sql = "INSERT INTO vysledok (pridelenieid, skore) VALUES (?, NULL) RETURNING vysledokid";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pridelenieID);
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException();
                }
            }
        }
    }

    private static int getVysledokId(Connection connection, int pridelenieID) throws SQLException {
        String sql = "SELECT vysledokid FROM vysledok WHERE pridelenieid = ? AND skore IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pridelenieID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("vysledokid");
            } else {
                return -1;
            }
        }
    }

    private static boolean testCheck(Connection connection, String login, int testID) throws SQLException {
        String sql = "SELECT 1 FROM pridelenie p "
                + "JOIN student s ON p.studentid = s.studentid "
                + "WHERE lower(s.prihlasovacie_meno) = lower(?) AND p.testid = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, login);
            ps.setInt(2, testID);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private static boolean loginCheck(Connection connection, String login) throws SQLException {
        String sql = "SELECT * FROM student WHERE lower(prihlasovacie_meno) = lower(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, login);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private static int getPridelenieID(Connection connection, String loginName, int testId) throws SQLException {
        String sql = "SELECT p.pridelenieid FROM pridelenie p "
                + "JOIN student s ON p.studentid = s.studentid "
                + "WHERE lower(s.prihlasovacie_meno) = lower(?) AND p.testid = ?";

        try (PreparedStatement pst = connection.prepareStatement(sql)) {
            pst.setString(1, loginName);
            pst.setInt(2, testId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt("pridelenieid");
            } else {
                throw new SQLException();
            }
        }
    }


    private static void printTests(Connection connection, String login) throws SQLException {
        String sql = "SELECT t.testid, t.nazov, u.meno, u.priezvisko, p.cas_pridelenia, v.skore "
                + "FROM pridelenie p "
                + "JOIN test t ON p.testid = t.testid "
                + "JOIN ucitel u ON t.autor_ucitelid = u.ucitelid "
                + "LEFT JOIN vysledok v ON p.pridelenieid = v.pridelenieid AND v.vysledokid IN ("
                + "    SELECT MAX(v2.vysledokid) FROM vysledok v2 WHERE v2.pridelenieid = p.pridelenieid GROUP BY v2.pridelenieid) "
                + "JOIN student s ON p.studentid = s.studentid "
                + "WHERE lower(s.prihlasovacie_meno) = lower(?) "
                + "ORDER BY p.cas_pridelenia DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, login);
            ResultSet rs = ps.executeQuery();

            System.out.println("Testy:");
            while (rs.next()) {
                int testID = rs.getInt("testid");
                String testNazov = rs.getString("nazov");
                String ucitelMeno = rs.getString("meno") + " " + rs.getString("priezvisko");
                Timestamp casPridelenia = rs.getTimestamp("cas_pridelenia");
                double skore = rs.getDouble("skore");
                System.out.println("ID testu: " + testID + ", Nazov testu: " + testNazov + ", Ucitel: " + ucitelMeno + ", Cas pridelenia: " + casPridelenia + ", Najlepsie skore: " + skore);
            }
        }

    }
}