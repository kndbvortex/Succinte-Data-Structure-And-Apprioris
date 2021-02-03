MODULE Main;
IMPORT APRIORiID,APRIORI,SETM,In,Out;

VAR support,choix:INTEGER;
    continuer, recommencer:CHAR;
     
	PROCEDURE Choix():INTEGER;
		VAR ENTRER:INTEGER;

		BEGIN
		Out.String("---------------CHOSIR L'ALGORITHME ****");Out.Ln;
		Out.String("1 :---------------- APRIORI    ----------;");Out.Ln;
		Out.String("2 :---------------- APRIORI_TID ----------;");Out.Ln;
		Out.String("3 :----------------  SETM  ----------;");Out.Ln;
		Out.String("choix----->");
		In.Int(ENTRER);
		RETURN ENTRER
	END Choix;

BEGIN
  	Out.String("################################################### Apriori  #######################################");
	Out.Ln;	
	continuer:="o";
	WHILE ((continuer = "o") OR (continuer="O")) DO
		recommencer := "o";
	    WHILE ((recommencer = "o") OR (recommencer="O")) DO
		 	Out.Ln;
		 	Out.String("ENTRER LE SUPPORT------->");
		 	In.Int(support);
		  	IF support >0 THEN
				choix:=Choix();
				IF( choix # 1 ) &( choix # 2 ) & ( choix # 3 ) THEN
					Out.String("!!!!!!!!!!! SORTIR !!!!!!!!!!") ;
				ELSE
					CASE choix OF
						1 : APRIORI.MainApriori(support) |
						2 : APRIORiID.MainAprioriId(support)|
						3 : SETM.MainSemt(support) 
					END;
				END;
			Out.String("TAPER O pour continuer ---->");
			In.Char(recommencer); In.Char(recommencer);

			ELSE
				Out.String("ENTRER un support positif");
				Out.Ln;Out.Ln;
			END;
		END;
	END; 
	Out.Ln;Out.Ln; 
	Out.String("Voulez vous continuer[O/N] ---->");In.Char(continuer);In.Char(continuer);

END Main.
