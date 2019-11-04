CREATE OR REPLACE FUNCTION FUN_FECHA_VENDA(ID_CLIENTE TB_CLIENTE.COD_CLIENTE%TYPE, ID_FUNCIONARIO TB_FUNCIONARIO.COD_FUNCIONARIO%TYPE) RETURN BOOLEAN
IS
	ID_VENDA TB_VENDA.COD_VENDA%TYPE;
	ID_CARRINHO TB_CARRINHO.COD_CARRINHO%TYPE;
	
	MSG_ERRO VARCHAR2(512);
	
	CURSOR VEN_CURSOR IS	SELECT
								TB_CARRINHO.COD_CARRINHO, TB_ITENSCARRINHO.COD_PRODUTO, TB_ITENSCARRINHO.QTDE, TB_PRODUTO.VALOR_UN
							FROM
								TB_CARRINHO, TB_ITENSCARRINHO, TB_PRODUTO
							WHERE
									TB_CARRINHO.COD_CLIENTE = ID_CLIENTE
								AND
									TB_CARRINHO.IND_EXCLUIDO <> 1
								AND
									TB_CARRINHO.COD_CARRINHO = TB_ITENSCARRINHO.COD_CARRINHO
								AND
									TB_ITENSCARRINHO.COD_PRODUTO = TB_PRODUTO.COD_PRODUTO;
									
	ERRO_CLI_NULL EXCEPTION;
	ERRO_FUN_NULL EXCEPTION;
	
	ERRO_FOREIGN_KEY EXCEPTION;
	PRAGMA EXCEPTION_INIT(ERRO_FOREIGN_KEY, -02291);
	ERRO_ESTOQUE EXCEPTION;
	PRAGMA EXCEPTION_INIT(ERRO_ESTOQUE, -20230);
BEGIN
	--VALIDA ENTRADA DE DADOS--
	
	IF ID_CLIENTE IS NULL THEN
		RAISE ERRO_CLI_NULL;
	ELSIF ID_FUNCIONARIO IS NULL THEN
		RAISE ERRO_FUN_NULL;
	END IF;
	
	--CRIA VENDA E RETORNA SEU ID--
	
	INSERT INTO TB_VENDA (COD_VENDA, COD_CLIENTE, COD_FUNCIONARIO, DT_VENDA) VALUES (SQ_VENDA.NEXTVAL, ID_CLIENTE, ID_FUNCIONARIO, SYSDATE) RETURNING COD_VENDA INTO ID_VENDA;
	
	--ABRE O CURSOR PARA PEGAR OS ITENS DO CARRINHO DO CLIENTE--
	
	FOR VEN_RECORD IN VEN_CURSOR LOOP
	
		--INSERE OS PRODUTOS NA VENDA--
		
		INSERT INTO TB_PRODUTOVENDA (COD_PRODUTOVENDA, COD_VENDA, COD_PRODUTO, QTDE, VALOR_UN) VALUES (SQ_PRODUTOVENDA.NEXTVAL, ID_VENDA, VEN_RECORD.COD_PRODUTO, VEN_RECORD.QTDE, VEN_RECORD.VALOR_UN);
		
		ID_CARRINHO := VEN_RECORD.COD_CARRINHO;
		
	END LOOP;
	
	--FAZ A EXCLUSÃO LOGICA DO CARRINHO--
	
	UPDATE TB_CARRINHO SET IND_EXCLUIDO = 1 WHERE COD_CARRINHO = ID_CARRINHO;
	
	COMMIT;
	
	RETURN TRUE;
	
EXCEPTION
	WHEN ERRO_CLI_NULL THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20220, 'ID DO CLIENTE NÃO PODE SER NULL!!!');
		RETURN FALSE;
	WHEN ERRO_FUN_NULL THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20221, 'ID DO FUNCIONARIO NÃO PODE SER NULL!!!');
		RETURN FALSE;
	WHEN ERRO_FOREIGN_KEY THEN		
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20222, 'CLIENTE OU FUNCIONARIO NÃO EXISTE!!!');
		RETURN FALSE;
	WHEN ERRO_ESTOQUE THEN		
		ROLLBACK;
		MSG_ERRO := SQLERRM;
		RAISE_APPLICATION_ERROR(-20223, MSG_ERRO);
		RETURN FALSE;
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20224, 'ALGUM OUTRO ERRO OCORREU!!!');
		RETURN FALSE;
END;