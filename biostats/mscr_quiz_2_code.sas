/*
SAS code for Quiz 2
Anish Shah
11/27/19
*/

*Set library;
LIBNAME H "H:\My Documents\Github\tl1\mscr\biostats\";

* Import data;
PROC IMPORT OUT = WORK.sandwich_name 
	DATAFILE = "H:\My Documents\Github\tl1\mscr\biostats\sandwich_name.xls";
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;


PROC IMPORT OUT = WORK.sandwich_nutrition
	DATAFILE = "H:\My Documents\Github\tl1\mscr\biostats\sandwich_nutrition.xls";
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;

*Examine contents of data sets;
PROC CONTENTS DATA = WORK.sandwich_name; RUN;
PROC CONTENTS DATA = WORK.sandwich_nutrition;
RUN;

* Merge into temp file by sandwich_number into temp data set called sandwiches;
PROC SORT DATA = WORK.sandwich_name;
	BY Sandwich_Number;
RUN;

PROC SORT DATA = WORK.sandwich_nutrition;
	BY Sandwich_Number;
RUN;

DATA WORK.sandwiches;
	MERGE WORK.sandwich_name WORK.sandwich_nutrition;
	BY Sandwich_Number;
RUN;

* Descriptive analysis;
PROC UNIVARIATE DATA = WORK.sandwiches;
	VAR Calories TFat Protein Carb Fiber Sodium Weight;
	HISTOGRAM Calories TFat Protein Carb Fiber Sodium Weight;
	PROBPLOT Calories TFat Protein Carb Fiber Sodium Weight;
RUN;

PROC FREQ DATA = WORK.sandwiches;
	TABLES Brand Name Category Frozen;
RUN;

* Modify teh data... change category of BEEF to Beef;
DATA WORK.sandwiches;
	SET WORK.sandwiches;
	* Decapitate the cow;
	IF Category = "BEEF" THEN Category = "Beef";
RUN;

PROC CONTENTS DATA = WORK.sandwiches;
RUN;

* Test average calories different for fresh or frozen, alpha = 0.01;
PROC TTEST DATA = WORK.sandwiches ALPHA=0.01;
	CLASS Frozen;
	VAR Calories;
	TITLE "Difference in calories for fresh or frozen sammies";
RUN;

* 99% confinddence in difference in mean calories of frozen versus fresh sammies;
PROC MEANS DATA = WORK.sandwiches CLM ALPHA = 0.01;
	CLASS Frozen;
	VAR Calories;
RUN;


