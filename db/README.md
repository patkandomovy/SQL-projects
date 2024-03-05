V rámci elearningového systému môžu učitelia vytvárať testy, prideľovať ich študentom a sledovať ako sa študentom v teste darilo. Pre jednoduchosť budeme uvažovať len testy typu ABCD, vždy s jednou správnou a 3 nesprávnymi odpoveďami. Chceme teda evidovať nasledovné údaje:

Otázky testu: Text otázky, správna odpoveď, nesprávne odpovede. Pre jednoduchosť budeme uvažovať len testy typu ABCD vždy s jednou správnou a 3 nesprávnymi odpoveďami.

Test: učiteľ môže vytvoriť test pozostávajúci z niekoľkých otázok (ľubovoľne veľa). O teste potrebujeme evidovať názov testu, ID autora (majiteľa testu) a ID otázok, ktoré daný test obsahuje.

Pridelenie: Učiteľ môže prideliť test žiakom. O pridelení je potrebné evidovať kto test pridelil (t.j. ID učiteľa), komu je test pridelený (ID študenta), ID testu a čas, kedy bol test žiakovi pridelený.

Výsledok: Po vypracovaní prideleného testu chceme zaznamenať študentove skóre. O výsledku (vypracovaní) potrebujeme vedieť, ktorého pridelenia sa týka, čas vypracovania testu a skóre v percentách. Študent môže v rámci jedného pridelenia absolvovať test ľubovoľne veľa krát.

Odpoveď: Pri vypracovávaní prideleného testu, t.j. pridelenia, žiak zvolil na otázky testu jednu z možných odpovedí. Chceme evidovať, ktoré odpovede zvolil, t.j. pre daný výsledok (resp. vypracovanie) a otázku testu chceme evidovať text odpovede.

Študent, Učiteľ: O každom študentovi a učiteľovi chceme evidovať jeho meno a priezvisko.

Vašou úlohou je:

Navrhnite štruktúru vyššie popísanej databázy a vytvorte súbor testy.sql, ktorý bude obsahovať SQL príkazy, ktoré vytvoria tabuľky Vami navrhnutej databázy. Tabuľky nech majú názvy otazka, test, otazka_test, pridelenie, vysledok, odpoved, student, ucitel.

Pred každý príkaz CREATE TABLE doplňte aj príkaz DROP TABLE IF EXISTS, aby bolo možné súbor testy.sql spúšťať viac krát za sebou bez chybových hlásení (prípadne všetky DROP TABLE IF EXISTS pridajte na začiatok súboru).

Tam, kde je to vhodné nastavte prepojenie medzi tabuľkami cez cudzie kľúče (FOREIGN KEY). Nezabudnite správne nastaviť ON DELETE / ON UPDATE.
Každú tabuľku naplňte aspoň 3 záznamami. T.j. do súboru testy.sql pridajte dotazy, ktoré naplnia každú tabuľku aspoň 3 záznamami.

Pri odchode učiteľa zo školy chceme presunúť jeho testy na iného učiteľa. Napíšte dotaz, ktorý zmení autora/majiteľa testu na iného učiteľa (ID učiteľov môžu byť konštanty). Dotaz pridajte do súboru testy.sql.

Napíšte dotazy, ktoré pre dané ID testu (konštanta) vymažú tento test z databázy spolu so všetkými jeho prideleniami a výsledkami. Dotazy pridajte do súboru testy.sql.

Učitelia majú požiadavku na doplnenie informácie, dokedy môže študent pridelený test vypracovať. Napíšte dotaz, ktorý upraví štruktúru tabuliek tak, aby pre každé pridelenie bolo možné evidovať termín, dokedy študent musí test vypracovať

Na koniec súbory testy.sql napíšte nasledovné SELECT dotazy:

Vypíšte zoznam študentov a im pridelených testov, t.j. 5-tice [Meno študenta, Priezvisko študenta, NazovTestu, CasPridelenia, CasVypracovania], kde NazovTestu je názov testu, ktorý bol pridelený študentovi StudentID v čase CasPridelenia. Ak študent test vypracoval, nech CasVypracovania je čas posledného vypracovania testu. Ak študent test ešte nerobil, CasVypracovania je NULL. Zoznam usporiadajte zostupne podľa času pridelenia.

Doplňte zoznam z predchádzajúcej úlohy o informáciu o výsledku študenta z daného testu, t.j. vypíšte 6-tice [Meno študenta, Priezvisko študenta, NazovTestu, CasPridelenia, CasVypravovania, VysledokPercenta], kde VysledokPercenta je posledný výsledok (ak existuje) daného študenta z daného pridelenia (t.j. VysledokPercenta zodpoveda tomu istemu vypracovaniu ako CasVypracovania). Ak študent ešte test neriešil, VysledokPercenta nech je NULL (podobne ako CasVypracovania).

Doplňte predchádzajúci zoznam o informáciu, či študent odpovedal na všetky otázky testu. T.j. vypíšte 6-tice [Meno študenta, Priezvisko študenta, NazovTestu, CasPridelenia, VysledokPercenta, Dokoncil], kde Dokoncil je "ano", ak študent odpovedal na všetky otázky daného testu a "nie" ak existuje otázka, na ktorú neodpovedal (t.j. neexistuje záznam v tabuľke s odpoveďami)

Vypíšte otázky, t.j. 2-tice [Text,SpravnaOdpoved], na ktoré odpovedal správne každý študent (v rámci akéhokoľvek pridelenia, t.j. neexistuje nesprávne odpovedanie na túto otázku).

