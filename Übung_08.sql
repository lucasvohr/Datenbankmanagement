USE bestellungen;

DELETE FROM artikel
	WHERE fk_kategorie IN ( 11, 3, 10, 5); 
    
DELETE FROM kunde
	WHERE kd_nr = 1;
    
DELETE FROM auftrag
WHERE fk_kunde IS NULL;

DELETE FROM bestellposition
WHERE fk_auftrag IS NULL;

DELETE FROM auftrag
WHERE fk_kunde = 437;

DELETE FROM bestellposition
WHERE fk_auftrag IS NULL;
    