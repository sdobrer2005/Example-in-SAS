# Equality of Variance Assessment for Independent Sample t-tests in SAS

## Introduction

Independent sample t-tests assume that observations are independent and that the outcome variable is approximately normally distributed within each group. An additional assumption for the pooled t-test is equality of variances between groups. Equality of variance refers to whether the variability of the outcome is similar across comparison groups.

In practice, SAS `PROC TTEST` provides both:
- a pooled variance t-test, which assumes equal variances
- a Satterthwaite (Welch) t-test, which does not assume equal variances

Because the Welch approach is robust to unequal variances, it is commonly recommended when the equality of variance assumption is violated.

---

## Equality of Variance Testing in SAS

By default, SAS `PROC TTEST` uses the Folded F Test (also referred to as the F-test for equality of variances) to evaluate whether group variances are equal. This explains why the output includes `Folded F` under the `Method` column together with the F Value, numerator degrees of freedom (`Num DF`), denominator degrees of freedom (`Den DF`), and associated p-value.

---

## Interpretation

The Folded F Test evaluates the null hypothesis that the variances of the two groups are equal.

- A non-significant p-value (`p ≥ 0.05`) suggests no strong evidence against equal variances, supporting use of the pooled t-test.
- A significant p-value (`p < 0.05`) suggests unequal variances, supporting interpretation of the Satterthwaite (Welch) t-test results, which do not assume equal variances.

Because `PROC TTEST` automatically provides both pooled and Satterthwaite t-test results, the appropriate method can be selected based on the outcome of the Folded F Test.

---

## Practical Considerations

The independent sample t-test is generally robust to moderate deviations from equal variances, particularly when sample sizes are balanced across groups. However, unequal variances combined with unequal group sizes may affect the validity of the pooled t-test.

For this reason, the Satterthwaite (Welch) approach is often preferred in applied analyses because it does not require the assumption of equal variances and provides reliable inference under variance heterogeneity.

---
## Note

Please note that t-test will automatically produce the normal and kernel density plots as well as QQ-plot. You can decide if you would like to run normality test independently using normality procedure or use the output from the T-test plots.

---
## Summary

Equality of variance assessment is an important component of independent sample t-test diagnostics. SAS automatically provides both pooled and Welch t-test results, allowing investigators to select the most appropriate method based on the variance assessment. In many practical applications, the Welch t-test provides a robust alternative when variances differ across groups.

## Source

For more information use SAS documentation document https://support.sas.com/documentation/onlinedoc/stat/132/ttest.pdf
