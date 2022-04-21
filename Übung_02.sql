
-- Übung 02

USE bestellungen;

ALTER TABLE auftrag 
	ADD rabatt DOUBLE (2,2) DEFAULT 0.03,
	ADD letzter TIMESTAMP;
    
ALTER TABLE kunden RENAME kunde;
    
ALTER TABLE kunde
	ADD letzter TIMESTAMP;

ALTER TABLE kunde
    CHANGE letzter letzter_zugriff TIMESTAMP,
    MODIFY strasse VARCHAR (35);
    
ALTER TABLE artikel
	ADD KEY (artikelbezeichnung);
