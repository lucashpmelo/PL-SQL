Exerc�cio:
 Desenvolver uma trigger que após inserir um registro na tabela de caixa (tb_caixa) execute as seguinte tarefas.
	a) Se estiver inserindo um registro, deverá verificar se o atributo IND_ADIANTAMENTO na tabela TB_HISTORICO esta setado para 'SIM'
	Neste caso deverá inserir um registro na tabela TB_ADIANTAMENTO baseado nos dados da tabela TB_CAIXA.
	para o atributo chave primaria da tabela TB_ADIANTAMENTO deverá ser utilizado a sequencia SQ_ADIANTAMENTO.
	b) Se estiver excluindo um registro, deverá verificar se existe um registro na tabela TB_ADIANTAMENTO que deverá ser excluido.
	c) Se estiver alterando um registro, deverá verificar se existe um registro na tabela TB_ADIANTAMENTO e alterar o valor do mesmo, quando alterar 
	o c�digo do hist�rico deverá verificar tambem se o novo historico esta setado para 'NAO' para IND_ADIANTAMENTO, neste caso deverá ser
	excluido o registro na tabela TB_ADIANTAMENTO. (não será testado a alteração de um historico que era 'NAO' para 'SIM' para o atributo IND_ADIANTAMENTO).
	
	

	
	
	
CREATE OR REPLACE TRIGGER TRG_TB_CAIXA
AFTER INSERT OR UPDATE OR DELETE ON TB_CAIXA
FOR EACH ROW
DECLARE
	CHECK_ADIANTAMENTO TB_HISTORICO.IND_ADIANTAMENTO%TYPE;
	ID_ADIAN TB_ADIANTAMENTO.COD_ADIANTAMENTO%TYPE;
BEGIN
	
	IF INSERTING THEN
	
		SELECT IND_ADIANTAMENTO INTO CHECK_ADIANTAMENTO
		FROM TB_HISTORICO
		WHERE TB_HISTORICO.COD_HISTORICO = :NEW.COD_HISTORICO;
		
		IF CHECK_ADIANTAMENTO = 'SIM' THEN
			INSERT INTO TB_ADIANTAMENTO VALUES (SQ_ADIANTAMENTO.NEXTVAL, :NEW.COD_CAIXA, :NEW.DT_MOVIMENTO, :NEW.VAL_MOVIMENTO, :NEW.COD_CADASTRO, 0);
		END IF;
		
	ELSIF UPDATING THEN
	
		SELECT COD_ADIANTAMENTO INTO ID_ADIAN
		FROM TB_ADIANTAMENTO
		WHERE TB_ADIANTAMENTO.COD_CAIXA = :OLD.COD_CAIXA;
		
		IF ID_ADIAN IS NOT NULL THEN
		
			IF :OLD.COD_HISTORICO <> :NEW.COD_HISTORICO THEN
			
				SELECT IND_ADIANTAMENTO INTO CHECK_ADIANTAMENTO
				FROM TB_HISTORICO
				WHERE TB_HISTORICO.COD_HISTORICO = :NEW.COD_HISTORICO;
				
				IF CHECK_ADIANTAMENTO = 'NAO' THEN
				
					DELETE FROM TB_ADIANTAMENTO WHERE COD_ADIANTAMENTO = ID_ADIAN;
					
				END IF;
				
			ELSE
			
				UPDATE TB_ADIANTAMENTO SET VAL_MOVIMENTO = :NEW.VAL_MOVIMENTO WHERE COD_ADIANTAMENTO = ID_ADIAN;
				
			END IF;
			
		END IF;		
		
	ELSIF DELETING THEN
	
		SELECT COD_ADIANTAMENTO INTO ID_ADIAN
		FROM TB_ADIANTAMENTO
		WHERE TB_ADIANTAMENTO.COD_CAIXA = :OLD.COD_CAIXA;
		
		IF ID_ADIAN IS NOT NULL THEN
		
			DELETE FROM TB_ADIANTAMENTO WHERE COD_ADIANTAMENTO = ID_ADIAN;
			
		END IF;
		
	END IF;
	
END;


Insert into Tb_Caixa (Cod_Caixa, Dt_Movimento, Cod_Historico, Val_Movimento, Desc_Observacao, Cod_Cadastro) values(sq_Caixa.Nextval, '22/11/2018',1, 1000,'Venda',3);
delete from tb_caixa where cod_caixa = 3;
update tb_caixa set val_movimento=5000 where cod_caixa = 2;