/*
Learning how to do correlation in SAS
*/

* Named library;
LIBNAME H "H:\My Documents\Github\tl1-grant\mscr\biostats\";

DATA sodium_bp;
  INPUT x y @@;
  LABEL x = ‘Sodium Intake’ y = ‘SBP’;
  DATALINES;
6.8 154 7.0 158 6.5 148 7.0 167 7.0 166 6.4 140
6.9 162 7.5 195 7.2 175 7.3 189 7.3 190 7.1 186
;
  PROC CORR;
  VAR x;
  WITH y;
RUN;
