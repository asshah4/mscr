*******************************
MSCR533 Quiz 1
Question 1 faulty code
*******************************;

DATA work.BIOS500Lab;
	INPUT IDNUM  Name$ Tution   CourseName$;
DATALINES;
8374 Erica     750.00 BIOS100 
5638 Joey      825.00 BIOS200 
8634 Michael   925.00 BIOS200 
8746 Zoey         .   BIOS100 
8743 George    450.00 BIOS100 
;
RUN;

PROC CONTENTS DATA = work.BIOS500Lab;
RUN;

PROC FREQ DATA = work.BIOS500Lab;
  TABLES CourseName; 
RUN;
