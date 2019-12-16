/\*SAS doesn\'t know how to transpose vectors

Nor can it save vectors of data to transpose

Excel did it for me \*/

DATA hw;

INPUT A B;

DATALINES;

1.31 1.13

1.45 1.71

1.12 1.39

1.16 1.15

1.3 1.33

1.5 1

1.2 1.03

1.22 1.68

1.42 1.76

1.14 1.55

1.23 1.34

1.59 1.47

1.11 1.74

1.1 1.74

1.53 1.19

1.52 1.15

1.17 1.2

1.49 1.59

1.62 1.47

1.29

;

RUN;

\*Has the content;

PROC CONTENTS DATA = hw; RUN;

\*Summary;

PROC UNIVARIATE DATA = hw;

VAR A B;

HISTOGRAM A B;

INSET N MEAN STD QRANGE / POS = NW;

RUN;
