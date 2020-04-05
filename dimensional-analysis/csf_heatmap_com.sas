
libname a ".";
data work.csf;
infile 'csfdata.txt' lrecl=9999;
  input group$ x1-x140;
run;

data csf_long;
   set csf;
   array x{140} x1-x140;
   Subject + 1;
   do gene=1 to 140;
      expression=x{Gene};
      output;
   end;
   drop x1-x140;
run;

data csf_long; set csf_long;
gp=compress(put(subject,2.0))|| " (" || compress(group) || ")";

run;
proc template;
  define statgraph heatmap;
 dynamic _t;
    begingraph / designheight=900 designwidth=800;
	  entrytitle _t;
	  rangeattrmap name="rmap";
	    
		range 0 - max /  rangecolormodel=(lightgreen green red);
	  endrangeattrmap;
	  rangeattrvar attrmap="rmap" var=expression attrvar=pColor;
	  layout overlay / Xaxisopts=(Label="Subject"  ) yaxisopts=(display=(ticks tickvalues line))  ;
	    heatmapparm y=Gene x=gp colorresponse=pColor / 
                          /*xboundaries=(1 2 3 4 5 6 7 8 9 10 11 12 13) */
                          xvalues=leftpoints xendlabels=true 
                          name="heatmap";
		continuouslegend "heatmap"/title="Expression level";
	  endlayout;
	endgraph;
  end;
run;
*** figure 1;
ods listing;
**** print;
options orientation="portrait";
ods rtf file=".\csf_heatmap_comp2018.rtf" startpage=no;

Title ;
ods graphics /noborder ;


proc sgrender data=csf_long template=heatmap; 
dynamic _t="Fig 1a:Heatmap of 140 gene expression levels for 16 subjects";
run;

ods rtf close;

**** Do Bonferroni and  FDR;
proc multtest data=csf FDR bon;
  test mean (x1 -- x140);
  class group;
  ods output pvalues=work.csfmulttest;
run;

data csfmulttest; set csfmulttest;
genetxt=substr(variable,2);
gene = input(genetxt,3.0);
run;

proc sort data=work.csfmulttest;
  by falsediscoveryrate;
run;



proc sql;
create table csf_p as
select variable, "Raw P" as group, gene,raw  as p from csfmulttest
union
select variable, "FDR P" as group, gene, falsediscoveryrate  as p from csfmulttest

order by group, gene;
quit;



proc sql;
create table csf_px1 as
select variable, "BON =0.05" as group, 2 as gp, gene, bonferroni  as p from csfmulttest where bonferroni <0.05
union
select variable, "BON =0.1" as group, 3 as gp, gene, bonferroni  as p from csfmulttest where bonferroni <0.1
union
select variable, "FDR =0.2" as group, 6 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.2
union
select variable, "FDR =0.1" as group, 5 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.1
union
select variable, "FDR =0.05" as group,4 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.05
union
select variable, "Raw P<0.05" as group, 1 as gp,gene,raw  as p from csfmulttest where raw <0.05

order by gp, gene;
quit;



Proc sql;
select compress(put(count(*),2.0))  into:pfdr5  from csfmulttest where falsediscoveryrate < 0.05 ;

select count(*) format=2.  into:pfdr1  from csfmulttest where falsediscoveryrate < 0.1 ;
select count(*) format=2.  into:pfdr2  from csfmulttest where falsediscoveryrate < 0.2 ;
select count(*) format=2.  into:praw  from csfmulttest where raw < 0.05 ;
select count(*) format=2.  into:pbon  from csfmulttest where bonferroni< 0.05 ;
select count(*) format=2. into:pbon2  from csfmulttest where bonferroni< 0.1 ;
quit;

**** figure 2;
proc template;
  define statgraph heatmap2;
    begingraph / designheight=800 designwidth=920;
	  entrytitle 'Figure 2:Identification of proteins with FDR and Bonferroni correction: CSF dataset';
	  

entryfootnote " ";
	   entryfootnote "Significant proteins: &praw. proteins(Raw P=0.05 )";
	   entryfootnote "Bonferroni correction: &pbon. proteins(Overall alpha=0.05); &pbon2. proteins (Overall alpha=0.1)";
	  entryfootnote "FDR correction: &pfdr5. proteins(FDR=0.05); &pfdr1. proteins (FDR=0.1);&pfdr2. proteins (FDR=0.2)";
	  
	  rangeattrmap name="rmap";
	    range 0  - < 0.05     /rangecolor=lightgreen rangealtcolor=lightgreen ;
        range 0.05  - < 0.1     / rangecolor=red rangealtcolor=red ;
		 range 0.1  - < 0.15     / rangecolor=yellow  rangealtcolor=yellow ;
		
	    range 0.15  - max  / rangecolor=lightpurple rangealtcolor= lightpurple ;
		
	  endrangeattrmap;
	  rangeattrvar attrmap="rmap" var=p attrvar=pColor;

	 layout overlay / 

xaxisopts=(Label="Method"  ) 
x2axisopts=(Label=" " griddisplay=on ) yaxisopts=( Label="Protein number"  griddisplay=on
	  display=( ticks tickvalues line label) linearopts=(minorticks=yes ))  ;
	    heatmapparm y=Gene x=group colorresponse=pColor / 
                          
                          xvalues=leftpoints xendlabels=true 
                          name="heatmap";
			
		continuouslegend "heatmap" / orient=vertical 
 title="P value";
 			
	  endlayout;
	 
	endgraph;
  end;
run;


**** print;
ods rtf file=".\csf_heatmap_comp2020.rtf" startpage=no;
ods graphics/reset noborder;
proc sgrender data=csf_long template=heatmap;  
dynamic _t="Figure 1:Heatmap of 140 protein expression levels for 16 subjects: CSF dataset";
run;
title ;


proc sgrender data=csf_px1 template=heatmap2; format p pvalue6.2;run;
title ;
Ods rtf close;

***** further refinment figure 3;


proc template;
  define statgraph heatmap3;
    begingraph / designheight=800 designwidth=820;
	  entrytitle 'Figure 3:Identification of proteins with FDR and Bonferroni correction: CSF dataset';
entrytitle 'Gene numbers annotated';
entryfootnote " ";
	   entryfootnote "Significant proteins: &praw. proteins(Raw P=0.05 )";
	   entryfootnote "Bonferroni correction: &pbon. proteins(Overall alpha=0.05); &pbon2. proteins (Overall alpha=0.1)";
	  entryfootnote "FDR correction: &pfdr5. proteins(FDR=0.05); &pfdr1. proteins (FDR=0.1);&pfdr2. proteins (FDR=0.2)";
	  
	  rangeattrmap name="rmap";
	    range 0  - < 0.05     /rangecolor=lightgreen rangealtcolor=lightgreen ;
        range 0.05  - < 0.1     / rangecolor=red rangealtcolor=red ;
		 range 0.1  - < 0.15     / rangecolor=yellow rangealtcolor=yellow ;
		
	    range 0.15  - max  / rangecolor=lightpurple rangealtcolor= lightpurple ;
		
	  endrangeattrmap;
	  rangeattrvar attrmap="rmap" var=p attrvar=pColor;

	 layout overlay / 

xaxisopts=(Label="Method"  ) 
x2axisopts=(Label=" " griddisplay=on ) yaxisopts=( Label="Protein number"  griddisplay=on
	  display=( ticks tickvalues line label) linearopts=(minorticks=no ))  ;
	    heatmapparm y=gene x=group colorresponse=pColor / 
                          
                          xvalues=leftpoints xendlabels=true 
                          name="heatmap";
						  scatterplot y=gene x=group/markerchar=gene;
			
		continuouslegend "heatmap" / orient=vertical 
 title="P value";
 			
	  endlayout;
	 
	endgraph;
  end;
run;



**** print;
options nodate nonumber;
ods listing;
ods escapechar="~";
title ;
footnote;

ods rtf file=".\csf_heatmap_comp2020.rtf" startpage=no;
ods graphics/reset noborder;
****** Figure 1;
proc sgrender data=csf_long template=heatmap;  
dynamic _t="Figure 1:Heatmap of 140 protein expression levels for 16 subjects: CSF dataset";
run;
title ;

********** Figure 2;

proc sgrender data=csf_px1 template=heatmap2; format p pvalue6.2;run;

ods text="~{style [ color=black
       font_size=10pt just=center fontfamily=arial   font_style=italic width=100pct]
      The colors reflect  the  strength of the p-values corresponding to the adjusted method. They are not corresponding to the raw p values. }";

title ;

title;
title;
proc sgrender data=csf_px1 template=heatmap3; 
format p pvalue6.2  ;

run;

ods text="~{style [ color=black
       font_size=10pt just=center fontfamily=arial   font_style=italic width=100pct]
      The colors reflect  the  strength of the p-values corresponding to the adjusted method. They are not corresponding to the raw p values. }";

title ;
Ods rtf close;

title ;
