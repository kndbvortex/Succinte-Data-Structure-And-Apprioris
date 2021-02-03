MODULE APRIORI;
IMPORT ListeChaine,Out,Extraction, Files;
 (*//////////////////////////////////////LES VARIABLES/////////////////////////////////////////////////////////////////*)
VAR 
   variable2:ARRAY 20 OF CHAR;
   action,tailleFichier,premiere_fois:INTEGER;
   listeSansDoublon,listeAvecDoublon,listeFrequent,plusF,moinF:ListeChaine.Node;
   fichier1:Files.File; 
   tableau:ARRAY 200000 OF ARRAY 10000 OF BYTE;
  
(*////////////////////////////////////////LES PROCEDURES//////////////////////////////////////////////////////////////*)

(*procedure qui permet de trier les produits  pour faciliter la jointure*)

PROCEDURE tri(VAR itemFrequent:ListeChaine.Node):ListeChaine.Node;
VAR NewitemFrequent,Tete:ListeChaine.Node;
    permuteur:INTEGER;

  BEGIN
  Tete:=itemFrequent;
    WHILE (itemFrequent # NIL) DO
     NewitemFrequent:=itemFrequent.next;

        WHILE (NewitemFrequent # NIL) DO

         IF itemFrequent.key > NewitemFrequent.key THEN
         permuteur:=itemFrequent.key;
         itemFrequent.key:= NewitemFrequent.key;
         NewitemFrequent.key:=permuteur;
        END;

      NewitemFrequent:=NewitemFrequent.next;
    END;

  itemFrequent:=itemFrequent.next
  END;

RETURN  Tete

END tri;  

(*///////////////////////////////////////////////////////////////////////////////*)

(*procedure qui permet de verifier si tout les k ensembles de (k-1) element obtenus par decomposition de l'ensemble 
  a k element sont tous present dans la liste des element frequent de rang k-1;*)

PROCEDURE VerifierSousEnsemble( VAR candidatPrecedent:ListeChaine.Node2;VAR preCandidat:ListeChaine.Node):INTEGER;
  VAR BOL,BOLSorti,valeurSuprimer:INTEGER;
      PositionTete:ListeChaine.Node;

    BEGIN
    BOLSorti:=1;
    PositionTete:=preCandidat;
      WHILE (PositionTete # NIL) & (BOLSorti =1) DO
         valeurSuprimer:=PositionTete.key;
         ListeChaine.Suppression(preCandidat,valeurSuprimer);
         BOL:=ListeChaine.GrandeAppartenance(candidatPrecedent,preCandidat);
         BOLSorti:=BOLSorti*BOL;
         ListeChaine.InsertionTete(preCandidat,valeurSuprimer);
        PositionTete:=PositionTete.next;
      END;
    
 RETURN BOLSorti 

END VerifierSousEnsemble;  

(*////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure qui permet de faire la jointure des itemsets de k-1 elements pour obetnir les k elements*)

PROCEDURE Jointure(VAR candidatPrecedent:ListeChaine.Node2):ListeChaine.Node2;
  VAR candidatPrecedent1,candidatPrecedent2,sorti:ListeChaine.Node2;
      sousItem1,sousItem2,sousItem3,sousSorti:ListeChaine.Node;
      valeur,decision:INTEGER;

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

         (*suppresion des itemset donc les k-1 sous-ensemble ne sont pas dans  les itemsets frequent n'existe pas dans Lk-1 *)
          decision:=VerifierSousEnsemble(candidatPrecedent,sousSorti);

            IF decision = 1 THEN
              ListeChaine.GrandInsertionTete(sorti,sousSorti);
            END;
          END;

      candidatPrecedent2:=candidatPrecedent2.next;    
      END;

    candidatPrecedent1:=candidatPrecedent1.next; 
    END; 

  RETURN sorti

END Jointure; 
(*////////////////////////////////////////////////////////////////////////////////////*) 

(*procedure qui donne la liste des items frequents de premiere generation*)

PROCEDURE itemFrequent*(VAR listeSansDoublon,listeAvecDoublon:ListeChaine.Node;VAR Frequence:INTEGER):ListeChaine.Node;
    
VAR avecD,sansD,ItemFr:ListeChaine.Node;
     nombrefois,max,min,produit1,produit2:INTEGER;

     BEGIN
       avecD:=listeAvecDoublon;
       sansD:=listeSansDoublon;
       max:=Frequence;
       min:=Frequence;
       plusF:=NIL;
       moinF:=NIL;

      WHILE sansD #  NIL DO
        nombrefois:=0;
        avecD:=listeAvecDoublon;

        WHILE avecD # NIL DO

          IF avecD.key = sansD.key  THEN
           nombrefois:=nombrefois+1;
          END; 

        avecD:=avecD.next;
        END;  

        IF nombrefois >= Frequence THEN
          ListeChaine.InsertionTete(ItemFr,sansD.key);

            IF max<nombrefois THEN
                 max:=nombrefois;
                 produit1:=sansD.key;
            END;

            IF min>=nombrefois THEN
                min:=nombrefois;
                produit2:=sansD.key;
            END;     
            
        END; 
      sansD:=sansD.next;
      END;

    ListeChaine.InsertionTete(plusF,produit1);
    ListeChaine.InsertionTete(moinF,produit2);

  RETURN ItemFr
END itemFrequent;

(*////////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure qui donne les items fequents d' un certain rang k*)

PROCEDURE DecisionCandidature(VAR tableau:ARRAY  OF ARRAY OF BYTE ;VAR preCandidat,itemFrequentTrie:ListeChaine.Node;VAR nombreTransaction,support :INTEGER):INTEGER;
VAR decision,i,toutLesElementA1,Frequence:INTEGER;
    newposition ,positionProduit,newPreCandidat,newitems:ListeChaine.Node;

  BEGIN 
  i:=0;
  newPreCandidat:=preCandidat;
  newitems:=itemFrequentTrie;

    WHILE newPreCandidat # NIL DO
    i:=0;
    newitems:=itemFrequentTrie;

      WHILE newitems # NIL DO

        IF newitems.key = newPreCandidat.key THEN
        ListeChaine.InsertionTete(positionProduit,i);
        newitems:=NIL;
        ELSE
        newitems:=newitems.next; 
        END; 

      i:=i+1;
     END;

    newPreCandidat:=newPreCandidat.next;
    END;

  i:=0;
  Frequence:=0;decision:=0;;

    WHILE i<nombreTransaction DO
      toutLesElementA1:=1;
      newposition:=positionProduit;

        WHILE newposition # NIL DO
        toutLesElementA1:=toutLesElementA1*tableau[i][newposition.key];
        newposition:=newposition.next;
        END;

      IF toutLesElementA1=1 THEN
      Frequence:=Frequence+1;
      END;

    i:=i+1;
    END;

    IF Frequence>=support THEN
            decision:=1;
    END;

  RETURN decision 
   
END DecisionCandidature;
(*////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE Apriori(VAR tableau:ARRAY  OF ARRAY OF BYTE;VAR candidat:ListeChaine.Node2 ;VAR itemFrequentTrie:ListeChaine.Node;
                  VAR correspondanceItems:ListeChaine.NodeItems;VAR nombreTransaction,support:INTEGER);
 
VAR ListeGeneration:ListeChaine.Node2;
    generation,decision,Fmax:INTEGER;
    preCandidat:ListeChaine.Node;

  BEGIN     
    generation:=3;

    WHILE candidat # NIL DO
    ListeGeneration:=Jointure(candidat);

      IF ListeGeneration #NIL THEN
      Out.String("*********************************************");Out.Int(generation,0);Out.String("  GENERATION **********************************");
      ELSE
      Out.String(" ************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********** FIN  Apriori ***********************!!!!!!!!!!!!!!!!!!!!!!!");
      
        (*///////////////////////////////////////*)

        Extraction.PlusMoinFreq(correspondanceItems);
            
        (*///////////////////////////////////////*) 

    END; 

    candidat:=NIL;

      WHILE ListeGeneration # NIL DO
      preCandidat:=ListeGeneration.key;
      decision:=DecisionCandidature(tableau,preCandidat,itemFrequentTrie,nombreTransaction,support);
        
        IF decision = 1 THEN
        ListeChaine.GrandInsertionTete(candidat,preCandidat);
        END;

      ListeGeneration:=ListeGeneration.next;
      END;

    generation:=generation+1; 
    Out.Ln;
    Extraction.affichageItemset(candidat,correspondanceItems);Out.Ln;
   END; 
END Apriori; 

(*////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE AprioriInitialisation(VAR tableau:ARRAY  OF ARRAY OF BYTE;VAR itemFrequentTrie:ListeChaine.Node;VAR nombreTransaction,support:INTEGER);
  
VAR listeVariable1,listeVariable2,preCandidat:ListeChaine.Node;
    candidat,ListeGenerationReutilisable:ListeChaine.Node2;
    decision:INTEGER;
    correspondanceItems:ListeChaine.NodeItems;

      BEGIN 
      correspondanceItems:=Extraction.extraction();
      
      Out.String("************************************************  PREMIERE GENERATION  ********************************");Out.Ln;
      Extraction.correspondance(itemFrequentTrie, correspondanceItems);
      listeVariable1:=itemFrequentTrie; 
     
          WHILE listeVariable1 # NIL DO
          preCandidat:=NIL;
          ListeChaine.InsertionTete(preCandidat,listeVariable1.key);
          listeVariable2:=listeVariable1.next;

            WHILE listeVariable2 # NIL DO
           ListeChaine.InsertionTete(preCandidat,listeVariable2.key);
            decision:=DecisionCandidature(tableau,preCandidat,itemFrequentTrie,nombreTransaction,support);

              IF decision = 1 THEN
              ListeChaine.GrandInsertionTete(candidat,preCandidat);

              END; 

            preCandidat:=NIL;
            ListeChaine.InsertionTete(preCandidat,listeVariable1.key);
            listeVariable2:=listeVariable2.next;
            END;

         listeVariable1:=listeVariable1.next;  
         END;

      Out.String("************************************************ DEUXIEME GENERATION   ***********************************");Out.Ln;    
     Extraction.affichageItemset(candidat,correspondanceItems);Out.Ln;

    ListeGenerationReutilisable:=candidat;
    candidat:=NIL;

    WHILE ListeGenerationReutilisable # NIL DO
    ListeChaine.GrandInsertionTete(candidat,ListeGenerationReutilisable.key);  
    ListeGenerationReutilisable:=ListeGenerationReutilisable.next;
    END;

       Apriori(tableau,candidat, itemFrequentTrie,correspondanceItems,nombreTransaction ,support);
END AprioriInitialisation;
 
(*/////////////////////////////////////////////////////////////////////////*)
PROCEDURE AppartenenceTransaction(VAR transaction:ListeChaine.Node ;VAR produit:INTEGER):INTEGER;
    VAR BOL:INTEGER;
        transact:ListeChaine.Node;
    BEGIN 
    BOL:=0;
   transact:=transaction;
    WHILE (transact # NIL) & (BOL=0) DO
      IF transact.key = produit THEN
        BOL:=1;
      END;
    transact:=transact.next;
    END;
  RETURN BOL  
END AppartenenceTransaction; 
(*/////////////////////////////////////////////////////////////////////////////////////////////*)

(*procedure qui produit un tableau binaire ayant en ligne les transactions et en colonne les produits
  une case contient un (1) si le produit appartient a la transaction de cette ligne et 0 sinon*)
  
PROCEDURE TableauBinaire(VAR tableau:ARRAY  OF ARRAY OF BYTE;VAR itemFrequentTrie:ListeChaine.Node;VAR support:INTEGER);
  VAR nombreLigne,nombreColonne,i,j,appart:INTEGER;
      LISTE1,LISTE:ListeChaine.Node2;
      SansDoublon:ListeChaine.Node;
  BEGIN
  nombreLigne:=0;
  nombreColonne:=0;
  LISTE1:=Extraction.extractionParTransaction();
  LISTE:=LISTE1;
  WHILE LISTE # NIL DO
   nombreLigne:=nombreLigne+1;
   LISTE:=LISTE.next;
  END;
  SansDoublon:=listeSansDoublon;
  WHILE SansDoublon # NIL DO
    nombreColonne:=nombreColonne+1;
    SansDoublon:=SansDoublon.next;
  END;
  i:=0;
  WHILE i<nombreLigne DO
  j:=0;
     WHILE j<nombreColonne DO
      tableau[i][j]:=0;
      j:=j+1;
     END;
  i:=i+1;
  END;
  LISTE:=LISTE1;
  i:=0;
    WHILE LISTE # NIL DO
     SansDoublon:=listeSansDoublon;
     j:=0; 
      WHILE SansDoublon # NIL DO
       appart:=AppartenenceTransaction(LISTE.key,SansDoublon.key);
        IF (appart = 1)THEN
         tableau[i][j]:=1;   
       END;
       j:=j+1;
       SansDoublon:=SansDoublon.next;
      END; 
      i:=i+1;
      LISTE:=LISTE.next; 
    END;

   AprioriInitialisation(tableau,itemFrequentTrie,nombreLigne,support);

END TableauBinaire;
(*/////////////////////////////////////////////////////////////////////////////*)

PROCEDURE MainApriori*(VAR support:INTEGER);
   BEGIN
  fichier1:=Files.Old("transactions1.txt");
  tailleFichier:=Files.Length(fichier1);
  variable2:="transactions1.txt";
  action:=1;
  Extraction.LireIntFichier(listeSansDoublon ,variable2,action,tailleFichier);
  action:=0;
  Extraction.LireIntFichier(listeAvecDoublon,variable2,action,tailleFichier);
  NEW(listeFrequent);
  listeFrequent:=itemFrequent(listeSansDoublon,listeAvecDoublon,support);
  listeSansDoublon :=tri(listeFrequent);
  TableauBinaire(tableau,listeSansDoublon,support);
END MainApriori;
	

BEGIN
END APRIORI.
