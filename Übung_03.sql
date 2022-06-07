
-- Übung 03

-- Anpassung der bestehenden Tabellen


ALTER TABLE artikel 
	ADD fk_kategorie TINYINT (3) UNSIGNED,
    ADD fk_hersteller TINYINT UNSIGNED,
    ADD FOREIGN KEY (fk_kategorie) 
		REFERENCES kategorie (kat_nr) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD FOREIGN KEY (fk_hersteller) 
		REFERENCES hersteller (herst_nr) 
		ON UPDATE CASCADE ON DELETE SET NULL;

-- Hinzufügen weiterer Tabellen

CREATE TABLE stadt (
	stadt_nr TINYINT UNSIGNED,
    stadt VARCHAR (30),
    lat DOUBLE UNSIGNED,
    lon DOUBLE UNSIGNED,
    
    PRIMARY KEY (stadt_nr)
);

CREATE TABLE shoptyp (
	typ_nr TINYINT UNSIGNED,
    shoptyp VARCHAR (30),
    
    PRIMARY KEY (typ_nr)
);

CREATE TABLE shop (
	shop_nr SMALLINT UNSIGNED,
    fk_shoptyp TINYINT UNSIGNED,
    strasse VARCHAR (30),
	plz CHAR (5),
    fk_stadt TINYINT UNSIGNED,
    
    PRIMARY KEY (shop_nr),
    FOREIGN KEY (fk_stadt) 
		REFERENCES stadt (stadt_nr) 
        ON DELETE CASCADE,
    FOREIGN KEY (fk_shoptyp) 
		REFERENCES shoptyp (typ_nr) 
        ON DELETE CASCADE
);


ALTER TABLE auftrag 
	ADD fk_kunde SMALLINT UNSIGNED ZEROFILL,
    ADD FOREIGN KEY (fk_kunde) 
		REFERENCES kunde (kd_nr) 
        ON UPDATE CASCADE ON DELETE SET NULL,
	
    ADD fk_shop SMALLINT UNSIGNED,
    ADD FOREIGN KEY (fk_shop) 
		REFERENCES shop (shop_nr) 
        ON UPDATE CASCADE ON DELETE SET NULL;