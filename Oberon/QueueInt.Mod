MODULE QueueInt;
IMPORT Out; 
    TYPE 
        Element* = RECORD
            val* : INTEGER;
            suivant* : POINTER TO Element;
        END;

        File* = RECORD 
            tete* : POINTER TO Element;
            queue* : POINTER TO Element;
        END;
 
    PROCEDURE InitQueue* (VAR F : File);
    BEGIN 
        F.tete := NIL; F.queue := NIL;
    END InitQueue;

    PROCEDURE IsEmpy* (VAR F : File) : BOOLEAN;
    BEGIN 
        RETURN (F.tete = NIL) & (F.queue = NIL);
    END IsEmpy;

    PROCEDURE PrintQueue* (VAR F : File);
    VAR 
        p : POINTER TO Element;
    BEGIN 
        IF IsEmpy(F) THEN
            Out.String("File vide"); Out.Ln;
        ELSE
            NEW(p); p := F.tete;
            WHILE p # NIL DO
                Out.Int(p.val, 1);
                IF p.suivant # NIL THEN
                    Out.String(" ---> ");
                END;
                p := p.suivant;
            END;
            Out.Ln;
        END;
    END PrintQueue;

    PROCEDURE EstPresent* (VAR F : File; e : INTEGER) : BOOLEAN ;
    VAR 
        n : POINTER TO Element;
        present : BOOLEAN;
    BEGIN
        n := F.tete;
        present := FALSE;
        WHILE (n # NIL) & (~present) DO
            IF n.val = e THEN
                present := TRUE;
            ELSE
                n := n.suivant;
            END;
        END;
        RETURN present;
    END EstPresent;

    PROCEDURE Enqueue*(VAR F : File ; e : INTEGER);
        VAR 
            nouveau : POINTER TO Element;
    BEGIN 
        NEW(nouveau); nouveau.val := e; nouveau.suivant := NIL;
        IF IsEmpy(F) THEN 
            F.tete := nouveau;
            F.queue := nouveau;
        ELSE
            F.queue.suivant := nouveau;
            F.queue := nouveau;
        END; 
    END Enqueue;

    PROCEDURE Dequeue* (VAR F: File): INTEGER;
        VAR
            e : INTEGER ;
            v : POINTER TO Element; 
    BEGIN 
        IF ~IsEmpy(F) THEN
            e := F.tete.val;
            v := F.tete;
            F.tete := F.tete.suivant;
            IF F.tete = NIL THEN
                F.queue := NIL;
            END;
            RETURN e;
        END;
        
    END Dequeue;

    PROCEDURE  Select*(b : INTEGER; S : File; position : INTEGER) : INTEGER;
    VAR 
        i, j: INTEGER;
        found : BOOLEAN;
        p : POINTER TO Element;
    BEGIN
        IF (position <= 0) OR (S.tete = NIL) THEN 
            RETURN -1;
        ELSE
            p := S.tete;
            j := 0; i := 0;
            found := FALSE;
            WHILE(p # NIL) & (~found) DO
                IF p.val = b THEN
                    j := j + 1;
                END;
                IF j = position THEN
                    found := TRUE;
                END;
                p := p.suivant;
                i := i + 1;
            END;
            IF j = position THEN 
                RETURN i;
            ELSE
                RETURN -1;
            END;
        END;
    END Select;

END QueueInt.