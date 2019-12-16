/*
Homework for SAS session 3
Anish Shah
09/18/19
*/

* Set up a library name;
LIBNAME CLASS "H:\My Documents\Github\tl1-grant\mscr\biostats\";

* Import in hte candy;
PROC IMPORT OUT = CLASS.candy
	DATAFILE = "H:\My Documents\Github\tl1-grant\mscr\biostats\candy_nutrition.xls"
	DBMS = EXCEL REPLACE;
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;

* Spill the candy guts;
PROC CONTENTS DATA = CLASS.candy;
RUN;

* Temporary file for messing with teh candy;
DATA WORK.candy_temp;
	SET CLASS.candy;

	* Change all the nutrition to content per gram, instead of per serving;
	calories_per_g = calories / serving_size__g_;
	total_fat_per_g = total_fat__g_ / serving_size__g_;
	sat_fat_per_g = saturated_fat__g_  / serving_size__g_;
	sodium_per_g = sodium__mg_ / 1000 / serving_size__g_;
	carb_per_g = total_carbohydrate__g_ / serving_size__g_;
	sugar_per_g = sugars__g_ / serving_size__g_;
	protein_per_g =  protein__g_ / serving_size__g_;

	* Chocolate coding;
	IF candy_type = "Chocolate" THEN candy_type = 1;
		ELSE candy_type = 0;

RUN;

* Save the new candy bits;
DATA CLASS.candy_mod;
	SET WORK.candy_temp;
RUN;

* Sample data of new obs;
PROC PRINT DATA = CLASS.candy_mod (OBS = 10);
RUN;

* Check the contents;
PROC CONTENTS DATA = CLASS.candy_mod;
RUN;

* Send the output data to a excel file;
ODS EXCEL FILE = "H:\My Documents\Github\tl1-grant\mscr\biostats\overall_candy.xls";

* Descripive analysis by all candy;
PROC MEANS DATA = CLASS.candy_mod STACKODSOUTPUT;
	VAR calories_per_g total_fat_per_g sat_fat_per_g sodium_per_g carb_per_g sugar_per_g protein_per_g;
	ODS OUTPUT SUMMARY = stacked;
RUN;

* Desc by candy type;
PROC MEANS DATA = CLASS.candy_mod STACKODSOUTPUT;
	CLASS candy_type;
	VAR calories_per_g total_fat_per_g sat_fat_per_g sodium_per_g carb_per_g sugar_per_g protein_per_g;
	ODS OUTPUT SUMMARY = stacked;
RUN;

* Print into an excell FILE;
ODS EXCEL CLOSE;
