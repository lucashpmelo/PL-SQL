DO
$$
DECLARE
	EMP_CURSOR CURSOR IS SELECT DEPARTMENT_ID, DEPARTMENT_NAME
						 FROM DEPARTMENTS
						 WHERE DEPARTMENT_ID < 100;
	EMP_CURSOR2 CURSOR (DEPTNO_ID DEPARTMENTS.DEPARTMENT_ID%TYPE) IS SELECT LAST_NAME, JOB_TITLE, SALARY, TO_CHAR(HIRE_DATE,'DD/MM/YYYY') AS DATA
																	  FROM EMPLOYEES, JOBS
																	  WHERE EMPLOYEES.JOB_ID = JOBS.JOB_ID AND EMPLOYEE_ID < 120 AND DEPARTMENT_ID = DEPTNO_ID;
	EMP_RECORD RECORD;
	EMP_RECORD2 RECORD;
BEGIN
	OPEN EMP_CURSOR;
	LOOP
		FETCH EMP_CURSOR INTO EMP_RECORD;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE 'ID: %, DEPARTAMENTO: %', EMP_RECORD.DEPARTMENT_ID, EMP_RECORD.DEPARTMENT_NAME;
		OPEN EMP_CURSOR2(EMP_RECORD.DEPARTMENT_ID);
		LOOP
			FETCH EMP_CURSOR2 INTO EMP_RECORD2;
			EXIT WHEN NOT FOUND;
			RAISE NOTICE 'SOBRENOME: %, FUNÇÃO: %, SALARIO: %, DATA ADMISSÃO: %', EMP_RECORD2.LAST_NAME, EMP_RECORD2.JOB_TITLE, EMP_RECORD2.SALARY, EMP_RECORD2.DATA;			
		END LOOP;
		CLOSE EMP_CURSOR2;
	END LOOP;
	CLOSE EMP_CURSOR;
END;
$$