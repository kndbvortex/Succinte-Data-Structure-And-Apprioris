MODULE Structure;
IMPORT In, Out, Strings, QueueInt, Tree, Graphe;
    VAR
        S : ARRAY 50 OF CHAR; 
        c : CHAR;
        choix, m, n, choix1, choix2, sommet: INTEGER;
        T : Tree.Tree;
        G : Graphe.Graph;
        shadowsNode : QueueInt.File;

    PROCEDURE Rank*(b : CHAR; S : ARRAY OF CHAR; maxPosition : INTEGER) : INTEGER;
    VAR 
        i , j: INTEGER;

    BEGIN 
        i := 0; j := 0;
        WHILE (i < Strings.Length(S)) & (i < maxPosition) DO 
            IF S[i] = b THEN    
                j := j + 1;
            END;
            i := i + 1;
        END;
        RETURN j
    END Rank;

    PROCEDURE  Select*(b : CHAR; S : ARRAY OF CHAR; position : INTEGER) : INTEGER;
    VAR 
        i, j: INTEGER;

    BEGIN 
        IF (position <= 0) OR (position >= LEN(S)) THEN 
            RETURN -1;
        ELSE
            i := 0; j := 0;
            WHILE(i < Strings.Length(S)) & (j # position) DO 
                IF b = S[i] THEN
                    j := j + 1;
                END;
                i := i + 1;
            END;
            IF j = position THEN 
                RETURN i;
            ELSE
                RETURN -1;
            END;
        END;
    END Select;

    PROCEDURE Succ* (b : CHAR; S : ARRAY OF CHAR; position : INTEGER): INTEGER ;
    BEGIN 
        RETURN(Select(b, S, Rank(b, S, position) + 1));
    END Succ;

    PROCEDURE Pred* (b : CHAR; S : ARRAY OF CHAR; position : INTEGER): INTEGER ;
    BEGIN 
        RETURN(Select(b, S, Rank(b, S, position) - 1));
    END Pred;

    PROCEDURE Parent* (n : INTEGER; S : ARRAY OF CHAR) : INTEGER;
    VAR  
        y, j : INTEGER;
    BEGIN 
        y := Select('1', S, n);
        j := Rank('0', S, y);
        RETURN j;
    END Parent;

    PROCEDURE Children*(VAR S: ARRAY OF CHAR ;i : INTEGER);
    VAR 
        x , t: INTEGER;
        children : QueueInt.File;
    BEGIN 
        t := 0;
        x := Select('0', S, i);
        QueueInt.InitQueue(children);
        WHILE ((x + t) < Strings.Length(S)) & (S[x + t] # '0') DO
            INC(t);
            QueueInt.Enqueue(children, Rank('1', S, x + t));
        END;
        QueueInt.PrintQueue(children);
    END Children;

    PROCEDURE GraphChildren*(VAR S: ARRAY OF CHAR ;i : INTEGER; VAR H : QueueInt.File);
    VAR 
        x , t, i1: INTEGER;
        children : QueueInt.File;
        a : POINTER TO QueueInt.Element;
    BEGIN 
        t := 0;
        x := Select('0', S, i);
        QueueInt.InitQueue(children);
        WHILE ((x + t) < Strings.Length(S)) & (S[x + t] # '0') DO
            IF S[x + t] = '1' THEN 
                QueueInt.Enqueue(children, Rank('1', S, x + t) + 1);
            ELSE
                a := H.tete;
                FOR i1 := 0 TO (Rank('2', S, x + t) -1) DO
                    a := a.suivant;
                END;
                QueueInt.Enqueue(children, a.val);
            END;
            INC(t);
        END;
        QueueInt.PrintQueue(children);
    END GraphChildren;

    PROCEDURE GraphParent(VAR S: ARRAY OF CHAR ; i : INTEGER; VAR H : QueueInt.File);
    VAR
        j, x ,a : INTEGER;
        parent : QueueInt.File;
    BEGIN 
        QueueInt.InitQueue(parent);

        j := 1;
        x := QueueInt.Select(i, H, j);
        a := Rank('0', S, Select('1', S, i));
        IF a > 0 THEN
        	QueueInt.Enqueue(parent, a); 
        END;
        WHILE x # -1 DO
            QueueInt.Enqueue(parent, Rank('0', S, Select('2', S, x)));
            j := j + 1;
            x := QueueInt.Select(i, H, j);
        END;
        QueueInt.PrintQueue(parent);
    END GraphParent;


BEGIN 
    choix := 1;
    Out.String("____________ Structure de données succintes ____________");Out.Ln;
    WHILE choix # 3 DO
        Out.String("_______________ 1/ Arbre _________");Out.Ln; 
        Out.String("_______________ 2/ Graphe ________"); Out.Ln;
        Out.String("_______________ 3/ Sortir _________"); Out.Ln;
        Out.String("Entrez Votre Choix : "); In.Int(choix);

        CASE choix OF
            1:  
                Out.String("Entrez le nombre de sommet : "); 
                In.Int(n);
                Tree.CreateTree(T, n);
                Tree.PrintTree(T);
                Tree.LoudsTreeEncoding(T, S);
                choix1 := 1;
                WHILE choix1 # 0 DO
                    Out.String("_________ 1/ Louds Tree Encoding");Out.Ln;
                    Out.String("_________ 2/ Successeurs d'un sommet");Out.Ln;
                    Out.String("_________ 3/ Parent d'un sommet");Out.Ln;
                    Out.String("_________ 0/ Retour"); Out.Ln;
                    Out.String("Entrez Votre Choix : "); In.Int(choix1);
                    CASE choix1 OF
                        1: 
                            Out.String(S);Out.Ln;
                            In.Char(c);
                        |2: 
                            Out.String("Entrez le sommet : ");In.Int(sommet);
                            Out.String("Les successeurs de ");Out.Int(sommet, 1); Out.String(" est "); 
                            Children(S, sommet);Out.Ln;;In.Char(c);
                        |3: 
                            Out.String("Entrez le sommet : ");In.Int(sommet);
                            Out.String("Le parent de ");Out.Int(sommet, 1); Out.String(" est "); 
                            Out.Int(Parent(sommet, S), 1);Out.Ln;In.Char(c);
                        ELSE
                    END;
                END;
            |2:
                Out.String("Entrez le nombre de sommet : "); 
                In.Int(n);
                Out.String("Entrez le nombre d'arrete : "); In.Int(m);
                Graphe.CreateGraph(G, n, m);
                Graphe.PrintGraph(G);
                Graphe.GLoudsEncoding(G, S, shadowsNode);
                choix2 := 1;
                WHILE choix2 # 0 DO 
                    Out.String("_________ 1/ GLOUD Encoding");Out.Ln;
                    Out.String("_________ 2/ Parent");Out.Ln;
                    Out.String("_________ 3/ Enfant");Out.Ln;
                    Out.String("_________ 0/ Retour"); Out.Ln;
                    Out.String("Entrez Votre Choix : "); In.Int(choix2);
                    CASE choix2 OF
                        1: 
                            Out.String(S);Out.Ln;
                            In.Char(c);
                        |2:
                            Out.String("Entrez le sommet : ");In.Int(sommet);
                            Out.String("Le(s) parent(s) de ");Out.Int(sommet, 1); Out.String(" :"); 
                            GraphParent(S, sommet, shadowsNode);Out.Ln;
                            In.Char(c);
                        |3 :
                            Out.String("Entrez le sommet : ");In.Int(sommet);
                            Out.String("Le(s) Enfant(s) de ");Out.Int(sommet, 1); Out.String(" : "); 
                            GraphChildren(S, sommet, shadowsNode);Out.Ln;
                            In.Char(c);
                        ELSE    
                    END;                        
                END;
            ELSE
        END;    
    END;

END Structure.
