-- INIT
-- HINWEIS: Das Zeichen * bei den Aufgaben zeigt an, dass der Umweg über eine termporäre Stütztabelle gewählt wurde, da MariaDB in Sub-Selects aktuell keine Limitierung zulässt.

-- Korrekte Datenbank aktivieren
USE bestellungen;

-- Abfrage 1
-- Zeigen Sie an, welche Kunden aus München kommen.
SELECT * FROM kunde WHERE ort = "muenchen";

-- Abfrage 2
-- Zeigen Sie alle Artikel aus der Kategorie "Monitor" sortiert nach Einzelpreis absteigend an. 
-- Sie dürfen NICHT in der Kategorietabelle nachsehen, welche Kategorienummer die Kategorie "Monitor" hat.
SELECT * FROM artikel LEFT JOIN kategorie
	ON artikel.fk_kategorie = kategorie.kat_nr
    WHERE kategorie.kategoriebezeichnung = "Monitor";

-- Abfrage 3
-- Zeigen Sie alle Kunden aus dem PLZ-Gebiet 4 nach PLZ aufsteigend sortiert an.
SELECT * FROM kunde WHERE LEFT(plz, 1) = "4" ORDER BY plz ASC;

-- Abfrage 4
-- Zeigen Sie für den Kunden mit der Kundennummer 319 an, von welchen Kategorien er Artikel gekauft hat. 
-- Jede Kategorie soll nur einmal betrachtet werden.
SELECT DISTINCT kategorie.kategoriebezeichnung AS "Kategorien" FROM auftrag 
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
	LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
	LEFT JOIN kategorie ON kategorie.kat_nr = artikel.fk_kategorie
		WHERE auftrag.fk_kunde = 319;
    
-- Abfrage 5
-- Zeigen Sie für den Kunden mit der Kundennummer 111 an, wann er welche Artikel bestellt hat.
SELECT auftrag.fk_kunde AS "Kundennummer", auftrag.auft_nr AS "Auftragsnummer", bestellposition.fk_artikel AS "Artikel", bestellposition.anzahl AS "Bestellmenge", auftrag.bestelldat AS "Bestelldatum" FROM auftrag 
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		WHERE auftrag.fk_kunde = 111 ORDER BY auftrag.bestelldat ASC;

-- Abfrage 6
-- Wie viele Kunden kommen aus dem PLZ-Gebiet 5?
SELECT COUNT(*) AS "Anzahl Kunden aus dem PLZ-Gebiet 5" FROM kunde WHERE LEFT(plz, 1) = 5;

-- Abfrage 7
-- Wie viele Kunden haben im August 2020 mindestens einen Auftrag erteilt?
SELECT COUNT(DISTINCT auftrag.fk_kunde) AS "Anzahl Kunden die in '08-2020' gekauft haben" FROM auftrag
	WHERE (auftrag.bestelldat >= "2020-08-01" AND auftrag.bestelldat <= "2020-08-31");

-- Abfrage 8
-- Welchen Gesamtumsatz haben wir mit Kunden aus Essen erzielt?
SELECT SUM(artikel.einzelpreis * bestellposition.anzahl) AS "Gesamtumsatz in Essen" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE kunde.ort = "essen";

-- Abfrage 9
-- In welchem Auftrag wurden vom Artikel mit der Artikelnummer 555 stückmäßig am meisten verkauft?
SELECT auftrag.auft_nr AS "Auftragsnummer", MAX(DISTINCT bestellposition.anzahl) AS "Bestellmenge" FROM auftrag
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		WHERE bestellposition.fk_artikel = 555
			GROUP BY auftrag.auft_nr ORDER BY MAX(DISTINCT bestellposition.anzahl) DESC LIMIT 1;

-- Abfrage 10
-- In welchen drei PLZ-Gebieten bezogen auf die ersten beiden Stellen der PLZ in der Kundentabelle haben 
-- wir die meisten Kunden?
SELECT LEFT(kunde.plz, 2) AS "PLZ-Gebiet", COUNT(kunde.kd_nr) AS "Anzahl Kunden" FROM kunde
	GROUP BY LEFT(kunde.plz, 2) ORDER BY COUNT(kunde.kd_nr) DESC LIMIT 3;

-- Abfrage 11:
-- Zeigen Sie den jüngsten Kunden an. Sollten mehrere Kunden am selben Tag geboren sein, so sollen alle angezeigt werden.
SELECT kunde.kd_nr AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname", kunde.geburtsdatum AS "Geburtsdatum" from kunde
    WHERE kunde.geburtsdatum = 
		(SELECT MAX(kunde.geburtsdatum) FROM kunde);

-- Abfrage 12:
-- Zeigen Sie alle Kunden an, die am selben Datum bestellt haben, wie der Kunde 400 bei seiner letzten Auftragserteilung. 
-- Der Kunde 400 selbst soll nicht angezeigt werden.
SELECT auftrag.fk_kunde AS "Kundennummer" FROM auftrag
	WHERE auftrag.bestelldat IN
		(SELECT MAX(auftrag.bestelldat) FROM auftrag WHERE auftrag.fk_kunde = 400)
	ORDER BY auftrag.fk_kunde ASC;

-- Abfrage 13:
-- Wie ist der Gesamtumsatz der Kunden nach PLZ-Gebieten (erste Stelle)? Ordnen Sie das Ergebnis aufsteigend nach Gesamtumsatz. 
-- Beziehen Sie sich in Ihrer Lösung auf die PLZ in der Kundentabelle.
SELECT LEFT(kunde.plz, 1) AS "PLZ-Gebiet", SUM(bestellposition.anzahl * artikel.einzelpreis) AS "Gesamtumsatz" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		GROUP BY LEFT(kunde.plz, 1)
			ORDER BY SUM(bestellposition.anzahl * artikel.einzelpreis) DESC;

-- Abfrage 14:
-- Wie viele Artikel führen wir in den einzelnen Kategorien?
SELECT kategorie.kat_nr AS "Kategorie", kategorie.kategoriebezeichnung AS "Bezeichnung", COUNT(artikel.art_nr) AS "Anzahl Artikel" FROM kategorie
	LEFT JOIN artikel ON artikel.FK_kategorie = kategorie.kat_nr
		GROUP BY kategorie.kat_nr, kategorie.kategoriebezeichnung ORDER BY kategorie.kat_nr ASC;

-- Abfrage 15:
-- Zeigen Sie alle Kunden mit Kundennummer, Vornamen und Nachnamen an, die irgendwann mehr als 10 Festplatten in einer 
-- Bestellposition geordert haben. Jeder Kunde soll allerdings nur einmal angezeigt werden, selbst wenn er mehrere Bestell-
-- positionen mit mehr als 10 Festplatten hatte. Die Ausgabe soll nach Kundennummer sortiert sein.
SELECT DISTINCT kunde.kd_nr AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname", SUM(bestellposition.anzahl) AS "Kaufmenge" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
    LEFT JOIN kategorie ON kategorie.kat_nr = artikel.fk_kategorie
		WHERE kategorie.kategoriebezeichnung = "festplatte" AND bestellposition.anzahl > 10 
			GROUP BY kunde.kd_nr, kunde.vorname, kunde.nachname
            ORDER BY kunde.kd_nr ASC;

-- Abfrage 16:
-- Zeigen Sie alle Aufträge an, zu denen es keine Daten in der Bestellpositionentabelle gibt.
SELECT auftrag.auft_nr AS "Auftragsnummer" FROM auftrag
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		WHERE bestellposition.position IS NULL;

-- Abfrage 17:
-- Wie viele Artikel führen wir insgesamt in den Kategorien ‚Monitor", ‚Festplatte" und ‚Drucker"?
SELECT COUNT(artikel.fk_kategorie) AS "Anzahl Artikel" FROM artikel
	LEFT JOIN kategorie ON kategorie.kat_nr = artikel.fk_kategorie
		WHERE kategorie.kategoriebezeichnung IN ("Monitor", "Festplatte", "Drucker");

-- Abfrage 18:
-- Wann hat der Kunde mit der Kundennummer 33 zuletzt bestellt?
SELECT auftrag.bestelldat AS "Datum letzte Bestellung von Kunde 33" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		WHERE kunde.kd_nr = 33
			ORDER BY auftrag.bestelldat DESC LIMIT 1;

-- Abfrage 19:
-- Wer sind die 10 ältesten Kunden?
SELECT kunde.kd_nr AS "Kundennummer", kunde.geburtsdatum AS "Geburtsdatum" FROM kunde
	WHERE kunde.geburtsdatum IS NOT NULL
		ORDER BY kunde.geburtsdatum ASC LIMIT 10;

-- Abfrage 20:
-- Wie hoch war der höchste Einzelumsatz einer Position? Die Auftrags-nummer soll ebenfalls angezeigt werden.
SELECT DISTINCT bestellposition.fk_auftrag AS "Auftragsnummer", bestellposition.position AS "Position", (bestellposition.anzahl * artikel.einzelpreis) AS "Umsatz Einzelposition" FROM bestellposition
	LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		ORDER BY (bestellposition.anzahl * artikel.einzelpreis) DESC LIMIT 1;

-- Abfrage 21:
-- Wie viele Kunden haben bei mindestens einem Auftrag noch nicht gezahlt?
SELECT COUNT(DISTINCT auftrag.fk_kunde) AS "Kunden mit mindestens einem unbezahlten Auftrag" FROM auftrag
	WHERE auftrag.zahleingang IS NULL;

-- Abfrage 22:
-- In wie vielen Städten haben wir mindestens einen Shop vom Typ "Großhandel"?
SELECT COUNT(DISTINCT shop.fk_stadt) AS "Anzahl Städte mit mindestens einem Shop des Typs 'Großhandel'" FROM shop
	LEFT JOIN shoptyp ON shoptyp.typ_nr = shop.fk_shoptyp
		WHERE shoptyp.shoptyp = "Grosshandel";

-- Abfrage 23:
-- In wie vielen Städten haben wir keinen Shop vom Typ "Großhandel"?
SELECT COUNT(DISTINCT shop.fk_stadt) AS "Anzahl Städte ohne einem Shop des Typs 'Großhandel'" FROM shop
	LEFT JOIN shoptyp ON shoptyp.typ_nr = shop.fk_shoptyp
		WHERE shop.fk_stadt NOT IN
			(SELECT shop.fK_stadt AS "Anzahl Städte mit mindestens einem Shop des Typs 'Großhandel'" FROM shop
				LEFT JOIN shoptyp ON shoptyp.typ_nr = shop.fk_shoptyp
					WHERE shoptyp.shoptyp = "Grosshandel");

-- Abfrage 24:
-- Welcher im Jahr 2020 gelieferte Auftrag hatte den niedrigsten Gesamtwert?
SELECT auftrag.auft_nr AS "Auftragsnummer", SUM(bestellposition.anzahl * artikel.einzelpreis) AS "Gesamtwert" FROM auftrag
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE bestellposition.anzahl * artikel.einzelpreis IS NOT NULL AND auftrag.bestelldat between "2020-01-01" AND "2020-12-31"
			GROUP BY auftrag.auft_nr ORDER BY SUM(bestellposition.anzahl * artikel.einzelpreis) ASC LIMIT 1;

-- Abfrage 25:
-- Zeigen Sie alle Kunden mit Kundennummer, Vornamen und Nachnamen an, die im August 2019 einen Auftrag erteilt haben, der im 
-- selben Monat geliefert wurde. Jeder Kunde soll nur einmal angezeigt werden.
SELECT DISTINCT auftrag.fk_kunde AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname" FROM auftrag
	LEFT JOIN kunde ON kunde.kd_nr = auftrag.fk_kunde
		WHERE auftrag.bestelldat BETWEEN "2019-08-01" AND "2019-08-31" AND auftrag.lieferdat BETWEEN auftrag.bestelldat AND "2019-08-31";

-- Abfrage 26:
-- Wie hoch ist die durchschnittliche Lieferdauer pro Auftrag im PLZ-Gebiet 4 und wie hoch ist sie im PLZ-Gebiet 8? (PLZ bezogen auf die Kundentabelle)
SELECT LEFT(kunde.plz, 1) AS "PLZ-Gebiet", (SUM(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat))/COUNT(auftrag.auft_nr)) AS "Durchschnittliche Lieferzeit [Tage]" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		WHERE LEFT(kunde.plz, 1) = 4 OR LEFT(kunde.plz, 1) = 8
			GROUP BY LEFT(kunde.plz, 1)
				ORDER BY LEFT(kunde.plz, 1) ASC;

-- Abfrage 27:
-- Bei welchen Hamburgern und Münchenern wurde im selben Monat geliefert, in dem sie auch bestellt haben? Jeder Kunde soll nur 
-- einmal betrachtet werden.
SELECT DISTINCT kunde.kd_nr AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname", kunde.ort AS "Wohnort" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		WHERE kunde.ort IN ("Hamburg", "Muenchen") AND MONTH(auftrag.bestelldat) = MONTH(auftrag.lieferdat) AND YEAR(auftrag.bestelldat) = YEAR(auftrag.lieferdat)
			ORDER BY kunde.ort, kunde.kd_nr ASC;

-- Abfrage 28:
-- An welchen drei Tagen bezogen auf Tag und Monat wurde in der gesamten Zeit am häufigsten geliefert?
SELECT RIGHT(lieferdat, 5) AS "Liefertag (MM-TT)", COUNT(RIGHT(lieferdat, 5)) AS "Anzahl Lieferungen" FROM auftrag
	GROUP BY RIGHT(lieferdat, 5)
		ORDER BY COUNT(RIGHT(lieferdat, 5)) DESC LIMIT 3;

-- Abfrage 29:
-- Welche Kunden haben im nächsten Monat Geburtstag?
-- Die Abfrage soll allgemeingültig sein und sich immer auf das aktuelle Datum beziehen! Die Ausgabe soll sortiert nach der 
-- Tageszahl erfolgen.
SELECT DAY(kunde.geburtsdatum) AS "Tag", kunde.kd_nr AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname", kunde.geburtsdatum AS "Geburtsdatum" FROM kunde
	WHERE MONTH(kunde.geburtsdatum) = MONTH(DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH))
		ORDER BY DAY(kunde.geburtsdatum) ASC;

-- Abfrage 30:
-- Zeigen Sie zu jeder Stadt (Wohnort des Kunden) an, wie viele Kunden keinen Rabatt bekommen.
SELECT kunde.ort AS "Wohnort", COUNT(DISTINCT kunde.kd_nr) AS "Anzahl Kunden ohne Rabatt" FROM kunde
	WHERE kunde.rabatt = 0
		GROUP BY kunde.ort;

-- Abfrage 31:
-- Ermitteln Sie alle Kunden, die innerhalb der nächsten 20 Tage Geburtstag haben. Kunden, die heute Geburtstag haben, sollen 
-- nicht angezeigt werden.
SELECT * FROM kunde
	WHERE RIGHT(kunde.geburtsdatum, 5) BETWEEN RIGHT(DATE(DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY)), 5) AND RIGHT(DATE(DATE_ADD(CURRENT_DATE(), INTERVAL 20 DAY)), 5)
		ORDER BY RIGHT(kunde.geburtsdatum, 5) ASC;

-- Abfrage 32:
-- Wie viele Aufträge haben eine Lieferdauer von 10 Tagen?
SELECT COUNT(DISTINCT auftrag.auft_nr) AS "Anzahl Aufträge mit genau 10 Tagen Lieferzeit" FROM auftrag
	WHERE DATEDIFF(auftrag.lieferdat, auftrag.bestelldat) = 10;

-- Abfrage 33:
-- Ermitteln Sie die Adressdaten und den Shoptyp des Shops, in dem der höchste Umsatz mit Festplatten erzielt wurde.
SELECT shop.shop_nr AS "Shop-Nummer", shop.strasse AS "Straße", shop.plz AS "PLZ", stadt.stadt AS "Stadt" FROM shop
	INNER JOIN stadt ON stadt.stadt_nr = shop.fk_stadt
	INNER JOIN shoptyp ON shoptyp.typ_nr = shop.fk_shoptyp
    INNER JOIN auftrag ON auftrag.fk_shop = shop.shop_nr
    INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
	INNER JOIN kategorie ON kategorie.kat_nr = artikel.fk_kategorie
		GROUP BY shop.shop_nr, shop.strasse, shop.plz, stadt.stadt, kategorie.kategoriebezeichnung
			HAVING kategorie.kategoriebezeichnung = "Festplatte"
				ORDER BY SUM(bestellposition.anzahl * artikel.einzelpreis) DESC LIMIT 1;

-- Abfrage 34:
-- Ermitteln Sie das pro Auftrag anfallende Durchschnittsgewicht nach PLZ-Gebieten der Kunden (erste Stelle). Ordnen Sie das 
-- Ergebnis aufsteigend nach Durchschnittsgewicht.
SELECT DISTINCT LEFT(kunde.plz, 1) AS "PLZ-Gebiet", SUM(artikel.gewicht * bestellposition.anzahl) / COUNT(DISTINCT auftrag.auft_nr) AS "Durchschnittsgewicht pro Auftrag" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		GROUP BY LEFT(kunde.plz, 1)
			ORDER BY (SUM(artikel.gewicht * bestellposition.anzahl) / COUNT(DISTINCT auftrag.auft_nr)) ASC;

-- Abfrage 35:
-- In welchen Orten haben wir im Durchschnitt die kürzesten Lieferzeiten (bezogen auf die Wohnorte der Kunden)? Zeigen Sie die 5 besten Orte an.
SELECT kunde.ort AS "Top 5-Orte mit der kürzesten Lieferzeit" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		GROUP BY kunde.ort
			ORDER BY SUM(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) / COUNT(DISTINCT auftrag.auft_nr) ASC LIMIT 5;

-- Abfrage 36:
-- Ermitteln Sie alle Aufträge im Bereich der Auftragsnummern 8000 bis 9000, bei denen der Rechnungsbetrag (inkl. Rabatt) über 1.000.000 Euro lag.
SELECT DISTINCT auftrag.auft_nr AS "Auftragsnummer", SUM(bestellposition.anzahl * artikel.einzelpreis * (1 - kunde.rabatt)) AS "Umsatz aus Auftrag (inkl. Rabattierung)" FROM kunde
	LEFT JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE (auftrag.auft_nr BETWEEN 8000 and 9000)								
            GROUP BY auftrag.auft_nr
				HAVING SUM(bestellposition.anzahl * artikel.einzelpreis * (1 - kunde.rabatt)) > 1000000
					ORDER BY auftrag.auft_nr ASC;

-- Abfrage 37:
-- Ermitteln Sie alle Artikel, die mehr kosten als der Durchschnittspreis aller Artikel.
SELECT artikel.art_nr FROM artikel
	WHERE artikel.einzelpreis > 
    	
			(SELECT AVG(artikel.einzelpreis) FROM artikel)
		
        ORDER BY artikel.art_nr;

-- Abfrage 38:
-- Ermitteln Sie pro Kategorie, wie viele Artikel mehr kosten als der Durchschnittspreis der Artikel in der jeweiligen Kategorie. 
-- Die Ausgabe soll nach Kategoriebezeichnung absteigend sortiert erfolgen.
SELECT kategorie.kategoriebezeichnung AS "Kategoriebezeichnung", COUNT(A.art_nr) AS "Artikel, teurer als Durchschnitt in jeweiliger Kategorie" FROM kategorie
	INNER JOIN artikel AS A ON A.fk_kategorie = kategorie.kat_nr
		WHERE A.einzelpreis > 
        
			(SELECT AVG(artikel.einzelpreis) FROM artikel 
				WHERE A.fk_kategorie = artikel.fk_kategorie)
					
			GROUP BY kategorie.kategoriebezeichnung        
				ORDER BY kategorie.kategoriebezeichnung DESC;

-- Abfrage 39:
-- Ermitteln Sie alle Essener Kunden, die mehr als 3 Mio. € Umsatz gemacht haben.
SELECT kunde.kd_nr AS "Kundennummer", kunde.ort, SUM(bestellposition.anzahl * artikel.einzelpreis * (1 - kunde.rabatt)) AS "Kundenumsatz" FROM kunde 
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
	INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE kunde.ort = "Essen"
			GROUP BY kunde.kd_nr, kunde.ort
				HAVING (SUM(bestellposition.anzahl * artikel.einzelpreis * (1 - kunde.rabatt))) > 3000000
					ORDER BY kunde.kd_nr ASC;

-- Abfrage 40:
-- Welche Kunden haben mehr als 3 Aufträge im Dezember 2019 erteilt?
SELECT kunde.kd_nr AS "Kundennummer", COUNT(DISTINCT auftrag.auft_nr) AS "Anzahl Aufträge" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		WHERE auftrag.bestelldat BETWEEN "2019-12-01" AND "2019-12-31"
			GROUP BY kunde.kd_nr
				HAVING COUNT(DISTINCT auftrag.auft_nr) > 3;

-- Abfrage 41:
-- Ermitteln Sie alle inkonsistenten Datensätze aus der Bestellungstabelle in Bezug auf die Auftragstabelle, also Bestellungen, 
-- die einem Auftrag zugeordnet sind, der nicht existiert.
SELECT bestellposition.fk_auftrag FROM bestellposition
	WHERE bestellposition.fk_auftrag NOT IN 
		
        (SELECT auftrag.auft_nr FROM auftrag);

-- Abfrage 42:
-- Wie hoch ist die Differenz zwischen dem Umsatz im Shop mit der ShopID 15 und dem im Shop mit der ShopID 10? Der Wert soll als 
-- positive Zahl angezeigt werden.
SELECT ABS(SUM(bestellposition.anzahl * artikel.einzelpreis) - 

	(SELECT SUM(bestellposition.anzahl * artikel.einzelpreis) AS "Umsatz" FROM shop
		INNER JOIN auftrag ON auftrag.fk_shop = shop.shop_nr
		INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
			WHERE shop.shop_nr IN (10)
				GROUP BY shop.shop_nr
				ORDER BY SUM(bestellposition.anzahl * artikel.einzelpreis) DESC LIMIT 1))
				
																	AS "Umsatz" FROM shop
	INNER JOIN auftrag ON auftrag.fk_shop = shop.shop_nr
    INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE shop.shop_nr IN (15)
			GROUP BY shop.shop_nr
            ORDER BY SUM(bestellposition.anzahl * artikel.einzelpreis) DESC LIMIT 1;

-- Abfrage 43:
-- Welchen Durchschnittsumsatz haben Sie in den Aufträgen 2000 bis 2100 erzielt?
SELECT SUM(bestellposition.anzahl * artikel.einzelpreis) / COUNT(DISTINCT auftrag.auft_nr) AS "Durchschnittsumsatz" FROM auftrag
	INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE auftrag.auft_nr BETWEEN 2000 AND 2100;

-- Abfrage 44:
-- Welche Artikel (Artikelnummer, Artikelbezeichnung, Einzelpreis und Anzahl) hatte der Kunde 193 bei seiner letzten Bestellung 
-- in seinem Warenkorb? Wann hat er die Bestellung aufgegeben und wann wurde geliefert?
SELECT bestellposition.fk_artikel AS "Artikel", artikel.artikelbezeichnung AS "Bezeichnung", artikel.einzelpreis AS "Einzelpreis", bestellposition.anzahl AS "Anzahl" FROM auftrag
	INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE auftrag.fk_kunde = 193 AND auftrag.bestelldat IN
			(SELECT MAX(auftrag.bestelldat) FROM auftrag
				WHERE auftrag.fk_kunde = 193);

-- Abfrage 45: *
-- Berechnen Sie das aktuelle Alter der Kunden in Jahren. Das Alter in Jahren soll tagesgenau berechnet werden.
-- Hinweis: Recherchieren Sie eine einfache Lösung, das Alter zu berechnen.
SELECT kunde.kd_nr AS "Kundennummer", kunde.geburtsdatum AS "Geburtsdatum", -LEFT((PERIOD_DIFF(CONCAT(LEFT(kunde.geburtsdatum,4), LEFT(RIGHT(kunde.geburtsdatum,5),2)), CONCAT(LEFT(CURRENT_DATE(),4), LEFT(RIGHT(CURRENT_DATE(),5),2)))/12),3) AS "Alter" FROM kunde;

-- Abfrage 46:
-- Ermitteln Sie die PLZ-Gebiete (1. Stelle), in denen das Durchschnittsalter der Kunden höher als der Gesamtdurchschnitt ist.
SELECT LEFT(kunde.plz, 1) FROM kunde
	WHERE kunde.geburtsdatum IS NOT NULL
		GROUP BY LEFT(kunde.plz, 1)
		HAVING SUM(ABS(DATEDIFF(kunde.geburtsdatum, CURDATE()) DIV 365)) DIV COUNT(kunde.kd_nr) > 
        
			(SELECT SUM(ABS(DATEDIFF(kunde.geburtsdatum, CURDATE()) DIV 365)) DIV COUNT(kunde.kd_nr) AS "Alter" FROM kunde
				WHERE kunde.geburtsdatum IS NOT NULL);

-- Abfrage 47 *:
-- Berechnen Sie die Differenz zwischen der maximalen und der minimalen Durchschnitts-Lieferdauer in den PLZ-Gebieten (1. Stelle).
DROP TEMPORARY TABLE IF EXISTS min_max;

CREATE TEMPORARY TABLE min_max SELECT LEFT(kunde.plz, 1) AS "PLZ-Gebiet", AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) AS "Lieferzeit" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		GROUP BY LEFT(kunde.plz, 1)
        ORDER BY AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) DESC LIMIT 1;
        
INSERT INTO min_max SELECT LEFT(kunde.plz, 1) AS "PLZ-Gebiet", AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) AS "Lieferzeit" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
		GROUP BY LEFT(kunde.plz, 1)
        ORDER BY AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) ASC LIMIT 1;
        
SELECT MAX(min_max.Lieferzeit) - MIN(min_max.lieferzeit) AS "Delta MIN/MAX Lieferdauer" FROM min_max;

-- Abfrage 48:
-- Ermitteln Sie, welches PLZ-Gebiet (1. Stelle, bezogen auf die Shops) die geringste Abweichung von der durchschnittlichen Lieferdauer 
-- über alle Gebiete aufweist.
SELECT LEFT(shop.plz, 1) AS "PLZ-Gebiet (nach Shop)", ABS(AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) - 
	(SELECT AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) FROM auftrag)) AS "geringste Abweichung von durchschnittlicher Lieferdauer"
FROM shop
	INNER JOIN auftrag ON auftrag.fk_shop = shop.shop_nr
		GROUP BY LEFT(shop.plz, 1)
        ORDER BY ABS(AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) - (SELECT AVG(DATEDIFF(auftrag.lieferdat, auftrag.bestelldat)) FROM auftrag)) LIMIT 1;

-- Abfrage 49:
-- Ermitteln Sie für die Aufträge 8533 bis 8537 die jeweilige Anzahl der Bestellpositionen. Aufträge, die keine Bestellpositionen haben, 
-- sollen den Wert 0 ausweisen!
SELECT auftrag.auft_nr AS "Auftrag", COUNT(DISTINCT bestellposition.position) AS "Anzahl Positionen" FROM auftrag
	LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		WHERE auftrag.auft_nr BETWEEN 8533 AND 8537
			GROUP BY auftrag.auft_nr;

-- Abfrage 50:
-- Wie hoch ist die prozentuale Veränderung der Umsätze im Jahr 2020 im Vergleich zum Jahr 2019? (Nutzen Sie als Datumsfeld bitte das Lieferdatum.)
SELECT (

	(SELECT SUM(artikel.einzelpreis * bestellposition.anzahl)FROM auftrag
		LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
			WHERE LEFT(auftrag.lieferdat, 4) IN (2020))
            
            / SUM(artikel.einzelpreis * bestellposition.anzahl)-1)*100 AS "Umsatzänderung 2019 -> 2020 [%]" FROM auftrag
				LEFT JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
				LEFT JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
				WHERE LEFT(auftrag.lieferdat, 4) IN (2019);

-- Abfrage 51:
-- Zeigen Sie alle Kunden aus Regensburg mit den von ihnen vergebenen Aufträgen und den in den Aufträgen vorhandenen Bestellpositionen an.
-- Hinweis: Auch Kunden ohne Aufträge sollen angezeigt werden.
SELECT kunde.kd_nr AS "Kundenummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname", auftrag.auft_nr AS "Auftragsnummer", bestellposition.position AS "Bestellposition", bestellposition.fk_artikel AS "Artikel", artikel.artikelbezeichnung AS "Artikelbezeichnung", bestellposition.anzahl AS "Menge" FROM kunde
	INNER JOIN auftrag ON auftrag.fk_kunde = kunde.kd_nr
    INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
    INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
		WHERE kunde.ort IN ('Regensburg');

-- Abfrage 52: *
-- Zeigen Sie die drei Kunden mit den höchsten und die drei Kunden mit den niedrigsten Gesamtumsätzen - geordnet nach den Gesamtumsätzen absteigend - an.
DROP TEMPORARY TABLE IF EXISTS high_low;

CREATE TEMPORARY TABLE high_low SELECT auftrag.fk_kunde AS "Kundennummer", SUM(artikel.einzelpreis * bestellposition.anzahl) AS "Umsatz" FROM auftrag
		INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
			GROUP BY auftrag.fk_kunde
			ORDER BY SUM(artikel.einzelpreis * bestellposition.anzahl) ASC LIMIT 3;
            
INSERT INTO high_low SELECT auftrag.fk_kunde, SUM(artikel.einzelpreis * bestellposition.anzahl) FROM auftrag
		INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
			GROUP BY auftrag.fk_kunde
			ORDER BY SUM(artikel.einzelpreis * bestellposition.anzahl) DESC LIMIT 3;

SELECT * FROM high_low
	ORDER BY high_low.Umsatz DESC;	

-- Abfrage 53: *
-- Sie vermuten, dass bei der Eingabe Fehler gemacht wurden, so dass manche Kunden doppelt in Ihrem Kundenstamm vorkommen. Suchen Sie alle Datensätze aus 
-- der Kundentabelle, bei denen der Vorname, der Nachname und der Wohnort übereinstimmen. Handelt es sich hier tatsächlich um ein Duplikat?
SELECT * FROM kunde
	WHERE kunde.nachname IN 
		(SELECT kunde.nachname AS "Nachname" FROM kunde	GROUP BY kunde.nachname, kunde.vorname, kunde.ort HAVING COUNT(DISTINCT kunde.kd_nr) > 1) 
	AND kunde.vorname IN 
		(SELECT kunde.vorname AS "Vorname" FROM kunde GROUP BY kunde.nachname, kunde.vorname, kunde.ort HAVING COUNT(DISTINCT kunde.kd_nr) > 1)
	AND kunde.ort IN 
		(SELECT kunde.ort AS "Ort" FROM kunde GROUP BY kunde.nachname, kunde.vorname, kunde.ort HAVING COUNT(DISTINCT kunde.kd_nr) > 1);
-- Antwort: Nein, offensichtlich handelt es sich um kein Dublikat: Geburtstage, Telefonnummern und Ehestand sind unterschiedlich, als auch die PLZs.

-- Abfrage 54: *
-- Mit welchem Auftrag wurde der 5. höchste Umsatz erzielt? Es soll nur dieser eine Auftrag angezeigt werden.
DROP TEMPORARY TABLE IF EXISTS top5 ;
CREATE TEMPORARY TABLE top5 SELECT auftrag.auft_nr AS "auftragsnummer", SUM((bestellposition.anzahl * artikel.einzelpreis)) AS "umsatz" FROM auftrag
		INNER JOIN kunde ON kunde.kd_nr = auftrag.fk_kunde
		INNER JOIN bestellposition ON bestellposition.fk_auftrag = auftrag.auft_nr
		INNER JOIN artikel ON artikel.art_nr = bestellposition.fk_artikel
				GROUP BY auftrag.auft_nr
					ORDER BY SUM((bestellposition.anzahl * artikel.einzelpreis)) DESC LIMIT 5;
SELECT auftragsnummer FROM top5
	ORDER BY umsatz LIMIT 1;

-- Abfrage 55: *
-- Zeigen Sie alle Kunden an, deren Nachname mit "M", "N" oder "O" beginnt und mit "n", "r" oder "s" endet.
SELECT kunde.kd_nr AS "Kundennummer", kunde.vorname AS "Vorname", kunde.nachname AS "Nachname" FROM kunde
	WHERE LEFT(kunde.nachname, 1) IN ('M', 'N', 'O') AND RIGHT(kunde.nachname, 1) IN ('n', 'r', 's');