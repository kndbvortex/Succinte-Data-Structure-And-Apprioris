unit extractionPascal;

interface
uses ListeChaine;

function extractionSansOuAvecDoublons(choix:INTEGER):Node;
function extractionParTransaction():Node2;
function extraction():NodeItems;
PROCEDURE correspondance(VAR listeSansDoublon:Node;VAR Extrai:NodeItems);
PROCEDURE affichageItemset(VAR liste:Node2;VAR Extrai:NodeItems);  
PROCEDURE PlusMoinFreq(correspondanceItems:NodeItems);  

implementation
(*///////////////////////////////////////// extraction //////////////////////  /////////////////////////////////////*)
function diviseChaine(var ligne:string; choix:INTEGER):string;
  var nom,code:string;
      i:INTEGER;

  begin
  i:=1;nom:='';code:='';
   while ligne[i]<> ':' do
   begin
   nom:=nom+ligne[i];
   i:=i+1;
   end;
   i:=i+1;
   while i< Length(ligne) do
   begin
   code:=code+ligne[i];
   i:=i+1;
   end;
  IF choix = 0 THEN
   diviseChaine:=nom
  ELSE 
   diviseChaine:=code; 
end;
{/////////////////////////////////////////////////////////////////}
  function extractionSansOuAvecDoublons(choix:INTEGER):Node;
VAR 
      itemsSansdoublon,itemsavecdoublon:Node;
      fichier:text;
      ligne: string;
      nom:string;
      code,vide:INTEGER;
    BEGIN
    itemsSansdoublon:=nil;itemsavecdoublon:=nil;
      assign(fichier,'transactions10.txt');
      {$I-}
      reset(fichier);
      readln(fichier,ligne);
        while not eof(fichier) do
        begin
          nom:=diviseChaine(ligne,1);
          val(nom,code,vide);
          InsertionSansDoublon(itemsSansdoublon,code); 
          InsertionTete(itemsavecdoublon,code);
          readln(fichier,ligne);
        end;
        close(fichier); 
    IF choix = 0  THEN        
    extractionSansOuAvecDoublons:= itemsSansdoublon
    ELSE  
    extractionSansOuAvecDoublons:= itemsavecdoublon; 

END;
  (*/////////////////////////////////////////////////////////////////////////////////////////////////////*)
function extractionParTransaction():Node2;
  VAR ListeParTransaction:Node2;
      SousListeFinal:Node;
      fichier:text;
      ligne: string;
      NumeroTransaction,numeroProduit:string;
      numero,produit,vide,numeroPrecedent:INTEGER;

    BEGIN
    SousListeFinal:=NIL;
    ListeParTransaction:=NIL;
      assign(fichier,'transactions10.txt');
      {$I-}
      reset(fichier);
      readln(fichier,ligne);
      numeroPrecedent:=-1;
        while not eof(fichier) do
        begin
          NumeroTransaction:=diviseChaine(ligne,0);
          numeroProduit:=diviseChaine(ligne,1);
          val(NumeroTransaction,numero,vide);
          val(numeroProduit,produit,vide);
           IF numeroPrecedent =-1 THEN
            numeroPrecedent:=numero;

          IF numeroPrecedent = numero  THEN
           InsertionTete(SousListeFinal,produit)
          ELSE
          begin
          numeroPrecedent:=numero;
          GrandInsertionTete(ListeParTransaction,SousListeFinal);
          SousListeFinal:=NIL;
          InsertionTete(SousListeFinal,produit);
          end;
          readln(fichier,ligne);
        end;
        GrandInsertionTete(ListeParTransaction,SousListeFinal);
        close(fichier); 

extractionParTransaction:=ListeParTransaction;
     
END; 
(*///////////////////////////////////////////////////////////////////////////////////////////////*)


(*/////////////////////////////////////////////////////////////////////////////////*)

function extraction():NodeItems;
VAR 
      items:NodeItems;
      fichier:text;
      ligne: string;
      nom:string;
      code,vide:INTEGER;
    BEGIN
      assign(fichier,'test.txt');
      {$I-}
      reset(fichier);
      readln(fichier,ligne);
        while not eof(fichier) do
        begin
          nom:=diviseChaine(ligne,0);
          ligne:=diviseChaine(ligne,1);
          val(ligne,code,vide);
          InsertionTeteItem(items,nom,code);
          readln(fichier,ligne);
        end;
        close(fichier);
     extraction:=items;     
END; 
(*///////////////////////////////////////////////////////////////////////////////////////////////////*)
PROCEDURE correspondance(VAR listeSansDoublon:Node;VAR Extrai:NodeItems);
 VAR sansDoublon:Node;
     itemLettre,itemLettreNonModifier:NodeItems;
     premierFois:INTEGER;
 BEGIN
 sansDoublon:=NIL;
 itemLettre:=NIL;
 itemLettreNonModifier:=NIL;
 premierFois:=1;
 sansDoublon:=listeSansDoublon;
 itemLettre:=Extrai;
 itemLettreNonModifier:=itemLettre;
 WHILE sansDoublon <> NIL DO
 begin
  itemLettre:=itemLettreNonModifier;
    WHILE itemLettre <> NIL DO
    begin

      IF sansDoublon^.key = itemLettre^.key2 THEN
      begin
          writeln(itemLettre^.key1); 
          itemLettre:=NIL;
          premierFois:=0;
      END   
      ELSE 
      itemLettre:=itemLettre^.next;
    
    END;
  sansDoublon:=sansDoublon^.next;
  END;
 writeln(' ');

    IF premierFois = 0 THEN
      write('-----------------------------------------------');

END; 
(*/////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE affichageItemset(VAR liste:Node2;VAR Extrai:NodeItems);
  VAR newliste:Node2;
    BEGIN
     newliste:=NIL;
    newliste:=liste;  
    WHILE newliste <> NIL DO
    begin
     correspondance(newliste^.key,Extrai);
     writeln('');
     newliste:=newliste^.next; 
    END;
END ;
(*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*)

PROCEDURE PlusMoinFreq(correspondanceItems:NodeItems);
VAR max,min,nombrefois,choix,premierFois:INTEGER;
    avecD,sansD,listeAvecDoublon,listeSansDoublon,listePlusFreq,listeMoinFreq:Node;

BEGIN
    
  choix:=1;premierFois:=1;
  writeln(' ');writeln('ITEMS PLUS OU MOINS FREQUENTS ?');
 
  WHILE((Choix = 1) OR (Choix = 2)) DO BEGIN
        writeln('1 ---ITEMS  PLUS FREQUENTS :');
        writeln('2 ---ITEMS MOINS FREQUENTS :');
        writeln('0 ---POUR SORTIR:');
        read(Choix);

          IF (Choix = 1) OR (Choix = 2) THEN BEGIN

            IF premierFois =1 THEN BEGIN
              listeSansDoublon:=nil;listeAvecDoublon:=nil;
              listeSansDoublon:=extractionSansOuAvecDoublons(0);
              listeAvecDoublon:=extractionSansOuAvecDoublons(1);
               premierFois:=0;
            END;

            sansD:=listeSansDoublon;
            max:=0;min:=3;

              WHILE (sansD <> NIL) DO BEGIN
                  avecD:=listeAvecDoublon;
                  nombrefois:=0;

                  WHILE (avecD <> NIL) DO BEGIN
                      
                      IF (sansD^.key = avecD^.key) THEN
                          nombrefois:=nombrefois+1;

                  avecD:=avecD^.next;
                  END;

                  IF (max < nombrefois) THEN BEGIN
                     listePlusFreq:=NIL;
                     max:=nombrefois;
                     ListeChaine.InsertionTete(listePlusFreq,sansD^.key);
                  END
                  ELSE IF(max = nombrefois) THEN 
                     ListeChaine.InsertionTete(listePlusFreq,sansD^.key);
              
                  IF (min > nombrefois) THEN BEGIN
                     listeMoinFreq:=NIL;
                     min:=nombrefois;
                     ListeChaine.InsertionTete(listeMoinFreq,sansD^.key);
                  END 
                  ELSE IF (min=nombrefois) THEN
                     ListeChaine.InsertionTete(listeMoinFreq,sansD^.key);

              sansD:=sansD^.next;
              END;
             
          MAX:=max;
          MIN:=min;
          writeln('');
          IF( Choix = 1) THEN BEGIN
          writeln('_______________________LES ITEMS LES PLUS FREQUENTS_________________');writeln('');
          correspondance(listePlusFreq,correspondanceItems);
          write(' DE FREQUENCE MAXIMALE : ');writeln(MAX);
          END;

          IF( Choix = 2) THEN BEGIN
          writeln('');
          writeln('____________________________LES ITEMS LES MOINS FREQUENTS_________________');
          correspondance(listeMoinFreq,correspondanceItems);
          write(' DE FREQUENCE MINIMALE : ');writeln(MIN);
          END;
        END;    

  END;
END;

begin
end.