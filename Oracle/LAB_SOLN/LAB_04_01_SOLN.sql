VARIABLE DEPT_ID NUMBER

BEGIN
	SELECT MAX(DEPARTMENT_ID) INTO :DEPT_ID FROM DEPARTMENTS;
	DBMS_OUTPUT.PUT_LINE(:DEPT_ID);	
END;