**************************************************************************************;
* T-Test for independent samples                                                      ;
* 1. Check the equality of variance assumption                                        ;
* 2. Based on variance decided on what output to pull                                 ;
**************************************************************************************;

**************************************************************************************;
*Macro to run independent sample t-tests for multiple variables
#The macro loops through variables listed in &norm
#For each variable:
#1. Runs PROC TTEST
#2. Saves variance test and t-test results
#3. Automatically selects Ppooled or Satterthwaite results based on equality of variance test (ProbF)
#4. Creates one final dataset per variable          
**************************************************************************************;



%macro ttests(start, stop, var);
*note Loop through selected variables from the list;
%do i=&start %to &stop;
*note Extract variable name from the macro list &norm;
    %let yvar = %scan(&norm., &i.);
*save PROC TTEST output tables;
    ods output
        ConfLimits = cl_&yvar.
        Equality   = equality_&yvar.
        TTests     = ttest_&yvar.;

    proc ttest data=&dat;
        class &var;
        var &yvar.;
    run;

*keep p-value for variance test;
	data _null_;
	set equality_&yvar.;
	CALL SYMPUTX('pVAR',ProbF) ;
	run;
	%put p=&pVAR;
 *choose what data to save in the final data set based on variance test p-value;
 *keep what needed for the final data;
	data cl_&yvar.;
	set cl_&yvar.;
	if &pVAR<0.05 and Variances="Unequal" then delete;
	else if &pVAR>=0.05 and Variances="Equal" then delete;
	n=_n_;
	run;
	data ttest_&yvar.;
	set ttest_&yvar.;
	if &pVAR<0.05 and Variances="Unequal" then delete;
	else if &pVAR>=0.05 and Variances="Equal" then delete;
	n=1;
	keep n tValue Probt;
	run;
	data equality_&yvar.;
	set equality_&yvar.;
	n=1;
	keep Variable FValue ProbF n;
	run;
    *combines all in final data set; 
	data final_&yvar.;
	merge cl_&yvar. ttest_&yvar. equality_&yvar.;
	by n;
	label Probt="Probability for mean comparison (Probt)"
	tValue="T-value for mean comparison (tValue)"
	FValue="F value for variance comparison"
	ProbF="Probability for variance comparison";

	drop n;
	run;
%end;   
%mend ttests;
