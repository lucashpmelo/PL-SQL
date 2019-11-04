/*
criar um bloco pl/sql para inserir novos dados informados pelo usuário através de variáveis de substituição
na tabela job_history. as exceções abaixo deverão ser tratadas.

a) 	não permitir inserir data inválida, exceção oracle -01843, que deverá ser associada a variável erro_data_invalida e tratada na seção especifica;
b) 	não permitir inserir valores para chave estrangeira que não existe na tabela especifica (departamento_id e employee_id). exceção oracle -02291 que
	deverá ser associado a variável erro_foreing_key e tratada na seção especifica;
c)	tratar erro de dados nulos exceção oracle -01400, que deverá ser associada a variável erro_nulos e tratada na seção especifica;
d)	não deverá permitir inserir uma data menor que a data atual do servidor;
e)	qualquer outro erro que ocorrer deverá ser tratado e informado para o usuário através da mensagem "outro erro ocorreu".
*/


DECLARE
  WEMPLOYEE_ID JOB_HISTORY.EMPLOYEE_ID%TYPE := &WEMPLOYEE_ID;
  WSTART_DATE JOB_HISTORY.START_DATE%TYPE := '&WSTART_DATE';
  WEND_DATE JOB_HISTORY.END_DATE%TYPE := '&WEND_DATE';
  WJOB_ID JOB_HISTORY.JOB_ID%TYPE := '&WJOB_ID';
  WDEPTO JOB_HISTORY.DEPARTMENT_ID%TYPE := &WDEPTO;
  ERRO_DATA_INVALIDA EXCEPTION;
  ERRO_FOREING_KEY EXCEPTION;
  ERRO_DADOS_NULOS EXCEPTION;
  ERRO_DATA EXCEPTION;
  PRAGMA EXCEPTION_INIT(ERRO_DATA_INVALIDA, -01843);
  PRAGMA EXCEPTION_INIT(ERRO_FOREING_KEY, -02291);
  PRAGMA EXCEPTION_INIT(ERRO_DADOS_NULOS, -01400);
BEGIN
  IF WSTART_DATE < SYSDATE OR WEND_DATE < SYSDATE THEN
     RAISE ERRO_DATA;
  END IF;
  INSERT INTO JOB_HISTORY(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID)
        VALUES(WEMPLOYEE_ID, WSTART_DATE, WEND_DATE, WJOB_ID, WDEPTO);
EXCEPTION
   WHEN ERRO_DATA_INVALIDA THEN
      DBMS_OUTPUT.PUT_LINE('INFORMADO UMA DATA INVALIDA');
   WHEN ERRO_FOREING_KEY THEN
      DBMS_OUTPUT.PUT_LINE('REGISTRO NÃO EXISTE NA OUTRA TABELA');
   WHEN ERRO_DADOS_NULOS THEN
      DBMS_OUTPUT.PUT_LINE('NÃO PERMITE INSERIR NULO EM CAMPO OBRIGATORIO');
   WHEN ERRO_DATA THEN
      DBMS_OUTPUT.PUT_LINE('NÃO PERMITE INSERIR INSERIR DATA MENOR QUE DATA ATUAL');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('OCORREU ALGUM ERRO AO TENTAR EXCLUIR O REGISTRO 40 DA TABELA DEPARTMENTS');
END;