# Endogeneity-in-OLS
This repository looks at instances of endogeneity and how to correct for them.

Continuation of Endogeneity_in_OLS_1

We set up the problem the same as OLS_1

Problem: Here we will consider the regression model Y = β0 +β1X + epsilon. If X and epsilon are related, we say that X is endogenous and has both good and bad variation.
--> Thus, there is variation in X that is uncorrelated with the error term in the regression model (Z) and variation in X that is correlated with the error term in the regression model (u).

If we could use only the variation in X that’s generated by Z, we would not have to worry about bias.
-->Instrumental Varaible!

In the associated do file, we will simulate the bias in OLS estimates of β1 where some determinant of X may also directly determine Y. We will also summarize and display the results.

True Model: Y = β0 + β1X + β2u + e --> epsilon = β2u + e

Assumptions: Z ∼N(0, 1), u ∼ N(0, 1), e ∼ N(0, 1), β0 = 0.8, β1 = 0.6, X = 0.5Z + 0.1u + v, v ∼ N(0, 1)

1) Simulate the OLS and IV estimates of the treatment effect of interest for β2 = 0.5, running 1000 repetitions of samples of n = 100. 
2) Summarize beta1_OLS, beta1_2SLS and beta1_IV and show that the mean values of beta1_2SLS and beta1_IV are the same (ie. the coefficient estimate produced using two stage least squares is identical to what we obtain by regressing Y on X-hat where X-hat is the X predicted from a regression of X on Z (instrumental variable). 
3) Summarize the t stattistic for each approach to show how often it has us reject that the estimated effect is equal to the true test at the 5% significance level (ie. show that controlling for bad variation leads to fewer rejections).