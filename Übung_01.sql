
-- Übung 01 --

create database bestellungen;
use bestellungen;

create table kunden(
	
    kd_nr smallint unsigned zerofill auto_increment,
	vorname varchar(30),
	nachname varchar(30),
	strasse varchar(25),
	plz char(5),
	ort varchar(30),
	vorwahl varchar(6),
	telefon varchar(15),
	geburtsdatum date,
	ledig bool,
    key nachvor (nachname, vorname),
    primary key (kd_nr)
    
) engine = innodb;

create table auftrag(
	
    auftr_nr int unsigned,
    bestelldat date,
    lieferdat date,
    constraint check_lieferdat check (lieferdat > bestelldat),
    zahlungsziel date,
	constraint check_zahlungsziel check (zahlungsziel > lieferdat),
    zahleingang date,
    mahnung enum ('0', '1', '2', '3') default '0',
	primary key (auftr_nr)

) engine = innodb;

create table artikel(
	
    art_nr smallint unsigned,
    artikelbezeichnung varchar(100),
    einzelpreis double (8,2),
    constraint check_preis check (einzelpreis >= 10),
    gewicht double (5,2),
	primary key(art_nr)
    
);

create table hersteller(
	
    herst_nr tinyint unsigned primary key, 
    
    herstellerbezeichnung varchar(39)

);

create table kategorie(
	
    kat_nr tinyint unsigned primary key,
	
    kategoriebezeichnung varchar(30)

);


