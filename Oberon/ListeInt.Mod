MODULE ListeInt;
IMPORT Out;
    TYPE
        Node* = POINTER TO Liste;
        Liste* = RECORD
            key : INTEGER;
            next : Node
        END;

    PROCEDURE AfficherListe*(VAR Tete:Node);
    VAR 
       liste:Node;
     BEGIN
        NEW(liste);
        liste := Tete;
        Out.String("S = [");
        WHILE liste # NIL DO
            Out.Int(liste.key, 1);
            IF liste.next # NIL THEN
                Out.String("; ");
            END;
            liste:=liste.next;
        END;
        Out.String("]");
        Out.Ln;
    END AfficherListe; 

    PROCEDURE InsertionTete*(VAR Tete:Node; valeur:INTEGER);
       VAR 
            n : Node;
       BEGIN
        IF Tete # NIL THEN
            NEW(n);
            n.key := valeur;
            n.next := Tete;
            Tete := n;
        ELSE
            NEW(Tete);
            Tete.key := valeur;
            Tete.next := NIL;
        END

    END InsertionTete;  

    PROCEDURE Suppression*(VAR Tete:Node; valeur:INTEGER);
        VAR 
            tete, Asuprimer : Node;
            trouver : INTEGER;
        BEGIN
        trouver:=0;
        NEW(tete);
        tete:=Tete;
        IF tete.key =valeur THEN
            Tete:=tete.next;
        ELSE
            WHILE (tete.next # NIL) & (trouver = 0) DO
                IF tete.next.key = valeur THEN
                     Asuprimer:=tete.next;
                     trouver:=1;
                     IF tete.next.next # NIL THEN
                         tete.next:=tete.next.next;
                     ELSE
                       trouver := 2;
                       tete.next := NIL;    
               		 END;
               	END;	 
            	IF trouver = 2 THEN
              		 tete.next := NIL;
              	ELSE
              	 tete := tete.next;
              	END 	 
            END;
        END;
    END Suppression;  

    PROCEDURE EstPresent*(VAR Tete:Node; valeur:INTEGER) : BOOLEAN;
       VAR 
            n : Node;
            present : BOOLEAN;
       BEGIN
            n := Tete;
            present := FALSE;
            WHILE (n # NIL) & (~present) DO
                IF n.key = valeur THEN
                    present := TRUE;
                ELSE
                    n := n.next;
                END;
            END;
        RETURN present;
    END EstPresent;

    PROCEDURE InsertionSansDoublon*(VAR tete:Node; val : INTEGER);
    BEGIN
        IF (~EstPresent(tete, val)) THEN
            InsertionTete(tete, val);
        END;
    END InsertionSansDoublon;

END ListeInt.    