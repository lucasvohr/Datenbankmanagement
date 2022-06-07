USE bestellungen;

-- **********************************
-- * Einfügen in Tabelle hersteller *
-- **********************************
    
INSERT INTO hersteller VALUES
	(1, "Samsung"),
    (2, "Jamaha");

-- *********************************
-- * Einfügen in Tabelle kategorie *
-- *********************************

INSERT INTO kategorie VALUES
	(1, "Festplatte"),
	(2, "Monitor"),
	(3, "Rechner"),
	(4, "Drucker"),
	(5, "Multimedia"),
	(6, "Grafikkarten"),
	(7, "Mainboard"),
	(8, "Software"),
	(9, "Software (Anwendung)"),
	(10, "Software (Spiel)"),
	(11, "Testkategorie");

-- *******************************
-- * Einfügen in Tabelle artikel *
-- *******************************

INSERT INTO artikel VALUES
	(1, "Festplatte 178 GB, 7150 rpm", 133.50, 0.80, 1, 1),
	(2, "Festplatte 165 B, 7200 rpm", 128.70, 0.82, 1, 2),
	(3, "Monitor 19 TFT XA33-5", 368.99, 11.40, 2, 1);

-- *****************************
-- * Einfügen in Tabelle stadt *
-- *****************************

INSERT INTO stadt VALUES 
	(1, "Hamburg", 10.0, 53.55),
	(2, "Duesseldorf", 6.7667, 51.2167),
	(3, "Dortmund", 4.4734, 51.5147);

-- *******************************
-- * Einfügen in Tabelle shoptyp *
-- *******************************

INSERT INTO shoptyp VALUES
	(1, "Grosshandel"),
    (2, "Supermarkt"),
    (3, "Einzelhandel");

-- *****************************
-- * Einfügen in Tabelle shop *
-- *****************************

INSERT INTO shop VALUES
	(1, 3, "Hauptstr. 38", "44145", 3),
    (2, 1, "Lessinggasse 15", "40589", 2);

-- *****************************
-- * Einfügen in Tabelle kunde *
-- *****************************

INSERT INTO bestellungen.kunde VALUES
	(NULL, "Claudia", "Schulze", "Hansastr. 334", "20332", "Hamburg", "030", "223234", NULL, 1, 0.4, NULL),
    (NULL, "Hans", "Müller", "Hauptstr. 44a", "45147", "Essen", "0201", "345123", NULL, 1, 0.3, NULL);

-- *******************************
-- * Einfügen in Tabelle auftrag *
-- *******************************

INSERT INTO auftrag	VALUES 
	(1000, "2018-07-01", "2018.08-02", "2018-08-31", NULL, '1', 1, 2),
    (1001, "2018-07-01", "2018.07-19", "2018-08-20", "2018-08-05", NULL, 2, NULL);
    
