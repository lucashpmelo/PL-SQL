DECLARE
	CHILDRECORD_EXISTS EXCEPTION;
	PRAGMA EXCEPTION_INIT(CHILDRECORD_EXISTS, -02292);
BEGIN
	DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 40;
EXCEPTION
	WHEN CHILDRECORD_EXISTS THEN
		DBMS_OUTPUT.PUT_LINE('REGISTRO EM USO');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('OCORREU UM ERRO');
END;