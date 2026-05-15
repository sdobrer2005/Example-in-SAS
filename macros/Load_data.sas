**************************************************************************************;
* GENRAL MACROS USED IN THIS PROGRAM                                                  ;
* 1. Load the data set from GitHub                                                    ;
* 2. Macro for normality check for all initial varaibles in the data                  ;
**************************************************************************************;

**************************************************************************************;
* Load IRIS data set from GitHub. If unavailable, fall back to SASHELP.IRIS.          ;
**************************************************************************************;

%macro load_iris(outds=work.iris);

  %if %length(&GITHUB_IRIS_URL) > 0 %then %do;

    %put NOTE: Attempting to load IRIS from GitHub: &GITHUB_IRIS_URL;

    filename irisurl url "&GITHUB_IRIS_URL";

    proc import datafile=irisurl
        out=&outds
        dbms=csv
        replace;
      guessingrows=max;
      getnames=yes;
    run;

    filename irisurl clear;

    %if not %sysfunc(exist(&outds)) %then %do;
      %put NOTE: GitHub import failed or file missing. Falling back to SASHELP.IRIS.;
      data &outds;
        set sashelp.iris;
      run;
    %end;

  %end;
  %else %do;
    %put NOTE: No GitHub URL provided. Using SASHELP.IRIS.;
    data &outds;
      set sashelp.iris;
    run;
  %end;

%mend load_iris;
