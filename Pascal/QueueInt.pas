unit QueueInt;
    
interface
    TYPE 
        Element  = RECORD
            val  : INTEGER;
            suivant  :  ^Element;
        END;
        Files  = RECORD 
            tete  :  ^Element;
            queue  :  ^Element;
        END;

    PROCEDURE InitQueue  (VAR F : Files);
    function IsEmpy  (VAR F : Files) : BOOLEAN;
    PROCEDURE PrintQueue  (VAR F : Files);
    function EstPresent  (VAR F : Files; e : INTEGER) : BOOLEAN ;
    PROCEDURE Enqueue (VAR F : Files ; e : INTEGER);
    function Dequeue  (VAR F: Files): INTEGER;
    function Select(b : INTEGER; S : Files; position : INTEGER) : INTEGER;
    
implementation
    
    PROCEDURE InitQueue  (VAR F : Files);
    BEGIN 
        F.tete := NIL; F.queue := NIL;
    END;    

    
    function IsEmpy  (VAR F : Files) : BOOLEAN;
    BEGIN 
        IsEmpy := (F.tete = NIL) and (F.queue = NIL);
    END;

    PROCEDURE PrintQueue  (VAR F : Files);
    VAR 
        p :  ^Element;
    BEGIN 
        IF IsEmpy(F) THEN
            writeln( 'queue vide ')
        ELSE
            NEW(p); p := F.tete;
            WHILE p <> NIL DO
            begin
                write(p^.val);
                 IF (p^.suivant <> NIL) THEN
                   write(' ---->');

                p := p^.suivant;
            end;
            writeln();
    END;

    function EstPresent  (VAR F : Files; e : INTEGER) : BOOLEAN ;
    VAR 
        n :  ^Element;
        present : BOOLEAN;
    BEGIN
        n := F.tete;
        present := FALSE;
        WHILE (n <> NIL) and ( not present) DO
        begin
            IF n^.val = e THEN
                present := TRUE
            ELSE
                n := n^.suivant;
        END;
        EstPresent := present;
    END;


    PROCEDURE Enqueue (VAR F : Files ; e : INTEGER);
        VAR 
            nouveau :  ^Element;
    BEGIN 
        NEW(nouveau); nouveau^.val := e; nouveau^.suivant := NIL;
        IF IsEmpy(F) THEN 
        begin
            F.tete := nouveau;
            F.queue := nouveau;
        end
        ELSE
            F.queue^.suivant := nouveau;
            F.queue := nouveau;
    END;

    function Dequeue  (VAR F: Files): INTEGER;
        VAR
            e : INTEGER ;
    BEGIN 
        IF not IsEmpy(F) THEN
        BEGIN    
            e := F.tete^.val;
            F.tete := F.tete^.suivant;
            IF F.tete = NIL THEN
            BEGIN
                F.queue := NIL;
            END;
            Dequeue := e;
        END;
    END;

    function Select(b : INTEGER; S : Files; position : INTEGER) : INTEGER;
    VAR 
        i, j, a: INTEGER;
        found : BOOLEAN;
        p : ^Element;
    BEGIN
        IF (position <= 0) OR (S.tete = NIL) THEN 
            a := -1
        ELSE
        BEGIN
            p := S.tete;
            j := 0; i := 0;
            found := FALSE;
            WHILE(p <> NIL) and  (not found) DO
            BEGIN
                IF p^.val = b THEN
                    j := j + 1;
                IF j = position THEN
                    found := TRUE;
                p := p^.suivant;
                i := i + 1;
            END;
            IF j = position THEN 
                a := i
            ELSE
                a := -1;
        END;
        Select := a;
    END;

end.
    