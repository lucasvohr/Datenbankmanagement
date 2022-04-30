USE bestellungen;

-- ************************
-- * Update Tabelle kunde *
-- ************************

UPDATE kunde
	SET vorwahl = "040",
		geburtsdatum = "1978-01-01"
    WHERE vorname = "Claudia"
    AND nachname = "Schulze";

-- ****************************
-- * Update Tabelle kategorie *
-- ****************************

UPDATE kategorie
	SET kategoriebezeichnung = "Software (Betriebssystem)"
    WHERE kat_nr = 8;
    
-- *****************************
-- * Update Tabelle hersteller *
-- *****************************

UPDATE hersteller
	SET herstellerbezeichnung = "Yamaha"
    WHERE herst_nr = 2;