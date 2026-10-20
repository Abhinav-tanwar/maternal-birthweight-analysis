/* Run with the repository as the current directory, or use absolute paths below. */
%include "src/config.sas";
%prepare_output;
%include "&project_root./src/analysis.sas";
ods html5 close;
title; footnote;
