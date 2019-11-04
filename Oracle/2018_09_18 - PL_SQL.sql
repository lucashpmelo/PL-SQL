DECLARE
	CURSOR SAL IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 30;
	EMPNO EMPLOYEES.EMPLOYEE_ID%TYPE;
	LNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
	OPEN SAL;
	FETCH SAL INTO EMPNO, LNAME;
	DBMS_OUTPUT.PUT_LINE('ID: ' || EMPNO || ', NOME: ' || LNAME);
	CLOSE SAL;
END;

-----------------------------------------------------------------

DECLARE
	CURSOR SAL IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 30;
	EMPNO EMPLOYEES.EMPLOYEE_ID%TYPE;
	LNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
	OPEN SAL;
	LOOP
		FETCH SAL INTO EMPNO, LNAME;
		EXIT WHEN SAL%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMPNO || ', NOME: ' || LNAME);
	END LOOP;
	CLOSE SAL;
END;

-----------------------------------------------------------------

DECLARE
	CURSOR EMP IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 30;
	EMP_RECORD EMP%ROWTYPE;
BEGIN
	OPEN EMP;
	LOOP
		FETCH EMP INTO EMP_RECORD;
		EXIT WHEN EMP%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMP_RECORD.EMPLOYEE_ID || ', NOME: ' || EMP_RECORD.LAST_NAME);
	END LOOP;
	CLOSE EMP;
END;

-----------------------------------------------------------------

DECLARE
	CURSOR EMP IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 30;
BEGIN
	FOR EMP_RECORD IN EMP LOOP
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMP_RECORD.EMPLOYEE_ID || ', NOME: ' || EMP_RECORD.LAST_NAME);
	END LOOP;
END;

-----------------------------------------------------------------

DECLARE
	CURSOR EMP (DEPTNO_ID EMPLOYEES.DEPARTMENT_ID%TYPE) IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = DEPTNO_ID;
	EMP_RECORD EMP%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO 10');
	OPEN EMP(10);
	LOOP
		FETCH EMP INTO EMP_RECORD;
		EXIT WHEN EMP%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMP_RECORD.EMPLOYEE_ID || ', NOME: ' || EMP_RECORD.LAST_NAME);
	END LOOP;
	CLOSE EMP;
	DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO 20');
	OPEN EMP(20);
	LOOP
		FETCH EMP INTO EMP_RECORD;
		EXIT WHEN EMP%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMP_RECORD.EMPLOYEE_ID || ', NOME: ' || EMP_RECORD.LAST_NAME);
	END LOOP;
	CLOSE EMP;
END;

-----------------------------------------------------------------

DECLARE
	CURSOR EMP (DEPTNO_ID EMPLOYEES.DEPARTMENT_ID%TYPE) IS SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = DEPTNO_ID FOR UPDATE;
	EMP_RECORD EMP%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO 10');
	OPEN EMP(10);
	LOOP
		FETCH EMP INTO EMP_RECORD;
		EXIT WHEN EMP%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('ID: ' || EMP_RECORD.EMPLOYEE_ID || ', NOME: ' || EMP_RECORD.LAST_NAME);
		UPDATE EMPLOYEES SET SALARY = 10 WHERE CURRENT OF EMP;
	END LOOP;
	CLOSE EMP;
END;