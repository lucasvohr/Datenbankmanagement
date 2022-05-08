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
        
	-- Ein Primärschlüssel auf Anzahl macht keinen Sinn, weil sonst nur ein einziges Mal ein Artikel verkauft werden dürfte
    -- Weiterhin könnte man über die Verbindung von den Fremdschlüsseln einen Primärschlüssel generieren, allerdings wäre das
    -- nicht erlaubt, weil dann beim Löschen eines der Schlüssel, bzw. beim Setzen auf NULL die komplette Referenzielle Integrität
    -- zerstört werden würde.
);

LOAD DATA INFILE
	"C:\\temp\\bestellungimp.txt"
    INTO TABLE bestellposition;  
    
UPDATE artikel
	SET einzelpreis = einzelpreis * 0.94
    WHERE fk_hersteller = 6;