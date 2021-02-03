MODULE APRIORiID;
IMPORT ListeChaine,Out,In,Extraction;
(*////////////////////////////////////////LES PROCEDURES//////////////////////////////////////////////////////////////*)


(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
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

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE InverserListe(VAR LISTE:ListeChaine.Node2 );
  VAR newliste:ListeChaine.Node2;

    BEGIN
      newliste:=LISTE;
      LISTE:=NIL;

        WHILE newliste # NIL DO
        ListeChaine.GrandInsertionTete(LISTE,newliste.key);  
        newliste:=newliste.next;
        END;

END InverserListe;  

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure qui permet de decide de la candidature un candidat*)

PROCEDURE APRIORiIdDecision(VAR tableauDeTransaction : ARRAY OF ListeChaine.Node2;VAR nombreTransaction,support:INTEGER):ListeChaine.Node2;
  VAR tableauDeTransactionVariable :ARRAY 100000 OF ListeChaine.Node2;
      Transaction1,Transaction2,resultatFinal:ListeChaine.Node2;
      itemset,listeIndice:ListeChaine.Node;
      indice,i,j,supportItemset,decision,k:INTEGER;
    BEGIN
    indice:=0;

      WHILE indice < nombreTransaction DO
        tableauDeTransactionVariable[indice]:=tableauDeTransaction[indice];
        tableauDeTransaction[indice]:=NIL;
        indice:=indice+1;
      END;

        indice:=0;

        WHILE indice < nombreTransaction DO
        Transaction1:=tableauDeTransactionVariable[indice];

             WHILE Transaction1 # NIL DO
             itemset:=Transaction1.key;
             supportItemset:=1;
             ListeChaine.InsertionTete(listeIndice,indice);
             j:=indice+1;

                WHILE j<nombreTransaction DO
                Transaction2:=tableauDeTransactionVariable[j];
                decision:= ListeChaine.GrandeAppartenance(Transaction2,itemset);

                    IF decision = 1 THEN
                     supportItemset:=supportItemset+1;
                     ListeChaine.GrandSuppression(tableauDeTransactionVariable[j],itemset);
                     ListeChaine.InsertionTete(listeIndice,j);
                     END; 

                j:=j+1;
                END;

                IF supportItemset >=support THEN
                ListeChaine.GrandInsertionTete(resultatFinal,itemset);
                       k:=0;
                    WHILE k< supportItemset DO
                      ListeChaine.GrandInsertionTete(tableauDeTransaction[listeIndice.key],itemset);
                      listeIndice:=listeIndice.next;
                      k:=k+1;
                    END;


                END;

            Transaction1:=Transaction1.next;
            END;

        indice:=indice+1;
        END;
        indice:=0;
        WHILE indice< nombreTransaction DO
           InverserListe(tableauDeTransaction[indice]);
           indice:=indice+1;
        END;
 
  RETURN resultatFinal

END APRIORiIdDecision;  
(*////////////////////////////////////////////////////////////////////////////*)
PROCEDURE InitiationAprioriId*(VAR tableauDeTransaction : ARRAY OF ListeChaine.Node2; VAR Transaction:ListeChaine.Node2 ;VAR nombreTransaction,support:INTEGER):ListeChaine.Node2;

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

       itemsetFrequent:=APRIORiIdDecision(tableauDeTransaction,nombreTransaction,support);
    RETURN  itemsetFrequent

END InitiationAprioriId;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE Jointure(VAR Transaction: ListeChaine.Node2;VAR candidatPrecedent: ListeChaine.Node2): ListeChaine.Node2;

VAR candidatPrecedent1,candidatPrecedent2,sorti: ListeChaine.Node2;
    sousItem1,sousItem2,sousItem3,sousSorti: ListeChaine.Node;
    valeur,decision,i:INTEGER;

    BEGIN
    candidatPrecedent1:=Transaction;
  
  		WHILE candidatPrecedent1 # NIL DO
    	candidatPrecedent2:=candidatPrecedent1.next;
            sousItem1:=candidatPrecedent1.key;
            decision:= ListeChaine.GrandeAppartenance(candidatPrecedent,sousItem1);
        IF decision = 1 THEN
    		WHILE candidatPrecedent2 # NIL DO
      		sousItem1:=candidatPrecedent1.key;
      		sousItem3:=candidatPrecedent1.key;
      		sousItem2:=candidatPrecedent2.key;
      		valeur:=sousItem2.key;	

        		IF(sousItem1.key>sousItem2.key) THEN 
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

   		END;   
        candidatPrecedent1:=candidatPrecedent1.next; 
        END; 

    RETURN sorti

END Jointure;

(*/////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE triAprioriId(VAR preCandidat: ListeChaine.Node2);

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

            IF teteDeRecherche.key.key <valeur THEN
            valeur:=teteDeRecherche.key.key ;
            dernierePosition:=teteDeRecherche;
            SousTete:=dernierePosition.key;
            END;
        teteDeRecherche:=teteDeRecherche.next;
        END;

       ListeChaine.GrandSuppression(preCandidat1,dernierePosition.key);

       ListeChaine.GrandInsertionTete(preCandidat , dernierePosition.key); 
     END;

END triAprioriId;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE JointureParTransaction(VAR tableauDeTransaction : ARRAY OF  ListeChaine.Node2;VAR candidatPrecedent: ListeChaine.Node2; VAR nombreTransaction: INTEGER);

VAR 
   preCandidat:  ListeChaine.Node2;
   i:INTEGER;

   BEGIN
   i:=0;

    WHILE i< nombreTransaction DO
    triAprioriId(tableauDeTransaction[i]);
    preCandidat:=Jointure(tableauDeTransaction[i],candidatPrecedent);
    tableauDeTransaction[i]:= preCandidat;
    i:=i+1;
    END;

END JointureParTransaction;
(*///////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE APRIORIID(VAR Transaction:ListeChaine.Node2;VAR nombreTransaction,support:INTEGER);

VAR resultatDuTriPartransaction,RegroupementParTransaction,Generation,back:ListeChaine.Node2;
    tableauDeTransaction: ARRAY 100000 OF ListeChaine.Node2;
    generation,i:INTEGER;
    correspondanceItems:ListeChaine.NodeItems;

      BEGIN
      correspondanceItems:=Extraction.extraction();
      generation:=2;
      i:=0;
      Out.Ln;
      Out.String("************************************************  PREMIERE GENERATION  ********************************");Out.Ln;
      Generation:=InitiationAprioriId(tableauDeTransaction,Transaction,nombreTransaction,support);
      Extraction.affichageItemset(Generation,correspondanceItems);
      Out.Ln;
       	WHILE Generation # NIL DO
       	JointureParTransaction(tableauDeTransaction,Generation,nombreTransaction);

        Generation:=APRIORiIdDecision(tableauDeTransaction,nombreTransaction,support);

        	IF Generation # NIL THEN
        	Out.String("*********************************************");Out.Int(generation,0);Out.String("  GENERATION **********************************");
          Extraction.affichageItemset(Generation,correspondanceItems);
          ELSE 
          Out.String(" ************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  AprioriId ***********************!!!!!!!!!!!!!!!!!!!!!!!"); 
           (*///////////////////////////////////////*)

            Extraction.PlusMoinFreq(correspondanceItems);

            (*///////////////////////////////////////*)
          END;

       	generation:=generation+1;
        Out.Ln;
        END;

END APRIORIID;
(*//////////////////////////////////////////////////////////////*)

PROCEDURE MainAprioriId*(VAR support:INTEGER);

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
    
    APRIORIID(Transaction,nombreTransaction,support);

 END MainAprioriId;
BEGIN
END APRIORiID.
