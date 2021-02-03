unit SETM;

interface
uses ListeChaine,extractionPascal;
PROCEDURE MainSemt( support:INTEGER);


implementation
(*///////////////////////////////////////////////////////////// setm        //////////////////////////////////////////////*)

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

                   IF decision = 1 THEN
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
function JointureSet(VAR candidatPrecedent:Node2):Node2;

VAR candidatPrecedent1,candidatPrecedent2,sorti:Node2;
    sousItem1,sousItem2,sousItem3,sousSorti:Node;
    valeur:INTEGER;

    BEGIN
    sousItem1:=nil;sousItem2:=nil;sousItem3:=nil;sousSorti:=nil;
    candidatPrecedent1:=nil;candidatPrecedent2:=nil;sorti:=nil;
    candidatPrecedent1:=candidatPrecedent;
  
      WHILE candidatPrecedent1 <> NIL DO
      begin
      candidatPrecedent2:=candidatPrecedent1^.next;
    
        WHILE candidatPrecedent2 <> NIL DO
        begin
          sousItem1:=candidatPrecedent1^.key;
          sousItem3:=candidatPrecedent1^.key;
          sousItem2:=candidatPrecedent2^.key;
          valeur:=sousItem2^.key; 

            IF(sousItem1^.key<sousItem2^.key) THEN
            begin 
              sousItem1:=sousItem1^.next;
              sousItem2:=sousItem2^.next;

                WHILE (sousItem1 <> NIL) and (sousItem1^.key =sousItem2^.key) DO 
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
        candidatPrecedent1:=candidatPrecedent1^.next; 
        END; 

    JointureSet:=sorti;

END;

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE triSetm(VAR preCandidat:Node2);
VAR 
    preCandidat1,dernierePosition,teteDeRecherche:Node2;
    SousTete:Node;
    valeur:INTEGER;

   BEGIN 
   preCandidat1:=nil;dernierePosition:=nil;teteDeRecherche:=nil;
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
            IF teteDeRecherche^.key^.key > valeur THEN
            begin
            valeur:=teteDeRecherche^.key^.key ;
            dernierePosition:=teteDeRecherche;
            SousTete:=dernierePosition^.key;
            END;
        teteDeRecherche:=teteDeRecherche^.next;
        END;

            GrandSuppression(preCandidat1,dernierePosition^.key);
            GrandInsertionTete(preCandidat ,dernierePosition^.key); 
     END;

END;
(*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*) 
PROCEDURE JointureParTransaction(VAR tableauDeTransaction : ARRAY OF Node2;VAR nombreTransaction: INTEGER);

VAR 
   preCandidat:Node2;
   i:INTEGER;
   BEGIN
   preCandidat:=nil;
   i:=0;
    WHILE i< nombreTransaction DO
    begin
    triSetm(tableauDeTransaction[i]);
    preCandidat:=JointureSet(tableauDeTransaction[i]);
    tableauDeTransaction[i]:= preCandidat;
    i:=i+1;
    END;

END;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE triParTansaction(VAR tableauDeTransaction: ARRAY OF Node2;VAR itemset,listeIndice:Node);

   BEGIN
    WHILE listeIndice <> NIL DO
    begin
    GrandInsertionTete(tableauDeTransaction[listeIndice^.key],itemset);
    listeIndice:=listeIndice^.next;
    END;

END;    

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function SetmDecision(VAR tableauDeTransaction: ARRAY  OF Node2;VAR resultatDuTriPartransaction:Node2;VAR support:INTEGER):Node2;

VAR resultatDuTriPartransaction2,MonResultat:Node2;
    ListeIndice2,ListeIndice,itemset:Node;
    calculSupport:INTEGER; 

    BEGIN
    MonResultat:=NIL;
    resultatDuTriPartransaction2:=nil;MonResultat:=nil;
    ListeIndice2:=nil;ListeIndice:=nil;itemset:=nil;
    resultatDuTriPartransaction2:=resultatDuTriPartransaction;

      WHILE resultatDuTriPartransaction2 <> NIL DO
      begin
      itemset:=resultatDuTriPartransaction2^.key;
      resultatDuTriPartransaction2:=resultatDuTriPartransaction2^.next;
      ListeIndice:=resultatDuTriPartransaction2^.key;
      ListeIndice2:=ListeIndice;
      calculSupport:=0;

        WHILE ListeIndice2 <> NIL DO
        begin
        calculSupport:=calculSupport+1; 
        ListeIndice2:=ListeIndice2^.next;
        END;

        IF calculSupport >= support THEN
        begin
        GrandInsertionTete(MonResultat,itemset);
        triParTansaction(tableauDeTransaction,itemset,ListeIndice);
        END;

     resultatDuTriPartransaction2:=resultatDuTriPartransaction2^.next;   
     END;

        SetmDecision:=MonResultat;

 END;

 (*////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

function InitiationSet(VAR tableauDeTransaction: ARRAY  OF Node2; VAR Transaction:Node2;VAR nombreTransaction,support:INTEGER):Node2;

VAR i:INTEGER;
    itemsetFrequent,resultatDuTriPartransaction,Nouveau:Node2; 
    NouveauSousListe1,NouveauSousListe2:Node;
 
    BEGIN 
      itemsetFrequent:=nil;resultatDuTriPartransaction:=nil;Nouveau:=NIL;
       NouveauSousListe1:=nil;NouveauSousListe2:=nil;
      i:=0;
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
       
       resultatDuTriPartransaction:=triParItemset(tableauDeTransaction,nombreTransaction);
       itemsetFrequent:=SetmDecision(tableauDeTransaction,resultatDuTriPartransaction,support);

    InitiationSet:=itemsetFrequent

END;

(*////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE SEMT(VAR Transaction:Node2;VAR nombreTransaction,support:INTEGER);

VAR resultatDuTriPartransaction,Generation:Node2;
    tableauDeTransaction: ARRAY OF Node2;
    generations:INTEGER;
    correspondanceItems:NodeItems;

      BEGIN
      resultatDuTriPartransaction:=nil;Generation:=NIL;
      correspondanceItems:=NIL;
      setlength(tableauDeTransaction,nombreTransaction);
      correspondanceItems:=extraction();
      generations:=2;
      writeln('************************************************  PREMIERE GENERATION  ********************************');
      Generation:=InitiationSet(tableauDeTransaction,Transaction,nombreTransaction,support);
      affichageItemset(Generation,correspondanceItems);
        WHILE Generation <> NIL DO
        begin
       
        JointureParTransaction(tableauDeTransaction, nombreTransaction);
       
        resultatDuTriPartransaction:=triParItemset(tableauDeTransaction,nombreTransaction);
       
        Generation:=SetmDecision(tableauDeTransaction,resultatDuTriPartransaction,support);
        
          IF Generation <> NIL THEN
          begin
          write('*********************************************');write(generations);writeln('  GENERATION **********************************');
          affichageItemset(Generation,correspondanceItems);
          end
          ELSE BEGIN
          writeln('**************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  SEMT ***********************!!!!!!!!!!!!!!!!!!!!!!!');
           (*///////////////////////////////////////////////////*)
         PlusMoinFreq(correspondanceItems);
         (*///////////////////////////////////////////////////*)
          END;
          
        generations:=generations+1;
        END;
    
END;

(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE MainSemt( support:INTEGER);

VAR Transaction,TransactionVariable:Node2;
    nombreTransaction:INTEGER;

    BEGIN 
    Transaction:=nil;TransactionVariable:=NIL;
    nombreTransaction:=0;
    Transaction:=extractionParTransaction();
    TransactionVariable:=Transaction;

        WHILE TransactionVariable <> NIL DO 
        begin
        nombreTransaction:=nombreTransaction+1;
        TransactionVariable:=TransactionVariable^.next;
        END;
    
    SEMT(Transaction,nombreTransaction,support);

 END;
(*/////////////////////////////////////////////////////////////*)

begin

end.

