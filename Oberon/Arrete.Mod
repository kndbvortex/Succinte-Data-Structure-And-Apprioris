MODULE Arrete;
IMPORT Out ;

    TYPE
        Arrete* = RECORD 
            e1* : INTEGER;
            e2* : INTEGER;
        END;
        Element* = RECORD
                valeur* : Arrete;
                suivant* : POINTER TO Element;
            END;

        ListeArrete* = RECORD 
            tete* : POINTER TO Element;
            queue* : POINTER TO Element;
        END;

    (*VAR 
        l : ListeArrete;*)
    
    PROCEDURE InitListeArrete* (VAR liste : ListeArrete);
    BEGIN 
        liste.tete := NIL; liste.queue := NIL;
    END InitListeArrete;

    PROCEDURE IsEmpy* (VAR liste : ListeArrete) : BOOLEAN;
    BEGIN 
        RETURN (liste.tete = NIL) & (liste.queue = NIL);
    END IsEmpy;

    PROCEDURE PrintListeArrete* (VAR liste : ListeArrete);
    VAR 
        p : POINTER TO Element;
    BEGIN 
        IF IsEmpy(liste) THEN
            Out.String("ListeArrete vide"); Out.Ln;
        ELSE
            NEW(p); p := liste.tete;
            Out.String("E = {");
            WHILE p # NIL DO
                Out.String("{"); Out.Int(p.valeur.e1, 1); Out.String(" ---- ");
                Out.Int(p.valeur.e2, 1);Out.String("}");
                IF p.suivant # NIL THEN 
                    Out.String(";");
                END;
                p := p.suivant;
            END;
            Out.String("}");
            Out.Ln;
        END;
    END PrintListeArrete;

    PROCEDURE AppendArrete*(VAR liste : ListeArrete ; o, a : INTEGER);
        VAR 
            nouveau, p, s : POINTER TO Element;
            ok : BOOLEAN;
    BEGIN 
        NEW(nouveau); nouveau.valeur.e2 := a;nouveau.valeur.e1 := o; nouveau.suivant := NIL;
        IF IsEmpy(liste) THEN 
            liste.tete := nouveau; liste.queue := nouveau;
        ELSE
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE ((s # NIL) & (~ok)) DO
                IF (s.valeur.e1 < o) OR ((s.valeur.e1 = o) & (s.valeur.e2 < a)) THEN
                    p := s;
                    s := s.suivant;
                ELSIF (s.valeur.e1 > o) OR ((s.valeur.e1 = o) & (s.valeur.e2 > a)) THEN
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
    END AppendArrete;

    PROCEDURE Supprimer* (VAR liste: ListeArrete; o,e : INTEGER);
        VAR
            p, s : POINTER TO Element; 
            ok : BOOLEAN;
    BEGIN 
        IF  ~IsEmpy(liste) THEN
            p := liste.tete; s := liste.tete; ok := FALSE;
            WHILE (s # NIL) & (~ok) DO
                IF (s.valeur.e1 = o) & (s.valeur.e2 = e) THEN 
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

    PROCEDURE Present* (VAR liste : ListeArrete; o, e : INTEGER): BOOLEAN;
    VAR 
        p : POINTER TO Element;
        ok : BOOLEAN;
    BEGIN 
        IF  IsEmpy(liste) THEN
            RETURN FALSE;
        ELSE 
            p := liste.tete; ok := FALSE;
            WHILE (p # NIL) & (~ok) DO
                IF (p.valeur.e1 = o) & (p.valeur.e2 = e) THEN 
                    RETURN TRUE;
                ELSE
                    p := p.suivant;
                END;
            END;
        END;
        RETURN FALSE;
    END Present;

BEGIN 

END Arrete.
