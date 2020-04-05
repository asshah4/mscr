
*** from Neter, Kutner, Nachtsheim,and Wasserman
    Applied Linear Statistical Models
    4th edition
    McGraw-Hill, 1996
    table 17.2 page 712;

data rust;
 input rust brand i;
 cards;
  43.9  1   1
  39.0  1   2
  46.7  1   3
  43.8  1   4
  44.2  1   5
  47.7  1   6
  43.6  1   7
  38.9  1   8
  43.6  1   9
  40.0  1  10
  89.8  2  11
  87.1  2  12
  92.7  2  13
  90.6  2  14
  87.7  2  15
  92.4  2  16
  86.1  2  17
  88.1  2  18
  90.8  2  19
  89.1  2  20
  68.4  3  21
  69.3  3  22
  68.5  3  23
  66.4  3  24
  70.0  3  25
  68.1  3  26
  70.6  3  27
  65.2  3  28
  63.8  3  29
  69.2  3  30
  36.2  4  31
  45.2  4  32
  40.7  4  33
  40.5  4  34
  39.3  4  35
  40.3  4  36
  43.2  4  37
  38.7  4  38
  40.9  4  39
  39.7  4  40
;
run;

proc means maxdec=2;
class brand;
var rust;
run;


ods listing;
/*** using bonferroni adjustment **/
Title "Bonferroni adjustment not used. All 6 comparisions are significant.";
proc glm data=rust;
 class brand;
  model rust=brand;
 lsmeans brand / pdiff;  **** also gives p value for all 6 pairwise comparisons;

  
  means brand / lines;
run;quit;

/*** using bonferroni adjustment **/
Title "Bonferroni adjustment used.  One comparision is not-siginificant. ";

proc glm data=rust;
 class brand;
  model rust=brand;
 lsmeans brand /adjust=bon pdiff;
 
  **** other choices  instead of bonferroni
       tukey, lsd, snk, duncan, dunnett, scheffe ....;
  ***** to get 95% Confidence Intervals do
  means brand / bon cldiff;
 ***** if unbalanced use tukey;
  means brand / bon lines;
run;quit;
