unit Trees;
    
interface
    uses QueueInt, Arcs, ListeInt;
    TYPE        
        Tree = RECORD
            root : INTEGER;
            S : ListeInt.Node;
            E : Arcs.ListeArc;
        END;

    PROCEDURE CreateTree (VAR T:Tree ;n : INTEGER) ;
    PROCEDURE  PrintTree (VAR T: Tree);
    PROCEDURE Children(VAR T : Tree; n : INTEGER;VAR q :QueueInt.Files);
    PROCEDURE TreeBFS (VAR T : Tree);
    PROCEDURE LoudsTreeEncoding(VAR T : Tree; VAR CODE: string);
    
implementation
    
    PROCEDURE CreateTree (VAR T:Tree ;n : INTEGER) ;
        VAR 
        j : INTEGER;
        o, e : INTEGER;
        d : BOOLEAN;
    BEGIN 
        Arcs.InitListeArc(T.E);
        T.S := NIL;
        j := 0;
        T.root := 1;
        ListeInt.InsertionSansDoublon(T.S, T.root);
        FOR j := 2 TO n DO
        BEGIN
            ListeInt.InsertionTete(T.S, j);
        END;
        FOR j := 1 TO n - 1 DO
        BEGIN
            d := TRUE;
            WHILE d DO
            BEGIN
                write('Entrez l origine de l arc N° ',j ,': ');
                read(o);
                WHILE not ListeInt.EstPresent(T.S, o) DO
                BEGIN
                    writeln('Entrez une origine présente dans l ensemble de sommet');
                    write('Entrez l origine de l arc N° "',j,': ');
                    read(o);
                END;
                write('Entrez l extremite de l arc N°' ,j,': ');
                read(e);
                WHILE not ListeInt.EstPresent(T.S, o) OR (o = e) DO
                BEGIN
                    IF (o = e) THEN 
                        write('Un arbre ne contient pas de boucle')
                    ELSE
                        writeln('Entrez une extremite présente dans l ensemble de sommet');
                    write('Entrez l extremite de l arc N° ', j,': ');
                    read(e);
                END;
                IF not Arcs.Present(T.E, o, e) THEN
                BEGIN
                    Arcs.AppendArc(T.E, o, e);
                    d := FALSE;
                END
                ELSE
                    writeln('Arc déjà présent Recommencez');
            END;
        END;
    END;

    PROCEDURE  PrintTree (VAR T: Tree);
    BEGIN 
    writeln('');
        write('#Arbre : '); 
        ListeInt.AfficherListe(T.S);
        writeln('');   
        Arcs.PrintListeArc(T.E);
        writeln('');
    END;

    PROCEDURE Children(VAR T : Tree; n : INTEGER;VAR q :QueueInt.Files);
    VAR
        p : ^Arcs.Element;
        e : INTEGER;
    BEGIN 
        QueueInt.InitQueue(q); p := T.E.tete;
        WHILE p <> NIL DO
        BEGIN
            IF p^.valeur.origine = n THEN
            BEGIN
                e := p^.valeur.extremite;
                QueueInt.Enqueue(q, e);
            END;
            p := p^.suivant;
        END;
    END;

    PROCEDURE TreeBFS (VAR T : Tree);
    VAR 
        t1 : INTEGER;
        f, treated, childrens : QueueInt.Files;
        s : ^QueueInt.Element;
    BEGIN 
        QueueInt.Enqueue(f, T.root);
        WHILE not QueueInt.IsEmpy(f) DO
        BEGIN
            t1 := QueueInt.Dequeue(f);
            QueueInt.Enqueue(treated, t1);
            Children(T, t1, childrens);
            s := childrens.tete;
            WHILE (s <> NIL) DO
            BEGIN
                IF not QueueInt.EstPresent(treated, s^.val) THEN
                    QueueInt.Enqueue(f, s^.val);
                s := s^.suivant;
            END;
        END;
        QueueInt.PrintQueue(treated);
    END;

    PROCEDURE LoudsTreeEncoding(VAR T : Tree; VAR CODE: string);
    VAR 
        i, k: INTEGER ;
        f, childrens: QueueInt.Files;
        p : ^QueueInt.Element;
        t1 : INTEGER;
    BEGIN 
        QueueInt.InitQueue(f);
        QueueInt.Enqueue(f, T.root);
        CODE := '10'; 
        WHILE not QueueInt.IsEmpy(f) DO
        BEGIN
            k := 0;
            t1 := QueueInt.Dequeue(f);
            Children(T, t1, childrens);
            p := childrens.tete;
            WHILE p <> NIL DO
            BEGIN
                QueueInt.Enqueue(f, p^.val);
                k := k + 1; 
                p := p^.suivant;
            END;
            FOR i := 1 TO k DO
            BEGIN
                CODE := CODE + '1';
            END;
            CODE := CODE + '0';  
        END;
    END;    
end.