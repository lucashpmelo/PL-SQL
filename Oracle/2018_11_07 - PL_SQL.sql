CREATE OR REPLACE PROCEDURE PROC_INCERT_MOVIMENTO(
  ID TB_HISTORICO.COD_HISTORICO%TYPE, VALOR TB_BANCO_MOVIMENTO.VAL_MOVIMENTO%TYPE, DESCRICAO TB_BANCO_MOVIMENTO.DESC_OBSERVACAO%TYPE, RECEBER_ID TB_RECEBER.COD_RECEBER%TYPE)
  IS  
  
  ERRO_RECE EXCEPTION;
  ERRO_HIST EXCEPTION;
  ID_CHECK INTEGER;
  RECEBER_CHECK INTEGER;
BEGIN
	SELECT COUNT(*) INTO ID_CHECK FROM TB_HISTORICO WHERE COD_HISTORICO = ID;
   
	IF ID_CHECK = 0 THEN
		RAISE ERRO_HIST;
	END IF;
   
	IF RECEBER_ID IS NOT NULL THEN
		SELECT COUNT(*) INTO RECEBER_CHECK FROM TB_RECEBER WHERE COD_RECEBER = RECEBER_ID;
		IF RECEBER_CHECK = 0 THEN
			RAISE ERRO_RECE;
		END IF;
	END IF;
	
	INSERT INTO TB_BANCO_MOVIMENTO(COD_BANCO_MOVIMENTO, COD_HISTORICO, VAL_MOVIMENTO, DESC_OBSERVACAO, COD_RECEBER)
	VALUES(SQ_BANCO_MOVIMENTO.NEXTVAL, ID, VALOR, DESCRICAO, RECEBER_ID);

EXCEPTION
	WHEN ERRO_HIST THEN		
		RAISE_APPLICATION_ERROR(-20200, 'HISTORICO NÃO EXISTE.');
	WHEN ERRO_RECE THEN
		RAISE_APPLICATION_ERROR(-20201, 'JÁ EXISTE CONTAS A RECEBER.');
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20202, 'ERRO!!!');
END;


CREATE OR REPLACE FUNCTION FUN_SALDO(DATA_INICIAL TB_BANCO_MOVIMENTO.DT_MOVIMENTO%TYPE, DATA_FINAL TB_BANCO_MOVIMENTO.DT_MOVIMENTO%TYPE)
RETURN TB_BANCO_MOVIMENTO.VAL_MOVIMENTO%TYPE
IS
	TOTAL TB_BANCO_MOVIMENTO.VAL_MOVIMENTO%TYPE;
	ERRO_DATA_INICIAL EXCEPTION;
	ERRO_DATA_FINAL EXCEPTION;
	ERRO_DATA EXCEPTION;
BEGIN
	IF DATA_INICIAL IS NULL THEN
		RAISE ERRO_DATA_INICIAL;
	END IF;
	
	IF DATA_FINAL IS NULL THEN
		RAISE ERRO_DATA_FINAL;
	END IF;
	
	IF DATA_INICIAL > DATA_FINAL THEN
		RAISE ERRO_DATA;
	END IF;
	
	SELECT SUM(DECODE(IND_SOMA_DIMINUI, '+', VAL_MOVIMENTO, VAL_MOVIMENTO * -1)) INTO TOTAL FROM TB_BANCO_MOVIMENTO, TB_HISTORICO WHERE TB_BANCO_MOVIMENTO.COD_HISTORICO = TB_HISTORICO.COD_HISTORICO AND TB_BANCO_MOVIMENTO.DT_MOVIMENTO BETWEEN DATA_INICIAL AND DATA_FINAL;
	RETURN TOTAL;
EXCEPTION
	WHEN ERRO_DATA_INICIAL THEN		
		RAISE_APPLICATION_ERROR(-20200, 'DATA INICIAL NÃO PODE SER NULL.');
	WHEN ERRO_DATA_FINAL THEN		
		RAISE_APPLICATION_ERROR(-20201, 'DATA FINAL NÃO PODE SER NULL.');
	WHEN ERRO_DATA THEN		
		RAISE_APPLICATION_ERROR(-20202, 'DATA INICIAL NÃO PODE SER MAIOR QUE DATA FINAL.');
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20203, 'ERRO!!!');
END;



CREATE OR REPLACE FUNCTION FUN_SALDO_RECEBER(PCADASTRO TB_CADASTRO.COD_CADASTRO%TYPE)
RETURN NUMBER
IS
	WSALDO TB_RECEBER.VAL_TITULO%TYPE;
	WQUANT INTEGER;
	ERRO_CADASTRO EXCEPTION;
	ERRO_INEXISTENTE EXCEPTION;
BEGIN
	IF PCADASTRO IS NULL THEN
		RAISE ERRO_CADASTRO;
	END IF;

	SELECT COUNT(*) INTO WQUANT FROM TB_CADASTRO WHERE COD_CADASTRO = PCADASTRO;

	IF WQUANT = 0 THEN
		RAISE ERRO_INEXISTENTE;
	END IF;

	SELECT SUM(VAL_TITULO) INTO WSALDO FROM TB_RECEBER WHERE COD_CADASTRO = PCADASTRO AND IND_SITUACAO = 'A';

	RETURN WSALDO;
EXCEPTION
	WHEN ERRO_CADASTRO THEN		
		RAISE_APPLICATION_ERROR(-20200, 'INFORMAR UM CODIGO DE CADASTRO.');
	WHEN ERRO_INEXISTENTE THEN		
		RAISE_APPLICATION_ERROR(-20201, 'CADASTRO INFORMADO NÃO EXISTE.');	
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20202, 'ERRO!!!');
END;