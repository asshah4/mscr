
/*--------------------------------------*/
/** Keep cancer dataset and this cancer_heatmap.sas file 
  in the same directory  */
/*** input: cancer sas dataset **********/
/*** output plot file: cancer_heatmap2_2018.rtf ---- ***/

libname a ".";


ods listing;;

data cancer_long;
   set a.cancer;
   array x{10000} x1-x10000;
   Subjectid + 1;
   do gene=1 to 10000;
      expression=x{Gene};
      output;
   end;
   drop x1-x10000;
run;
proc format ; value $gp "1"="C" "0"="N";run;

data cancer_long; set cancer_long;
subject=compress(put(subjectid,2.0))|| "-" || compress(put(group,$gp.)) ;

run;


proc multtest data=a.cancer FDR bon;
  test mean (x1 -- x10000);
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


data xx1; set csfmulttest;   where raw <0.2 ;run;
***NOTE: 2675 genes selected;

data xx2; set csfmulttest;   where raw <0.05 ;run;
***NOTE: 1001 genes selected;

proc sql;
create table cancer_p as
select variable, "Raw P" as group, gene,raw  as p from csfmulttest
union
select variable, "FDR P" as group, gene, falsediscoveryrate  as p from csfmulttest

order by group, gene;
quit;



proc sql;
create table cancer_px1 as

select variable, "FDR =0.2" as group, 4 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.2
union
select variable, "FDR =0.1" as group, 3 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.1
union
select variable, "FDR =0.05" as group,2 as gp, gene, falsediscoveryrate  as p from csfmulttest where falsediscoveryrate <0.05
union
select variable, "Raw P<0.05" as group, 1 as gp,gene,raw  as p from csfmulttest where raw <0.05

order by gp, gene;
quit;



Proc sql;
select count(*) into:pfdr5  from csfmulttest where falsediscoveryrate < 0.05 ;

select count(*) into:pfdr1  from csfmulttest where falsediscoveryrate < 0.1 ;
select count(*) into:pfdr2  from csfmulttest where falsediscoveryrate < 0.2 ;
select count(*) into:praw  from csfmulttest where raw < 0.05 ;

quit;

**** create plot template;
proc template;
  define statgraph heatmap;
 dynamic _t;
    begingraph / designheight=900 designwidth=800;
	  entrytotle _t;
	  rangeattrmap name="rmap";
	    
		range 0 - max /  rangecolormodel=(lightgreen green red);
	  endrangeattrmap;
	  rangeattrvar attrmap="rmap" var=expression attrvar=pColor;
	  layout overlay / Xaxisopts=(Label="Subject"  ) yaxisopts=(display=(ticks tickvalues line))  ;
	    heatmapparm y=Gene x=subject colorresponse=pColor / 
                          /*xboundaries=(1 2 3 4 5 6 7 8 9 10 11 12 13) */
                          xvalues=leftpoints xendlabels=true 
                          name="heatmap";
		continuouslegend "heatmap"/title="Expression level";
	  endlayout;
	endgraph;
  end;
run;
**** create plot template;
proc template;
  define statgraph heatmap2;
    begingraph / designheight=820 designwidth=500;
	  entrytitle 'Identification of genes with FDR correction';
	  entryfootnote " ";
	   entryfootnote1 "Significant genes (Raw P=0.05): &praw.";
	  entryfootnote1 "Significant genes (FDR=0.05): &pfdr5.";
	  entryfootnote2 "Significant genes (FDR=0.1): &pfdr1.";
	   entryfootnote3 "Significant genes (FDR=0.2): &pfdr2.";
	  rangeattrmap name="rmap";
	    range 0  - < 0.05     /rangecolor=lightgreen rangealtcolor=lightgreen ;
        range 0.05  - < 0.1     /rangecolor=red rangealtcolor=red ;
		 range 0.1  - < 0.15     /rangecolor=black rangealtcolor=black ;
		
	    range 0.15  - max  /rangecolor=lightpurple rangealtcolor= lightpurple ;
		
	  endrangeattrmap;
	  rangeattrvar attrmap="rmap" var=p attrvar=pColor;

	 layout overlay / 

xaxisopts=(Label="Method"  ) 
x2axisopts=(Label=" " griddisplay=on ) yaxisopts=( Label="Gene"  
	  display=( ticks tickvalues line label))  ;
	    heatmapparm y=Gene x=group colorresponse=pColor / 
                          
                          xvalues=leftpoints xendlabels=true 
                          name="heatmap";
			
		continuouslegend "heatmap" / orient=vertical 
 title="P value";
 			
	  endlayout;
	 
	endgraph;
  end;
run;

proc format ; value gp 1-2="Raw P<0.2" 2-3="FDR=0.05" 3-4="FDR=0.1" 4-5="FDR=0.2"; run;

**** print;
ods rtf file=".\cancer_heatmap2_2020.rtf" startpage=no;
ods graphics/reset noborder;
proc sgrender data=cancer_long template=heatmap; where gene<=200; 
dynamic _t="Fig 1a:Heatmap of first 200 gene expression levels for 52 subjects";
run;
title ;
ods graphics /noborder ;
proc sgrender data=cancer_long template=heatmap; where gene<=1000;
dynamic _t="Fig 1b:Heatmap of 1,000 gene expression levels for 52 subjects";
run;
**** heatmap for all 10,000 genes is computationaly intensive, therefore, does not run on windows computer;

proc sgrender data=cancer_px1 template=heatmap2;  ;run;
title ;
Ods rtf close;

