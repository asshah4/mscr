* Practice zinc file;

* Set up a library name;
LIBNAME H "H:\My Documents\Github\tl1-grant\mscr\biostats\";

*Import the data;
PROC IMPORT OUT = WORK.zinc_imported
	DATAFILE = "H:\My Documents\Github\tl1-grant\mscr\biostats\quiz_zinc.xls"
	DBMS = EXCEL REPLACE;
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;

* Check uot the data;
PROC PRINT DATA = WORK.zinc_imported (OBS=10);
RUN;

PROC CONTENTS;
RUN;

*Create permanent dataset;
DATA H.zinc_Anish_Shah;
  SET WORK.zinc_imported;

  *Add variable named "Diff", for each pair of rats;
  *Difference b/w treated and utreated rats;
  Diff = Calcium - No_Calcium;

  *"Sex" variable;
  *Pairs 1 to 10 are male;
  *Pairs 11-20 are female;
  IF Pair <= 10 THEN Sex = "Male";
  	ELSE IF Pair >= 11 THEN Sex = "Female";

RUN;

* Perform descriptive analyses;
PROC CONTENTS DATA = H.zinc_Anish_Shah;
RUN;

PROC PRINT DATA = H.zinc_Anish_Shah (OBS = 10);
RUN;

PROC UNIVARIATE DATA = H.zinc_Anish_Shah;
	VAR Calcium No_Calcium Diff;
RUN;
