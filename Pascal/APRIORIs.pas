unit APRIORIs;

interface
uses ListeChaine,extractionPascal;
PROCEDURE MainApriori(VAR support:INTEGER);

implementation

TYPE
  Tligne=ARRAY of byte;
  tableauDeuxDimension=ARRAY of Tligne;

(*////////////////////////////////////////LES PROCEDURES//////////////////////////////////////////////////////////////*)

function tri(VAR itemFrequent:Node):Node;
VAR NewitemFrequent,Tete:Node;
    permuteur:INTEGER;

  BEGIN
  NewitemFrequent:=nil;Tete:=nil;
  Tete:=itemFrequent;
    WHILE (itemFrequent <> NIL) DO
    begin
    NewitemFrequent:=itemFrequent^.next;
        WHILE (NewitemFrequent <> NIL) DO
        begin

          IF itemFrequent^.key > NewitemFrequent^.key THEN
          begin
          permuteur:=itemFrequent^.key;
          itemFrequent^.key:= NewitemFrequent^.key;
          NewitemFrequent^.key:=permuteur;
          END;
        
        NewitemFrequent:=NewitemFrequent^.next;
       END;
       
    itemFrequent:=itemFrequent^.next
    END;
tri:= Tete;
END ;  

(*///////////////////////////////////////////////////////////////////////////////*)
function VerifierSousEnsemble( VAR candidatPrecedent:Node2;VAR preCandidat:Node):INTEGER;
  VAR BOL,BOLSorti,valeurSuprimer:INTEGER;
      PositionTete:Node;

    BEGIN
    BOLSorti:=1;
    PositionTete:=nil;
    PositionTete:=preCandidat;
        
        WHILE (PositionTete <> NIL) and (BOLSorti =1) DO
        begin
        valeurSuprimer:=PositionTete^.key;
        Suppression(preCandidat,valeurSuprimer);
        BOL:=GrandeAppartenance(candidatPrecedent,preCandidat);
        BOLSorti:=BOLSorti*BOL;
        InsertionTete(preCandidat,valeurSuprimer);
        PositionTete:=PositionTete^.next;
        END;

    VerifierSousEnsemble:=BOLSorti ;

END ;

(*////////////////////////////////////////////////////////////////////////////////////*) 
function itemFrequent(VAR listeSansDoublon,listeAvecDoublon:Node;VAR Frequence:INTEGER):Node;
    VAR avecD,sansD,ItemFr:Node;
     nombrefois:INTEGER;
     BEGIN
      avecD:=nil;sansD:=nil;ItemFr:=nil;
       avecD:=listeAvecDoublon;
       sansD:=listeSansDoublon;
    WHILE sansD <>  NIL DO
    begin
        nombrefois:=0;
        avecD:=listeAvecDoublon;
        WHILE avecD <> NIL DO
        begin
          IF avecD^.key = sansD^.key  THEN
           nombrefois:=nombrefois+1;

        avecD:=avecD^.next;
        END;
        
        IF nombrefois >= Frequence THEN
          InsertionTete(ItemFr,sansD^.key); 

    sansD:=sansD^.next;
    END;
    itemFrequent:=ItemFr;
END;
(*////////////////////////////////////////////////////////////////////////////////////////*)

function Jointure(VAR candidatPrecedent:Node2):Node2;
  VAR candidatPrecedent1,candidatPrecedent2,sorti:Node2;
      sousItem1,sousItem2,sousItem3,sousSorti:Node;
      valeur,decision:INTEGER;
  
    BEGIN
    candidatPrecedent1:=NIL;candidatPrecedent2:=NIL;sorti:=nil;
    sousItem1:=nil;sousItem2:=nil;sousItem3:=nil;sousSorti:=nil;
    candidatPrecedent1:=candidatPrecedent;
    
    decision:=0;
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
          
          {suppresion des itemset donc les k-1 sous-ensemble ne sont pas dans  les itemsets frequent n'existe pas dans Lk-1} 
          {decision:=VerifierSousEnsemble(candidatPrecedent,sousSorti);}
            IF decision = 0 THEN
             GrandInsertionTete(sorti,sousSorti)
        END;
    	candidatPrecedent2:=candidatPrecedent2^.next;    
    	END;

    candidatPrecedent1:=candidatPrecedent1^.next; 
    END; 
    dispose(candidatPrecedent1);
    dispose(candidatPrecedent2);
     Jointure:=sorti;

END; 
(*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*) 
function DecisionCandidature(VAR tableauBinaire:tableauDeuxDimension;VAR preCandidat,itemFrequentTrie:Node;VAR nombreTransaction,support:INTEGER):INTEGER;
VAR decision,i,j,toutLesElementA1,Frequence:INTEGER;
    newposition ,positionProduit,newPreCandidat,newitems:Node;

  BEGIN 
  i:=0;
  newposition:=NIL;
  positionProduit:=NIL;
  newPreCandidat:=NIL;
  newitems:=NIL;
  newPreCandidat:=preCandidat;
  newitems:=itemFrequentTrie;

    WHILE newPreCandidat <> NIL DO
    begin 
    i:=0;
    newitems:=itemFrequentTrie;

      WHILE newitems <> NIL DO
      begin

        IF newitems^.key = newPreCandidat^.key THEN
        begin
        InsertionTete(positionProduit,i);
        newitems:=NIL;
        end
        ELSE
        newitems:=newitems^.next ;

    i:=i+1;
     END;

    newPreCandidat:=newPreCandidat^.next;
    END;

  i:=0;
  Frequence:=0;decision:=0;;

    WHILE i<nombreTransaction DO
    begin
      toutLesElementA1:=1;
      newposition:=positionProduit;

        WHILE newposition <> NIL DO
        begin
        j:=newposition^.key;
        toutLesElementA1:=toutLesElementA1*tableauBinaire[i][j];
        newposition:=newposition^.next;
        END;
      IF toutLesElementA1=1 THEN
      Frequence:=Frequence+1;

    i:=i+1;
    END;

    IF Frequence>=support THEN
       decision:=1;

   DecisionCandidature:=decision; 
   
END;


(*///////////////////////////////////////////////// APRIORI ID  // //////////////////////////////////////////////////*)


(*////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE Apriori(VAR tableau:tableauDeuxDimension;VAR candidat:Node2 ;VAR itemFrequentTrie:Node;
                  VAR correspondanceItems:NodeItems;VAR nombreTransaction,support:INTEGER);
 
VAR ListeGeneration:Node2;
    generation,decision:INTEGER;
    preCandidat:Node;

  BEGIN     
     ListeGeneration:=NIL;
     preCandidat:=NIL;
     generation:=3;
    WHILE candidat <> NIL DO
    begin
    ListeGeneration:=Jointure(candidat);

      IF ListeGeneration <>NIL THEN
      begin
      write('*********************************************');
      write(generation);
      writeln('  GENERATION **********************************');
      end
      ELSE BEGIN
     
      writeln('*************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  Apriori ***********************!!!!!!!!!!!!!!!!!!!!!!!');
         (*///////////////////////////////////////////////////*)
         PlusMoinFreq(correspondanceItems);
         (*///////////////////////////////////////////////////*)
      END;   
     candidat:=NIL;

      WHILE ListeGeneration <> NIL DO
      begin
      preCandidat:=ListeGeneration^.key;
      decision:=DecisionCandidature(tableau,preCandidat,itemFrequentTrie,nombreTransaction,support);
        
        IF decision = 1 THEN
        GrandInsertionTete(candidat,preCandidat);

      ListeGeneration:=ListeGeneration^.next;
      END;

    generation:=generation+1; 
    writeln('');
    affichageItemset(candidat,correspondanceItems);writeln('');
   END;  

END; 

(*////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE AprioriInitialisation(VAR tableau:tableauDeuxDimension;VAR itemFrequentTrie:Node;VAR nombreTransaction,support:INTEGER);
  
VAR listeVariable1,listeVariable2,preCandidat:Node;
    candidat,ListeGenerationReutilisable:Node2;
    decision:INTEGER;
    correspondanceItems:NodeItems;

      BEGIN 
      listeVariable1:=nil;listeVariable2:=nil;preCandidat:=nil;
      candidat:=nil;ListeGenerationReutilisable:=nil;
      correspondanceItems:=nil;
      correspondanceItems:=extraction();
      writeln('************************************************  PREMIERE GENERATION  ********************************');
      correspondance(itemFrequentTrie,correspondanceItems);
      listeVariable1:=itemFrequentTrie; 

          WHILE listeVariable1 <> NIL DO
          begin
          preCandidat:=NIL;
          InsertionTete(preCandidat,listeVariable1^.key);
          listeVariable2:=listeVariable1^.next;

            WHILE listeVariable2 <> NIL DO
            begin
            InsertionTete(preCandidat,listeVariable2^.key);
            decision:=DecisionCandidature(tableau,preCandidat,itemFrequentTrie,nombreTransaction,support);

              IF decision = 1 THEN
              GrandInsertionTete(candidat,preCandidat);

            preCandidat:=NIL;
            InsertionTete(preCandidat,listeVariable1^.key);
            listeVariable2:=listeVariable2^.next;
            END;

         listeVariable1:=listeVariable1^.next;  
         END;

      writeln('************************************************ DEUXIEME GENERATION   ***********************************');    
      affichageItemset(candidat,correspondanceItems);
      ListeGenerationReutilisable:=candidat;
      candidat:=NIL;

    WHILE ListeGenerationReutilisable <> NIL DO
    begin
    GrandInsertionTete(candidat,ListeGenerationReutilisable^.key);  
    ListeGenerationReutilisable:=ListeGenerationReutilisable^.next;
    END;
       Apriori(tableau,candidat, itemFrequentTrie,correspondanceItems,nombreTransaction ,support);
END ;
(*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)
function AppartenenceTransaction(VAR transaction:Node ;VAR produit:INTEGER):INTEGER;
    VAR BOL:INTEGER;
        transact:Node;
    BEGIN 
    BOL:=0;
    transact:=nil;
    transact:=transaction;
    WHILE (transact <> NIL) and (BOL=0) DO
    begin
      IF transact^.key = produit THEN
        BOL:=1;

    transact:=transact^.next;
    END;
  AppartenenceTransaction:=BOL;  
END ; 
(*/////////////////////////////////////////////////////////////////////////*)
PROCEDURE TableauBinaire(VAR itemFrequentTrie:Node;VAR support:INTEGER);
  VAR nombreLigne,nombreColonne,i,j,appart:INTEGER;
      LISTE1,LISTE:Node2;
      SansDoublon:Node;
      tableau:tableauDeuxDimension;
  BEGIN
  LISTE1:=nil;LISTE:=nil;
  nombreLigne:=0;
  nombreColonne:=0;
  LISTE1:=extractionParTransaction();
  LISTE:=LISTE1;
  WHILE LISTE <> NIL DO
  begin
   nombreLigne:=nombreLigne+1;
   LISTE:=LISTE^.next;
  END;
  SansDoublon:=itemFrequentTrie;
  WHILE SansDoublon <> NIL DO
  begin
    nombreColonne:=nombreColonne+1;
    SansDoublon:=SansDoublon^.next;
  END;

  setlength(tableau,nombreLigne,nombreColonne);

  i:=0;
  WHILE i<nombreLigne DO
  begin
  j:=0;
     WHILE j<nombreColonne DO
     begin
      tableau[i][j]:=0;
      j:=j+1;
     END;
  i:=i+1;
  END;
  LISTE:=LISTE1;
  i:=0;
    WHILE LISTE <> NIL DO
    begin
     SansDoublon:=itemFrequentTrie;
     j:=0; 
      WHILE SansDoublon <> NIL DO
      begin
       appart:=AppartenenceTransaction(LISTE^.key,SansDoublon^.key);
        IF (appart = 1)THEN
         tableau[i][j]:=1;   
      j:=j+1;
       SansDoublon:=SansDoublon^.next;
      END; 
      i:=i+1;
      LISTE:=LISTE^.next; 
    END;

   AprioriInitialisation(tableau,itemFrequentTrie,nombreLigne,support);

END;
(*/////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE MainApriori(VAR support:INTEGER);
VAR listeSansDoublon ,listeAvecDoublon,listeFrequent:node; 
  BEGIN
    listeSansDoublon:=nil;listeAvecDoublon:=nil;
    listeSansDoublon:=extractionSansOuAvecDoublons(0);
    listeAvecDoublon:=extractionSansOuAvecDoublons(1);
    NEW(listeFrequent);
    listeFrequent:=itemFrequent(listeSansDoublon,listeAvecDoublon,support);
    listeSansDoublon :=tri(listeFrequent);
     

    TableauBinaire(listeSansDoublon,support);
  END ;
(*/////////////////////////////////////////////////////////////////////////////*) 
begin
end.