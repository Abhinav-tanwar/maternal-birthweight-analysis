/* Maternal Birthweight Analysis */
%require_input(babies.csv);
/* Reconstruction follows the report screenshots, with explicit CSV types.
   weight in the input is pounds; analysis weight is ounces, matching the report. */
data babies;
  infile "&project_root./data/babies.csv" dsd dlm=',' firstobs=2 truncover;
  input bwt :?? best32. gestation :?? best32. parity :?? best32.
        age :?? best32. height :?? best32. weight :?? best32. smoke :?? best32.;
run;
proc contents data=babies; run;
data babies_clean;
  set babies; weight=weight*16;
  label bwt='Infant birth weight (ounces)' gestation='Gestation (days)'
        weight='Maternal weight (ounces)' height='Maternal height (inches)'
        age='Maternal age (years)';
run;
proc format;
  value missfmt .='MISSING' other='NOT MISSING';
run;
proc freq data=babies_clean;
  format _numeric_ missfmt.; tables _all_ / missing nocum;
  title 'Missing data before imputation';
run;
proc means data=babies_clean median; var age height weight gestation; run;
proc freq data=babies_clean; tables smoke / missing; run;
/* Exact fixed imputation values visible in the report, page 17. */
data babies_imputed;
  set babies_clean;
  if missing(age) then age=26;
  if missing(height) then height=64;
  if missing(weight) then weight=2000;
  if missing(gestation) then gestation=280;
  if missing(smoke) then smoke=0;
run;
proc freq data=babies_imputed;
  format _numeric_ missfmt.; tables _all_ / missing nocum;
  title 'Missing data after imputation';
run;
%macro explore(var);
  proc univariate data=babies_imputed normal;
    var &var.; histogram &var. / normal;
    qqplot &var. / normal(mu=est sigma=est);
    title "Distribution of &var.";
  run;
  proc sgplot data=babies_imputed; vbox &var.; run;
%mend;
%explore(bwt); %explore(gestation); %explore(age); %explore(height); %explore(weight);
proc freq data=babies_imputed; tables smoke parity / nocum; run;
proc sgplot data=babies_imputed; vbar smoke; run;
proc sgplot data=babies_imputed; vbar parity; run;
proc corr data=babies_imputed;
  var bwt age height weight gestation;
  title 'Correlation matrix for numerical variables';
run;
proc sgplot data=babies_imputed; vbox bwt / category=smoke; run;
/* Numeric parity labels retained because external dictionaries conflict. */
proc sgplot data=babies_imputed; vbox bwt / category=parity; run;
proc sgplot data=babies_imputed; scatter x=gestation y=bwt; run;
proc sgplot data=babies_imputed; scatter x=weight y=bwt; run;
/* 118 oz is the report's comparison value, not a verified current national average. */
proc ttest data=babies_imputed h0=118 sides=2 alpha=0.05;
  var bwt; title 'One-sample birth-weight comparison against 118 ounces';
run;
proc ttest data=babies_imputed order=internal sides=2 alpha=0.05;
  class smoke; var bwt; title 'Birth weight by smoking status';
run;
proc freq data=babies_imputed;
  tables smoke*parity / chisq expected;
  title 'Smoking status and parity association';
run;
data babies_imputed;
  set babies_imputed;
  if age<20 then age_group=1;
  else if 20<=age and age<=30 then age_group=2;
  else if age>30 then age_group=3;
run;
proc anova data=babies_imputed;
  class age_group; model bwt=age_group;
  means age_group / tukey;
  title 'Birth weight across maternal age groups';
run; quit;
/* Supplemental assumption check; not present in original ANOVA screenshot. */
proc glm data=babies_imputed;
  class age_group; model bwt=age_group;
  means age_group / hovtest=levene;
  output out=age_diagnostics r=residual;
run; quit;
proc univariate data=age_diagnostics normal;
  var residual; qqplot / normal(mu=est sigma=est);
run;
