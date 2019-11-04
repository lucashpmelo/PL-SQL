CREATE TABLE EMP AS SELECT * FROM EMPLOYEES

ALTER TABLE EMP ADD STARS VARCHAR(50)

DECLARE
	EMPNO EMP.EMPLOYEE_ID%TYPE := 176;
	ASTERISK EMP.STARS%TYPE := '';
	SAL EMP.SALARY%TYPE;
BEGIN
	SELECT ROUND(SALARY/1000) INTO SAL FROM EMP WHERE EMPLOYEE_ID = EMPNO;
	FOR I IN 1..SAL LOOP
		ASTERISK := ASTERISK || '*';
	END LOOP;
	UPDATE EMP SET STARS = ASTERISK WHERE EMPLOYEE_ID = 176;
END;