**************************************************************************************;
* WHRI GitHub                                                                         ;
* Prepared: Sabina Dobrer, Senior Statistician, P.Stat                                ;
* Date: May 20, 2026                                                                  ;
* Program: This program uses publicly available data set IRIS to perform              ;
*          assumption checking for two independent samples using normality macros     ;
*                                                                                     ;
* This program creates THREE separate Word documents:                                 ;
* 1. Raw SAS output report                                                            ;
* 2. Clean summary report                                                             ;
* 3. Figures report                                                                   ;
*                                                                                     ;
* Workflow:                                                                           ;
* 1. Load IRIS data from GitHub (fallback to SASHELP.IRIS if needed)                  ;
* 2. Download required macros from GitHub                                             ;
* 3. Save macros locally in the drive folder                                          ;
* 4. Verify both macros downloaded successfully                                       ;
* 5. Include saved local macro files                                                  ;
* 6. Run macros and export output documents                                           ;
**************************************************************************************;

**************************************************************************************;
* SAS options                                                                         ;
**************************************************************************************;

options ps=256 ls=256 nocenter nofmterr
        mprint mlogic symbolgen
        sortanom=tv sortsize=max msglevel=i;


**************************************************************************************;
* Folder locations                                                                    ;
**************************************************************************************;

*Specify folder/directory for the project;
%let base_dir   = C:\Documents\GITHub;

*Specify folder for where Macros will be saved;
%let macro_dir  = &base_dir.\Macros;

*Specify folder for where the results will be saved;
%let result_dir = &base_dir.\Results;

**************************************************************************************;
* Output files                                                                        ;
**************************************************************************************;
*Create documents for the results for normality assumption checks;
%let outdoc_raw   = &result_dir.\normality_raw_report.docx;
%let outdoc_clean = &result_dir.\normality_summary_report.docx;
%let outdoc_fig   = &result_dir.\normality_figures_report.docx;

**************************************************************************************;
* GitHub source files                                                                 ;
**************************************************************************************;
*This part create all the source files you would need to run the program;
*No need to change!;
%let GITHUB_IRIS_URL = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/iris.csv;

%let GH_URL_TABLE = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/normal_by_group.sas;
%let GH_URL_FIG   = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/figures_by_group.sas;
%let GH_URL_DATA  = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/Load_data.sas;
%let GH_URL_RUN   = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/To_run.sas;
%let GH_URL_TTEST   = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/Ttest.sas;
%let GH_URL_SETS   = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/Sets.sas;
%let GH_URL_TPRINT   = https://raw.githubusercontent.com/sdobrer2005/WHRI-Statistical-Methods-Repository/T-test-for-two-independent-samples-SAS/macros/Print_ttest.sas;

**************************************************************************************;
* Local saved macro files                                                             ;
**************************************************************************************;
*Specify where the macros will be saved;
*No need to change!;

%let GH_SAVE_TABLE = &macro_dir.\normal_by_group.sas;
%let GH_SAVE_FIG   = &macro_dir.\figures_by_group.sas;
%let GH_SAVE_data  = &macro_dir.\Load_data.sas;
%let GH_SAVE_run   = &macro_dir.\To_run.sas;
%let GH_SAVE_TTEST = &macro_dir.\Ttest.sas;
%let GH_SAVE_SETS  = &macro_dir.\Sets.sas;
%let GH_SAVE_Print  = &macro_dir.\Print_ttest.sas;


**************************************************************************************;
* Download TABLE macro from GitHub, save locally, verify, then include                ;
**************************************************************************************;
*This part of the program will save all the macros locally and validate;
*No need to change!;
filename mactable "&GH_SAVE_TABLE";

proc http
  url="&GH_URL_TABLE"
  method="GET"
  out=mactable;
run;

%put NOTE: TABLE macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: TABLE macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Table macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_TABLE)) %then %do;
  %put ERROR: Table macro file was not saved: &GH_SAVE_TABLE;
  %abort cancel;
%end;

%include mactable;
filename mactable clear;
*******************************************************************************************************************;
filename macfig "&GH_SAVE_FIG";

proc http
  url="&GH_URL_FIG"
  method="GET"
  out=macfig;
run;

%put NOTE: FIGURES macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: FIGURES macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Figures macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_FIG)) %then %do;
  %put ERROR: Figures macro file was not saved: &GH_SAVE_FIG;
  %abort cancel;
%end;

%include macfig;
filename macfig clear;

*******************************************************************************************************************;
filename macdata "&GH_SAVE_DATA";

proc http
  url="&GH_URL_DATA"
  method="GET"
  out=macdata;
run;

%put NOTE: DATA macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: DATA macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Data macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_DATA)) %then %do;
  %put ERROR: Data macro file was not saved: &GH_SAVE_DATA;
  %abort cancel;
%end;

%include macdata;
filename macdata clear;

*******************************************************************************************************************;

filename macrun "&GH_SAVE_RUN";

proc http
  url="&GH_URL_RUN"
  method="GET"
  out=macrun;
run;

%put NOTE: RUN macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: RUN macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Run macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_RUN)) %then %do;
  %put ERROR: Run macro file was not saved: &GH_SAVE_RUN;
  %abort cancel;
%end;

%include macrun;
filename macrun clear;

*******************************************************************************************************************;
filename mactest "&GH_SAVE_TTEST";

proc http
  url="&GH_URL_TTEST"
  method="GET"
  out=mactest;
run;

%put NOTE: RUN macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: RUN macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Run macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_RUN)) %then %do;
  %put ERROR: Run macro file was not saved: &GH_SAVE_RUN;
  %abort cancel;
%end;

%include mactest;
filename mactest clear;

*******************************************************************************************************************;
filename macset "&GH_SAVE_SETS";

proc http
  url="&GH_URL_SETS"
  method="GET"
  out=macset;
run;

%put NOTE: RUN macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: RUN macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Run macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_RUN)) %then %do;
  %put ERROR: Run macro file was not saved: &GH_SAVE_RUN;
  %abort cancel;
%end;

%include macset;
filename macset clear;

*******************************************************************************************************************;
filename macprint "&GH_SAVE_Print";

proc http
  url="&GH_URL_TPRINT"
  method="GET"
  out= macprint;
run;

%put NOTE: RUN macro HTTP status code   = &SYS_PROCHTTP_STATUS_CODE;
%put NOTE: RUN macro HTTP status phrase = &SYS_PROCHTTP_STATUS_PHRASE;

%if &SYS_PROCHTTP_STATUS_CODE ne 200 %then %do;
  %put ERROR: Run macro download failed. HTTP status=&SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE;
  %abort cancel;
%end;

%if not %sysfunc(fileexist(&GH_SAVE_RUN)) %then %do;
  %put ERROR: Run macro file was not saved: &GH_SAVE_RUN;
  %abort cancel;
%end;

%include  macprint;
filename  macprint clear;

**************************************************************************************;
* Load IRIS into WORK                                                                 ;
**************************************************************************************;
*Uses macro to load IRIS data tp the work directory;
*You can save data set also in different library by creating it and re-saving work data set;
%load_iris(outds=work.iris);

**************************************************************************************;
* Review group counts                                                                 ;
**************************************************************************************;
*I wanted to check that the data loaded correctly by running the frequency.;
*Frequncy are specified below in the comment section;
proc freq data=work.iris;
  tables Species;
run;

/*
                        Iris Species

                                       Cumulative    Cumulative
Species       Frequency     Percent     Frequency      Percent
Setosa              50       33.33            50        33.33
Versicolor          50       33.33           100        66.67
Virginica           50       33.33           150       100.00
*/

**************************************************************************************;
* Variables and grouping                                                              ;
**************************************************************************************;
*Creating list of variabls, group varialbe for Species, and calculating number of variables 
in &norm into variable l;
%let norm  = SepalLength SepalWidth PetalLength PetalWidth;
%let group = Species;
%let l     = %sysfunc(countw(&norm,%str( )));
*Running macro for Normality assumption checks that exports outputs to specified directory;
%to_run;

**************************************************************************************;
* T-test for 3 datasets with different permutations                                   ;
**************************************************************************************;

*creating  3 different datasets for use in the ttest;

data SetosaVersicolor;
set Iris;
where &group in ("Setosa" "Versicolor");
run;

data SetosaVirginica;
set Iris;
where &group in ("Setosa" "Virginica");
run;
data VersicolorVirginica;
set Iris;
where &group in ("Versicolor" "Virginica");
run;

*Running Ttest for each of the data sets;
*Combining 4 output data sets in one;
%let dat=SetosaVersicolor;
%ttests(1,&l,&group);
%sets(1,&l);


%let dat=SetosaVirginica;
%ttests(1,&l,&group);
%sets(1,&l);

%let dat=VersicolorVirginica;
%ttests(1,&l,&group);
%sets(1,&l);

*Printing all datasets in one document;
%let outdoc_ttest= &result_dir.\ttest.docx;
*creatong list of data sets;
%let list=SetosaVersicolor SetosaVirginica VersicolorVirginica;
*calculating numer of data sets in the list into variable ll;
%let ll     = %sysfunc(countw(&list,%str( )));
*I want it to be in the landscape format. Do not forget to reset it to portrait at the end by closing the option;
options orientation=landscape;
ods word file="&outdoc_ttest"  options(orientation='landscape');
	%print_ttest(1, &ll);
ods word close;
options orientation=portrait;
