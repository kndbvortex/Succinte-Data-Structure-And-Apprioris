MODULE Tree;
IMPORT Out, In, QueueInt, Arc, ListeInt;

    TYPE
        
        Tree* = RECORD
            root* : INTEGER;
            S* : ListeInt.Node;
            E* : Arc.ListeArc;
        END;

    PROCEDURE CreateTree* (VAR T:Tree ;n : INTEGER) ;
    VAR 
        j : INTEGER;
        o, e : INTEGER;
        d : BOOLEAN;
    BEGIN 
        Arc.InitListeArc(T.E);
        T.S := NIL;
        j := 0;
        T.root := 1;
        ListeInt.InsertionSansDoublon(T.S, T.root);
        FOR j := 2 TO n DO
            ListeInt.InsertionTete(T.S, j)
        END;
        FOR j := 1 TO n - 1 DO
            d := TRUE;
            WHILE d DO
                Out.String("Entrez l'origine de l'arc N° "); Out.Int(j, 1);Out.String(": ");
                In.Int(o);
                WHILE ~ListeInt.EstPresent(T.S, o) DO
                    Out.String("Entrez une origine présente dans l'ensemble de sommet");Out.Ln;
                    Out.String("Entrez l'origine de l'arc N° "); Out.Int(j, 1);Out.String(": ");
                    In.Int(o);
                END;
                Out.String("Entrez l'extremite de l'arc N° "); Out.Int(j, 1);Out.String(": ");
                In.Int(e);
                WHILE ~ListeInt.EstPresent(T.S, o) OR (o = e) DO
                    IF o = e THEN 
                        Out.String("Un arbre ne contient pas de boucle");
                    ELSE
                        Out.String("Entrez une extremite présente dans l'ensemble de sommet");Out.Ln;
                    END;
                    Out.String("Entrez l'extremite de l'arc N° "); Out.Int(j, 1);Out.String(": ");
                    In.Int(e);
                END;
                IF ~Arc.Present(T.E, o, e) THEN
                    Arc.AppendArc(T.E, o, e);
                    d := FALSE;
                ELSE
                    Out.String("Arc déjà présent Recommencez");Out.Ln;
                END;
            END;
        END;
    END CreateTree;

    PROCEDURE  PrintTree* (VAR T: Tree);
    BEGIN 
        Out.String("# Arbre : "); 
        ListeInt.AfficherListe(T.S);
        Arc.PrintListeArc(T.E);
    END PrintTree;

    PROCEDURE Children*(VAR T : Tree; n : INTEGER;VAR q :QueueInt.File);
    VAR
        p : POINTER TO Arc.Element;
        e : INTEGER;
    BEGIN 
        QueueInt.InitQueue(q); p := T.E.tete;
        WHILE p # NIL DO
            IF p.valeur.origine = n THEN
                e := p.valeur.extremite;
                QueueInt.Enqueue(q, e);
            END;
            p := p.suivant;
        END;
    END Children;

    PROCEDURE TreeBFS* (VAR T : Tree);
    VAR 
        t : INTEGER;
        f, treated, children : QueueInt.File;
        s : POINTER TO QueueInt.Element;
    BEGIN 
        QueueInt.Enqueue(f, T.root);
        WHILE ~QueueInt.IsEmpy(f) DO
            t := QueueInt.Dequeue(f);
            QueueInt.Enqueue(treated, t);
            Children(T, t, children);
            s := children.tete;
            WHILE s # NIL DO
                IF ~QueueInt.EstPresent(treated, s.val) THEN
                    QueueInt.Enqueue(f, s.val);
                END;
                s := s.suivant;
            END;
        END;
        QueueInt.PrintQueue(treated);
    END TreeBFS;

    PROCEDURE LoudsTreeEncoding*(VAR T : Tree; VAR CODE: ARRAY OF CHAR);
    VAR 
        i, k, j : INTEGER ;
        f, children: QueueInt.File;
        p : POINTER TO QueueInt.Element;
        t : INTEGER;
    BEGIN 
        QueueInt.InitQueue(f);
        QueueInt.Enqueue(f, T.root);
        CODE := "10"; j:= 2;
        WHILE ~QueueInt.IsEmpy(f) DO
            k := 0;
            t := QueueInt.Dequeue(f);
            Children(T, t, children);
            p := children.tete;
            WHILE p # NIL DO
                QueueInt.Enqueue(f, p.val);
                k := k + 1; p := p.suivant;
            END;
            FOR i := 1 TO k DO
                CODE[j] := '1';
                INC(j);
            END;
            CODE[j] := '0'; 
            INC(j); 
        END;
    END LoudsTreeEncoding;
END Tree.