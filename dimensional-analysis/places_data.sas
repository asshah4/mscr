options ls=78;
title "PCA - Covariance Matrix - Places Rated";
data places;
*** choose correct path as below for  places.txt file;
  *infile "H:\MSCR509\spring2017\lecture9_PC2\places.txt";
  infile ".\places.txt";
  
  input climate housing health crime trans educate arts recreate econ id;
  climate=log10(climate);
  housing=log10(housing);
  health=log10(health);
  crime=log10(crime);
  trans=log10(trans);
  educate=log10(educate);
  arts=log10(arts);
  recreate=log10(recreate);
  econ=log10(econ);
  run;
  
