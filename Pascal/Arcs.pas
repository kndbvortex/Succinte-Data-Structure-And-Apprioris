unit Arcs;
    
interface
    TYPE
        Arc  = record 
            origine : INTEGER;
            extremite : INTEGER;
        end;
        Element = RECORD
                valeur : Arc;
                suivant :  ^Element;
            end;

        ListeArc  = RECORD 
            tete  : ^Element;
            queue  : ^Element;
        end;

    PROCEDURE InitListeArc  (VAR liste : ListeArc);
    function IsEmpy  (VAR liste : ListeArc) : BOOLEAN;
    PROCEDURE PrintListeArc  (VAR liste : ListeArc);
    PROCEDURE AppendArc (VAR liste : ListeArc ; o, a : INTEGER);
    PROCEDURE Supprimer  (VAR liste: ListeArc; o,e : INTEGER);
    function Present  (VAR liste : ListeArc; o, e : INTEGER): BOOLEAN;

 

implementation
    PROCEDURE InitListeArc  (VAR liste : ListeArc);
    BEGIN 
        liste.tete := NIL; liste.queue := NIL;
    end;

    function IsEmpy  (VAR liste : ListeArc) : BOOLEAN;
    BEGIN 
        IsEmpy := (liste.tete = NIL) and (liste.queue = NIL);
    end;

    PROCEDURE PrintListeArc  (VAR liste : ListeArc);
    VAR 
        p : ^Element ;
    BEGIN 
        p := liste.tete;
        IF IsEmpy(liste) THEN
            writeln('ListeArc vide')
        ELSE
        begin
            write('#Arcs  : E = { ');
            WHILE p <> NIL DO
            begin
                write('(', p^.valeur.origine, ' --> ', p^.valeur.extremite,')');
                if  p^.suivant <> NIL THEN
                  write(' ; ');       
                p := p^.suivant;
            end;
            writeln(' }');
        end;
    end;

    PROCEDURE AppendArc (VAR liste : ListeArc ; o, a : INTEGER);
        VAR 
            nouveau , p, s: ^Element;
            ok : BOOLEAN;
    BEGIN 
        NEW(nouveau); 
        nouveau^.valeur.extremite := a; nouveau^.valeur.origine := o; nouveau^.suivant := NIL;
        IF IsEmpy(liste) THEN 
        BEGIN
            liste.tete := nouveau; 
            liste.queue := nouveau;
        END
        ELSE
        BEGIN
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE (s <> NIL) and (not ok) DO
            BEGIN
                IF (s^.valeur.origine < o) OR ((s^.valeur.origine = o) and (s^.valeur.extremite < a)) THEN
                BEGIN 
                    p := s;
                    s := s^.suivant;
                END
                ELSE IF (s^.valeur.origine > o) OR ((s^.valeur.origine = o) and (s^.valeur.extremite > a)) THEN
                    ok := TRUE;
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
    end ;

    PROCEDURE Supprimer  (VAR liste: ListeArc; o,e : INTEGER);
        VAR
            p, s : ^Element ;
            ok : BOOLEAN = false;
    BEGIN 
        p := liste.tete; 
        s := liste.tete;
        IF  not IsEmpy(liste) THEN
        begin
            WHILE (s <> NIL) and (not ok) DO
            begin
                IF (s^.valeur.origine = o) and (s^.valeur.extremite = e) THEN 
                begin
                    IF s = liste.tete THEN
                        liste.tete := liste.tete^.suivant
                    ELSE
                    begin
                        p^.suivant := s^.suivant;
                    end;
                    ok := TRUE;
                end
                ELSE
                    p := s; s := s^.suivant;
            end;
        end;
        
    end;

    function Present  (VAR liste : ListeArc; o, e : INTEGER): BOOLEAN;
    VAR 
        p : ^Element;
        ok : BOOLEAN = false;
    BEGIN 
        p := liste.tete;
        IF  IsEmpy(liste) THEN
            Present := FALSE
        ELSE 
        begin
            WHILE (p <> NIL) and (not ok) DO
            begin
                IF (p^.valeur.origine = o) and (p^.valeur.extremite = e) THEN 
                    Present := TRUE
                ELSE
                    p := p^.suivant;
            end;
        end;
        Present := FALSE;
    end; 
end.
   