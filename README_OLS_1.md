# Endogeneity-in-OLS
This repository looks at instances of endogeneity and how to correct for them.

Problem:
Here we will consider the regression model Y = β0 +β1X + epsilon. 
If X and epsilon are related, we say that X is endogenous and has both good and bad variation. 

In the associated do file, we will simulate the bias in OLS estimates of β1 where some determinant of X may also directly determine Y. 
We will also summarize and display the results.

We want to show that a strong link between the outcome variable and the omitted variable leads to greater bias (Case 1), and demonstrate that the strength of the link between the omitted variable and the included regressor matters as well (Case 2).

True Model:
Y = β0 + β1X + β2u + e 
-->  epsilon = β2u + e

Will only yield unbiased results of the parameter of interest, β1, if β2 = 0
If not, β1-hat will reflect both the effect of X itself on Y plus the bias arising from X’s correlation with u.

Assumptions:
Z ∼N(0, 1)
u ∼ N(0, 1)
e ∼ N(0, 1) 
β0 = 0.8 
β1 = 0.6
Case 1
  X = 0.5Z + 0.4u
Case 2
  X = 0.5Z + 0.1u
  
Simulate the bias in OLS estimates of β1 across a range of potential β2. 
1) For each β2 in -1.0, -0.9 ... , 0.9, 1.0, run 50 repetitions of samples of n = 5000.
2) Get the summary statistics for β1 and β2 and check the means (we want to see β1 = 0.6 and β2 = 0)
3) Make a scattter plot with a line at the true β1 = 0.6 and the simulated β2 for visualization
4) Repeat for case 2
5) Make a scatter plot to compare case 1 and case 2
