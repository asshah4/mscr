*--------------------------------------------------------------*
**** Owner: Neeta Shenvi nshenvi@emory.edu;
**** Purpose: Introduction to SAS format procedure;
*** This code will demonstrate how to create and apply formats;
*What Does the FORMAT Procedure Do?
The FORMAT procedure enables you to define your own informats and formats for variables.

***With formats, you can do the following:

Print numeric values as character values (for example, print 1 as MALE and 2 as FEMALE).
Print one character string as a different character string (for example, print YES as OUI).

*--------------------------------------------------------------;
**** create SAS dataset using in-line statements;
*** male is character variable and race is numeric variable;

*--------------------------------------------------------------;
data format_example;
input systolic diastolic male $ race;
datalines;
120 90  M 1
130 89  F 2
150 95  M 3
170 100 F 1
145 89  F  3
156 95  M  1
;
run;

***one-way frequency table;
Proc freq data=format_example;
tables race male;

run;

***two-way frequency table;
Proc freq data=format_example;
tables race*male;
run;

****Create format library for race and male variable using PROC FORMAT procedure;
**** Below is simple format code;
proc format;
**** VALUE statement to create a numeric format for numeric variable that prints a value to a different character string;
value racefmt 
    1="AA" 
    2="Caucasian" 
    3="Asian"
    ;
**** character format for character variable male;
	***VALUE statement to create a character format that prints a value of a character variable as a different character string.;
	value $malesex 
        "M"="Male" 
        "F"="Female"
      ;

	  ***VALUE statement to create a character format that prints a value of a character variable as a different numeric value.;
	  value $male
        "M"=1 
        "F"=0
      ;
run;
*---- Use below link to learn more about formats  ---------------------*

https://documentation.sas.com/?docsetId=proc&docsetTarget=p1upn25lbfo6mkn1wncu4dyh9q91.htm&docsetVersion=9.4&locale=en;
*---------------------------------------------------*

**** one-way frequency table with format statement;

Proc freq data=format_example;
tables race male;

**** apply formats using format statement;
format race racefmt.
       male $malesex.
	   ;
run;


**** one-way frequency table with format statement;
Proc freq data=format_example;
tables  male;

**** apply formats using format statement;
format male $male.
	   ;
run;
**** cross-table with format statement;
Proc freq data=format_example;
tables race*male;

**** apply formats using format statement;
format race racefmt.
       male $malesex.
	   ;
run;
***** Descriptive stats for continuous variable by sex category and apply formats;
proc means data=format_example  maxdec=0 n mean std min max median p25 p75 ;
class male;
var systolic diastolic;
format  male $malesex.  ;
run;


***** BOX plot procedure simple code and using format statement;
proc sgplot data=format_example;
vbox systolic/category=male;
yaxis Label="Systolic BP(mm Hg)";
format  male $malesex.  ;
run;


***** BOX plot procedure enhanced code with several options to enhance the picture;
proc sgplot data=format_example;
vbox systolic/category=male  fillattrs=(color=lightgreen) meanattrs=(color=red symbol=starfilled) medianattrs=(color=purple thickness=2pt) ;

yaxis Label="Systolic BP(mm Hg)" labelattrs=(color=black size=12pt) minor GRID values=(120 to 180 by 2);
xaxis Label=" ";

inset "Mean(SD) for Systolic BP "  / textattrs=(color=black size=12pt);  ***** proc means will give mean in each group ;
inset "Females:148(20) , Males:142(19)"  / textattrs=(color=red size=12pt);  ***** proc means will give mean in each group ;

format  male $malesex.  ;
Title "Systolic BP by Sex" ;
run;


