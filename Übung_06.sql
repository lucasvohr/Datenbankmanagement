USE bestellungen;

LOAD DATA INFILE
	"C:\\temp\\stadtimp.txt"
    INTO TABLE stadt;
    
LOAD DATA INFILE
	"C:\\temp\\herstellerimp.txt"
    INTO TABLE hersteller;
    
LOAD DATA INFILE
	"C:\\temp\\artikelimp.txt"
    INTO TABLE artikel;  
    
LOAD DATA INFILE
	"C:\\temp\\shopimp.txt"
    INTO TABLE shop;
    
LOAD DATA INFILE
	"C:\\temp\\kundenimp.txt"
    INTO TABLE kunde;
    
LOAD DATA INFILE
	"C:\\temp\\auftragimp.txt"
    INTO TABLE auftrag;
    

    