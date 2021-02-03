MODULE Extraction;
IMPORT ListeChaine,Out,Files,In;
(*/////////////////////////////////////////////////////////////////////////////*)
VAR MAX,MIN:INTEGER;

PROCEDURE CastCaract*(VAR Caract:CHAR):INTEGER;
   VAR codeAsc,valeur,i:INTEGER;
       entier:ARRAY 10 OF INTEGER;
       BEGIN
       i:=0;
        WHILE i<10 DO
           entier[i]:=i;
           i:=i+1;
          END;
    codeAsc:=ORD(Caract);
    codeAsc:=codeAsc-48;
    IF (codeAsc < 10) & (codeAsc >=0) THEN
    valeur:=entier[codeAsc];
    END;
    RETURN valeur
END CastCaract;

(*////////////////////////////////////////////////////////////////////////////*)

 PROCEDURE RetourneINT*(VAR Item:ARRAY OF CHAR;VAR Tete:ListeChaine.Node;VAR doublon,taille:INTEGER);
   VAR valeur,valeurFinale,i,j,k,l:INTEGER;
       nomberS:ListeChaine.Node;
       valeurChar:CHAR;
     BEGIN 
      i:=0;k:=0;
      WHILE (i<taille) DO
       NEW(nomberS);
          IF Item[i] = ":" THEN
             i:=i+1;
             k:=0;
             l:=0;
               WHILE ((i<LEN(Item))&(Item[i] # ";")) DO
                 valeurChar:=Item[i];
                 j:=CastCaract(valeurChar);
                 ListeChaine.InsertionTete(nomberS,j);
                 i:=i+1; 
               END;
          k:=0;
          valeurFinale:=0;
          WHILE nomberS.next # NIL DO
               j:=0;
                valeur:=nomberS.key;
               WHILE j<k DO
               valeur:=valeur*10;
               j:=j+1;
               END;
               k:=k+1; 
            valeurFinale:=valeurFinale+valeur;
             nomberS:=nomberS.next;    
          END;
          IF doublon =1 THEN
            ListeChaine.InsertionSansDoublon(Tete,valeurFinale);
          ELSE
            ListeChaine.InsertionTete(Tete, valeurFinale);
          END;
        END;  
         i:=i+1;
      END;  
END RetourneINT;
(*/////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE LireIntFichier*(VAR Tete:ListeChaine.Node;VAR NomFichier:ARRAY OF CHAR;VAR doublon:INTEGER;VAR taille:INTEGER);
   VAR 
        variable:ARRAY 6904806 OF CHAR;
        fichier:Files.File;
        rider:Files.Rider; 
      BEGIN 
      fichier:=Files.Old(NomFichier);
      Files.Set(rider,fichier,0);
      Files.ReadString(rider,variable);
      RetourneINT(variable,Tete,doublon,taille);
      Files.Close(fichier);
END LireIntFichier;
(*/////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE extraction*():ListeChaine.NodeItems;
VAR  valeur,i,j,k,l,m,valeurFinale:INTEGER;
     valeurChar:CHAR;
      variable:ARRAY 140665 OF CHAR;
      cle:ARRAY 50 OF CHAR;
      fichier:Files.File;
      rider:Files.Rider;
      items:ListeChaine.NodeItems;
      nomberS:ListeChaine.Node;
    BEGIN
      i:=0;
      fichier:=Files.Old("data_items.txt");
      Files.Set(rider,fichier,0);
      Files.ReadString(rider,variable);
      Files.Close(fichier);
      WHILE(i<Files.Length(fichier)) DO
             j:=0;m:=0;
             WHILE m <LEN(cle) DO
             cle[m]:="";
             m:=m+1;
             END;
             WHILE (i<Files.Length(fichier)) & (variable[i] # ":") DO
              cle[j]:=variable[i];
              j:=j+1;
              i:=i+1;
              END;
              i:=i+1;
              k:=0;
              l:=0;
               WHILE ((i<Files.Length(fichier))&(variable[i] # ";")) DO
                 valeurChar:=variable[i];
                 j:=CastCaract(valeurChar);
                 ListeChaine.InsertionTete(nomberS,j);
                 i:=i+1; 
               END;
              valeurFinale:=0;
              WHILE nomberS.next # NIL DO
               j:=0;
                valeur:=nomberS.key;
               WHILE j<k DO
               valeur:=valeur*10;
               j:=j+1;
               END;
               k:=k+1; 
            valeurFinale:=valeurFinale+valeur;
             nomberS:=nomberS.next;    
          END;
          ListeChaine.InsertionTeteItem(items,cle,valeurFinale);
        i:=i+1;
      END;
       RETURN items
END extraction; 
(*/////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE correspondance*(VAR listeSansDoublon:ListeChaine.Node;VAR Extrai:ListeChaine.NodeItems);
 VAR sansDoublon:ListeChaine.Node;
     itemLettre,itemLettreNonModifier:ListeChaine.NodeItems;
     premierFois:INTEGER;
 BEGIN
 premierFois:=1;
 sansDoublon:=listeSansDoublon;
itemLettre:=Extrai;
itemLettreNonModifier:=itemLettre;
 WHILE sansDoublon # NIL DO
 itemLettre:=itemLettreNonModifier;
    WHILE itemLettre # NIL DO
      IF sansDoublon.key = itemLettre.key2 THEN
          Out.String(itemLettre.key1); 
          itemLettre:=NIL;
          premierFois:=0;
      ELSE 
     itemLettre:=itemLettre.next;
    END;
  END;
 sansDoublon:=sansDoublon.next;
 END;
 Out.Ln;
 IF premierFois = 0 THEN
 Out.String("------------------------------------------------------------------------------------------------");
 END;
END correspondance; 
(*///////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE affichageItemset*(VAR liste:ListeChaine.Node2;VAR Extrai:ListeChaine.NodeItems);
  VAR newliste:ListeChaine.Node2;
    BEGIN
    newliste:=liste;  
    WHILE newliste # NIL DO
     correspondance(newliste.key,Extrai);
     Out.Ln;
     newliste:=newliste.next; 
    END;
END affichageItemset;
(*/////////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE extractionParTransaction*():ListeChaine.Node2;
  VAR  premiereEntrer,k,i,j,valeur,NumeroTransaction,NumeroTransactionModifiable,produit:INTEGER;
        variable:ARRAY 6904806 OF CHAR;
        fichier:Files.File;
        rider:Files.Rider;
        ListeParTransaction:ListeChaine.Node2;
        valeurChar:CHAR;
        listeTran,listeProd,SousListeFinal:ListeChaine.Node;
        numeroTranscFinal,produitFinal:INTEGER;
  BEGIN
  i:=0;
  premiereEntrer:=1;
    fichier:=Files.Old("transactions1.txt");
    Files.Set(rider,fichier,0);
    Files.ReadString(rider,variable); 
    NumeroTransaction:=0;
    NumeroTransactionModifiable:=-1;
    WHILE(i<Files.Length(fichier)) DO
      WHILE((i<Files.Length(fichier)) & (variable[i] # ":")) DO 
        valeurChar:=variable[i];
        NumeroTransaction:=CastCaract(valeurChar);
        ListeChaine.InsertionTete(listeTran,NumeroTransaction);
        i:=i+1;
      END;
      i:=i+1;
      WHILE ((i<Files.Length(fichier)) & (variable[i] # ";")) DO
        valeurChar:=variable[i];
        produit:=CastCaract(valeurChar);
        ListeChaine.InsertionTete(listeProd,produit);
        i:=i+1; 
      END;
      i:=i+1;
      k:=0;
      produitFinal:=0;
      WHILE listeProd # NIL DO
        j:=0;
        valeur:=listeProd.key;
        WHILE j<k DO
          valeur:=valeur*10;
          j:=j+1;
        END;
        k:=k+1; 
     produitFinal:=produitFinal+valeur;
        listeProd:=listeProd.next;    
      END;
      numeroTranscFinal:=0;
      k:=0;
      WHILE listeTran # NIL DO
        j:=0;
        valeur:=listeTran.key;
        WHILE j<k DO
          valeur:=valeur*10;
          j:=j+1;
        END;
        k:=k+1;
        numeroTranscFinal:=numeroTranscFinal+valeur;
        listeTran:=listeTran.next; 
      END; 
    IF premiereEntrer = 1 THEN    
      NumeroTransactionModifiable:=numeroTranscFinal;
      premiereEntrer:=0;
    END;  
      IF numeroTranscFinal = NumeroTransactionModifiable THEN
          ListeChaine.InsertionTete(SousListeFinal,produitFinal);
      ELSE 
      NumeroTransactionModifiable:=numeroTranscFinal;
      ListeChaine.GrandInsertionTete(ListeParTransaction,SousListeFinal);
      SousListeFinal:=NIL;
      ListeChaine.InsertionTete(SousListeFinal,produitFinal);
      END;
    END;
  RETURN  ListeParTransaction

END extractionParTransaction; 
(*///////////////////////////////////////////////////////////////////////////////*)

PROCEDURE PlusMoinFreq*(VAR correspondanceItems:ListeChaine.NodeItems);
VAR max,min,nombrefois,tailleFichier,Choix,action:INTEGER;
    avecD,sansD,listeAvecDoublon,listeSansDoublon,listePlusFreq,listeMoinFreq:ListeChaine.Node;
    fichier:Files.File;
    variable2:ARRAY 20 OF CHAR;


BEGIN
	Choix:=1;
  Out.Ln;Out.Ln; Out.String("  ITEMS PLUS OU MOINS FREQUENTS ?");Out.Ln;
  action:=1;
   WHILE((Choix = 1) OR (Choix = 2)) DO
      Out.Ln;Out.Ln;
	  Out.String("1 ---ITEMS  PLUS FREQUENTS :");Out.Ln;
	  Out.String("2 ---ITEMS MOINS FREQUENTS :");Out.Ln;
	  Out.String("0 ---POUR SORTIR:");Out.Ln;Out.String("-->");
		  In.Int(Choix);
		   	IF (Choix # 1)&(Choix # 2) THEN
		    	Out.String("");
		   	ELSE 
		   	       
		   	        IF action = 1 THEN
					  fichier:=Files.Old("transactions1.txt");
					  tailleFichier:=Files.Length(fichier);
					  variable2:="transactions1.txt";
					  LireIntFichier(listeSansDoublon ,variable2,action,tailleFichier);
					  action:=0;
					  LireIntFichier(listeAvecDoublon,variable2,action,tailleFichier);
                    END;
					   max:=0;min:=3;
					   sansD:=listeSansDoublon;
					   WHILE (sansD # NIL) DO
					   avecD:=listeAvecDoublon;
					   nombrefois:=0;

					      WHILE (avecD # NIL) DO
					        
					          IF (sansD.key = avecD^.key) THEN
					                nombrefois:=nombrefois+1;
					          END;

					      avecD:=avecD^.next;
					      END;

					      IF (max < nombrefois) THEN
					         listePlusFreq:=NIL;
					         max:=nombrefois;
					         ListeChaine.InsertionTete(listePlusFreq,sansD^.key);
					      ELSIF (max = nombrefois) THEN
					            ListeChaine.InsertionTete(listePlusFreq,sansD^.key);
					      END;

					      IF (min > nombrefois) THEN
					       listeMoinFreq:=NIL;
					       min:=nombrefois;
					       ListeChaine.InsertionTete(listeMoinFreq,sansD^.key);
					      ELSIF (min=nombrefois) THEN
					        ListeChaine.InsertionTete(listeMoinFreq,sansD^.key);
					      END; 
					      

					   sansD:=sansD^.next;
					   END;
					   
					   MAX:=max;
					   MIN:=min;
					   IF( Choix = 1) THEN
					   Out.Ln;Out.Ln;Out.String("_______________________LES ITEMS LES PLUS FREQUENTS_________________");Out.Ln;
					   correspondance(listePlusFreq,correspondanceItems);
					   Out.String(" LA FREQUENCE MAXIMALE EST: ");Out.Int(MAX,0);
					   END;
					   IF (Choix = 2) THEN
					   Out.Ln;Out.String("____________________________LES ITEMS LES MOINS FREQUENTS_________________");Out.Ln;
					   correspondance(listeMoinFreq,correspondanceItems);
					   Out.String(" LA FREQUENCE MAXIMALE EST: ");Out.Int(MIN,0);
					   END;
		END; 	END;			   
END PlusMoinFreq;

(*///////////////////////////////////////////////////////////////////////////////*)
END Extraction.
