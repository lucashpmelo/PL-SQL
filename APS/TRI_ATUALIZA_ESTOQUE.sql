CREATE OR REPLACE TRIGGER TRI_ATUALIZA_ESTOQUE
BEFORE INSERT ON TB_PRODUTOVENDA
FOR EACH ROW
DECLARE
	PRO_NOME TB_PRODUTO.DESC_PRODUTO%TYPE;
BEGIN
	--VALIDA A QUANTIDADE EM ESTOQUE DO PRODUTO--
	
	IF FUN_VALIDA_PRO_QTDE(:NEW.COD_PRODUTO, :NEW.QTDE) THEN
		--DA BAIXA NO ESTOQUE--
		
		UPDATE TB_PRODUTO SET ESTOQUE_PRODUTO = ESTOQUE_PRODUTO - :NEW.QTDE WHERE COD_PRODUTO = :NEW.COD_PRODUTO;
	ELSE
	
		SELECT DESC_PRODUTO INTO PRO_NOME FROM TB_PRODUTO WHERE COD_PRODUTO = :NEW.COD_PRODUTO;
		
		RAISE_APPLICATION_ERROR(-20230, 'QUANTIDADE DO PRODUTO ' || PRO_NOME || ' INSUFICIENTE NO ESTOQUE!!!');
	END IF;
END;