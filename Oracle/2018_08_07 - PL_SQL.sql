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
--------------------------------------------------------------------------
--LAB_01_02_SOLN

BEGIN
	DBMS_OUTPUT.PUT_LINE('OLÁ MUNDO!');
END;