
-- Übung 01 --

DROP DATABASE IF EXISTS bestellungen;
CREATE DATABASE bestellungen;
USE bestellungen;

CREATE TABLE kunden(
	kd_nr SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
	vorname VARCHAR (30),
	nachname VARCHAR (30),
	strasse VARCHAR (25),
	plz CHAR (5),
	ort VARCHAR (30),
	vorwahl VARCHAR (6),
	telefon VARCHAR (15),
	geburtsdatum DATE,
	ledig BOOL,
    KEY nachvor (nachname, vorname),
   
	PRIMARY KEY (kd_nr)
);

CREATE TABLE auftrag(
	auft_nr INT UNSIGNED,
    bestelldat DATE,
    lieferdat DATE,
    CONSTRAINT check_lieferdat CHECK (lieferdat > bestelldat),
    zahlungsziel DATE,
	CONSTRAINT check_zahlungsziel CHECK (zahlungsziel > lieferdat),
    zahleingang DATE,
    mahnung ENUM ('0', '1', '2', '3') DEFAULT '0',
	
    PRIMARY KEY (auft_nr)
);

create table artikel(
	art_nr SMALLINT UNSIGNED,
    artikelbezeichnung VARCHAR (100),
    einzelpreis DOUBLE (8,2),
    CONSTRAINT check_preis CHECK (einzelpreis >= 10),
    gewicht DOUBLE (5,2),
	
    PRIMARY KEY (art_nr)
);

CREATE TABLE hersteller(
	herst_nr TINYINT UNSIGNED, 
    herstellerbezeichnung VARCHAR (39),
    
    PRIMARY KEY (herst_nr)
);

create table kategorie(
	kat_nr TINYINT UNSIGNED,
	kategoriebezeichnung varchar (30),
    
    PRIMARY KEY (kat_nr)
);


