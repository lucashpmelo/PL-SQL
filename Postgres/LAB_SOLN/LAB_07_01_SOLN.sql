CREATE TABLE TP_SALARIES (SALARY NUMERIC(8,2))

DO
$$
DECLARE
	EMP CURSOR IS SELECT DISTINCT(SALARY) AS SALARIO FROM EMPLOYEES ORDER BY SALARY DESC LIMIT 5;
	EMP_RECORD RECORD;
BEGIN
	OPEN EMP;
	LOOP
		FETCH EMP INTO EMP_RECORD;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', EMP_RECORD.SALARIO;
		INSERT INTO TP_SALARIES VALUES (EMP_RECORD.SALARIO);
	END LOOP;
	CLOSE EMP;
END;
$$