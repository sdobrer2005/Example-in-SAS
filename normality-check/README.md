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

For EDF tests, the statistic measures the distance between the empirical distribution function of the observed data and the fitted normal cumulative distribution function. The p-value is then based on the sampling distribution of that statistic under normality. That sampling distribution is not always available as a simple exact closed-form calculation, especially when the mean and standard deviation are estimated from the same data.

# What SAS PROC UNIVARIATE does

SAS PROC UNIVARIATE provides several tests for normality, including Shapiro-Wilk, Kolmogorov-Smirnov, Anderson-Darling, and Cramer-von Mises. The Kolmogorov-Smirnov, Anderson-Darling, and Cramer-von Mises tests are empirical distribution function tests. SAS computes EDF statistics by comparing the observed EDF with the hypothesized distribution function.
For normality testing, SAS uses the sample mean and sample variance when comparing the data against a normal distribution. For the Kolmogorov-Smirnov normality test, SAS documentation states that PROC UNIVARIATE uses a modified Kolmogorov D statistic to test the data against a normal distribution with mean and variance equal to the sample mean and variance.
After the EDF statistic is calculated, SAS uses its own internal method to compute the p-value. The important point is that SAS and R can agree on the statistic but still differ in the p-value because the p-value approximation method is software-specific.

# What the R function does
The R functions I decided yo use to match the SAS PROC UNIVARIATE

| Output | R calculation used in the function | Reason |
|---|---|---|
| Shapiro-Wilk | `stats::shapiro.test(x)` | Base R implementation matches the SAS validation example closely for both statistic and p-value. |
| Kolmogorov-Smirnov | `KScorrect::LcKS(x, cdf = "pnorm")` | Used because normal parameters are estimated from the data; a Lilliefors-corrected approach is more appropriate than base `ks.test()`. |
| Cramer-von Mises | `nortest::cvm.test(x)` | Retained because it matched the SAS CvM statistic closely in the validation example. |
| Anderson-Darling | `nortest::ad.test(x)` | Retained because it matched the SAS AD statistic closely in the validation example. |

# Cramer-von Mises calculation in R

In the nortest package, cvm.test() performs the Cramer-von Mises test for the composite hypothesis of normality. The data are ordered and transformed through the fitted normal cumulative distribution function. Conceptually, the transformed probabilities are:
p_i = Phi((x_(i) - mean(x)) / sd(x))
where Phi is the standard normal cumulative distribution function and x_(i) is the i-th ordered observation.
The Cramer-von Mises statistic used by nortest is described as:
W = 1/(12*n) + sum_{i=1}^n [p_i - (2*i - 1)/(2*n)]^2
This statistic measures the squared distance between the fitted normal cumulative distribution and the empirical distribution. The p-value is then obtained using the approximation implemented in nortest. The R documentation describes cvm.test() as an EDF omnibus test for the composite hypothesis of normality and gives the statistic formula.

# Anderson-Darling calculation in R

The Anderson-Darling test is also an EDF test for the composite hypothesis of normality. It is related to the Cramer-von Mises family of tests but gives more weight to the tails of the distribution. This makes it more sensitive to tail departures from normality.
In the R function, Anderson-Darling is calculated using nortest::ad.test(x). The statistic is calculated from the ordered values transformed through the fitted normal cumulative distribution function. The p-value is then obtained using the approximation implemented in nortest.
Because the test statistic and the p-value conversion are separate steps, matching the Anderson-Darling statistic does not guarantee an identical p-value across SAS and R.

# Kolmogorov-Smirnov calculation in R

The usual one-sample Kolmogorov-Smirnov test assumes that the reference distribution is fully specified before looking at the data. That assumption is not true in normality testing when the mean and standard deviation are estimated from the same sample.
For that reason, the R function uses KScorrect::LcKS(), which implements a Lilliefors-corrected Kolmogorov-Smirnov test for cases where population parameters are unknown and estimated by sample statistics. The KScorrect documentation states that p-values are estimated by simulation.
Because SAS and KScorrect use different methods to obtain the p-value, the K-S statistic can match closely while the p-value differs slightly. For normality testing, SAS uses a modified Kolmogorov D statistic and derives the associated p-value from internal probability tables, using linear interpolation between tabulated probability levels, whereas KScorrect::LcKS() estimates the p-value by simulation.
CAMIS recommends dgof::ks.test() as a commonly used R implementation of the Kolmogorov-Smirnov test. However, for a one-sample test with a continuous reference distribution, dgof::ks.test() requires the distribution parameters to be specified in advance and not estimated from the same data. In the CAMIS normality example, ks.test(x, "pnorm") compares the data with the standard normal distribution unless parameters are supplied; if the mean and standard deviation are instead estimated from the sample, the ordinary K-S p-value does not adjust for that estimation. Because SAS PROC UNIVARIATE estimates the normal mean and variance from the sample, KScorrect::LcKS() was retained for this repository as the closer conceptual analogue to the SAS normality test.

# Why goftest was not used

The goftest package was evaluated as an alternative for Cramer-von Mises and Anderson-Darling. However, in the iris validation example, goftest changed the Cramer-von Mises and Anderson-Darling test statistics substantially compared with SAS. Therefore, goftest was not retained.
For this repository, the priority is to reproduce SAS-like PROC UNIVARIATE output. Since nortest matched the SAS EDF test statistics more closely, nortest was kept, even though some p-values may differ slightly.




