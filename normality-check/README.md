## Distributions and Normality checks 
(used in two independent samples t-test as assumption checks)

# Technical note for the WHRI SAS-like PROC UNIVARIATE output function in R

This document explains why some normality test p-values from the R implementation may not be numerically identical to SAS PROC UNIVARIATE, even when the descriptive statistics and the normality test statistics match closely. The focus is on the calculation step before any display cutoffs or reporting limits are applied. In other words, this note explains why two programs can calculate the same or nearly the same empirical distribution function (EDF) statistic but still produce a different p-value.

# Main conclusion

•	The descriptive statistics, quantiles, skewness, kurtosis, and several normality test statistics can be reproduced closely in R.
•	The main remaining differences are p-values for Kolmogorov-Smirnov, Cramer-von Mises, and Anderson-Darling tests.
•	These differences occur at the step where the statistic is converted into a p-value using a reference distribution, approximation formula, table, simulation, or interpolation method.
•	The R function keeps nortest::cvm.test() and nortest::ad.test() because those matched the SAS CvM and AD test statistics more closely than goftest in the iris validation example.
•	The p-value differences are software implementation differences, not data errors.

# Test statistic versus p-value

A normality test has two separate steps. First, the software calculates a test statistic from the data. Second, the software converts that statistic into a p-value under the null hypothesis that the data are normally distributed. The first step and second step are not the same calculation.

| Step | What is calculated | Why SAS and R may differ |
|---|---|---|
| 1 | Test statistic | Usually reproducible if the same formula and same fitted normal distribution are used. |
| 2 | P-value | Can differ if software uses different approximations, finite-sample corrections, tables, simulations, or interpolation rules. |
