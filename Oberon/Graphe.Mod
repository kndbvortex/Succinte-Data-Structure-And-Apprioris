MODULE Graphe;
IMPORT Out, In, QueueInt, Arrete, ListeInt;

    TYPE

        Graph* = RECORD
            root* : INTEGER;
            S* : ListeInt.Node;
            E* : Arrete.ListeArrete;
        END;
    (*VAR
        i : INTEGER; 
        G : Graph;
        CODE : ARRAY 50 OF CHAR;
        H : QueueInt.File;
    *)
    PROCEDURE CreateGraph* (VAR T:Graph ;n,m : INTEGER) ;
    VAR 
        j : INTEGER;
        o, e : INTEGER;
    BEGIN 
        Arrete.InitListeArrete(T.E);
        T.S := NIL;
        j := 0;
        T.root := 1 ;
        ListeInt.InsertionSansDoublon(T.S, 1);
        FOR j := 2 TO n DO
            ListeInt.InsertionTete(T.S, j)
        END;
        FOR j := 1 TO m DO
            Out.String("Entrez l'extremité 1 de l'arrete N° "); Out.Int(j, 1);Out.String(": ");
            In.Int(o);
            Out.String("Entrez l'extremite 2 de l'arrete N° "); Out.Int(j, 1);Out.String(": ");
            In.Int(e);
            Arrete.AppendArrete(T.E, o, e);
        END;
    END CreateGraph;

    PROCEDURE  PrintGraph* (VAR T: Graph);
    BEGIN 
        Out.String("# Graphe : ");Out.Ln; 
        ListeInt.AfficherListe(T.S);
        Arrete.PrintListeArrete(T.E);
    END PrintGraph;

    PROCEDURE Neighbors*(VAR T : Graph; n : INTEGER;VAR q :QueueInt.File);
    VAR
        p : POINTER TO Arrete.Element;
        e : INTEGER;
    BEGIN 
        QueueInt.InitQueue(q); p := T.E.tete;
        WHILE p # NIL DO
            IF p.valeur.e1 = n THEN
                e := p.valeur.e2;
                QueueInt.Enqueue(q, e);
            END;
            p := p.suivant;
        END;
    END Neighbors;

    PROCEDURE GraphBFS* (VAR G : Graph);
    VAR 
        t : INTEGER;
        f, treatedNode, neighbors, markedNode : QueueInt.File;
        s : POINTER TO QueueInt.Element;
    BEGIN 
        QueueInt.InitQueue(f); QueueInt.InitQueue(treatedNode);
        QueueInt.InitQueue(markedNode); QueueInt.InitQueue(neighbors);
        QueueInt.Enqueue(f, G.root);
        QueueInt.Enqueue(markedNode, G.root);
        WHILE ~QueueInt.IsEmpy(f) DO
            t := QueueInt.Dequeue(f);
            Neighbors(G, t, neighbors);
            s := neighbors.tete;
            WHILE s # NIL DO
                IF ~QueueInt.EstPresent(markedNode, s.val) THEN
                    QueueInt.Enqueue(f, s.val);
                    QueueInt.Enqueue(markedNode, s.val);
                END;
                s := s.suivant;
            END;
            QueueInt.Enqueue(treatedNode, t);
        END;
        Out.Ln;
        QueueInt.PrintQueue(treatedNode);
    END GraphBFS;

    PROCEDURE GLoudsEncoding*(VAR G : Graph; VAR CODE: ARRAY OF CHAR; VAR shadowsNode : QueueInt.File);
    
    VAR 
        k, j, t : INTEGER ;
        f, treatedNode, neighbors, markedNode : QueueInt.File;
        p : POINTER TO QueueInt.Element;
    BEGIN 
        QueueInt.InitQueue(f); QueueInt.InitQueue(treatedNode);
        QueueInt.InitQueue(markedNode); QueueInt.InitQueue(neighbors);
        QueueInt.Enqueue(f, G.root);
        QueueInt.Enqueue(markedNode, G.root);
        CODE := "10"; j:= 2;
        WHILE ~QueueInt.IsEmpy(f) DO
            k := 0;
            t := QueueInt.Dequeue(f);
            Neighbors(G, t, neighbors);
            p := neighbors.tete;
            WHILE (p # NIL)  DO
                IF QueueInt.EstPresent(markedNode, p.val) THEN
                    QueueInt.Enqueue(shadowsNode, p.val);
                    CODE[j] := "2"; INC(j);
                END;
                p := p.suivant;
            END;
            p := neighbors.tete;
            WHILE p # NIL DO
                IF ~QueueInt.EstPresent(markedNode, p.val) THEN
                    QueueInt.Enqueue(f, p.val);
                    QueueInt.Enqueue(markedNode, p.val);
                    CODE[j] := "1"; INC(j);
                END;
                p := p.suivant;
            END;
            CODE[j] := "0"; 
            INC(j);
            QueueInt.Enqueue(treatedNode, t);
        END;
        Out.Ln;
    END GLoudsEncoding;

    (*BEGIN
    	ListeInt.InsertionSansDoublon(G.S, 1);
        G.root := 1; 
        FOR i := 2 TO 8 DO
            ListeInt.InsertionTete(G.S, i);
        END;
        Arrete.InitListeArrete(G.E);
        Arrete.AppendArrete(G.E, 1, 2);
        Arrete.AppendArrete(G.E, 1, 3);
        Arrete.AppendArrete(G.E, 2, 4);
        Arrete.AppendArrete(G.E, 3, 4);
        Arrete.AppendArrete(G.E, 3, 5);
        Arrete.AppendArrete(G.E, 4, 6);
        Arrete.AppendArrete(G.E, 4, 7);
        Arrete.AppendArrete(G.E, 5, 7);
        Arrete.AppendArrete(G.E, 5, 8);
        Arrete.AppendArrete(G.E, 6, 8);
        Arrete.AppendArrete(G.E, 8, 7);
        GLoudsEncoding(G, CODE, H);
        Out.String(CODE);Out.Ln;
        QueueInt.PrintQueue(H);
        GraphChildren(CODE, 3 ,H);*)
    END Graphe.