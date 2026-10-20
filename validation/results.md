# Independent numerical validation

Computed directly from the repository CSV using Python, pandas, NumPy, and SciPy. This is independent numerical evidence, not a SAS execution log. Reproduce with `python -m pip install -r validation/requirements.txt` then `python validation/check_results.py`.

```text
Missing counts before imputation: {'bwt': 0, 'gestation': 13, 'parity': 0, 'age': 2, 'height': 22, 'weight': 36, 'smoke': 10}
Mean and SD birthweight: 119.57686084142395 18.236451866972608
One-sample: TtestResult(statistic=np.float64(3.039920730582867), pvalue=np.float64(0.002416200148653829), df=np.int64(1235))
Smoking summaries:
       count        mean        std
smoke                              
0.0      752  123.095745  17.451668
1.0      484  114.109504  18.098946
Welch: TtestResult(statistic=np.float64(8.639808047352776), pvalue=np.float64(2.1921304760165115e-17), df=np.float64(1003.018508483183))
Pooled: TtestResult(statistic=np.float64(8.70833002772581), pvalue=np.float64(9.730641848848494e-18), df=np.float64(1234.0))
Observed smoking/parity table:
parity    0    1
smoke           
0.0     558  194
1.0     363  121
Chi-square: 0.09871389958714143 p: 0.7533784976079696 expected: [[560.34951456 191.65048544]
 [360.65048544 123.34951456]]
ANOVA: F_onewayResult(statistic=np.float64(0.6189490905653432), pvalue=np.float64(0.5386772969039394))
Correlation matrix:
               bwt      age   height   weight  gestation
bwt        1.00000  0.03367  0.19726  0.15198    0.40577
age        0.03367  1.00000  0.00314  0.15708   -0.05577
height     0.19726  0.00314  1.00000  0.43223    0.06250
weight     0.15198  0.15708  0.43223  1.00000    0.01934
gestation  0.40577 -0.05577  0.06250  0.01934    1.00000
```
