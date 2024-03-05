DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS ucitel CASCADE;
DROP TABLE IF EXISTS otazka CASCADE;
DROP TABLE IF EXISTS test CASCADE;
DROP TABLE IF EXISTS otazka_test CASCADE;
DROP TABLE IF EXISTS pridelenie CASCADE;
DROP TABLE IF EXISTS vysledok CASCADE;
DROP TABLE IF EXISTS odpoved CASCADE;

CREATE TABLE student (
	id INTEGER PRIMARY KEY,
	meno TEXT NOT NULL,
	priezvisko TEXT NOT NULL
);

CREATE TABLE ucitel (
	id INTEGER PRIMARY KEY,
	meno TEXT NOT NULL,
	priezvisko TEXT NOT NULL
);

CREATE TABLE otazka (
	id INTEGER PRIMARY KEY,
	text_otazky TEXT NOT NULL,
	spravna_odpoved TEXT NOT NULL,
	nespravne_odpovedi TEXT[3] NOT NULL
);

CREATE TABLE test (
	id INTEGER PRIMARY KEY,
	nazov TEXT NOT NULL,
	autor_id INTEGER NOT NULL,
	FOREIGN KEY (autor_id) REFERENCES ucitel(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE otazka_test (
	id INTEGER PRIMARY KEY,
	test_id INTEGER NOT NULL,
	otazka_id INTEGER NOT NULL,
	FOREIGN KEY (test_id) REFERENCES test(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (otazka_id) REFERENCES otazka(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pridelenie (
	id INTEGER PRIMARY KEY,
	ucitel_id INTEGER NOT NULL,
	student_id INTEGER NOT NULL,
	test_id INTEGER NOT NULL,
	cas_pridelenia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (ucitel_id) REFERENCES ucitel(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (test_id) REFERENCES test(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE vysledok (
	id INTEGER PRIMARY KEY,
	pridelenie_id INTEGER NOT NULL,
	cas_vypracovania TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	skore DECIMAL(5,2),
	FOREIGN KEY (pridelenie_id) REFERENCES pridelenie(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE odpoved (
	id INTEGER PRIMARY KEY,
	vysledok_id INTEGER NOT NULL,
	otazka_id INTEGER NOT NULL,
	zvolena_odpoved TEXT,
	FOREIGN KEY (vysledok_id) REFERENCES vysledok(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (otazka_id) REFERENCES otazka(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* 3 */

INSERT INTO student VALUES
(1, 'Filip', 'Papricka'),
(2, 'Jozko', 'Mrkvicka'),
(3, 'Janka', 'Zemiacikova');

INSERT INTO ucitel VALUES
(1, 'Rudolf', 'Skandinavsky'),
(2, 'Vladislav', 'Petrohradsky'),
(3, 'John', 'Americky');

INSERT INTO otazka VALUES
(1, 'Ktory tim nesidli v Londyne?', 'Wolves', '{"Chelsea", "Arsenal", "West Ham"}'),
(2, 'Ktory tim hraje na Stamford Bridge?', 'Chelsea', '{"Manchester City", "Liverpool", "Everton"}'),
(3, 'Ktory tim je znamy ako Cerveni Diabli?', 'Manchester United', '{"Newcastle", "Manchester City", "Liverpool"}'),
(4, 'Odkial pochadza CR7?', 'Portugalsko', '{"Spanielsko", "Anglicko", "Brazilia"}'),
(5, 'Kto je najvacsi rival CR7?', 'Lionel Messi', '{"David Beckham", "R9", "Zlatan Ibrahimovic"}'),
(6, 'V ktorom anglickom time hral CR7?', 'Manchester United', '{"Manchester City", "Liverpool", "Chelsea"}'),
(7, 'Ktory hrac prisiel z Boltonu do Chelsea?', 'Nicholas Anelka', '{"Cristiano Ronaldo", "Didier Drogba", "Ngolo Kante"}'),
(8, 'Kedy bola Chelsea zalozena?', '1905', '{"1915", "1925", "1935"}'),
(9, 'Aka je farba Chelsea?', 'Modra', '{"Zelena", "Cervena", "Zlta"}');

INSERT INTO test VALUES 
(1, 'Premier league trivia', 1),
(2, 'Cristiano Ronaldo trivia', 3),
(3, 'Chelsea trivia', 2);

INSERT INTO otazka_test VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 4),
(5, 2, 5),
(6, 2, 6),
(7, 3, 7),
(8, 3, 8),
(9, 3, 9);

INSERT INTO pridelenie VALUES
(1, 1, 1, 1, '2020-01-01'),
(2, 2, 3, 3, '2021-01-01'),
(3, 2, 2, 2, '2022-01-01');


INSERT INTO vysledok VALUES
(1, 1, '2020-01-02', 100.00),
(2, 2, '2021-01-02', 0.00),
(3, 3, '2022-01-02', 66.66);


INSERT INTO odpoved VALUES
(1, 1, 1, 'Wolves'),
(2, 1, 2, 'Chelsea'),
(3, 1, 3, 'Manchester United'),
(4, 2, 4, 'Spanielsko'),
(5, 2, 5, 'R9'),
(6, 2, 6, 'Liverpool'),
(7, 3, 7, 'Nicholas Anelka'),
(8, 3, 8, '1905');



/* 4 */ 
SELECT * FROM test;

UPDATE test
SET autor_id = 3 
WHERE autor_id = 2;

SELECT * FROM test;

/* 5 */
SELECT * FROM test;
SELECT * FROM pridelenie;
SELECT * FROM vysledok;

DELETE FROM otazka_test WHERE id = 1;

DELETE FROM odpoved WHERE vysledok_id IN 
(SELECT id FROM vysledok WHERE pridelenie_id IN 
	(SELECT id FROM pridelenie WHERE test_id = 1));

DELETE FROM vysledok WHERE pridelenie_id IN
(SELECT id FROM pridelenie WHERE test_id = 1);

DELETE FROM pridelenie WHERE test_id = 1;

DELETE FROM test WHERE id = 1;

SELECT * FROM test;
SELECT * FROM pridelenie;
SELECT * FROM vysledok;

/* 6 */
SELECT * FROM pridelenie;

ALTER TABLE pridelenie
ADD COLUMN cas_dokedy TIMESTAMP;

SELECT * FROM pridelenie;

/* 7.1 */

/*pridam si nicnerobiaceho studenta, ucitela a test, ktory nebol vypracovany */
insert into student values
(100, 'Student', 'Nicnerobiaci');
insert into ucitel values
(100, 'Ucitel', 'Nicnerobiaceho');
insert into pridelenie values
(100, 100, 100, 3, '2024-01-01');

/*pridam si studenta, ktory vypracoval test dvakrat */
insert into student values
(200, 'Opakovac', 'Motivovany');
insert into ucitel values
(200, 'Ucitel', 'Opakovaca');
insert into pridelenie values
(101, 200, 200, 2, '2025-01-01');
insert into vysledok values
(1000, 101, '2025-01-01', 50.00);
insert into vysledok values
(1001, 101, '2025-01-02', 25.00);

SELECT 
s.meno AS "Meno studenta",
s.priezvisko AS "Priezvisko studenta",
t.nazov AS "Nazov testu",
p.cas_pridelenia AS "Cas pridelenia",
MAX(v.cas_vypracovania) AS "Cas vypracovania"


FROM student s
JOIN pridelenie p ON s.id = p.student_id
JOIN test t ON p.test_id = t.id
LEFT JOIN vysledok v ON p.id = v.pridelenie_id



GROUP BY s.meno, s.priezvisko, t.nazov, p.cas_pridelenia
ORDER BY p.cas_pridelenia DESC;

/* 7.2  zaznam s opakovacom motivovanym by mal obsahovat posledny cas vypracovania a vysledok,
 ktory tomu vypracovaniu prislucha -- teda 2025-01-02 00:00:00 |  25.00 */

SELECT 
s.meno AS "Meno studenta",
s.priezvisko AS "Priezvisko studenta",
t.nazov AS "Nazov testu",
p.cas_pridelenia AS "Cas pridelenia",
MAX(v.cas_vypracovania) AS "Cas vypracovania",
v.skore AS "Vysledok"


FROM student s
JOIN pridelenie p ON s.id = p.student_id
JOIN test t ON p.test_id = t.id
LEFT JOIN vysledok v ON p.id = v.pridelenie_id

WHERE v.skore = (
	SELECT v2.skore
	FROM vysledok v2
	WHERE v2.cas_vypracovania = (
		SELECT MAX(v3.cas_vypracovania) 
		FROM vysledok v3
	       	WHERE v3.pridelenie_id = p.id))

GROUP BY s.meno, s.priezvisko, t.nazov, p.cas_pridelenia, v.skore
ORDER BY p.cas_pridelenia DESC;

/* 7.3 
v prvom zazname by malo byt nie - student nema zaznamenane ziadne odpovede;
v druhom zazname by malo byt nie - student nema zaznamenanu jednu odpoved, ostatne ano
v tretom zazname by malo byt ano - student ma zaznamenane vsetky odpovede*/

SELECT 
s.meno AS "Meno studenta",
s.priezvisko AS "Priezvisko studenta",
t.nazov AS "Nazov testu",
p.cas_pridelenia AS "Cas pridelenia",
MAX(v.cas_vypracovania) AS "Cas vypracovania",
v.skore AS "Vysledok",
CASE
	WHEN COUNT(DISTINCT ot.id) = COUNT(DISTINCT od.id) THEN 'Ano' ELSE 'Nie'
END AS "Dokoncil"


FROM student s
JOIN pridelenie p ON s.id = p.student_id
JOIN test t ON p.test_id = t.id
LEFT JOIN vysledok v ON p.id = v.pridelenie_id
LEFT JOIN otazka_test ot ON t.id = ot.test_id
LEFT JOIN odpoved od ON od.vysledok_id = v.id

WHERE v.skore = (
	SELECT v2.skore
	FROM vysledok v2
	WHERE v2.cas_vypracovania = (
		SELECT MAX(v3.cas_vypracovania) 
		FROM vysledok v3
	       	WHERE v3.pridelenie_id = p.id))


GROUP BY s.meno, s.priezvisko, t.nazov, p.cas_pridelenia, v.skore
ORDER BY p.cas_pridelenia DESC;


/* 7.4 snad som tomu pochopil spravne -- chceme otazky, na ktore niekto odpovedal spravne a zaroven nikto neodpovedal
 nespravne, a nemusime sa pozerat na to, ci tu otazku student musel mat v pridelenom teste*/

/*pridal som nove odpovede, vypisal tabulku na kontrolu neskor*/
INSERT INTO odpoved VALUES 
(10, 2, 5, 'Lionel Messi'),
(11, 3, 5, 'David Beckham');

SELECT o.text_otazky, o.spravna_odpoved, od.zvolena_odpoved
FROM otazka o
LEFT JOIN odpoved od ON od.otazka_id = o.id;

/*samotny dotaz, mal by vypisat len dva zaznamy. ostatne boli aspon raz zodpovedane zle alebo neboli zodpovedane vobec */
SELECT ot.text_otazky AS "Text", ot.spravna_odpoved AS "SpravnaOdpoved"
FROM otazka ot
WHERE NOT EXISTS(
	SELECT *
	FROM odpoved od
	WHERE ot.id = od.otazka_id
	AND od.zvolena_odpoved = ANY(ot.nespravne_odpovedi))
AND EXISTS(
	SELECT *
	FROM odpoved od2
	WHERE ot.id = od2.otazka_id
	AND od2.zvolena_odpoved = ot.spravna_odpoved);

