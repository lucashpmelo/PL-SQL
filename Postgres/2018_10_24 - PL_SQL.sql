CREATE OR REPLACE PROCEDURE nome(parametros)
IS
	variaveis
BEGIN
	ações
END nome;

DBMS_OUTPUT.PUT_LINE ('');

------------------------------------------------

CREATE OR REPLACE PROCEDURE PROC_SALARIO(ID IN EMPLOYEES.EMPLOYEE_ID%TYPE, PERCENT IN NUMBER)
IS
BEGIN
	UPDATE EMPLOYEES SET SALARY = SALARY * (1 + PERCENT / 100) WHERE EMPLOYEE_ID = ID;
END PROC_SALARIO;

EXECUTE PROC_SALARIO(176,10)

------------------------------------------------
SELECT TEXT FROM USER_SOURCE WHERE NAME = 'CREATE_DEPARTMENTS'

SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE'
--------------SLIDE 10----------------

CREATE OR REPLACE PROCEDURE add_departament (
  name VARCHAR2, mgr NUMBER, loc NUMBER) IS
BEGIN
   INSERT INTO DEPARTMENTS(department_id, department_name, manager_id, location_id) 
  VALUES(DEPARTMENTS_SEQ.NEXTVAL, name, mgr, loc);
  DBMS_OUTPUT.PUT_LINE(`Added Dept:` || name);
EXCEPTION 
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(`Err:. Adding dept:` || name);
	RAISE; -------->>>>>>> PROPAGA O ERRO PARA O CHAMADOR         -----------------PROVA----------------------
END;


CREATE or REPLACE PROCEDURE create_departments IS 
BEGIN
   add_departament(‘MEDIA’, 100, 1800);
   add_departament(‘EDITING’, 99, 1800);
   add_departament(‘MENOR’, 101, 1800);
EXCEPTION 
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(`Err:. Adding dept:` || name);
END;