/******************************
* Name Shah, Anish:
* Lab 1 in-lab exercise
******************************/

/* Data set for exercise */
DATA lab1_exercise;
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
I 1 yes yes
J 4 no no
K 3 no no
L 2 yes yes
M 1 yes yes
;
RUN;

/* Descriptive statistics */
PROC FREQ DATA = lab1_exercise;
	TABLES subject age daycare sore_throat;
	TABLES sore_throat / plots = freqplot;
	TABLES daycare*sore_throat / plots = freqplot;
RUN;

PROC UNIVARIATE DATA = lab1_exercise;
	VAR age;
	HISTOGRAM age;
	INSET n mean std;
RUN;



/************************************************

“The mean age in our sample of __a__ children was ___b__ years (sd ___c___ years). ___d___ of the children (___e___%) attended daycare. ___f____ children (__g_%) had sore throats. Of the children who attended daycare, ___h___ (___i___) had sore throats.”

Answers from part 6:
a: 13
b: 2.5
c: 1.1
d: 7
e: 54
f: 7
g: 54
h: 6
i: 46
***********************************************/

/*
Age may be related to sore throat, but its not completely clear. A table that shows the differences by age and sore throat would be helpful in identifiying a visual pattern, however would likely prefer a simple statistical test (e.g. chi-square), however would have to consider the either confounding/interaction term of the presence in daycare.

The code I would use is...

PROC FREQ DATA = lab1_exercise;
	TABLES subject age daycare sore_throat;
	TABLES age*sore_throat / plots = freqplot;
RUN;

*/
