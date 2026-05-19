# Statistical Output – Example and Interpretation

## Overview
This repository provides SAS-generated statistical output along with a companion interpretation document.

## Contents
- Raw output documents  
  Direct output from PROC UNIVARIATE, including descriptive statistics, quantiles, extreme observations, and normality tests.

- *_note documents  
  Companion files that include a detailed interpretation for one variable.

## Purpose
The `_note` documents demonstrate how to translate statistical output into clear, structured language suitable for a research paper, including both methods-style description and results interpretation.

## How to Use
- Review the raw output alongside the `_note` example  
- Follow the structure and reasoning used in the example  
- Apply the same approach to the remaining variables  

## Learning Approach
Only one variable is fully interpreted. The remaining variables are intended as an exercise to support independent learning and consistent reporting.

## Results of Normality check and usage of independent t-test
After doing the exersice of Normality check for the additional variables. Based on my opinion, as the world is not perfect, and we will rarely have the classical Normal distribution from the actual data:
The normality assessment demonstrated that the distributions within groups were generally approximately normal based on both formal statistical tests and graphical diagnostics. Although minor deviations from normality were observed for some group-variable combinations, these departures were small and not considered severe. Histograms, kernel density curves, and Q–Q plots showed overall symmetric and unimodal distributions with no major outliers or extreme skewness. In addition, sample sizes were balanced and sufficiently large across groups (N=50/group), supporting the robustness of parametric methods. Therefore, the Normality assumptions for independent sample t-tests were considered adequately satisfied for all evaluated variables.

## T-test output 

Includes final results for pairvise comparison, the assumption for equality of variance in SAS is done by PROC T-TEST


## Questions
Feel free to reach out if you have any questions or need clarification.
