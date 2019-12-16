/* 09/04/19 class on importing files
this is the batch window for for extracting/importing
data file is sandwich excel file */

*Import function;
PROC IMPORT OUT = WORK.sandwiches
	DATAFILE = "H:\My Documents\Github\tl1-grant\mscr\biostats\sandwiches_in_excel.xlsx"
	DBMS = EXCEL REPLACE;
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;

*Extract the names of hte columns;
PROC CONTENTS DATA = WORK.sandwiches;
RUN;

*Print out the table instead of using viewtable to save space;
*Header function through obs, needs () parentheses;
PROC PRINT DATA = WORK.sandwiches (OBS = 5);
RUN;

* Make a calorie histogram;
PROC UNIVARIATE DATA = WORK.sandwiches;
	VAR calories;
	HISTOGRAM calories;
	INSET N MEAN STD MEDIAN QRANGE / POSITION = NE;
	TITLE "Desc Stats for Calories";
RUN;

* Save the dataset;
DATA "H:\My Documents\Github\tl1-grant\mscr\biostats\sandwich.sas7bdat";
	SET WORK.sandwiches;
RUN;

* Identify the library location;
LIBNAME CLASS "H:\My Documents\Github\tl1-grant\mscr\biostats\";

* Let create an instream version of the data;
DATA CLASS.sore_throat;
	INPUT subject$ age daycare$ sore_throat$;
	DATALINES;
C 3 yes no
E 2 no no
F 3 no no
G 3 no no
A 1 yes yes
B 2 yes yes
D 4 yes yes
H 4 no yes
;
RUN;

*Save this sore throat into a sas dataset;
DATA CLASS.sore_throat;
	SET CLASS.sore_throat;
RUN;

*See if this is loaded;
PROC CONTENTS DATA = CLASS.sore_throat;
	TITLE "Contents of sore throat data";
RUN;

* Frequency table;
PROC FREQ DATA = CLASS.sore_throat;
	TITLE "Daycare data table";
	TABLE daycare;
RUN;
