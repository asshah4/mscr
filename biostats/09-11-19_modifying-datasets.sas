/* 09-11-19_modifying-datasets
*/

*Name my library;
LIBNAME CLASS "H:\My Documents\Github\tl1-grant\mscr\biostats\";

*Stroke data set;
PROC CONTENTS DATA = CLASS.strokestudy_baseline;
RUN;

*Sample of obs;
PROC PRINT DATA = CLASS.strokestudy_baseline (OBS = 10);
RUN;

*Perform desc analysis of the vars;
PROC UNIVARIATE DATA = CLASS.strokestudy_baseline;
	VAR age sbp ldl;
	HISTOGRAM age;
	INSET N MEAN STD /POS = NE;
RUN;

* Make a temporarly copy of hte data;
* Modify the data and save it elsewhere;
DATA WORK.strokestudy_temp;
	SET CLASS.strokestudy_baseline;

	*Convert LDL into milimoles;
	ldl_mmolperl = ldl * 0.02856;

	*add if ldl is in target range;
	IF (ldl < 70) THEN in_target = "yes";
		ELSE in_target = "no";
	IF ldl = . THEN in_target = " ";

	* add insurance status;
	IF (age >= 65) THEN DO;
		medicare = 1;
	END;
		ELSE medicare = 0;
	IF age = . THEN medicare = .;
RUN;

*Check to see if updates worked;
PROC MEANS DATA = WORK.strokestudy_temp MIN MAX;
	CLASS medicare;
	VAR age;
RUN;

*Save the new file;
DATA CLASS.strokestudy_new;
	SET WORK.strokestudy_temp;
RUN;
