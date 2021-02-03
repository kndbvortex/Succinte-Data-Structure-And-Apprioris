unit Arretes;
    
interface
    TYPE
        Arrete   = RECORD 
            e1   : INTEGER;
            e2   : INTEGER;
        END;
        Element = RECORD
                valeur   : Arrete;
                suivant   : ^Element;
            END;

        ListeArrete = RECORD 
            tete : ^Element;
            queue : ^Element;
        END;

    PROCEDURE InitListeArrete   (VAR liste : ListeArrete);
    function IsEmpy   (VAR liste : ListeArrete) : BOOLEAN;
    PROCEDURE PrintListeArrete  (VAR liste : ListeArrete);
    PROCEDURE AppendArrete  (VAR liste : ListeArrete ; o, a : INTEGER);
    PROCEDURE Supprimer   (VAR liste: ListeArrete; o,e : INTEGER);
    function Present (VAR liste : ListeArrete; o, e : INTEGER): BOOLEAN;



implementation
    PROCEDURE InitListeArrete   (VAR liste : ListeArrete);
    BEGIN 
        liste.tete := NIL; liste.queue := NIL;
    END;

    function IsEmpy   (VAR liste : ListeArrete) : BOOLEAN;
    BEGIN 
        IsEmpy := (liste.tete = NIL) and (liste.queue = NIL);
    END;

    PROCEDURE PrintListeArrete  (VAR liste : ListeArrete);
    VAR 
        p : ^Element;
    BEGIN 
        IF IsEmpy(liste) THEN
            writeln( 'ListeArrete vide ')
        ELSE
        BEGIN
            NEW(p); p := liste.tete;
            write( 'E = [ ');
            WHILE p <> NIL DO
            BEGIN
                write( '{ ', p^.valeur.e1, ' ----  ', p^.valeur.e2, '}');
                    IF p^.suivant <> NIL THEN
                    write(';');

                p := p^.suivant;
            END;
            writeln(' ]');
        END;
    END;

    PROCEDURE AppendArrete  (VAR liste : ListeArrete ; o, a : INTEGER);
        VAR 
            nouveau, s, p: ^Element;
            ok : BOOLEAN;
    BEGIN 
        NEW(nouveau); nouveau^.valeur.e2 := a; nouveau^.valeur.e1 := o; nouveau^.suivant := NIL;
        IF IsEmpy(liste) THEN 
        BEGIN
            liste.tete := nouveau; 
            liste.queue := nouveau;
        END
        ELSE
        BEGIN
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE ((s <> NIL) and (not ok)) DO
            BEGIN
                IF (s^.valeur.e1 < o) OR ((s^.valeur.e1 = o) and (s^.valeur.e2 < a)) THEN
                BEGIN
                    p := s;
                    s := s^.suivant;
                END
                ELSE IF (s^.valeur.e1 > o) OR ((s^.valeur.e1 = o) and (s^.valeur.e2 > a)) THEN
                BEGIN
                    ok := TRUE;
                END;
            END;
            IF not ok THEN
            BEGIN
                liste.queue^.suivant := nouveau;
                liste.queue := nouveau;
            END
            ELSE
            BEGIN
                IF s = liste.tete THEN
                BEGIN
                    liste.tete := nouveau;
                    nouveau^.suivant := p;
                END
                ELSE 
                BEGIN 
                    p^.suivant := nouveau;
                    nouveau^.suivant := s;
                END;
            END;
        END; 
    END;

    PROCEDURE Supprimer   (VAR liste: ListeArrete; o,e : INTEGER);
        VAR
            p, s : ^Element; 
            ok : BOOLEAN;
    BEGIN 
        IF  not IsEmpy(liste) THEN
        BEGIN
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE (s <> NIL) and (not ok) DO
            BEGIN
                IF (s^.valeur.e1 = o) and (s^.valeur.e2 = e) THEN 
                BEGIN
                    IF s = liste.tete THEN
                        liste.tete := liste.tete^.suivant
                    ELSE
                    BEGIN
                        p^.suivant := s^.suivant;
                    END;
                    ok := TRUE;
                END
                ELSE
                    p := s; 
                    s := s^.suivant;
            END;
            writeln('Dans la boucle 2');
        END;  
    END;

    function Present (VAR liste : ListeArrete; o, e : INTEGER): BOOLEAN;
    VAR 
        p : ^Element;
        ok : BOOLEAN;
    BEGIN 
        IF  IsEmpy(liste) THEN
            Present := FALSE
        ELSE
        writeln('Ok ....');
        BEGIN 
            p := liste.tete;
            ok := FALSE;
            WHILE ((p <> NIL) and (not ok)) DO
            BEGIN
                writeln('Dans le while');
                IF ((p^.valeur.e1 = o) and (p^.valeur.e2 = e)) THEN 
                    ok := TRUE
                ELSE
                    p := p^.suivant;
                writeln('Fin d"un tour');
            END;
        END;
        Present := ok;
    END;    
end.