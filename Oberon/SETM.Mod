MODULE SETM;
IMPORT ListeChaine , Out,Extraction;
(*////////////////////////////////////////LES PROCEDURES//////////////////////////////////////////////////////////////*)

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

(* la procedure triParItemset permet de faire le tri par itemset*)

PROCEDURE triParItemset(VAR tableauDeTransaction: ARRAY OF ListeChaine.Node2;VAR Taille:INTEGER):ListeChaine.Node2;

VAR 
listeIndice,valeur:ListeChaine.Node;
items1,items2,sorti:ListeChaine.Node2;
i,j,decision:INTEGER;

  BEGIN
  sorti:=NIL;
    i:=0;

      WHILE i<=Taille DO
        items1:=tableauDeTransaction[i];

          WHILE items1 # NIL DO
            valeur:=items1.key;
            ListeChaine.InsertionTete(listeIndice,i);
            j:=i+1;

               WHILE j<Taille  DO
               items2:=tableauDeTransaction[j];
               decision:=ListeChaine.GrandeAppartenance(items2,valeur);

                 IF decision = 1 THEN
                 ListeChaine.InsertionTete(listeIndice,j);
                 ListeChaine.GrandSuppression(tableauDeTransaction[j],valeur);
                 END;
                j:=j+1;
            END;  
        ListeChaine.GrandInsertionTete(sorti,listeIndice);
        ListeChaine.GrandInsertionTete(sorti,valeur);
        listeIndice:=NIL;
        items1:=items1.next;
        END;
    i:=i+1;
    END;
    i:=0;

       WHILE i<Taille DO
       tableauDeTransaction[i]:=NIL;
       i:=i+1;
       END;

   RETURN sorti

END triParItemset;  

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

(* la jointure permet de passer du niveau k au niveau k+1*)

PROCEDURE Jointure(VAR candidatPrecedent:ListeChaine.Node2):ListeChaine.Node2;

VAR candidatPrecedent1,candidatPrecedent2,sorti:ListeChaine.Node2;
    sousItem1,sousItem2,sousItem3,sousSorti:ListeChaine.Node;
    valeur:INTEGER;

    BEGIN
    candidatPrecedent1:=candidatPrecedent;
  
  		WHILE candidatPrecedent1 # NIL DO
    	candidatPrecedent2:=candidatPrecedent1.next;
    
    		WHILE candidatPrecedent2 # NIL DO
      		sousItem1:=candidatPrecedent1.key;
      		sousItem3:=candidatPrecedent1.key;
      		sousItem2:=candidatPrecedent2.key;
      		valeur:=sousItem2.key;	

        		IF(sousItem1.key<sousItem2.key) THEN 
          		sousItem1:=sousItem1.next;
          		sousItem2:=sousItem2.next;

            		WHILE (sousItem1 # NIL) & (sousItem1.key =sousItem2.key) DO 
              		sousItem1:=sousItem1.next;
              		sousItem2:=sousItem2.next;
            		END;
        		END;

        		IF sousItem2 = NIL THEN
        		sousSorti:=sousItem3;
        		ListeChaine.InsertionTete(sousSorti,valeur);
        		ListeChaine.GrandInsertionTete(sorti,sousSorti);
        		END;
      		candidatPrecedent2:=candidatPrecedent2.next;    
   		    END;
        candidatPrecedent1:=candidatPrecedent1.next; 
        END; 

    RETURN sorti

END Jointure;


(*///////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE triSetm*(VAR preCandidat:ListeChaine.Node2);

VAR 
    preCandidat1,dernierePosition,teteDeRecherche:ListeChaine.Node2;
    SousTete:ListeChaine.Node;
    valeur:INTEGER;

   BEGIN 
   preCandidat1:=preCandidat;
   preCandidat:=NIL;

      WHILE preCandidat1 # NIL DO
      teteDeRecherche :=preCandidat1;
      dernierePosition:=preCandidat1;
      valeur:=preCandidat1.key.key;

        WHILE teteDeRecherche # NIL DO

            IF teteDeRecherche.key.key >valeur THEN
            valeur:=teteDeRecherche.key.key ;
            dernierePosition:=teteDeRecherche;
            SousTete:=dernierePosition.key;
            END;
        teteDeRecherche:=teteDeRecherche.next;
        END;

       ListeChaine.GrandSuppression(preCandidat1,dernierePosition.key);

       ListeChaine.GrandInsertionTete(preCandidat , dernierePosition.key); 
     END;

END triSetm;
(*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*) 

(* procedure qui permet de faire les jointure par transaction*)

PROCEDURE JointureParTransaction(VAR tableauDeTransaction : ARRAY OF ListeChaine.Node2;VAR nombreTransaction: INTEGER);

VAR 
   preCandidat: ListeChaine.Node2;
   i:INTEGER;

   BEGIN
   i:=0;

    WHILE i< nombreTransaction DO
    triSetm(tableauDeTransaction[i]);
    preCandidat:=Jointure(tableauDeTransaction[i]);
    tableauDeTransaction[i]:= preCandidat;
    i:=i+1;
    END;

END JointureParTransaction;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

(* procedure qui tri les itemset par transaction*)

PROCEDURE triParTansaction(VAR tableauDeTransaction: ARRAY OF ListeChaine.Node2;VAR itemset,listeIndice:ListeChaine.Node);

   BEGIN

    WHILE listeIndice # NIL DO
    ListeChaine.GrandInsertionTete(tableauDeTransaction[listeIndice.key],itemset);
    listeIndice:=listeIndice.next;
    END;

END triParTansaction;    


(* procedure qui permet de verifier si un itemset sera candidat ou pas *)

PROCEDURE SetmDecision(VAR tableauDeTransaction: ARRAY  OF ListeChaine.Node2;VAR resultatDuTriPartransaction:ListeChaine.Node2;VAR support:INTEGER):ListeChaine.Node2;

VAR resultatDuTriPartransaction2,MonResultat:ListeChaine.Node2;
    ListeIndice2,ListeIndice,itemset:ListeChaine.Node;
    calculSupport:INTEGER; 

    BEGIN
    MonResultat:=NIL;
    resultatDuTriPartransaction2:=resultatDuTriPartransaction;

      WHILE resultatDuTriPartransaction2 # NIL DO
      itemset:=resultatDuTriPartransaction2.key;
      resultatDuTriPartransaction2:=resultatDuTriPartransaction2.next;
      ListeIndice:=resultatDuTriPartransaction2.key;
      ListeIndice2:=ListeIndice;
      calculSupport:=0;

        WHILE ListeIndice2 # NIL DO
        calculSupport:=calculSupport+1; 
        ListeIndice2:=ListeIndice2.next;
        END;

        IF calculSupport >= support THEN
        ListeChaine.GrandInsertionTete(MonResultat,itemset);
        triParTansaction(tableauDeTransaction,itemset,ListeIndice);
        END;

     resultatDuTriPartransaction2:=resultatDuTriPartransaction2.next;   
     END;

      RETURN MonResultat

 END SetmDecision;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure qui permet de transformer les produits de premiere generation en itemset de premiere generation*)
 PROCEDURE InitiationSet*(VAR tableauDeTransaction: ARRAY  OF ListeChaine.Node2; VAR Transaction:ListeChaine.Node2;VAR nombreTransaction,support:INTEGER):ListeChaine.Node2;

VAR i:INTEGER;
    itemsetFrequent,resultatDuTriPartransaction,Nouveau:ListeChaine.Node2; 
    NouveauSousListe1,NouveauSousListe2:ListeChaine.Node;

    BEGIN   
      i:=0;

        WHILE  Transaction # NIL DO
        NouveauSousListe1:=Transaction.key;

            WHILE NouveauSousListe1 # NIL DO
            ListeChaine.InsertionTete(NouveauSousListe2,NouveauSousListe1.key);
            ListeChaine.GrandInsertionTete(Nouveau,NouveauSousListe2);
            NouveauSousListe2:=NIL;
            NouveauSousListe1:=NouveauSousListe1.next;
            END;
        tableauDeTransaction[i]:=Nouveau;
        Nouveau:=NIL; 
        Transaction:=Transaction.next; 
        i:=i+1;
        END;
       resultatDuTriPartransaction:=triParItemset(tableauDeTransaction,nombreTransaction);
       itemsetFrequent:=SetmDecision(tableauDeTransaction,resultatDuTriPartransaction,support);

    RETURN  itemsetFrequent

END InitiationSet;

 (*///////////////////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure setm proprement dit*)
PROCEDURE SEMT(VAR Transaction:ListeChaine.Node2;VAR nombreTransaction,support:INTEGER);

VAR resultatDuTriPartransaction,Generation:ListeChaine.Node2;
    tableauDeTransaction: ARRAY 100000 OF ListeChaine.Node2;
    generation:INTEGER;
    correspondanceItems:ListeChaine.NodeItems;

      BEGIN
      correspondanceItems:= Extraction.extraction();
      generation:=2;
      Out.Ln;
      Out.Ln;
      Out.String("************************************************  PREMIERE GENERATION  ********************************");Out.Ln;
      Generation:=InitiationSet(tableauDeTransaction,Transaction,nombreTransaction,support);
      Extraction.affichageItemset(Generation,correspondanceItems);
       	WHILE Generation # NIL DO
       
       	JointureParTransaction(tableauDeTransaction, nombreTransaction);
       
       	resultatDuTriPartransaction:=triParItemset(tableauDeTransaction,nombreTransaction);
       
      	Generation:=SetmDecision(tableauDeTransaction,resultatDuTriPartransaction,support);
        
        	IF Generation # NIL THEN
        	Out.String("*********************************************");Out.Int(generation,0);Out.String("  GENERATION **********************************");
        	Extraction.affichageItemset(Generation,correspondanceItems);
       		ELSE
          Out.String(" ************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  SEMT ***********************!!!!!!!!!!!!!!!!!!!!!!!");
            (*///////////////////////////////////////*)

            Extraction.PlusMoinFreq(correspondanceItems);

            (*///////////////////////////////////////*) 
          END;
       	generation:=generation+1;
        Out.Ln;
        END;

END SEMT;

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE MainSemt*(VAR support:INTEGER);

VAR Transaction,TransactionVariable:ListeChaine.Node2;
    nombreTransaction:INTEGER;

    BEGIN 
    nombreTransaction:=0;
    Transaction:=Extraction.extractionParTransaction();
    TransactionVariable:=Transaction;

        WHILE TransactionVariable # NIL DO 
        nombreTransaction:=nombreTransaction+1;
        TransactionVariable:=TransactionVariable.next;
        END;
    
    SEMT(Transaction,nombreTransaction,support);

 END MainSemt;

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
  (*FIN MODULE SETM*) 
 BEGIN 
END SETM.  