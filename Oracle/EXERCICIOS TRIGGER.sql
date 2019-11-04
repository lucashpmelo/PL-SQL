/*
Manager
1) CRIAR UMA FUNÇÃO CHECK_SALARY QUE RECEBE DOIS PARAMETROS JOB E O SALARIO E RETORNA VERDADEIRO OU FALSO
	(SE SALARIO ESTIVER NA FAIXA PERMITIDA RETORNA TRUE CASO CONTRARIO RETORNA FALSE)
	VAI VERIFICAR NA TABELA JOBS SE O SALARIO ESTA ENTRE OS VALORES MINIMO E MAXIMO,
	CASO ESTEJA FORA DESTA FAIXA RETORNAR FALSO; TRATAR POSSIVEIS ERROS.

    CRIAR UMA TRIGGER NA TABELA EMPLOYEES, PARA CADA LINHA, NA INSERÇÃO OU ALTERAÇÃO CHAMAR A FUNÇÃO CHECK_SALARY,
	PASSANDO O NOVO JOB E O NOVO SALARIO, CASO RETORNE FALSO DA FUNÇÃO DEVERÁ SER GERADO UM ERRO.
	A TRIGGER DEVERÁ EXECUTAR ANTES DA INSERÇÃO OU ALTERAÇÃO. 


	- usando a procedure add_employee adicionar o funcionario First_name=Eleanor, 
          last_name = beh, e_mail=ebeh, job_id= IT_PROG SAL=5000

	- alterar o salario do funcionario com id 115 para 2000
	*/
	
CREATE OR REPLACE FUNCTION CHECK_SALARY( JOB JOBS.JOB_ID%TYPE, SALARIO JOBS.MIN_SALARY%TYPE) RETURN BOOLEAN
AS
	FLAG BOOLEAN;
	CONT INT;
	VERIFICA_NULL EXCEPTION;
BEGIN
	IF JOB IS NULL OR SALARIO IS NULL THEN
		RAISE VERIFICA_NULL;
	END IF;
	SELECT COUNT(*) INTO CONT FROM JOBS WHERE JOB_ID = JOB AND SALARIO BETWEEN MIN_SALARY AND MAX_SALARY;
	IF CONT = 0 THEN
		FLAG := FALSE;
	ELSE
		FLAG := TRUE;
	END IF;
	RETURN FLAG;
EXCEPTION
	WHEN VERIFICA_NULL THEN
		DBMS_OUTPUT.PUT_LINE('JOB OU SALARIO NÃO PODE SER NULL');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERRO!!!');
END;

DECLARE
	FLAG BOOLEAN;
BEGIN
	FLAG := CHECK_SALARY('ST_MAN', 6000);
	IF FLAG THEN
		DBMS_OUTPUT.PUT_LINE('TRUE');
	ELSE
		DBMS_OUTPUT.PUT_LINE('FALSE');
	END IF;
END;

CREATE OR REPLACE TRIGGER TRI_NEWSALARIO
BEFORE INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
	IF NOT CHECK_SALARY(:NEW.JOB_ID, :NEW.SALARY) THEN
		RAISE_APPLICATION_ERROR(-20200, 'ESTA FORA DA FAIXA SALARIAL!!!');
	END IF;	
END;


/*
2) ESCREVER UMA TRIGGER CHAMADA TRG_DELETE_EMP PARA PERMITIR DELETAR UM EMPREGADO APENAS NO HORARIO DE TRABALHO.
	A) PERMITIR DELETAR APENAS NOS DIAS DA SEMANA ENTRE SEGUNDA  E SEXTA FEIRA.
	B) PERMITIR APENAS DELETAR NO HORARIO COMERCIAL (8:00 AS 18:00 HORAS)

PARA VERIFICAR DIAS DA SEMANA:
	DIA VARCHAR2(3) := TO_CHAR(SYSDATE, 'DY');
	
PARA VERIFICAR A HORA:
	HORA PLS_INTEGER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));

 PARA TESTAR: DELETE FROM EMPLOYEES WHERE JOB_ID ='SA_REP' AND DEPARTMENT_ID IS NULL
 */
 
CREATE OR REPLACE TRIGGER TRG_DELETE_EMP
BEFORE DELETE ON EMPLOYEES
FOR EACH ROW
BEGIN
	IF (TO_CHAR(SYSDATE, 'DY') NOT BETWEEN 'SEG' AND 'SEX') AND (TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '08:00' AND '18:00') THEN
		RAISE_APPLICATION_ERROR(-20200, 'NÃO PODE DELETAR EMPREGADOS NESSE HORARIO');
	END IF;
END;

/*
3) ALTERAR A TRIGGER DO EXERCÍCIO 1 PARA EXECUTAR SOMENTE QUANDO:
	A) NOVO JOB_ID FOR DIFERENTE DO JOB_ID CADASTRADO.
	B) NOVO SALARIO FOR DIFERENTE DO SALARIO CADASTRADO.
       RESOLVER COM CLAUSULA WHEN NA TRIGER
	   
foi acrescentado or old.salary is null para resolver o problema de insert, devido
ao atributo salary estar nulo quando for inserção
when (new.salary <> old.salary or old.salary is null) and (new.job_id <> old.job_id or old.job_id is null)
*/

CREATE OR REPLACE TRIGGER TRI_NEWSALARIO
BEFORE INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
WHEN ((NEW.JOB_ID <> OLD.JOB_ID OR OLD.JOB_ID IS NULL) OR (NEW.SALARY <> OLD.SALARY OR OLD.SALARY IS NULL))
BEGIN
	IF NOT CHECK_SALARY(:NEW.JOB_ID, :NEW.SALARY) THEN
		RAISE_APPLICATION_ERROR(-20200, 'ESTA FORA DA FAIXA SALARIAL!!!');
	END IF;
END;