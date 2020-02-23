/*
MSCR 520
Homework 1
Anish Shah
February 9, 2020
*/

*** 1. Simple randomization using seed 938134;

* data step;
DATA tmp;
	seed = 938134;
	DO i = 1 to 8;
		rando = INT(RANUNI(seed)*10);
		OUTPUT;
	END;
	DROP seed i;
RUN;

* Print it out;
PROC PRINT DATA = tmp;
RUN;

* Check frequencies;
PROC FREQ DATA = tmp;
	TABLES rando;
RUN;


*** Blocked randomization, seed 737375

With block size = 4, the blocks are: 
AABB, ABAB, BAAB, BABA, BBAA, ABBA. 
Using the seed 737375 in the SAS code we did in class, 
determine the treatment allocation of the first eight subjects 
by filling in the table below.;

* Data step;
* Total of 6 blocks possible;
DATA tmp;
	seed = 737375;
	DO i = 1 to 8;
		rando = INT(RANUNI(seed)*6);
		OUTPUT;
	END;
	DROP seed i;
RUN;

* Print it out;
PROC PRINT DATA = tmp;
RUN;


* Assignment of groups!
0-AABB
1-ABAB
2-BAAB
3-BABA
4-BBAA
5-ABBA

Random number sequence (per seed) is... 4>1>2>0>4>5>1>1
Thus, first four patients go to BABA, then next four go to AABB
A = aspirin
B = placebo
;

*** Stratified randomization;

* Sex and diabetes are the variables, thus 2x2 = 4 strata;
* Seeds assigned to each grouplet

3374 = M, +DM
4875 = M, -DM
1389 = F, +DM
2973 = F, -DM

Each strata gets 8 subjects. Blocks are size = 2.;

* Data step;
DATA tmp;
	seed = 2973;
	DO i = 1 to 4; * Need total of 8 patients to be done;
		rando = INT(RANUNI(seed)*2);
		OUTPUT;
	END;
	DROP seed i;
RUN;

* Print it out;
PROC PRINT DATA = tmp;
RUN;

* Block of 2
1-AB
2-BA
