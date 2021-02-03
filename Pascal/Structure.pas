unit Structure;

interface
uses crt, QueueInt, Trees, Graphe;
    
    PROCEDURE MainSuccinte();
    PROCEDURE GraphParent(VAR S: string ; i : INTEGER; VAR H : QueueInt.Files);
    PROCEDURE GraphChildren(VAR S: string ;i : INTEGER; VAR H : QueueInt.Files);
    

implementation
    function Rank(b : CHAR; S : string; maxPosition : INTEGER) : INTEGER;
    VAR 
        i , j: INTEGER;

    BEGIN 
        i := 0; j := 0;
        WHILE (i < length(S)) and (i < maxPosition) DO 
        begin
            IF S[i] = b THEN    
                j := j + 1;
            i := i + 1;
        END;
        Rank := j;
    END;

    function  Select(b : CHAR; S : string; position : INTEGER) : INTEGER;
    VAR 
        i, j: INTEGER;

    BEGIN 
        IF ((position <= 0) or (position >= length(S))) THEN 
            i := -1
        ELSE
            BEGIN
            i := 0; j := 0;
            WHILE((i < length(S)) and (j <> position)) DO 
            BEGIN
                IF b = S[i] THEN
                    j := j + 1;
                i := i + 1;
            END;
            IF not (j = position) THEN 
                i := -1;
        END;
        Select := i;
    END ;

    function Succ(b : CHAR; S : string; position : INTEGER): INTEGER ;
    BEGIN 
        Succ := Select(b, S, Rank(b, S, position) + 1);
    END;

    function Pred(b : CHAR; S : string; position : INTEGER): INTEGER ;
    BEGIN 
        Pred := Select(b, S, Rank(b, S, position) - 1);
    END;

    function Parent(n : INTEGER; S : string) : INTEGER;
    VAR  
        y, j : INTEGER;
    BEGIN 
        y := Select('1', S, n);
        j := Rank('0', S, y);
        Parent := j;
    END;

    PROCEDURE Children(VAR S: string ;i : INTEGER);
    VAR 
        x , t: INTEGER;
        children : QueueInt.Files;
    BEGIN 
        t := 0;
        x := Select('0', S, i);
        QueueInt.InitQueue(children);
        WHILE ((x + t) < length(S)) and (S[x + t] <> '0') DO
        BEGIN
            t := t + 1;
            QueueInt.Enqueue(children, Rank('1', S, x + t));
        END;
        QueueInt.PrintQueue(children);
    END;

 PROCEDURE MainSuccinte();

 VAR
    S : string; 
    choix, m, n1, choix1, choix2, sommet: INTEGER;
    T : Trees.Tree;
    G : Graphe.Graph;
    shadowsNode : QueueInt.Files;

BEGIN 
   
    choix := 1;

    WHILE choix <> 3 DO 
    BEGIN
        writeln();
        writeln('____________________ 1/ Arbre ____________________'); 
        writeln('____________________ 2/ Graphe ____________________'); 
        writeln('____________________ 3/ Sortir ____________________'); 
        write('Entrez Votre Choix : '); 
        read(choix);
        IF choix = 1 THEN 
        BEGIN 
            write ('Entrez le nombre de sommet : '); 
            read(n1);
            Trees.CreateTree(T, n1);
            Trees.PrintTree(T);
            Trees.LoudsTreeEncoding(T, S);
            choix1 := 1;
            WHILE choix1 <> 0 DO
            BEGIN
                writeln();
                writeln('__________ 1/ Louds Tree Encoding__________');
                writeln('__________ 2/ Successeurs d un sommet __________');
                writeln('__________ 3/ Parent d un sommet __________');
                writeln('__________ 0/ Retour __________');
                write('Entrez Votre Choix : '); 
                read(choix1);
                IF choix1 = 1 THEN
                BEGIN 
                    writeln();
                    writeln();
                    write('Encodage : ', S);
                    writeln(); 
                    writeln('Tapez une touche pour continuer : ');
                    readkey;
                END;
                IF choix1 = 2 THEN 
                BEGIN 
                    writeln();
                    writeln();
                    write ('Entrez le sommet : ');read(sommet);
                    write ('Les successeurs de ', sommet,' est '); 
                    Children(S, sommet);
                    writeln();writeln();
                    writeln('Tapez une touche pour continuer  :');
                    readkey;
                END;
                IF choix1 = 3 THEN
                BEGIN     
                    writeln();
                    writeln();
                    write ('Entrez le sommet : ');
                    read(sommet);
                    write ('Le parent de ', sommet, ' est '); 
                    writeln(Parent(sommet, S));
                    writeln('Tapez une touche pour continuer :');
                    readkey;
                END;
            END;
        END;
        IF choix = 2 THEN
        BEGIN
            write ('Entrez le nombre de sommet : '); 
            read(n1);
            write ('Entrez le nombre d arrete : '); 
            read(m);
            Graphe.CreateGraph(G, n1, m);
            Graphe.PrintGraph(G);
            Graphe.GLoudsEncoding(G, S, shadowsNode);
            choix2 := 1;
            WHILE choix2 <> 0 DO
            BEGIN 
                writeln();
                write ('__________1/ GLOUD Encoding');writeln();
                write ('__________2/ Parents');writeln();
                write ('__________3/ Enfants');writeln();
                write ('__________0/ Retour'); writeln();
                write ('Entrez Votre Choix : '); 
                read(choix2);
                IF choix2 = 1 THEN 
                BEGIN
                    write (S);
                    writeln(); 
                    readkey; 
                END;
                IF choix2 = 2 THEN
                BEGIN
                    Write('Entrez le sommet : ');
                    read(sommet);
                    write('Le(s) parent(s) de ', sommet ,': '); 
                    GraphParent(S, sommet, shadowsNode);
                    readkey;
                END; 

                IF choix2 = 3 THEN
                BEGIN
                    Write('Entrez le sommet : ');
                    read(sommet);
                    write('Le(s) Enfant(s) de ', sommet ,': '); 
                    GraphChildren(S, sommet, shadowsNode);
                    readkey;
                END;                       
            END;
        END;    
    END;
    
    writeln();
    writeln();
    writeln('Merci Pour votre attention');
    writeln();
    writeln();
END;

    PROCEDURE GraphChildren(VAR S: string ;i : INTEGER; VAR H : QueueInt.Files);
    VAR 
        x , t, i1: INTEGER;
        childrens : QueueInt.Files;
        a : ^QueueInt.Element;
    BEGIN 
        t := 0;
        x := Select('0', S, i);
        QueueInt.InitQueue(childrens);
        WHILE ((x + t) < length(S)) and (S[x + t] <> '0') DO
        BEGIN
            IF S[x + t] = '1' THEN 
                QueueInt.Enqueue(childrens, Rank('1', S, x + t) + 1)
            ELSE
            BEGIN
                a := H.tete;
                FOR i1 := 0 TO (Rank('2', S, x + t) -1) DO
                BEGIN
                    a := a^.suivant;
                END;
                QueueInt.Enqueue(childrens, a^.val);
            END;
            t := t + 1;
        END;
        QueueInt.PrintQueue(childrens);
    END;

    PROCEDURE GraphParent(VAR S: string ; i : INTEGER; VAR H : QueueInt.Files);
    VAR
        j, x ,a : INTEGER;
        parent : QueueInt.Files;
    BEGIN 
        QueueInt.InitQueue(parent);

        j := 1;
        x := QueueInt.Select(i, H, j);
        a := Rank('0', S, Select('1', S, i));
        IF a > 0 THEN
        	QueueInt.Enqueue(parent, a);
        WHILE x <> -1 DO
        BEGIN
            QueueInt.Enqueue(parent, Rank('0', S, Select('2', S, x)));
            j := j + 1;
            x := QueueInt.Select(i, H, j);
        END;
        QueueInt.PrintQueue(parent);
    END;

BEGIN
END.