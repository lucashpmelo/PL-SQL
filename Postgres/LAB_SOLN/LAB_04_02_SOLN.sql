DO
$$
DECLARE	
	MAX_DEPTNO DEPARTMENTS.DEPARTMENT_ID%TYPE;
	DEPT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
	RES INTEGER;
BEGIN
	SELECT MAX(DEPARTMENT_ID) INTO MAX_DEPTNO FROM DEPARTMENTS;
	MAX_DEPTNO := MAX_DEPTNO + 10;
	INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES (MAX_DEPTNO, DEPT_NAME, NULL);
	GET DIAGNOSTICS RES = ROW_COUNT;
	SELECT MAX(DEPARTMENT_ID) INTO MAX_DEPTNO FROM DEPARTMENTS;
	RAISE NOTICE 'LINHAS: %, NOVO INSERT: %', RES, MAX_DEPTNO;	
END;
$$