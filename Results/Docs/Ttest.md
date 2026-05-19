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

---
## Final Output Dataset

The macro creates one final dataset for each analyzed variable (`final_variable_name`) and then combines all individual datasets into one master dataset (`final_&dat`).

The final dataset includes:

- Mean estimates and confidence intervals from PROC TTEST
- Selected t-test results based on the variance comparison test:
  - pooled t-test when equal variances are assumed
  - Satterthwaite (Welch) t-test when equal variances are not assumed
- T-value for mean comparison (`tValue`)
- Probability value for mean comparison (`Probt`)
- F statistic for equality of variances (`FValue`)
- Probability value for equality of variances (`ProbF`)

The macro automatically evaluates equality of variances using the variance comparison test and retains only the appropriate t-test results for interpretation.

Variables related to standard deviation confidence intervals are removed from the combined final dataset to simplify the output.

