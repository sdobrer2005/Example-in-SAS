## How to read T-test results for two independent samples
---
## Creating the data sets

Iris data set has three different Species: Setosa, Versicolor, and Virginica
Pairwise conparison (as t-test can only be used for two group comparison) will be done for each possible permutations: Setosa/Versicolor, Setosa/Virginica, and Versicolor/Virginica.

---
## What is created

Firs individual output is created for each of the variables in the Iris data set: SepalLength, SepalWidth, PetalLength, PetalWidth.
This is created by Macro Ttest
At the next stage all data sets are combined in final dataset in Macro Sets

The main program created 3 independent data set from IRIS data set, and Ttest macro run for all 3 variables and pair of Species. The data sets created by main program are: SetosaVersicolor, SetosaVirginica, SetosaVersicolor. The t-test macro runs for all 4 variables from the Iris file and created 4 independent data sets: final_SepalLength, final_SepalWidth, final_PetalLength, final_PetalWidth. 

After that three final combined output files are created: final_SetosaVersicolor, final_SetosaVirginica, final_SetosaVersicolor

---
## Final Output Dataset

The final dataset includes:

- Mean estimates and confidence intervals (I decided to keep those in independent variables, however, output data can be change to Mean (Lower95%CI,Upper95%CI) using simple data manipulation. You can use it as an 
  exersice to learn how to modify data set for what you need for final output for abstract/paper and etc.
- Selected t-test results based on the variance comparison test:
  - Pooled t-test when equal variances are assumed
  - Satterthwaite (Welch) t-test when equal variances are not assumed
- T-value for mean comparison (`tValue`)
- Probability value for mean comparison (`Probt`)
- F statistic for equality of variances (`FValue`)
- Probability value for equality of variances (`ProbF`)

## Plots

PROC TTEST in SAS automaticly inlcude plots for assumption checks. You can review them if needed. Those are not exported directly from the program, but usually are created as phg files and saved in the directory openned on your computer or in tmp directory (SAS 9.4 Base). The plots are saved in additional document with some notes on what those are and how to understand those.

## Notes:
The actual T-test output is not exported. As an excersize you can export actual t-test output to word and compare the results of this and final output prodiced

The macro automatically evaluates equality of variances using the variance comparison test and retains only the appropriate t-test results for interpretation.

Variables related to standard deviation confidence intervals are removed from the combined final dataset to simplify the output.

