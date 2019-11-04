DO
$$
DECLARE
	V_TEXT TEXT := 'Teste Teste Teste';
	V_NUM INT;
BEGIN
	V_NUM := LENGTH(V_TEXT);
	RAISE NOTICE '%', V_NUM;
	V_TEXT := LOWER(V_TEXT);
	RAISE NOTICE '%', V_TEXT;
END;
$$
------------------------------------------
DO
$$
DECLARE
	V_TEXT1 TEXT := 'Teste Teste Teste';	
BEGIN
	DECLARE		
		V_TEXT2 TEXT := 'Teste Teste Teste';
	BEGIN
		RAISE NOTICE 'DEFINIDA NO BLOCO EXTERNO %', V_TEXT1;
		RAISE NOTICE 'DEFINIDA NO BLOCO INTERNO %', V_TEXT2;
	END;
	RAISE NOTICE 'FORA DO BLOCO %', V_TEXT1;
END;
$$
-------------------------------------------
DO
$$
DECLARE
	V_NOMEPAI TEXT := 'PAFUNCIO';
	V_DTNASCIMENTO DATE := '20-04-1972';
BEGIN
	DECLARE		
		V_NOMEFILHO TEXT := 'JOÃO';
		V_DTNASCIMENTO DATE := '12-05-1992';
	BEGIN
		RAISE NOTICE 'PAI %', V_NOMEPAI;
		RAISE NOTICE 'FILHO %', V_NOMEFILHO;
		RAISE NOTICE 'DATA NASCIMENTO FILHO %', V_DTNASCIMENTO;
	END;
	RAISE NOTICE 'DATA NASCIMENTO PAI %', V_DTNASCIMENTO;
END;
$$
---------------------------------------------
DO
$$
<<BLOCO1>>
DECLARE
	V_NOMEPAI TEXT := 'PAFUNCIO';
	V_DTNASCIMENTO DATE := '20-04-1972';
BEGIN
	DECLARE		
		V_NOMEFILHO TEXT := 'JOÃO';
		V_DTNASCIMENTO DATE := '12-05-1992';
	BEGIN
		RAISE NOTICE 'PAI %', V_NOMEPAI;
		RAISE NOTICE 'DATA NASCIMENTO PAI %', BLOCO1.V_DTNASCIMENTO;
		RAISE NOTICE 'FILHO %', V_NOMEFILHO;		
		RAISE NOTICE 'DATA NASCIMENTO FILHO %', V_DTNASCIMENTO;
	END;	
END;
$$
---------------------------------------------
DO
$$
DECLARE
	V_VALID BOOLEAN;
	EMPNO TEXT := 'A'; --VERIFICA SE EMPNO É NULL
BEGIN
	V_VALID :=(EMPNO IS NOT NULL);
	RAISE NOTICE '%', V_VALID;
END;
$$