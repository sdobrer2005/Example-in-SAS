# SAS versus R Validation: Normality Checks results summary from the IRIS data analysis
  To match SAS PROC UNIVARIATE 

## Purpose

This document compares normality-check results produced by SAS `PROC UNIVARIATE` with the corresponding R implementation using the iris validation dataset.

The purpose of the comparison is to determine how closely the R implementation reproduces SAS results and, more importantly, whether any numerical differences affect the inferential conclusion at `alpha = 0.05`.

The comparison includes descriptive statistics and four normality tests:

- Shapiro-Wilk
- Kolmogorov-Smirnov
- Cramer-von Mises
- Anderson-Darling

Exact numerical agreement is desirable when SAS and R use the same calculation. However, small differences in p-values are not considered meaningful when the test statistic is reproduced and both programs lead to the same reject/do-not-reject decision.

## SAS reference implementation

The R function was developed and validated against the following
SAS `PROC UNIVARIATE` analysis. 

**Note:** `PROC MEANS` is used in the macro to create a compact descriptive statistics dataset for the clean summary table. `PROC UNIVARIATE` already calculates the same descriptive measures, but they are spread across multiple ODS output tables. Thus, `PROC MEANS` is used for convenience and output formatting, not because different statistical calculations are required.

```sas
proc sort data=iris out=iris_sorted;
    by Species;
run;

proc univariate data=iris_sorted normal;
    by Species;
    var SepalLength SepalWidth PetalLength PetalWidth;

    ods select
        Moments
        BasicMeasures
        TestsForNormality
        Quantiles
        ExtremeObs;
run;
```
## R packages and options used

| Output | R package / function | Options used | Different from default? | Reason |
|---|---|---|---|---|
| N | Base R | `length(x)` / non-missing count | No special option | Direct calculation from the data |
| Mean | Base R | `mean(x)` | No special option | Direct calculation from the data |
| Standard deviation | Base R `stats::sd()` | `sd(x)` | No | Standard sample SD |
| Variance | Base R `stats::var()` | `var(x)` | No | Standard sample variance |
| Median | Base R `stats::median()` | `median(x)` | No | Default calculation |
| Minimum / maximum | Base R | `min(x)`, `max(x)` | No | Direct calculation |
| Range | Base R | `max(x) - min(x)` | No | Direct calculation |
| Q1, Q3, IQR and other quantiles | Base R `stats::quantile()` / `stats::IQR()` | `type = 5` | **Yes** — R default is `type = 7` | `type = 5` was selected to reproduce the SAS quantile definition used in the validation output |
| Skewness | `e1071::skewness()` | `type = 2` | **Yes** — `e1071` default is `type = 3` | Type 2 corresponds to the SAS-style adjusted skewness calculation |
| Kurtosis | `e1071::kurtosis()` | `type = 2` | **Yes** — `e1071` default is `type = 3` | Type 2 was selected to reproduce SAS PROC UNIVARIATE results |
| Shapiro-Wilk | Base R `stats::shapiro.test()` | No additional options | No | Default R implementation reproduced the SAS statistic and p-value closely |
| Kolmogorov-Smirnov | `KScorrect::LcKS()` | `cdf = "pnorm"`; `nreps = 50000`; `set.seed(12345)` | **Yes** — `nreps` default is 4999 | Lilliefors correction is required because the normal mean and SD are estimated from the sample; 50,000 simulations were used to stabilize the Monte Carlo p-value |
| Cramer-von Mises | `nortest::cvm.test()` | No additional options | No | Default implementation reproduced the SAS test statistic closely |
| Anderson-Darling | `nortest::ad.test()` | No additional options | No | Default implementation reproduced the SAS test statistic closely |

## Overall agreement

| Component | SAS versus R agreement |
|---|---|
| Descriptive statistics | Match at the displayed precision |
| Quantiles | Match when R uses `quantile(type = 5)` |
| Shapiro-Wilk statistic | Match |
| Shapiro-Wilk p-value | Match at the reported precision, except for display of very small p-values |
| Kolmogorov-Smirnov statistic | Match |
| Kolmogorov-Smirnov p-value | May differ slightly because the p-value calculation is implemented differently |
| Cramer-von Mises statistic | Match |
| Cramer-von Mises p-value | May differ slightly |
| Anderson-Darling statistic | Match |
| Anderson-Darling p-value | May differ slightly |
| Inferential decision at `alpha = 0.05` | Same for every comparison in this validation dataset |

## Detailed comparison of normality tests

The tables below compare the SAS and R results for each variable and species.

The test statistics were reproduced in R. Differences were observed mainly in some p-values for the Kolmogorov-Smirnov, Cramer-von Mises, and Anderson-Darling tests.

SAS sometimes reports p-values as bounds, such as `>0.1500`, `>0.2500`, `<0.0100`, or `<0.0050`. These should be retained as bounds rather than interpreted as exact p-values.

### SepalLength

| Species | Test | Test statistic | SAS p-value | R p-value | SAS decision | R decision |
|---|---|---:|---:|---:|---|---|
| Setosa | Shapiro-Wilk | 0.977699 | 0.4595 | 0.4595 | Do not reject | Do not reject |
| Setosa | Kolmogorov-Smirnov | 0.114860 | 0.0962 | 0.0954 | Do not reject | Do not reject |
| Setosa | Cramer-von Mises | 0.071753 | `>0.2500` | 0.2597 | Do not reject | Do not reject |
| Setosa | Anderson-Darling | 0.407986 | `>0.2500` | 0.3352 | Do not reject | Do not reject |
| Versicolor | Shapiro-Wilk | 0.977836 | 0.4647 | 0.4647 | Do not reject | Do not reject |
| Versicolor | Kolmogorov-Smirnov | 0.096241 | `>0.1500` | 0.2823 | Do not reject | Do not reject |
| Versicolor | Cramer-von Mises | 0.057273 | `>0.2500` | 0.4039 | Do not reject | Do not reject |
| Versicolor | Anderson-Darling | 0.360841 | `>0.2500` | 0.4333 | Do not reject | Do not reject |
| Virginica | Shapiro-Wilk | 0.971179 | 0.2583 | 0.2583 | Do not reject | Do not reject |
| Virginica | Kolmogorov-Smirnov | 0.115034 | 0.0953 | 0.0943 | Do not reject | Do not reject |
| Virginica | Cramer-von Mises | 0.089467 | 0.1538 | 0.1522 | Do not reject | Do not reject |
| Virginica | Anderson-Darling | 0.551641 | 0.1506 | 0.1475 | Do not reject | Do not reject |

### SepalWidth

| Species | Test | Test statistic | SAS p-value | R p-value | SAS decision | R decision |
|---|---|---:|---:|---:|---|---|
| Setosa | Shapiro-Wilk | 0.971720 | 0.2715 | 0.2715 | Do not reject | Do not reject |
| Setosa | Kolmogorov-Smirnov | 0.104678 | `>0.1500` | 0.1789 | Do not reject | Do not reject |
| Setosa | Cramer-von Mises | 0.075410 | 0.2373 | 0.2324 | Do not reject | Do not reject |
| Setosa | Anderson-Darling | 0.490956 | 0.2184 | 0.2102 | Do not reject | Do not reject |
| Versicolor | Shapiro-Wilk | 0.974133 | 0.3380 | 0.3380 | Do not reject | Do not reject |
| Versicolor | Kolmogorov-Smirnov | 0.120665 | 0.0687 | 0.0635 | Do not reject | Do not reject |
| Versicolor | Cramer-von Mises | 0.103321 | 0.0992 | 0.0980 | Do not reject | Do not reject |
| Versicolor | Anderson-Darling | 0.559755 | 0.1445 | 0.1406 | Do not reject | Do not reject |
| Virginica | Shapiro-Wilk | 0.967391 | 0.1809 | 0.1809 | Do not reject | Do not reject |
| Virginica | Kolmogorov-Smirnov | 0.127872 | 0.0403 | 0.0382 | Reject | Reject |
| Virginica | Cramer-von Mises | 0.107797 | 0.0889 | 0.0850 | Do not reject | Do not reject |
| Virginica | Anderson-Darling | 0.618205 | 0.1021 | 0.1018 | Do not reject | Do not reject |

### PetalLength

| Species | Test | Test statistic | SAS p-value | R p-value | SAS decision | R decision |
|---|---|---:|---:|---:|---|---|
| Setosa | Shapiro-Wilk | 0.954977 | 0.0548 | 0.0548 | Do not reject | Do not reject |
| Setosa | Kolmogorov-Smirnov | 0.153398 | `<0.0100` | 0.0050 | Reject | Reject |
| Setosa | Cramer-von Mises | 0.189745 | 0.0070 | 0.0069 | Reject | Reject |
| Setosa | Anderson-Darling | 1.007324 | 0.0111 | 0.0108 | Reject | Reject |
| Versicolor | Shapiro-Wilk | 0.966004 | 0.1585 | 0.1585 | Do not reject | Do not reject |
| Versicolor | Kolmogorov-Smirnov | 0.117121 | 0.0855 | 0.0815 | Do not reject | Do not reject |
| Versicolor | Cramer-von Mises | 0.090004 | 0.1506 | 0.1498 | Do not reject | Do not reject |
| Versicolor | Anderson-Darling | 0.555056 | 0.1479 | 0.1446 | Do not reject | Do not reject |
| Virginica | Shapiro-Wilk | 0.962186 | 0.1098 | 0.1098 | Do not reject | Do not reject |
| Virginica | Kolmogorov-Smirnov | 0.113606 | 0.1036 | 0.1034 | Do not reject | Do not reject |
| Virginica | Cramer-von Mises | 0.086306 | 0.1725 | 0.1674 | Do not reject | Do not reject |
| Virginica | Anderson-Darling | 0.608956 | 0.1088 | 0.1074 | Do not reject | Do not reject |

### PetalWidth

| Species | Test | Test statistic | SAS p-value | R p-value | SAS decision | R decision |
|---|---|---:|---:|---:|---|---|
| Setosa | Shapiro-Wilk | 0.799764 | `<0.0001` | 0.0000 | Reject | Reject |
| Setosa | Kolmogorov-Smirnov | 0.348760 | `<0.0100` | 0.0000 | Reject | Reject |
| Setosa | Cramer-von Mises | 0.976886 | `<0.0050` | 0.0000 | Reject | Reject |
| Setosa | Anderson-Darling | 4.714831 | `<0.0050` | 0.0000 | Reject | Reject |
| Versicolor | Shapiro-Wilk | 0.947626 | 0.0273 | 0.0273 | Reject | Reject |
| Versicolor | Kolmogorov-Smirnov | 0.147699 | `<0.0100` | 0.0082 | Reject | Reject |
| Versicolor | Cramer-von Mises | 0.152210 | 0.0221 | 0.0213 | Reject | Reject |
| Versicolor | Anderson-Darling | 0.956851 | 0.0158 | 0.0144 | Reject | Reject |
| Virginica | Shapiro-Wilk | 0.959771 | 0.0870 | 0.0870 | Do not reject | Do not reject |
| Virginica | Kolmogorov-Smirnov | 0.120771 | 0.0682 | 0.0632 | Do not reject | Do not reject |
| Virginica | Cramer-von Mises | 0.117881 | 0.0658 | 0.0618 | Do not reject | Do not reject |
| Virginica | Anderson-Darling | 0.738786 | 0.0506 | 0.0508 | Do not reject | Do not reject |

## Interpretation

The R implementation reproduced the SAS normality-test statistics across all variable and species combinations examined.

Shapiro-Wilk p-values also matched SAS at the reported precision. Small numerical differences were observed for some Kolmogorov-Smirnov, Cramer-von Mises, and Anderson-Darling p-values.

These differences are consistent with software-specific methods used to convert the test statistic into a p-value. Different implementations may use different approximations, finite-sample corrections, probability tables, interpolation procedures, or simulation-based methods.

Importantly, the numerical differences in p-values did not change the inferential conclusion in any of the validation examples.

At `alpha = 0.05`, SAS and R produced the same reject/do-not-reject decision for every normality test examined.

For validation purposes, this inferential agreement is considered more important than exact equality of software-specific p-values.

## Examples

For SepalWidth in the Virginica group, the Kolmogorov-Smirnov p-value was `0.0403` in SAS and `0.0382` in R. Although the numerical values differ slightly, both are below 0.05 and therefore both reject the null hypothesis of normality.

For PetalWidth in the Virginica group, the Anderson-Darling p-value was `0.0506` in SAS and `0.0508` in R. Both values are above 0.05 and therefore both lead to the conclusion that normality is not rejected.

These examples illustrate why exact equality of p-values is not required when the same statistical interpretation is obtained.

## Reporting note

Very small p-values should not be displayed as `0.0000`, because a p-value is not literally zero.

Where appropriate, the R output should use a reporting threshold such as `<0.0001`.

Similarly, SAS values such as `>0.1500`, `>0.2500`, `<0.0100`, and `<0.0050` are reporting bounds and should be preserved as bounds rather than interpreted as exact p-values.

## Conclusion

For the iris validation dataset, the R implementation provides the same inferential conclusions as SAS `PROC UNIVARIATE` for all normality tests examined.

Descriptive statistics, quantiles, and normality-test statistics are reproduced closely. Shapiro-Wilk p-values match at the reported precision, while small differences remain for some Kolmogorov-Smirnov, Cramer-von Mises, and Anderson-Darling p-values.

These remaining differences are implementation-dependent and do not alter the statistical decision at `alpha = 0.05`.

The selected R functions can therefore be used for SAS-comparable normality assessment, with the documented caveat that some EDF-test p-values may not be numerically identical to SAS.
