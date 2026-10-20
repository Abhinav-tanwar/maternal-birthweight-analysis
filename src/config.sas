/* Set to the absolute repository directory in SAS Studio or batch SAS. */
%let project_root = .;
options validvarname=v7;
%macro require_input(name);
  %if not %sysfunc(fileexist(&project_root./data/&name.)) %then %do;
    %put ERROR: Required input &project_root./data/&name. is unavailable. See data/README.md.;
    %abort cancel;
  %end;
%mend;
%macro prepare_output;
  %if not %sysfunc(fileexist(&project_root./outputs)) %then %do;
    data _null_; rc=dcreate('outputs',"&project_root."); run;
  %end;
  ods graphics on;
  ods html5 file="&project_root./outputs/analysis.html" options(bitmap_mode='inline');
%mend;
