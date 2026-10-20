import pandas as pd,numpy as np
from scipy import stats
from pathlib import Path
root=Path(__file__).resolve().parents[1]
d=pd.read_csv(root/'data/babies.csv');assert len(d)==1236
expected={'bwt':0,'gestation':13,'parity':0,'age':2,'height':22,'weight':36,'smoke':10}
assert d.isna().sum().to_dict()==expected
print('Missing counts before imputation:',expected)
d.weight=d.weight*16;d=d.fillna({'age':26,'height':64,'weight':2000,'gestation':280,'smoke':0});assert not d.isna().any().any()
one=stats.ttest_1samp(d.bwt,118);welch=stats.ttest_ind(d[d.smoke==0].bwt,d[d.smoke==1].bwt,equal_var=False);pooled=stats.ttest_ind(d[d.smoke==0].bwt,d[d.smoke==1].bwt,equal_var=True);chi=stats.chi2_contingency(pd.crosstab(d.smoke,d.parity),correction=False);anova=stats.f_oneway(d[d.age<20].bwt,d[d.age.between(20,30)].bwt,d[d.age>30].bwt)
assert round(one.pvalue,4)==.0024 and round(welch.statistic,2)==8.64
assert round(chi.statistic,4)==.0987 and round(chi.pvalue,4)==.7534
assert round(anova.pvalue,4)==.5387
print('Mean and SD birthweight:',d.bwt.mean(),d.bwt.std());print('One-sample:',one);print('Smoking summaries:');print(d.groupby('smoke').bwt.agg(['count','mean','std']).to_string());print('Welch:',welch);print('Pooled:',pooled);print('Observed smoking/parity table:');print(pd.crosstab(d.smoke,d.parity).to_string());print('Chi-square:',chi.statistic,'p:',chi.pvalue,'expected:',chi.expected_freq);print('ANOVA:',anova);print('Correlation matrix:');print(d[['bwt','age','height','weight','gestation']].corr().round(5).to_string())
