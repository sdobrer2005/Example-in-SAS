# SAS and R Validation Branch

This branch was created to document the ongoing comparison of statistical results produced in SAS and R.
The purpose is not simply to reproduce SAS output numerically. The broader goal is to determine which R packages, functions, and settings most closely reproduce the statistical methods used in SAS
The goal is to identify where differences occur, and to document whether those differences affect interpretation or statistical conclusions.

As additional methods are evaluated, this branch will provide a structured record of the validation process and support decisions about which R implementation is most appropriate to use.

## What will be included

For each statistical method or SAS procedure, the comparison may include:

- the SAS procedure and options used;
- the corresponding R package and function;
- the dataset used for validation;
- descriptive statistics and parameter estimates;
- test statistics;
- p-values;
- confidence intervals, where applicable;
- model fit statistics and other relevant output;
- comparison of SAS and R results;
- identification of any numerical differences;
- explanation of differences caused by software implementation, defaults, approximations, or calculation methods;
- comparison of inferential decisions, such as rejection or non-rejection of the null hypothesis at a specified alpha level;
- alternative R packages or functions considered;
- recommended R implementation based on the validation results.

## Approach to validation

Exact numerical agreement is desirable when SAS and R implement the same calculation. However, exact agreement is not always expected.

Some statistical procedures use software-specific approximations, numerical algorithms, probability tables, interpolation methods, simulations, or default settings. In these situations, two implementations may produce the same or nearly identical test statistic while producing slightly different p-values or other derived quantities.

For this reason, validation will consider both:

1. **Numerical agreement** between SAS and R; and
2. **Inferential agreement**, including whether the two implementations lead to the same statistical conclusion.

Small numerical differences will therefore be documented rather than automatically treated as errors when they arise from known implementation differences and do not materially change interpretation.

Each procedure validated will have a detailed document on the differences, decisions made, and any additional relevant information

Over time, the branch is intended to develop into a practical SAS-to-R validation resource that documents not only which R functions can be used, but also which implementations provide the closest and most appropriate correspondence to commonly used SAS procedures.

## Future development

Every time new procedure, model, package is validated additional detailed documentation will be added for review
Comments and suggestions from previous experience working on the SAS/R validation are welcome


