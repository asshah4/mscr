* Library;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\dimensional-analysis";
RUN;

*** METHOD 2;
ODS SELECT NONE;
PROC MULTTEST DATA = H.cancer_stage fdr;
	TEST mean (x1 -- x10000);
	CLASS group;
	ODS OUTPUT pvalues = WORK.t2;
RUN;
ODS SELECT ALL;

* Sort pvalues;
PROC SORT DATA = t2;
	BY Raw;
RUN;

*Select by FDR of 1%;
DATA leads;
	SET t2;
	IF FalseDiscoveryRate < 0.01;
RUN;


* PCA on limited data;
DATA sample;
	SET H.cancer_stage;
	KEEP group id stage 
		x1012 x5834 x3519 x9686 x5056 x5458
		x1118 x1830 x3148 x4150 x8940 x5802;
	IF stage = '' THEN stage = "Missing";
RUN;

PROC CONTENTS DATA = sample; RUN;

* Run PC;
ODS GRAPHICS ON;
PROC PRINCOMP OUT = pca;
	VAR x1012 x5834 x3519 x9686 x5056 x5458
		x1118 x1830 x3148 x4150 x8940 x5802;
RUN;

PROC PRINT DATA = sample; RUN;

* Plot it;
PROC GPLOT DATA = pca;
	PLOT PRIN1 * PRIN2 = stage;
RUN;
