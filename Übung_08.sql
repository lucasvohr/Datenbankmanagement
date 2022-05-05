USE bestellungen;

DELETE FROM artikel
	WHERE fk_kategorie = 11 OR fk_kategorie = 3 OR fk_kategorie = 10 OR fk_kategorie = 5;
    

    