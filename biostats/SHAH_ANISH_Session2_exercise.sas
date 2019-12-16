/*
Shah, Anish
Session 2 HW
*/

*Name my library;
LIBNAME CLASS "H:\My Documents\Github\tl1-grant\mscr\biostats\";

* Load the sammiches;
PROC CONTENTS DATA = CLASS.sandwich;
RUN;

* Basic stats;
PROC FREQ DATA = CLASS.sandwich;
	TABLES Brand category frozen name;
RUN;

PROC UNIVARIATE DATA = CLASS.sandwich;
	VAR calories carb fiber protein sandwich_number sodium tfat weight;
RUN;

* Min and max weight of sammiches;
PROC MEANS DATA = CLASS.sandwich MIN MAX;
	VAR weight;
	TITLE "Example of weight min/max";
RUN;

* Sorting the data instead to get the fat and skinny on sammiches; 
PROC SORT DATA = CLASS.sandwich;
	BY weight;
PROC PRINT;
	TITLE "Example of sorted weights";
RUN;

/* Answers to HW paragraphs
The sandwiches data set contains _a__ numeric variables and _b__ character variables. In the sample of _c__ sandwiches, _d__ (_e__%) were frozen and __f_ (_g__ %) were fresh. The mean weight of the sandwiches was _h__ ozs, (sd _i__ ozs, median _j__ ozs). The lightest sandwich was the _k--name of sandwich_ , which weighed _l__ ozs. The heaviest sandwich was the _m--name of sandwich_, which weighed _n__ ozs.”

a: 8
b: 4
c: 64
d: 18
e: 28
f: 46
g: 72
h: 8.2
i: 2.0
j: 8.5
k: Lite Bagel
l: 4.5
m: Fried Platter
n: 14.7
*/
