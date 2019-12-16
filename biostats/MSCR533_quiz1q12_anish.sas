/* midterm exam for SAS class
Anish Shah
10/23/19
MSCR533_quiz1q12_anish.sas
*/

* Import survey;
PROC IMPORT OUT = WORK.n1_temp
	DATAFILE = "H:\My Documents\Github\tl1-grant\mscr\biostats\MSCRSurveys_n1_DATA_2019-10-22_1246.xlsx"
	DBMS = EXCEL REPLACE;
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATA = YES;
	SCANTIME = YES;
RUN;

* Examine contents;
PROC CONTENTS DATA = n1_temp;
PROC PRINT DATA = n1_temp (OBS=5);
RUN;

* Modified new temp data;
DATA n1_temp2(DROP = x y);
	SET n1_temp;

	*convert from pounds;
	wt_kg = weight/2.2; 

	* text sex male if gender is 2, female if gender is 1;
	IF gender = 2 THEN sex = "Male";
	ELSE IF gender = 1 THEN sex = "Female";

	* height just in feet;
	x = height/12;
	height_ft = INT(x);

	* height in inches;
	y = height_ft * 12;
	height_in = height - y;
RUN;

* Validate new data;
PROC CONTENTS DATA = n1_temp2;
RUN;

PROC FREQ;
	TABLES sex;
RUN;

PROC UNIVARIATE;
	VAR wt_kg height_ft height_in;
RUN;

* Save into premanent data folder;
LIBNAME H "H:\My Documents\Github\tl1-grant\mscr\biostats\";
DATA H.n1;
	SET WORK.n1_temp2;
RUN;

* Descriptive statistical analyses in all variables in n1 by sex;
PROC UNIVARIATE DATA = H.n1;
	CLASS sex;
	VAR age height height_ft height_in n1_exercise_and_nutrition_form_v person_id weight wt_kg;
RUN;

* ALL DONE. Hope your back gets better.
