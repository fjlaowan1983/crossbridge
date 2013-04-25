-- C83025C.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained 
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making 
--     this public release, the Government intends to confer upon all 
--     recipients unlimited rights  equal to those held by the Government.  
--     These rights include rights to use, duplicate, release or disclose the 
--     released technical data and computer software in whole or in part, in 
--     any manner and for any purpose whatsoever, and to have or permit others 
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED 
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE 
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- OBJECTIVE:
--     CHECK THAT A DECLARATION IN A DECLARATIVE REGION OF A GENERIC
--     SUBPROGRAM HIDES AN OUTER DECLARATION OF A HOMOGRAPH. ALSO CHECK
--     THAT THE OUTER DECLARATION IS DIRECTLY VISIBLE IN BOTH
--     DECLARATIVE REGIONS BEFORE THE DECLARATION OF THE INNER HOMOGRAPH
--     AND THE OUTER DECLARATION IS VISIBLE BY SELECTION AFTER THE INNER
--     HOMOGRAPH DECLARATION, IF THE GENERIC SUBPROGRAM BODY IS COMPILED
--     AS A SUBUNIT IN THE SAME COMPILATION.

-- HISTORY:
--     BCB 09/01/88  CREATED ORIGINAL TEST.

WITH REPORT; USE REPORT;
PRAGMA ELABORATE(REPORT);
PACKAGE C83025C_PACK IS
     Y : INTEGER := IDENT_INT(5);
     Z : INTEGER := Y;

     GENERIC
          TYPE T IS PRIVATE;
          X : T;
     FUNCTION GEN_FUN RETURN T;

     A : INTEGER := IDENT_INT(2);
     B : INTEGER := A;

     OBJ : INTEGER := IDENT_INT(3);

     FLO : FLOAT := 5.0;

     TYPE ENUM IS (ONE, TWO, THREE, FOUR);

     EOBJ : ENUM := ONE;

     GENERIC
          Y : FLOAT := 2.0;
     PROCEDURE INNER (X : IN OUT INTEGER);

     GENERIC
          Y : BOOLEAN := TRUE;
     PROCEDURE INNER2 (X : IN INTEGER := A;
                       A : IN OUT INTEGER);

     GENERIC
          Y : ENUM := ONE;
     FUNCTION INNER3 (X : INTEGER; Z : ENUM := Y) RETURN INTEGER;

     GENERIC
          Y : ENUM;
     FUNCTION INNER4 (X : INTEGER; Z : ENUM := Y) RETURN INTEGER;

     GENERIC
          Y : CHARACTER := 'A';
     PROCEDURE INNER5 (X : IN OUT INTEGER; F : IN FLOAT;
                       Z : CHARACTER := Y);
END C83025C_PACK;

PACKAGE BODY C83025C_PACK IS
     FUNCTION GEN_FUN RETURN T IS
     BEGIN
          RETURN X;
     END GEN_FUN;

     FUNCTION F IS NEW GEN_FUN (INTEGER, OBJ);

     FUNCTION F IS NEW GEN_FUN (FLOAT, FLO);

     PROCEDURE INNER (X : IN OUT INTEGER) IS SEPARATE;

     PROCEDURE INNER2 (X : IN INTEGER := C83025C_PACK.A;
                       A : IN OUT INTEGER) IS SEPARATE;

     FUNCTION INNER3 (X : INTEGER;
                      Z : ENUM := Y) RETURN INTEGER IS SEPARATE;

     FUNCTION INNER4 (X : INTEGER;
                      Z : ENUM := Y) RETURN INTEGER IS SEPARATE;

     PROCEDURE INNER5 (X : IN OUT INTEGER; F : IN FLOAT;
                       Z : CHARACTER := Y) IS SEPARATE;
END C83025C_PACK;

SEPARATE (C83025C_PACK)
PROCEDURE INNER (X : IN OUT INTEGER) IS
     C : INTEGER := A;
     A : INTEGER := IDENT_INT(3);
BEGIN
     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 1");
     END IF;

     IF C83025C_PACK.A /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 2");
     END IF;

     IF C83025C_PACK.B /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 3");
     END IF;

     IF C /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 4");
     END IF;

     IF X /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE PASSED IN - 5");
     END IF;

     IF Y /= 2.0 THEN
          FAILED ("INCORRECT VALUE INNER HOMOGRAPH - 6");
     END IF;

     IF EQUAL(1,1) THEN
          X := A;
     ELSE
          X := C83025C_PACK.A;
     END IF;
END INNER;

SEPARATE (C83025C_PACK)
PROCEDURE INNER2 (X : IN INTEGER := C83025C_PACK.A;
                 A : IN OUT INTEGER) IS
     C : INTEGER := A;
BEGIN
     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 10");
     END IF;

     IF C83025C_PACK.A /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 11");
     END IF;

     IF C83025C_PACK.B /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 12");
     END IF;

     IF C /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 13");
     END IF;

     IF X /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE PASSED IN - 14");
     END IF;

     IF Y /= TRUE THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 15");
     END IF;

     IF EQUAL(1,1) THEN
          A := IDENT_INT(4);
     ELSE
          A := 1;
     END IF;
END INNER2;

SEPARATE (C83025C_PACK)
FUNCTION INNER3 (X : INTEGER; Z : ENUM := Y) RETURN INTEGER IS
     C : INTEGER := A;
     A : INTEGER := IDENT_INT(3);
BEGIN
     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 20");
     END IF;

     IF C83025C_PACK.A /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 21");
     END IF;

     IF C83025C_PACK.B /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 22");
     END IF;

     IF C /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 23");
     END IF;

     IF X /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE PASSED IN - 24");
     END IF;

     IF Y /= ONE THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 25");
     END IF;

     IF Z /= ONE THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 26");
     END IF;

     IF EQUAL(1,1) THEN
          RETURN A;
     ELSE
          RETURN X;
     END IF;
END INNER3;

SEPARATE (C83025C_PACK)
FUNCTION INNER4 (X : INTEGER; Z : ENUM := Y) RETURN INTEGER IS
     C : INTEGER := A;
     A : INTEGER := IDENT_INT(3);
BEGIN
     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 30");
     END IF;

     IF C83025C_PACK.A /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 31");
     END IF;

     IF C83025C_PACK.B /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 32");
     END IF;

     IF C /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 33");
     END IF;

     IF X /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE PASSED IN - 34");
     END IF;

     IF Y /= ONE THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 35");
     END IF;

     IF Z /= ONE THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 36");
     END IF;

     IF EQUAL(1,1) THEN
          RETURN A;
     ELSE
          RETURN X;
     END IF;
END INNER4;

SEPARATE (C83025C_PACK)
PROCEDURE INNER5 (X : IN OUT INTEGER; F : IN FLOAT;
                  Z : CHARACTER := Y) IS
BEGIN
     X := INTEGER(F);

     IF Y /= 'A' THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 40");
     END IF;

     IF Z /= 'A' THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 41");
     END IF;
END INNER5;

WITH REPORT; USE REPORT;
WITH C83025C_PACK; USE C83025C_PACK;
PROCEDURE C83025C IS

     PROCEDURE NEW_INNER IS NEW INNER;

     PROCEDURE NEW_INNER2 IS NEW INNER2;

     FUNCTION NEW_INNER3 IS NEW INNER3;

     FUNCTION NEW_INNER4 IS NEW INNER4 (Y => EOBJ);

     PROCEDURE NEW_INNER5 IS NEW INNER5;

BEGIN
     TEST ("C83025C", "CHECK THAT A DECLARATION IN A DECLARATIVE " &
                      "REGION OF A GENERIC SUBPROGRAM HIDES AN OUTER " &
                      "DECLARATION OF A HOMOGRAPH");

     A := IDENT_INT(2);
     B := A;

     NEW_INNER (A);

     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE PASSED OUT - 7");
     END IF;

     A := IDENT_INT(2);

     NEW_INNER2 (A => OBJ);

     IF OBJ /= IDENT_INT(4) THEN
          FAILED ("INCORRECT VALUE PASSED OUT - 16");
     END IF;

     A := IDENT_INT(2);

     B := A;

     IF NEW_INNER3(A) /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE PASSED OUT - 27");
     END IF;

     A := IDENT_INT(2);

     B := A;

     IF NEW_INNER4(A) /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE PASSED OUT - 37");
     END IF;

     OBJ := 1;

     FLO := 6.25;

     NEW_INNER5 (OBJ, FLO);

     IF OBJ /= IDENT_INT(6) THEN
          FAILED ("INCORRECT VALUE RETURNED FROM FUNCTION - 42");
     END IF;

     IF Y /= 5 THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 50");
     END IF;

     IF Z /= 5 THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 51");
     END IF;

     RESULT;
END C83025C;