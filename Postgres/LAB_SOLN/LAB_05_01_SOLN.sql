DO
$$
DECLARE
	
BEGIN
	FOR I IN 1..10 LOOP
		IF I != 6 AND I != 8 THEN
			INSERT INTO RESULTS(RESULT) VALUES (I);
		END IF;
	END LOOP;
END;
$$