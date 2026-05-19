**************************************************************************************;
* T-Test for independent samples                                                      ;
* 1. Macro used to combine all data set in one final output for print/save            ;
**************************************************************************************;

*combine all final datasets into one master dataset;

%macro sets (start, stop);
data final_&dat;
set 
%do i=&start %to &stop;
final_%scan(&norm., &i.)
%end;
;
drop StdDev LowerCLStdDev UpperCLStdDev UMPULowerCLStdDev UMPUUpperCLStdDev;
run;
%mend sets;
