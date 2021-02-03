unit APRIORiID;

interface
uses ListeChaine,extractionPascal;
PROCEDURE MainAprioriId(VAR support:INTEGER);

implementation
(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function triParItemset(VAR tableauDeTransaction:array of Node2;var Taille:INTEGER):Node2;
VAR listeIndice,valeur:Node;
    items1,items2,sorti:Node2;
    i,j,decision:INTEGER;

   BEGIN
    sorti:=NIL;
    listeIndice:=NIL;
    i:=0;
    items1:=nil;
    items2:=nil;
    valeur:=nil;
    WHILE i<Taille DO
    begin
        items1:=tableauDeTransaction[i];
        WHILE items1 <> NIL DO
        begin
            valeur:=items1^.key;
            InsertionTete(listeIndice,i);
            j:=i+1;
               WHILE j<Taille  DO
               begin
               items2:=tableauDeTransaction[j];
               decision:=GrandeAppartenance(items2,valeur);

                   IF decision = 0 THEN
                   begin
                   InsertionTete(listeIndice,j);
                   GrandSuppression(tableauDeTransaction[j],valeur);
                   END;
                j:=j+1;
               END;  
           GrandInsertionTete(sorti,listeIndice);
           GrandInsertionTete(sorti,valeur);
           items1:=items1^.next;
           listeIndice:=NIL;
        END;
         
    i:=i+1;
    END;
    i:=0;

       WHILE i<Taille DO
       begin
       tableauDeTransaction[i]:=NIL;
       i:=i+1;
       END;
    triParItemset:=sorti

END;  

(*/////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE InverserListe(VAR LISTE:Node2);
  VAR newliste:Node2;

    BEGIN
      newliste:=nil;
      newliste:=LISTE;
      LISTE:=NIL;

        WHILE newliste <> NIL DO
        begin
        GrandInsertionTete(LISTE,newliste^.key);  
        newliste:=newliste^.next;
        END;

END;
(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function APRIORiIdDecision(VAR tableauDeTransaction : ARRAY OF Node2;VAR nombreTransaction,support:INTEGER):Node2;
  VAR tableauDeTransactionVariable :ARRAY OF Node2;
      Transaction1,Transaction2,resultatFinal:Node2;
      itemset,listeIndice:Node;
      indice,i,j,supportItemset,decision,k:INTEGER;

    BEGIN
    setlength(tableauDeTransactionVariable,nombreTransaction);
    indice:=0;
      Transaction1:=nil;Transaction2:=nil;resultatFinal:=nil;
      itemset:=nil;listeIndice:=NIL; 
      WHILE indice < nombreTransaction DO
      begin
        tableauDeTransactionVariable[indice]:=tableauDeTransaction[indice];
        tableauDeTransaction[indice]:=NIL;
        indice:=indice+1;
      END;

        indice:=0;

        WHILE indice < nombreTransaction DO
        begin
        Transaction1:=tableauDeTransactionVariable[indice];
            WHILE Transaction1 <> NIL DO
            begin
            listeIndice:=nil;
            itemset:=Transaction1^.key;
            supportItemset:=1;
            InsertionTete(listeIndice,indice);
            j:=indice+1;
                WHILE j<nombreTransaction DO
                begin
                Transaction2:=tableauDeTransactionVariable[j];
                decision:=GrandeAppartenance(tableauDeTransactionVariable[j],itemset);

                    IF decision = 1 THEN
                    begin
                     supportItemset:=supportItemset+1;
                     GrandSuppression(tableauDeTransactionVariable[j],itemset);
                     InsertionTete(listeIndice,j);
                    END; 

                j:=j+1;
                END;

                IF supportItemset >=support THEN
                begin
                GrandInsertionTete(resultatFinal,itemset);
                    k:=0;
                    WHILE k< supportItemset DO
                    begin
                      GrandInsertionTete(tableauDeTransaction[listeIndice^.key],itemset);
                      listeIndice:=listeIndice^.next;
                      k:=k+1;
                    END;
                END;
            Transaction1:=Transaction1^.next;
            END;

        indice:=indice+1;
        END;

        indice:=0;
        WHILE indice< nombreTransaction DO
        begin
           InverserListe(tableauDeTransaction[indice]);
           indice:=indice+1;
        END;
 
  APRIORiIdDecision:=resultatFinal;
END;   
(*/////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function InitiationAprioriId(VAR tableauDeTransaction : ARRAY OF Node2; VAR Transaction:Node2 ;VAR nombreTransaction,support:INTEGER):Node2;

VAR i:INTEGER;
    itemsetFrequent,resultatDuTriPartransaction,Nouveau:Node2; 
    NouveauSousListe1,NouveauSousListe2:Node;

    BEGIN   
      i:=0;
    itemsetFrequent:=nil;resultatDuTriPartransaction:=nil;Nouveau:=nil;
    NouveauSousListe1:=nil;NouveauSousListe2:=nil;
    
        WHILE  Transaction <> NIL DO
        begin
        NouveauSousListe1:=Transaction^.key;

            WHILE NouveauSousListe1 <> NIL DO
            begin
            InsertionTete(NouveauSousListe2,NouveauSousListe1^.key);
            GrandInsertionTete(Nouveau,NouveauSousListe2);
            NouveauSousListe2:=NIL;
            NouveauSousListe1:=NouveauSousListe1^.next;
            END;
        tableauDeTransaction[i]:=Nouveau;
        Nouveau:=NIL; 
        Transaction:=Transaction^.next; 
        i:=i+1;
        END;

       itemsetFrequent:=APRIORiIdDecision(tableauDeTransaction,nombreTransaction,support);

    InitiationAprioriId:=itemsetFrequent;

END;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function Jointure(VAR Transaction:Node2;VAR candidatPrecedent:Node2):Node2;

VAR candidatPrecedent1,candidatPrecedent2,sorti:Node2;
    sousItem1,sousItem2,sousItem3,sousSorti:Node;
    valeur,decision,i:INTEGER;

    BEGIN
    candidatPrecedent1:=nil;candidatPrecedent2:=nil;sorti:=nil;
    sousItem1:=nil;sousItem2:=nil;sousItem3:=nil;sousSorti:=nil;
    candidatPrecedent1:=Transaction;
  
      WHILE candidatPrecedent1 <> NIL DO
      begin
      candidatPrecedent2:=candidatPrecedent1^.next;
            sousItem1:=candidatPrecedent1^.key;
            decision:=GrandeAppartenance(candidatPrecedent,sousItem1);
        IF decision = 1 THEN
        begin
        WHILE candidatPrecedent2 <> NIL DO
        begin
          sousItem1:=candidatPrecedent1^.key;
          sousItem3:=candidatPrecedent1^.key;
          sousItem2:=candidatPrecedent2^.key;
          valeur:=sousItem2^.key;  

            IF(sousItem1^.key>sousItem2^.key) THEN 
            begin
              sousItem1:=sousItem1^.next;
              sousItem2:=sousItem2^.next;

                WHILE (sousItem1 <> NIL) AND (sousItem1^.key =sousItem2^.key) DO 
                begin
                  sousItem1:=sousItem1^.next;
                  sousItem2:=sousItem2^.next;
                END;
            END;
             
            IF sousItem2 = NIL THEN
            begin
             sousSorti:=sousItem3;
             InsertionTete(sousSorti,valeur);
             GrandInsertionTete(sorti,sousSorti);
            END;

          candidatPrecedent2:=candidatPrecedent2^.next;    
          END;

      END;   
        candidatPrecedent1:=candidatPrecedent1^.next; 
        END; 

    Jointure:=sorti;

END;

(*/////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE triAprioriId(VAR preCandidat:Node2);

VAR 
    preCandidat1,dernierePosition,teteDeRecherche:Node2;
    SousTete:Node;
    valeur:INTEGER;

   BEGIN 
    preCandidat1:=NIL;dernierePosition:=NIL;teteDeRecherche:=NIL;
    SousTete:=NIL;
   preCandidat1:=preCandidat;
   preCandidat:=NIL;

      WHILE preCandidat1 <> NIL DO
      begin
      teteDeRecherche :=preCandidat1;
      dernierePosition:=preCandidat1;
      valeur:=preCandidat1^.key^.key;

        WHILE teteDeRecherche <> NIL DO
        begin

            IF teteDeRecherche^.key^.key <valeur THEN
            begin
            valeur:=teteDeRecherche^.key^.key ;
            dernierePosition:=teteDeRecherche;
            SousTete:=dernierePosition^.key;
            END;
        teteDeRecherche:=teteDeRecherche^.next;
        END;
       
       GrandSuppression(preCandidat1,dernierePosition^.key);
       GrandInsertionTete(preCandidat , dernierePosition^.key); 
     
     END;

END;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE JointureParTransaction(VAR tableauDeTransaction : ARRAY OF Node2;VAR candidatPrecedent:Node2; VAR nombreTransaction: INTEGER);

VAR  preCandidat:Node2;
   i:INTEGER;

   BEGIN
    preCandidat:=NIL;
   i:=0;

    WHILE i< nombreTransaction DO
    begin
    triAprioriId(tableauDeTransaction[i]);
    preCandidat:=Jointure(tableauDeTransaction[i],candidatPrecedent);
    tableauDeTransaction[i]:= preCandidat;
    i:=i+1;
    END;

END;
(*///////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE APRIORIID(VAR Transaction:Node2;VAR nombreTransaction,support:INTEGER);

VAR resultatDuTriPartransaction,RegroupementParTransaction,Generation:Node2;
    tableauDeTransaction: ARRAY  OF Node2;
    generations,i:INTEGER;
    correspondanceItems:NodeItems;

      BEGIN
      setlength(tableauDeTransaction,nombreTransaction);
      resultatDuTriPartransaction:=nil;RegroupementParTransaction:=nil;Generation:=nil;
      correspondanceItems:=NIL;
      correspondanceItems:=extraction();
      generations:=2;
      i:=0;
      writeln('************************************************  PREMIERE GENERATION  ********************************');
      Generation:=InitiationAprioriId(tableauDeTransaction,Transaction,nombreTransaction,support);
      affichageItemset(Generation,correspondanceItems);
        WHILE Generation <> NIL DO
        begin
        JointureParTransaction(tableauDeTransaction,Generation,nombreTransaction);

        Generation:=APRIORiIdDecision(tableauDeTransaction,nombreTransaction,support);

          IF Generation <> NIL THEN
          begin
          write('*********************************************');write(generations);writeln('  GENERATION **********************************');
          affichageItemset(Generation,correspondanceItems);
          end
          ELSE  BEGIN
          writeln('*************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  AprioriId ***********************!!!!!!!!!!!!!!!!!!!!!!!');
          (*///////////////////////////////////////////////////*)
         PlusMoinFreq(correspondanceItems);
         (*///////////////////////////////////////////////////*)
          END;
        generations:=generations+1;
        writeln('');
        END;

END;
(*//////////////////////////////////////////////////////////////*)
PROCEDURE MainAprioriId(VAR support:INTEGER);

  VAR Transaction,TransactionVariable:Node2;
      nombreTransaction:INTEGER;

    BEGIN 
    Transaction:=nil;TransactionVariable:=nil;
    nombreTransaction:=0;
    Transaction:=extractionParTransaction();
    TransactionVariable:=Transaction;

        WHILE TransactionVariable <> NIL DO 
        begin
        nombreTransaction:=nombreTransaction+1;
        TransactionVariable:=TransactionVariable^.next;
        END;

    APRIORIID(Transaction,nombreTransaction,support);

END ;
(*///////////////////////////////////////////////////////////////////////////*)

begin
end.	