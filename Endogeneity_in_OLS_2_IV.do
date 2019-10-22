*Endogeneity in OLS_2_IV

clear all
capture cd "<\\toaster\homes\a\v\avarga5\nt"
set more off

*******************************************************************************************
************************Case One: X= 0.5 * z + 0.4 * u*************************************

capture program drop instrumental

program instrumental, rclass

drop _all

set obs 100

gen Z = rnormal()
gen u = rnormal()
gen e = rnormal()
gen v = rnormal()

gen beta0 = 0.8
gen beta1 = 0.6
gen beta2 = 0.5

gen X = 0.5 * Z + 0.1 * u + v
gen epsilon = beta2 * u + e
gen Y = beta0 + beta1 * X + epsilon


*********************************Basic OLS Regression*******************************
reg Y X
*we want avg estimate of b1 and t-stat
*I had to generate the variables before return becasue stata said varaible not found
gen beta1_OLS = 0
gen se_OLS = 0 
gen tstat_OLS = 0
return scalar beta1_OLS =_b[X]
return scalar se_OLS = _se[X]
return scalar tstat_OLS = (_b[X] - beta1)/_se[X]


************************************2SLS Regression*********************************
ivregress 2sls Y (X = Z)
*want avg estimate of b1 and t-stat
gen beta1_2SLS = 0
gen se_2SLS = 0 
gen tstat_2SLS = 0
return scalar beta1_2SLS = _b[X]
return scalar se_2SLS = _se[X]
return scalar tstat_2SLS = (_b[X] - beta1)/_se[X]


*****************************IV regrssion by hand(kind of)**************************
*first stage: regress endog on exog (iv)
reg X Z
predict Xhat
*second stage: regress dep on indep
reg Y Xhat
*want avg estimate of b1 and t-stat
gen beta1_IV = 0
gen se_IV = 0 
gen tstat_IV = 0
return scalar beta1_IV = _b[Xhat]
return scalar se_IV = _se[Xhat]
return scalar tstat_IV = (_b[Xhat] - beta1)/_se[Xhat]
end

**************************************Simulation************************************
*I went ahead and simulated se and tstat as well
*Also, the simulate line is super long so I divided it with /// so you can see it better

simulate beta1_OLS = r(beta1_OLS) beta1_2SLS = r(beta1_2SLS) beta1_IV = r(beta1_IV)   ///
		 se_OLS = r(se_OLS) se_2SLS = r(se_2SLS) se_IV = r(se_IV)   ///
		 tstat_OLS = r(tstat_OLS) tstat_2SLS = r(tstat_2SLS) tstat_IV = r(tstat_IV),   ///
		 saving(instrumentalData.dta, replace) reps(1000): instrumental
		 
		 
*1) What is the average estimate that each approach yields?
		 
summarize beta1_OLS beta1_2SLS beta1_IV
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
   beta1_OLS |      1,000    .6394624    .1022015    .303731   .9668212
  beta1_2SLS |      1,000    .5976998    .2472857  -.2437784   1.636652
    beta1_IV |      1,000    .5976998    .2472857  -.2437784   1.636652
	
notice the estimates for beta1_2SLS and beta1_IV are the same
*/

/*2) How often dos each approach have us reject that the estimated effect is
equal to the true effect at the 5% significance level? */

summarize tstat_OLS if abs(tstat_OLS) > 1.96
summarize tstat_2SLS if abs(tstat_2SLS) > 1.96
summarize tstat_IV if abs(tstat_IV) > 1.96
/*

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
   tstat_OLS |         79    1.924366    1.500435  -2.992288   3.577628

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
  tstat_2SLS |         39    .9109195    2.111921  -2.722484   3.061252

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    tstat_IV |         27    .9198393    2.112269  -2.494033   2.773739

	
Using OLS the t test rejects 79 observations becasue of the bad variation in X
Using 2SLS and IV the t test rejects fewer observation, 39 and 27 respectively, 
because some of the variation is controled for with the instrumental varaible Z
*/

erase instrumentalData.dta

