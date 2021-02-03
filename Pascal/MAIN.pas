program MAIN;
uses Structure,SETM,APRIORIiD,APRIORIs;

VAR support,Algo, grandchoixVariable:INTEGER;
    continuer:CHAR;
     
function Choix():INTEGER;
     VAR ENTRER:INTEGER;

     BEGIN
     writeln('************* CHOIX DE L"ALGORITHME ********');
     writeln('1 :---------------- APRIORI  ----------');
     writeln('2 :------------- APRIORI_TID ----------');
     writeln('3 :---------------- SETM  ----------');
     write('Entrez votre choix : ');
     read(ENTRER);

      Choix:=ENTRER;
END ; 

function GrandChoix():INTEGER;
VAR ValeurChoix:INTEGER;
BEGIN
writeln('------------------------------------------------------------------------------------------------------------------------');
writeln('|                                                TP INF301 : Groupe50                                                   |');
writeln('------------------------------------------------------------------------------------------------------------------------');
writeln();
writeln('---------------------------------------------- 1 : ITEMSET ----------------------------------------------------- ');
writeln('---------------------------------------------- 2 : STUCTURE DE DONNEES SUCCINTES-------------------------------- ');
writeln('');
write('Quelle est votre choix : ');
read(ValeurChoix);

GrandChoix:=ValeurChoix;

END; 


BEGIN
     continuer:='O';
    WHILE ((continuer = 'o') OR (continuer = 'O')) DO
    BEGIN
     grandchoixVariable:=GrandChoix();
        IF grandchoixVariable = 2 THEN
        BEGIN
         MainSuccinte();
            
        END
        ELSE IF grandchoixVariable =1 THEN
        BEGIN
            writeln(''); continuer:='o';
            WHILE ((continuer = 'o') OR (continuer='O')) DO
            BEGIN
	           write('ENTRER LE SUPPORT  : ');
               read(support); writeln('');
               IF support>0 THEN
               BEGIN
                   Algo:=Choix();

                    IF( ( Algo <> 1 ) and ( Algo <> 2 ) and ( Algo <> 3 )) THEN
                    writeln('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ERREUR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
                    ELSE
                    BEGIN
             	      CASE Algo OF

        		       1 : MainApriori(support);
        		       2 : MainAprioriId(support);
        		       3 : MainSemt(support); 
                      END;
        	        END;
                write('TAPER O pour continuer ---->');
                read(continuer);read(continuer);
                END
                ELSE 
                writeln('entrer un support positif');   

               
            END;
        END    
    ELSE
    writeln('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ERREUR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    writeln('');
    write('TAPER O pour CHOIX D"OPERATION ---->');
    read(continuer); read(continuer);
    END;

END.