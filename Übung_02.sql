
-- Übung 02

use bestellungen;

alter table auftrag 
	add rabatt double (2,2) default 0.03,
	add letzter timestamp,
    modify strasse varchar(35),
    rename kunde;
    
alter table kunde
	change letzter letzter_zugriff timestamp;
    
alter table artikel
	add key (artikelbezeichnung);
