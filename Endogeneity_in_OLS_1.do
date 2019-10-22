*Endogeneity in OLS_1

clear all
capture cd "<\\toaster\homes\a\v\avarga5\nt"
set more off

*******************************************************************************************
************************Case One: X= 0.5 * z + 0.4 * u*************************************

capture program drop endog

program endog, rclass
*create changing variable
syntax, beta2(real)

drop _all

set obs 5000 /*number of observations or samples*/

*variable generation
gen z = rnormal(0,1)
gen u = rnormal(0,1)
gen e = rnormal(0,1)
gen beta0 = 0.8
gen beta1 = 0.6

gen epsilon = `beta2' * u + e

gen x = 0.5 * z + 0.4 * u

gen y = beta0 + beta1 * x + epsilon

*estimation: dependent on independent
reg y x

*need these returned for scatter plot
return scalar beta1 = _b[x]
return scalar beta2 = `beta2'

end

*Loop to generate the coefficients for the 21 different values beta2 can take
/*When you look at the data and i = 0 it actually equals -1.39e-16 instead of zero 
but don't be alarmed, it is zero*/
forvalues i = -1(0.1)1{
	simulate beta1 = r(beta1) beta2 = r(beta2), saving(endogData_1_`i'.dta, replace) reps(50): endog, beta2(`i')
}

*append all the data from simulations for first scatter plot 
clear
forvalues i = -1(0.1)1{
	append using endogData_1_`i'.dta
	erase endogData_1_`i'.dta
}

*summary statistics--> check means
summarize beta1 beta2

*make scatter plot where commmand is scatter and then put y axis var first then x axis var
label var beta1 "Beta 1"
label var beta2 "Beta 2"
graph twoway scatter beta1 beta2, ///
caption("Case One: x = 0.5 * z + 0.4 * u") ///
yline(0.6) /*true beta1*/

*title("Scatterplot of the estimates of Beta 1 across Beta 2") ///
*save the scatter plot to compare with case 2
graph save Scatter_Case1_endogData_1.gph, replace


*******************************************************************************************
************************Case Two: X= 0.5 * z + 0.1 * u*************************************

clear all
capture program drop endog

program endog, rclass
*create changing variable
syntax, beta2(real)

drop _all

set obs 5000 /*number of observations or samples*/

*variable generation
gen z = rnormal(0,1)
gen u = rnormal(0,1)
gen e = rnormal(0,1)
gen beta0 = 0.8
gen beta1 = 0.6

gen epsilon = `beta2' * u + e

gen x = 0.5 * z + 0.1 * u

gen y = beta0 + beta1 * x + epsilon

*estimation: dependent on independent
reg y x

*need these returned for scatter plot
return scalar beta1 = _b[x]
return scalar beta2 = `beta2'

end

*Loop to generate the coefficients for the 21 different values beta2 can take
forvalues i = -1(0.1)1{
	simulate beta1 = r(beta1) beta2 = r(beta2), saving(endogData_1_`i'.dta, replace) reps(50): endog, beta2(`i')
}

*append all the data from simulations for first scatter plot 
clear
forvalues i = -1(0.1)1{
	append using endogData_1_`i'.dta
	erase endogData_1_`i'.dta
}

*summary statistics--> check means
summarize beta1 beta2

*make scatter plot where commmand is scatter and then put y axis var first then x axis var
label var beta1 "Beta 1"
label var beta2 "Beta 2"
graph twoway scatter beta1 beta2, ///
caption("Case Two: x = 0.5 * z + 0.1 * u ") ///
yline(0.6) /*true beta1*/

*title("Scatterplot of the estimates of Beta 1 across Beta 2") ///
*save the scatter plot to compare with case 2
graph save Scatter_Case2_endogData_1.gph, replace

graph combine Scatter_Case1_endogData_1.gph Scatter_Case2_endogData_1.gph, ///
title("Scatterplot of the estimates of Beta 1 across Beta 2") ///
subtitle("Created by: avarga5")

graph save Combined_Scatter_endogData_1.gph, replace
