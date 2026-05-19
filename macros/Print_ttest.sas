
**************************************************************************************;
*                                                                                     ;
* 1. Printing final output to word document for final t-test results                  ;
**************************************************************************************;


%macro print_ttest(start, stop1,stop2);

%do i=&start %to &stop1;

    %let yvar = %scan(&list., &i.);

    *note Start each variable on a new page;
    ods word startpage=now;

    title "Independent Sample T-Test for &yvar.";

    proc print data=final_&yvar. label noobs;
    run;


%end;

%mend print_ttest;

