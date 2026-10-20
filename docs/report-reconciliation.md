# Report reconstruction and reconciliation

The missing SAS source is reconstructed from the supplied report's embedded code screenshots. It reproduces procedures and data transformations, rather than fabricating expected output. Raw CSV types are read explicitly so the reconstruction does not depend on PROC IMPORT guessing.

| Report location | Recovered behavior / verification |
| --- | --- |
| Page 13 | Convert gestation to numeric; convert maternal weight from pounds to ounces (×16). Explicit CSV numeric parsing replaces the temporary rename workflow. |
| Pages 15–19 | Missing: gestation 13, age 2, height 22, weight 36, smoke 10. Impute age 26, height 64, weight 2000 oz, gestation 280, smoke 0. All verified. |
| Pages 20–43 | Histograms, normal Q-Q plots, boxplots; smoke/parity frequencies; numeric correlations; grouped birth-weight boxplots; gestation and weight scatterplots. |
| Pages 44–47 | One-sample birth-weight test against 118 oz: t=3.039921, df=1235, p=0.002416, matching displayed rounding. The report's 'national average' label is not independently established; 118 is retained as a report benchmark. |
| Pages 48–52 | Non-smokers n=752, mean=123.095745; smokers n=484, mean=114.109504. Welch t=8.639808, df=1003.0185. Pooled t=8.708330, df=1234. The narrative selects Welch's row despite discussing equal variances. Both SAS rows are preserved. |
| Pages 53–56 | Pearson chi-square=0.098714, df=1, p=0.753378, matching the report. Counts 558/194/363/121 are OBSERVED, not expected. Expected counts are 560.3495/191.6505/360.6505/123.3495. |
| Pages 57–59 | This section is ANOVA despite the page heading calling it chi-square. Age <20, 20–30 inclusive, >30: F=0.618949, df=(2,1233), p=0.538677. Tukey comparisons preserved; Levene test added as a supplemental assumption check. |

## Limits and corrected interpretation

- Age–height correlation is 0.00314 after imputation, rather than the narrative's 0.00341. Other headline correlations reproduce at reported precision.
- Maternal weight was deliberately converted to ounces: 2000 is 125 pounds, not a clinically implausible 2000-pound observation. Original pounds remain in the source CSV.
- Public data dictionaries conflict on the meaning of parity's binary coding. The supplied report interprets 0 as first-time and 1 as experienced. This reconstruction retains numeric 0/1 labels, and does not claim that interpretation is independently resolved. See [OpenIntro](https://www.openintro.org/data/index.php?data=babies) and [the corresponding birth-weight teaching data](https://people.hsc.edu/faculty-staff/blins/classes/spring18/math222/examples/BabiesBirthweight.html).
- Median/mode imputation reproduces the report; single imputation can understate uncertainty. Observational association is not causation. The supplied sampling documentation is insufficient to establish random selection or independence.
- No separate parity-versus-birth-weight hypothesis test was shown in the report, so its final statement about parity should not be presented as a tested conclusion.
- SAS was not available locally. Numeric checks independently reproduce the headline values, but native SAS logs, ODS table formatting, and exact plot appearance remain unverified.

## Collaboration

Original study contributors: Abhinav Tanwar, Devadharshini Udayakumar, and Prithwiraj Chatterjee. Source reconstruction and repository packaging do not imply sole authorship or establish individual contribution shares. The original PDF is not redistributed because it includes student identifiers.
