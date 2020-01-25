/* 
Simple randomization code
Taught by J. Switchenko
*/

* RNG for simple randomization;
DATA sr;
	seed = 072384; *forces a RNG to follow;
	DO i = 1 to 100;
		* Output random number b/w 0 and 1;
		* the *10 then scales it to 0 and 10;
		* INT rounds down to nearest integer (versus ROUND which goes up);
		randno = INT(RANUNI(seed) * 10);
		OUTPUT;
	END;
DROP seed i;
RUN;

* Print it out;
PROC PRINT DATA = sr;
RUN;

* Tables;
PROC FREQ DATA = sr;
	TABLES randno;
RUN;
