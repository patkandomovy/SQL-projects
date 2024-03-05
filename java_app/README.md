Vašou úlohou je napísať program, pomocou ktorého budú študenti cez konzolu vypĺňať test. Budeme používať databázu popísanú v druhej domácej úlohe. Tabuľku študentov je však potrebné rozšíriť o prihlasovacie meno, t.j. nejaký textový identifikátor študenta (heslo budeme pre jednoduchosť ignorovať). Váš program môže využívať akýkoľvek SQL databázový systém (t.j. môžete použiť PostgreSQL alebo SQLLite, prípadne aj iné štandardné databázové systémy (MySQL, MariaDB, ...))

Použite prosím nasledovné definície tabuliek:

    student(studentid, meno, priezvisko, prihlasovacie_meno)
    ucitel(ucitelid, meno, priezvisko)
    test(testid, autor_ucitelid, nazov)
    otazka(otazkaid, testid, text, spravne, nespravne1, nespravne2, nespravne3)
    pridelnie(pridelenieid, testid, studentid, ucitelid, cas_pridelenia)
    vysledok(vysledokid, pridelenieid, skore, cas_vypracovania)
    odpoved(vysledokid, otazkaid, text_odpovede)

Správanie programu (všetko beží v konzole):

Po spustení si program vyžiada prihlasovacie meno študenta. Ak sa zadané prihlasovacie meno nenašlo, program si ho vypýta znovu. Dbajte na to, aby pri zadávaní prihlasovacieho mena nezáležalo na veľkosti písmen.

Po zadaní správneho prihlasovacie mena program vypíše na konzolu zoznam testov pridelených danému študentovi (por. číslo, názov testu, meno učiteľa, čas pridelenia, najlepší výsledok daného študenta z tohto pridelenia) a študent zadaním poradového čísla vyberie, ktorý test chce spustiť.

Následne program bude postupne dávať otázky zvoleného testu. T.j. program vypíše na konzolu text otázky a možnosti A-D a študent má zvoliť správnu možnosť (napísaním písmenka a/b/c/d). Každé odpovedanie na otázku je taktiež ukladané do databázy (do tabuľky odpoved).

Po zodpovedaní všetkých otázok program vypíše percentuálnu úspešnosť a výsledok uloží do databázy (do tabuľky vysledok). Následne program skončí.

Bonusová úloha za 5 bodov: analyzujte, či popísaná databáza je v 3NF a BCNF. Svoje tvrdenia podrobne zdôvodnite.

