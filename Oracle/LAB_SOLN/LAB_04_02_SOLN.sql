DECLARE
	DEPT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
	:DEPT_ID := :DEPT_ID + 10;
	INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES (:DEPT_ID, DEPT_NAME, NULL);
	DBMS_OUTPUT.PUT_LINE('LINHAS: '||SQL%ROWCOUNT||' NOVO INSERT: '||:DEPT_ID);	
END;