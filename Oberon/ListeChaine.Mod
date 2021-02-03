MODULE ListeChaine;
IMPORT Out;
TYPE
  Node* = POINTER TO Liste;
  Liste* =RECORD
   key*:INTEGER;
   next*:Node
  END;
  Node2* = POINTER TO GrandeListe;
  GrandeListe* =RECORD
   key*:Node;
   next*:Node2
  END;
  NodeItems* =POINTER TO ItemsTotal;
  ItemsTotal* =RECORD
   key1*:ARRAY 50 OF CHAR;
   key2*:INTEGER;
   next*:NodeItems
  END;
VAR

PROCEDURE AfficherListe*(VAR Tete:Node);
    VAR 
       liste:Node;
     BEGIN
        NEW(liste);
        liste:=Tete;
       WHILE liste # NIL DO
         Out.Int(liste.key,1);
          IF liste.next # NIL THEN
           Out.String(";");
          END;
         liste:=liste.next;
        END;
    END AfficherListe;    
PROCEDURE GrandAfficherListe*(VAR Tete:Node2);
   VAR Gliste:Node2;
       r:INTEGER;
	 BEGIN
     r:=0;
	     NEW(Gliste);
       Gliste:=Tete;
	     WHILE Gliste # NIL DO
       Out.String("{");
		    AfficherListe(Gliste.key);
       Out.String("} "); 
       Gliste:=Gliste.next;
	     END;
  END GrandAfficherListe;	
PROCEDURE appartenir*(VAR Tete:Node;VAR valeur:INTEGER): INTEGER;
VAR newtete:Node;
    sorti: INTEGER;
    BEGIN
    sorti:=0;
    newtete:=Tete;
    WHILE (newtete # NIL) & (sorti =0) DO 
     IF newtete.key =valeur THEN
      sorti:=1;
     END;
     newtete:=newtete.next;
    END;
 RETURN sorti
END appartenir;
PROCEDURE GrandeAppartenance*(VAR Tete:Node2;VAR SousTete :Node):INTEGER;
  VAR newtete:Node2;
      newsoustete1,newsoustete2:Node;
      valeur,valeurFinale:INTEGER;
  BEGIN
  newtete:=Tete;
  newsoustete2:=SousTete;
  valeurFinale:=0;
      WHILE (newtete # NIL) & (valeurFinale = 0) DO
      valeurFinale:=1;
      newsoustete1:=newtete.key;
       WHILE (newsoustete1 # NIL) & (valeurFinale = 1) DO
         valeur:=appartenir(newsoustete2,newsoustete1.key);
         valeurFinale:=valeurFinale*valeur;
        newsoustete1:=newsoustete1.next;
       END;
      newtete:=newtete.next; 
      END; 
    RETURN valeurFinale
END GrandeAppartenance;  
PROCEDURE InsertionTete*(VAR Tete:Node;valeur:INTEGER);
       VAR n:Node;
       BEGIN
       IF Tete # NIL THEN
          NEW(n);
          n.key:=valeur;
          n.next:=Tete;
          Tete:=n;
        ELSE
        NEW(Tete);
        Tete.key:=valeur;
        Tete.next:=NIL;
        END
    END InsertionTete;  
PROCEDURE InsertionTeteItem*(VAR Tete:NodeItems;VAR chaine: ARRAY OF CHAR;VAR code:INTEGER);
VAR n:NodeItems;
BEGIN
    IF Tete # NIL THEN
     NEW(n);
     n.key1:=chaine;
     n.key2:=code;
     n.next:=Tete;
     Tete:=n;
    ELSE
    NEW(Tete);
    Tete.key1:=chaine;
    Tete.key2:=code;
    Tete.next:=NIL;
    END;
END  InsertionTeteItem;   
PROCEDURE GrandInsertionTete*(VAR Tete:Node2;SousTete:Node);
  VAR GndNode:Node2; 
		BEGIN
 		IF Tete # NIL THEN
      NEW(GndNode);
			GndNode.key:=SousTete;
			GndNode.next:=Tete;
			Tete:=GndNode;
		ELSE
			NEW(Tete);
			Tete.key:=SousTete;
			Tete.next:=NIL;
		END;
END GrandInsertionTete;
PROCEDURE Suppression*(VAR Tete:Node;valeur:INTEGER);
        VAR tete:Node;
            trouver:INTEGER;
            Asuprimer:Node;
        BEGIN
        trouver:=0;
        NEW(tete);tete:=Tete;
        IF tete.key =valeur THEN
              Tete:=tete.next;
        ELSE
            WHILE (tete.next # NIL)&(trouver=0) DO
                IF tete.next.key = valeur THEN
                     Asuprimer:=tete.next;
                     trouver:=1;
                     IF tete.next.next # NIL THEN
                         tete.next:=tete.next.next;
                     ELSE
                       trouver:=2;
                       tete.next:=NIL;    
                   END;
                END;   
              IF trouver=2 THEN
                   tete.next:=NIL;
                ELSE
                 tete:=tete.next;
                END    
            END;
        END;
END Suppression;  
PROCEDURE GrandSuppression*(VAR Tete:Node2;SousTete:Node);
        VAR tete,prec:Node2;
            trouver:INTEGER;
            Asuprimer,SousTetevariable:Node;
        BEGIN

    trouver:=0;
        IF Tete # NIL THEN
        tete:=Tete;
        prec:=Tete;
            WHILE (tete # NIL)&(trouver=0) DO
                Asuprimer:=tete.key;
                SousTetevariable:=SousTete;
                 WHILE (Asuprimer # NIL)&(Asuprimer.key = SousTetevariable.key) DO
                    Asuprimer:=Asuprimer.next;
                    SousTetevariable:=SousTetevariable.next;
                 END;
                 IF (Asuprimer = NIL)THEN
                   trouver:=1;
                 ELSE
                 prec:=tete;
                 tete:=tete.next;
                 END;
            END;
            IF (trouver = 1) THEN
              IF tete # Tete THEN
               prec.next:=tete.next;
              ELSE
                Tete:=Tete.next; 
              END;
            END;  
        END;     
  END GrandSuppression;   
PROCEDURE EstPresent*(VAR Tete:Node; valeur:INTEGER) : INTEGER;
       VAR 
            n : Node;
            present : INTEGER;
       BEGIN
            n := Tete;
            present := 0;
            WHILE (n # NIL) & (present # 1) DO
                IF n.key = valeur THEN
                    present := 1;
                ELSE
                    n := n.next;
                END;
            END;
        RETURN present
    END EstPresent; 

PROCEDURE InsertionSansDoublon*(VAR tete:Node; VAR val : INTEGER);
    BEGIN
        IF (EstPresent(tete, val) = 0 ) THEN
            InsertionTete(tete, val);
        END;
END InsertionSansDoublon;

END ListeChaine.

