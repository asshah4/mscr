/*
Session on concatenating databases
Done in lab time
*/

*Named library;
LIBNAME H "H:\My Documents\Github\tl1-grant\mscr\biostats\";

*Open up the cholera data sets from the villages;
PROC CONTENTS DATA = H.cholera_village1;
PROC CONTENTS DATA = H.cholera_village2;
RUN;

* Concatenate the data now;
DATA H.cholera_villages;
  SET H.cholera_village1 H.cholera_village2;
RUN;

* Explore the tables;
PROC FREQ DATA = H.cholera_villages;
  TABLES area;
RUN;

* Get the demographic data, but sorted;
PROC SORT DATA = H.cholera_demog;
  BY subject;
RUN;

* Sort the disease as well;
PROC SORT DATA = H.cholera_disease;
  BY subject;
RUN;

* Sort the villages as well;
PROC SORT DATA = H.cholera_villages;
  BY subject;
RUN;

* Merge the data;
DATA H.cholera_merge;
  MERGE H.cholera_demog H.cholera_disease;
  BY subject;
RUN;

*Substeting data;
DATA WORK.temp;
  SET H.cholera_merge;
  IF AGE >= 15 THEN DELETE;
  *IF age < 15 would also work without needing the deletion step;
RUN;

* Test the new subset;
PROC MEANS DATA = WORK.temp;
  VAR age;
RUN;

* Can also use a full data set, temporarily subset, and then analyze it;
PROC FREQ DATA = H.cholera_merge;
  TABLES disease;
  WHERE . < age < 15; *to include folks with missing age;
  WHERE disease = 1;
RUN;
