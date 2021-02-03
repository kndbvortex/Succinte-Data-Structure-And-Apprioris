unit Graphe;
    
interface
    uses QueueInt, Arretes, ListeInt;
    TYPE

        Graph = RECORD
            root: INTEGER;
            S: ListeInt.Node;
            E: Arretes.ListeArrete;
        END;
    
    PROCEDURE CreateGraph (VAR T:Graph ;n,m : INTEGER) ;
    PROCEDURE PrintGraph(VAR T: Graph);
    PROCEDURE Neighbors(VAR T : Graph; n : INTEGER;VAR q :QueueInt.Files);
    PROCEDURE GraphBFS(VAR G : Graph);
    PROCEDURE GLoudsEncoding(VAR G : Graph; VAR CODE: string; VAR shadowsNode : QueueInt.Files);

implementation
    
    PROCEDURE CreateGraph(VAR T:Graph ;n,m : INTEGER) ;
    VAR 
        j : INTEGER;
        o, e : INTEGER;
    BEGIN 
        Arretes.InitListeArrete(T.E);
        T.S := NIL;
        j := 0;
        T.root := 1 ;
        ListeInt.InsertionSansDoublon(T.S, T.root);
        FOR j := 2 TO n DO
        BEGIN
            ListeInt.InsertionSansDoublon(T.S, j)
        END;
        FOR j := 1 TO m DO
        BEGIN
            write('Entrez l extremité 1 de l arrete N° ',j, ': ');
            read(o);
            write('Entrez l extremite 2 de larrete N° ', j, ': ');
            read(e);
            Arretes.AppendArrete(T.E, o, e);
        END;
    END;

    PROCEDURE  PrintGraph(VAR T: Graph);
    BEGIN 
        writeln('#Graphe : '); 
        ListeInt.AfficherListe(T.S);
        Arretes.PrintListeArrete(T.E);
    END;

    PROCEDURE Neighbors(VAR T : Graph; n : INTEGER;VAR q :QueueInt.Files);
    VAR
        p : ^Arretes.Element;
        e : INTEGER;
    BEGIN 
        QueueInt.InitQueue(q); 
        p := T.E.tete;
        WHILE p <> NIL DO
        BEGIN
            IF p^.valeur.e1 = n THEN
            BEGIN
                e := p^.valeur.e2;
                QueueInt.Enqueue(q, e);
            END;
            p := p^.suivant;
        END;
    END;

    PROCEDURE GraphBFS(VAR G : Graph);
    VAR 
        t : INTEGER;
        f, treatedNode, neighbor, markedNode : QueueInt.Files;
        s : ^QueueInt.Element;
    BEGIN 
        QueueInt.InitQueue(f); QueueInt.InitQueue(treatedNode);
        QueueInt.InitQueue(markedNode); QueueInt.InitQueue(neighbor);
        QueueInt.Enqueue(f, G.root);
        QueueInt.Enqueue(markedNode, G.root);
        WHILE not QueueInt.IsEmpy(f) DO
        BEGIN
            t := QueueInt.Dequeue(f);
            Neighbors(G, t, neighbor);
            s := neighbor.tete;
            WHILE s <> NIL DO
            BEGIN
                IF not QueueInt.EstPresent(markedNode, s^.val) THEN
                BEGIN
                    QueueInt.Enqueue(f, s^.val);
                    QueueInt.Enqueue(markedNode, s^.val);
                END;
                s := s^.suivant;
            END;
            QueueInt.Enqueue(treatedNode, t);
        END;
        writeln();
        QueueInt.PrintQueue(treatedNode);
    END;


    PROCEDURE GLoudsEncoding(VAR G : Graph; VAR CODE: string; VAR shadowsNode : QueueInt.Files);
    VAR 
        t : INTEGER ;
        f, treatedNode, neighborss, markedNode : QueueInt.Files;
        p : ^QueueInt.Element;
    BEGIN 
        QueueInt.InitQueue(f); QueueInt.InitQueue(treatedNode);
        QueueInt.InitQueue(markedNode); QueueInt.InitQueue(neighborss);
        QueueInt.Enqueue(f, G.root);
        QueueInt.Enqueue(markedNode, G.root);
        CODE := '10';
        WHILE not QueueInt.IsEmpy(f) DO
        BEGIN
            t := QueueInt.Dequeue(f);
            Neighbors(G, t, neighborss);
            p := neighborss.tete;
            WHILE (p <> NIL)  DO
            BEGIN
                IF QueueInt.EstPresent(markedNode, p^.val) THEN
                BEGIN
                    QueueInt.Enqueue(shadowsNode, p^.val);
                    CODE := CODE + '2';
                END;
                p := p^.suivant;
            END;
            p := neighborss.tete;
            WHILE p <> NIL DO
            BEGIN
                IF not QueueInt.EstPresent(markedNode, p^.val) THEN
                BEGIN
                    QueueInt.Enqueue(f, p^.val);
                    QueueInt.Enqueue(markedNode, p^.val);
                    CODE := CODE + '1';
                END;
                p := p^.suivant;
            END;
            CODE := CODE + '0'; 
            QueueInt.Enqueue(treatedNode, t);
        END;
    END;
end.