USE bestellungen;

CREATE TABLE bestellposition (
	fk_auftrag INT(10) UNSIGNED,
    position TINYINT,
    fk_artikel SMALLINT(5) UNSIGNED,
    anzahl INT(10),
    
    CONSTRAINT fk_auftrag FOREIGN KEY (fk_auftrag)
		REFERENCES auftrag (auft_nr)
        ON DELETE SET NULL,
        
	CONSTRAINT fk_artikel FOREIGN KEY (fk_artikel)
		REFERENCES artikel (art_nr)
        ON DELETE CASCADE
);

LOAD DATA INFILE
	"C:\\temp\\bestellungimp.txt"
    INTO TABLE bestellposition;  
    
UPDATE artikel
	SET einzelpreis = einzelpreis * 0.94
    WHERE fk_hersteller = 6;