/*
MSCR 500 and 533
Final Exam SAS Code
Anish Shah
*/

*Named Library;
LIBNAME H "H:\My Documents\Github\mscr\biostats\";

DATA q5;
  INPUT mouse normal mutant;
  LABEL x = ‘Sodium Intake’ y = ‘SBP’;
  DATALINES;
1			180								100
2			160								97
3			140								80
4			62									6
5			82									31
6			73									110
7			43									7
8			36									55
9			110								100
;
RUN;
