# SAS and R Validation Branch

This branch was created to document the ongoing comparison of statistical results produced in SAS and R.

The purpose is not simply to reproduce SAS output numerically. The broader goal is to determine which R packages, functions, and settings most closely reproduce the statistical methods used in SAS, to identify where differences occur, and to document whether those differences affect interpretation or statistical conclusions.

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

## Validation principles

Exact numerical agreement is desirable when the underlying calculation is implemented in the same way in both SAS and R. However, exact equality is not always expected. In some situations, SAS and R may use different numerical algorithms, default settings, approximations, interpolation rules, internal probability tables, or simulation-based methods. These differences can result in slightly different p-values or other derived quantities even when the underlying test statistic is the same.

For this reason, validation in this branch will consider both:

1. **Numerical agreement** between SAS and R results  
2. **Inferential agreement**, including whether the same statistical conclusion is reached

Small differences will therefore be documented rather than automatically treated as errors when they do not materially affect interpretation.
The long-term aim is to build a structured SAS-to-R comparison resource that can guide the selection of R methods for analyses traditionally performed in SAS.

## Future direction

Every time the procedure, package, program are validated they would be added here. 
If you already validated some of the packages of have an idea how to do it please let me know

