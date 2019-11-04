manager

hr
hr

system
utfpr

set serveroutput on
--------------------------------------------------------------------------
declare
	f_name varchar2(20);
begin
	select first_name into f_name from employees where employee_id = 100;
	dbms_output.put_line('primeiro nome: '|| f_name);
end;

DO
$$
DECLARE
	F_NAME VARCHAR(20);
BEGIN
	SELECT FIRST_NAME INTO F_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = 100;
	RAISE NOTICE 'PRIMEIRO NOME %', F_NAME;
END;
$$
--------------------------------------------------------------------------
--LAB_01_02_SOLN

BEGIN
	DBMS_OUTPUT.PUT_LINE('OLÁ MUNDO!');
END;