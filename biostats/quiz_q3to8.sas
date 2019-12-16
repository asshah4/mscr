LIBNAME h 'H:\';
DATA h.quiz_q3to8;
  INPUT subject_id$ section$ score;
  IF score >= 94     THEN course_grade = 'A ';
  IF 88 < score < 94 THEN course_grade = 'B+';
  DATALINES;
A1 1 44
A2 1 82
A3 1 99
B1 2 89
B2 2 91
C1 2 22
;
RUN;

PROC CONTENTS DATA=h.quiz_q3to8;
RUN;

PROC FREQ DATA=h.quiz_q3to8;
  TABLES subject_id section course_grade;
RUN;

PROC UNIVARIATE DATA=h.quiz_q3to8;
  CLASS section;
  VAR score;
  HISTOGRAM score;
RUN;
