/* 
Homework assignment 1
SAS practice exercise in making a data table
Anish Shah
January 27, 2020
*/

/* 

Data Description

Can variables be used to predict if cancer has spread to lymph nodes?

Y = spread to nodes (1 = yes, 0 = no)
AGE = in years
ACID = acid phsophatase
XRAY = results of XR (1 = positive, 0 = negative)
SIZE = tumor size (1 = large, 0 = small) on prostate exam
GRADE = pathology (1 = serious, 0 = not so serious)
SES = income (high, middle, low)

Make this into a publication style data set with descriptive statistics
Do this with baseline characteristics in both groups

*/

* Establish directory;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\dimensional-analysis\";

* Quick prostate exam;
PROC CONTENTS DATA = H.prostate_data2;
RUN;

* Take a look at the prostate;
PROC PRINT DATA = H.prostate_data2 (OBS=100);
RUN;

* Check variables out with descriptive stats;
PROC FREQ DATA = H.prostate_data2;
	TABLE y xray size grade ses;
RUN;

PROC UNIVARIATE DATA = H.prostate_data2;
	VAR AGE ACID;
RUN;

* Massage said prostate into appropriate format;
PROC FORMAT
	VALUE y
		1 = "Nodal Spread"
		0 = "No Nodal Spread";
	VALUE xray
		1 = "Abnormal XR"
		0 = "Normal XR";
	VALUE size
		1 = "Big Prostate"
		0 = "Small Prostate";
	VALUE grade
		1 = "Serious Pathology"
		0 = "Not So Serious Pathology";
	VALUE $ses
		"high" = "High SES"
		"middle" = "Middle SES"
		"low" = "Low SES";
	VALUE overall 1 = "Overall";
RUN;

* Create a nice template for printing purposes;
PROC TEMPLATE;
	DEFINE STYLE styles.mytable;
		PARENT = styles.minimal;

		STYLE bodyDate from bodyDate /
			font=('Times',8pt);
		STYLE PagesDate from PagesDate /
			font=('Times',8pt);
		STYLE PagesTitle from PagesTitle /
			font=('Times',8pt);
		STYLE SystemTitle from SystemTitle /
			font=('Times',12pt);
		STYLE Data from Data /
			font=('Times, Times, Times',8pt);
		STYLE Header from HeadersAndFooters /
			font=('Times, Times, Times',8pt);
		STYLE RowHeader from HeadersAndFooters /
			font=('Times, Times, Times',8pt);

RUN;

* Label the main variable names;
DATA tbl;
	SET H.prostate_data2;
	LABEL y="Nodal Involvement";
	LABEL xray = "X-Ray Findings";
	LABEL size = "Prostate Exam Findings";
	LABEL grade = "Pathological Findings";
	LABEL ses = "Socioeconomic Status (SES)";
	overall = 1;
RUN;

* Open a file to print this stuff out to;
ODS RTF STYLE = mytable FILE = "C:\Users\asshah4\Box Sync\projects\mscr\dimensional-analysis\hw1-table.rtf";
	TITLE1 "Table 1. Characteristics of Patients with and without Prostate Nodal Involvement";

	* Create a table here using proc tabulate;
	* Column name are selected by proc format;
	* Must know the column names/values;
	PROC REPORT 

	TITLE1;
	ODS RTF CLOSE;
RUN;
