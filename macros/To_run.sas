**************************************************************************************;
* GENRAL MACROS USED IN THIS PROGRAM                                                  ;
* 1. Load the data set from GitHub                                                    ;
* 2. Macro for normality check for all initial varaibles in the data                  ;
**************************************************************************************;


**************************************************************************************;
* Wrapper macro to run normality checks for each variable - uses macros downloaded    ;
**************************************************************************************;

%macro to_run;

  %local i var;

  /************************************************************************************/
  * Create RAW SAS output document                                                    ;
  /************************************************************************************/
  ods word file="&outdoc_raw";

  %do i=1 %to &l;
    %let var=%scan(&norm,&i,%str( ));

    %put NOTE: Running RAW normality output for variable=&var group=&group;

    %normal_by_group(
      data=work.iris,
      var=&var,
      group=&group,
      alpha=0.05,
      mode=RAW
    );

    ods word startpage=now;
  %end;

  ods word close;

  /************************************************************************************/
  * Create CLEAN summary document                                                     ;
  /************************************************************************************/
  ods word file="&outdoc_clean";

  %do i=1 %to &l;
    %let var=%scan(&norm,&i,%str( ));

    %put NOTE: Running CLEAN normality output for variable=&var group=&group;

    %normal_by_group(
      data=work.iris,
      var=&var,
      group=&group,
      alpha=0.05,
      mode=CLEAN
    );

    ods word startpage=now;
  %end;

  ods word close;

  /************************************************************************************/
  * Create FIGURES document                                                           ;
  /************************************************************************************/
  ods word file="&outdoc_fig";

  %do i=1 %to &l;
    %let var=%scan(&norm,&i,%str( ));

    %put NOTE: Running FIGURES output for variable=&var group=&group;

    %figures_by_group(
      data=work.iris,
      var=&var,
      group=&group
    );

    ods word startpage=now;
  %end;

  ods word close;

%mend to_run;
