MODULE Arc;
IMPORT Out ;

    TYPE
        Arc* = RECORD 
            origine* : INTEGER;
            extremite* : INTEGER;
        END;
        Element* = RECORD
                valeur* : Arc;
                suivant* : POINTER TO Element;
            END;

        ListeArc* = RECORD 
            tete* : POINTER TO Element;
            queue* : POINTER TO Element;
        END;

    PROCEDURE InitListeArc* (VAR liste : ListeArc);
    BEGIN 
        liste.tete := NIL; liste.queue := NIL;
    END InitListeArc;

    PROCEDURE IsEmpy* (VAR liste : ListeArc) : BOOLEAN;
    BEGIN 
        RETURN (liste.tete = NIL) & (liste.queue = NIL);
    END IsEmpy;

    PROCEDURE PrintListeArc* (VAR liste : ListeArc);
    VAR 
        p : POINTER TO Element;
    BEGIN 
        IF IsEmpy(liste) THEN
            Out.String("ListeArc vide"); Out.Ln;
        ELSE
            NEW(p); p := liste.tete;
            Out.String("Arcs : ");Out.Ln;Out.String("E = {");
            WHILE p # NIL DO
                Out.String("("); Out.Int(p.valeur.origine, 1); Out.String(" --> ");
                Out.Int(p.valeur.extremite, 1);Out.String(")");
                IF p.suivant # NIL THEN 
                    Out.String(";");
                END;
                p := p.suivant;
            END;
            Out.String("}");
            Out.Ln;
        END;
    END PrintListeArc;

    PROCEDURE AppendArc*(VAR liste : ListeArc ; o, a : INTEGER);
        VAR 
            nouveau, p, s : POINTER TO Element;
            ok : BOOLEAN;
    BEGIN 
        NEW(nouveau); nouveau.valeur.extremite := a;nouveau.valeur.origine := o; nouveau.suivant := NIL;
        IF IsEmpy(liste) THEN 
            liste.tete := nouveau; liste.queue := nouveau;
        ELSE
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE (s # NIL) & (~ok) DO
                IF (s.valeur.origine < o) OR ((s.valeur.origine = o) & (s.valeur.extremite < a)) THEN
                    p := s;
                    s := s.suivant;
                ELSIF (s.valeur.origine > o) OR ((s.valeur.origine = o) & (s.valeur.extremite > a)) THEN
                    ok := TRUE;
                END;
            END;
            IF ~ok THEN
                liste.queue.suivant := nouveau;
                liste.queue := nouveau;
            ELSE
                IF s = liste.tete THEN
                    liste.tete := nouveau;
                    nouveau.suivant := p;
                ELSE  
                    p.suivant := nouveau;
                    nouveau.suivant := s;
                END;
            END;
        END; 
    END AppendArc;

    PROCEDURE Supprimer* (VAR liste: ListeArc; o,e : INTEGER);
        VAR
            p, s : POINTER TO Element; 
            ok : BOOLEAN;
    BEGIN 
        IF  ~IsEmpy(liste) THEN
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE (s # NIL) & (~ok) DO
                IF (s.valeur.origine = o) & (s.valeur.extremite = e) THEN 
                    IF s = liste.tete THEN
                        liste.tete := liste.tete.suivant;
                    ELSE
                        p.suivant := s.suivant;
                    END;
                    ok := TRUE;
                ELSE
                    p := s; s := s.suivant;
                END;
            END;
        END;
        
    END Supprimer;

    PROCEDURE Present* (VAR liste : ListeArc; o, e : INTEGER): BOOLEAN;
    VAR 
        p : POINTER TO Element;
        ok : BOOLEAN;
    BEGIN 
        IF  IsEmpy(liste) THEN
            RETURN FALSE;
        ELSE 
            p := liste.tete; ok := FALSE;
            WHILE (p # NIL) & (~ok) DO
                IF (p.valeur.origine = o) & (p.valeur.extremite = e) THEN 
                    RETURN TRUE;
                ELSE
                    p := p.suivant;
                END;
            END;
        END;
        RETURN FALSE;
    END Present;
END Arc.