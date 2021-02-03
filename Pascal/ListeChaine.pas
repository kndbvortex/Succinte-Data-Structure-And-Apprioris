unit ListeChaine;

interface
 TYPE
  Node= ^Liste;
  Liste =RECORD
   key:INTEGER;
   next:Node
  END;
  Node2= ^GrandeListe;
  GrandeListe=RECORD
   key:Node;
   next:Node2
  END;
  NodeItems=^ItemsTotal;
  ItemsTotal=RECORD
   key1:string;
   key2:INTEGER;
   next:NodeItems
  END;
PROCEDURE InsertionTete(VAR Tete:Node;valeur:INTEGER);
PROCEDURE GrandInsertionTete(VAR Tete:Node2;var SousTete:Node);
PROCEDURE InsertionTeteItem(VAR Tete:NodeItems;VAR chaine:string;VAR code:INTEGER);
PROCEDURE InsertionSansDoublon(VAR tete:Node;var val : INTEGER);
PROCEDURE AfficherListe(VAR Tete:Node); 
PROCEDURE GrandAfficherListe(VAR Tete:Node2); 
PROCEDURE Suppression(VAR liste:Node;var valeur:INTEGER);
PROCEDURE GrandSuppression(VAR Liste:Node2; VAR SousTete:Node);
function appartenir(VAR Tete:Node;VAR valeur:INTEGER):INTEGER;
function GrandeAppartenance(VAR Tete:Node2;VAR SousTete :Node):INTEGER;
function EstPresent(VAR Tete:Node;var valeur:INTEGER) :boolean;

IMPLEMENTATION
{///////////////////////////////////////////////////////////}
PROCEDURE InsertionTete(VAR Tete:Node;valeur:INTEGER);

VAR n:Node;

    BEGIN

       IF Tete <> NIL THEN
        begin
        NEW(n);
        n^.key:=valeur;
        n^.next:=Tete;
        Tete:=n;
        END  
      ELSE
        begin
        NEW(Tete);
        Tete^.key:=valeur;
        Tete^.next:=NIL;
        END
END ;  
{//////////////////////////////////////////////////////////////}

PROCEDURE GrandInsertionTete(VAR Tete:Node2;var SousTete:Node);
VAR GndNode:Node2; 

    BEGIN
    IF Tete <> NIL THEN
      begin
      NEW(GndNode);
      GndNode^.key:=SousTete;
      GndNode^.next:=Tete;
      Tete:=GndNode;
      end 
    ELSE
    begin
      NEW(Tete);
      Tete^.key:=SousTete;
      Tete^.next:=NIL;
    end  
END;

{///////////////////////////////////////////////////////////////}
PROCEDURE InsertionTeteItem(VAR Tete:NodeItems;VAR chaine:string;VAR code:INTEGER);

VAR n:NodeItems;
 BEGIN
    IF Tete <> NIL THEN
      begin 
      NEW(n);
      n^.key1:=chaine;
      n^.key2:=code;
      n^.next:=Tete;
      Tete:=n;
      end
    ELSE
      begin 
     NEW(Tete);
     Tete^.key1:=chaine;
     Tete^.key2:=code;
     Tete^.next:=NIL;
     end;
END;   
{/////////////////////////////////////////////////////////}

function EstPresent(VAR Tete:Node;var valeur:INTEGER) :boolean;
       VAR 
            n : Node;
            present :boolean;
       BEGIN
            n := Tete;
            present := true;
            WHILE (n <> NIL) and (present = true) DO
            begin
                IF n^.key = valeur THEN
                    present :=false
                ELSE
                    n := n^.next
            END;

        EstPresent:=present;
END ;

{//////////////////////////////////////////////////////////////}
PROCEDURE InsertionSansDoublon(VAR tete:Node;var val : INTEGER);
  BEGIN
        IF (EstPresent(tete, val)) THEN
            InsertionTete(tete, val)
END;

{////////////////////////////////////////////////////////////}

PROCEDURE AfficherListe(VAR Tete:Node);

VAR liste:Node;

     BEGIN
        NEW(liste);
        liste:=Tete;

      WHILE liste <> NIL DO
        begin
        write(liste^.key);

          IF liste^.next <> NIL THEN
           write(';');

        liste:=liste^.next;
      END;
END;
{///////////////////////////////////////////////////////////////}

PROCEDURE GrandAfficherListe(VAR Tete:Node2);

VAR Gliste:Node2;
      

   BEGIN
       NEW(Gliste);
       Gliste:=Tete;

    WHILE (Gliste <> NIL) DO
      begin
      write('{');
      AfficherListe(Gliste^.key);
      write('} '); 
      Gliste:=Gliste^.next;
    END;
END; 

{/////////////////////////////////////////////////////////////////}
PROCEDURE Suppression(VAR liste:Node;var valeur:INTEGER);

VAR tete,Asuprimer:Node;
    trouver:INTEGER;

      BEGIN
        trouver:=0;
        NEW(tete);
        tete:=Liste;
        IF tete^.key =valeur THEN
            Liste:=tete^.next
        ELSE
        begin

            WHILE ((tete^.next <> NIL)and(trouver=0) )DO
            begin

                IF tete^.next^.key = valeur THEN
                begin
                  Asuprimer:=tete^.next;
                  trouver:=1;
                    IF tete^.next^.next <> NIL THEN
                         tete^.next:=tete^.next^.next
                    ELSE
                    begin
                       trouver:=2;
                       tete^.next:=NIL;    
                    END;

                END; 
              tete:=tete^.next;
            END;

          IF trouver=2 THEN
          tete^.next:=NIL
          ELSE
          tete:=tete^.next
        END;    
END;

{/////////////////////////////////////////////////////////////////}
 PROCEDURE GrandSuppression(VAR Liste:Node2; VAR SousTete:Node);
VAR tete,prec:Node2;
    trouver:INTEGER;
    Asuprimer,SousTetevariable:Node;

        BEGIN
        trouver:=0;
        IF Liste <> NIL THEN
        begin
        tete:=Liste;
        prec:=Liste;
            WHILE (tete <> NIL)and(trouver=0) DO
            begin
              Asuprimer:=tete^.key;
              SousTetevariable:=SousTete;

                 WHILE (Asuprimer <> NIL)and(Asuprimer^.key = SousTetevariable^.key) DO
                 begin
                    Asuprimer:=Asuprimer^.next;
                    SousTetevariable:=SousTetevariable^.next;
                 END;
                 IF (Asuprimer = NIL)THEN
                   trouver:=1
                 ELSE
                 begin
                 prec:=tete;
                 tete:=tete^.next;
                 END;
            END;
            IF (trouver = 1) THEN
            begin
              IF tete <> Liste THEN
               prec^.next:=tete^.next
              ELSE
                Liste:=Liste^.next 
            END;      
  END ;   
end;

{/////////////////////////////////////////////////////////////////}

function appartenir(VAR Tete:Node;VAR valeur:INTEGER):INTEGER;
VAR newtete:Node;
    sorti: INTEGER;

    BEGIN
    sorti:=0;
    newtete:=Tete;

    WHILE (newtete <> NIL) and (sorti =0) DO 
    begin
       IF newtete^.key =valeur THEN
       sorti:=1;
     newtete:=newtete^.next;
    END;
 appartenir:=sorti;
END;
{/////////////////////////////////////////////////////////////////}
function GrandeAppartenance(VAR Tete:Node2;VAR SousTete :Node):INTEGER;
  VAR newtete:Node2;
      newsoustete1,newsoustete2:Node;
      valeur,valeurFinale:INTEGER;
  BEGIN
  newtete:=Tete;
  newsoustete2:=SousTete;
  valeurFinale:=0;

      WHILE (newtete <> NIL) and (valeurFinale = 0) DO
      begin
      valeurFinale:=1;
      newsoustete1:=newtete^.key;

         WHILE (newsoustete1 <> NIL) and (valeurFinale = 1) DO
         begin
         valeur:=appartenir(newsoustete2,newsoustete1^.key);
         valeurFinale:=valeurFinale*valeur;
         newsoustete1:=newsoustete1^.next;
         END;

      newtete:=newtete^.next; 
      END;
    GrandeAppartenance:=valeurFinale;
END;
(*//////////////////////////////////////////////////////////////////////*)
begin

end.