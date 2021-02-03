unit ListeInt;
    
interface
    TYPE
        Liste  = RECORD
            key : INTEGER;
            next : ^Liste;
        END;
        Node  = ^Liste;

    PROCEDURE AfficherListe (VAR Tete:Node);
    PROCEDURE InsertionTete (VAR Tete:Node; valeur:INTEGER);
    PROCEDURE Suppression (VAR Tete:Node; valeur:INTEGER);
    function EstPresent (VAR Tete:Node; valeur:INTEGER) : BOOLEAN;
    PROCEDURE InsertionSansDoublon (VAR tete:Node; val : INTEGER);

implementation
    
    PROCEDURE AfficherListe (VAR Tete:Node);
    VAR 
       liste : Node;
     BEGIN
        NEW(liste);
        liste := Tete;
        write(' S = [');
        WHILE liste <> NIL DO
        BEGIN
            write(liste^.key);
            IF (liste^.next <> NIL) THEN
            write(' ; '); 

         liste:=liste^.next;
        END;
        writeln(' ]');
    END; 

    PROCEDURE InsertionTete (VAR Tete:Node; valeur:INTEGER);
       VAR 
            n : Node;
       BEGIN
        IF Tete <> NIL THEN
        BEGIN
            NEW(n);
            n^.key := valeur;
            n^.next := Tete;
            Tete := n;
        END
        ELSE
        BEGIN
            NEW(Tete);
            Tete^.key := valeur;
            Tete^.next := NIL;
        END;
    END;  

    PROCEDURE Suppression (VAR Tete:Node; valeur:INTEGER);
    VAR 
        t : Node;
        trouver : INTEGER;
    BEGIN
        trouver := 0;
        NEW(tete);
        t := Tete;
        IF t^.key =valeur THEN
            Tete:=t^.next
        ELSE
        BEGIN
            WHILE (t^.next <> NIL) and (trouver = 0) DO
            BEGIN
                IF t^.next^.key = valeur THEN
                BEGIN
                        trouver:=1;
                        IF t^.next^.next <> NIL THEN
                            t^.next := t^.next^.next
                        ELSE
                        BEGIN
                            trouver := 2;
                            t^.next := NIL;    
                        END;
                END;	 
                IF trouver = 2 THEN
                        t^.next := NIL
                ELSE
                BEGIN
                    t := t^.next;
                END 	 
            END;
        END;
    END;  

    function EstPresent (VAR Tete:Node; valeur:INTEGER) : BOOLEAN;
       VAR 
            n : Node;
            present : BOOLEAN;
       BEGIN
            n := Tete;
            present := FALSE;
            WHILE (n <> NIL) and (not present) DO
            BEGIN   
                IF n^.key = valeur THEN
                    present := TRUE
                ELSE
                BEGIN
                    n := n^.next;
                END;
            END;
        EstPresent := present;
    END;

    PROCEDURE InsertionSansDoublon (VAR tete:Node; val : INTEGER);
    BEGIN
        IF (not EstPresent(tete, val)) THEN
            InsertionTete(tete, val);
    END; 
end.
   