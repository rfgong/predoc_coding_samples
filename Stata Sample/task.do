* 1a
set obs 1000
set seed 0
generate u = rnormal(0,5)
gen x1 = rnormal()
gen x2 = exp(x1)
gen y = 2 + 4 * x1 - 6 * x2 + u
* 1b
reg y x1
reg y x2
* 1c
reg y x1 x2
* 1d
gen v = rnormal(0, 0.5)
gen x3 = 1 + x1 - x2 + v
reg y x1 x2 x3
* 1e
gen x1_coef_avg = 0
gen x2_coef_avg = 0
gen x1_cor_avg = 0
gen x2_cor_avg = 0
forvalues i = 1/1000 {
	quietly {
		replace u = rnormal(0,5)
		replace x1 = rnormal()
		replace x2 = exp(x1)
		replace y = 2 + 4 * x1 - 6 * x2 + u
		reg y x1 x2
		replace x1_coef_avg = x1_coef_avg + _b[x1]
		replace x2_coef_avg = x2_coef_avg + _b[x2]
		cor y x1
		replace x1_cor_avg = x1_cor_avg + r(rho)
		cor y x2
		replace x2_cor_avg = x2_cor_avg + r(rho)
	}
}
replace x1_coef_avg = x1_coef_avg / 1000
replace x2_coef_avg = x2_coef_avg / 1000
replace x1_cor_avg = x1_cor_avg / 1000
replace x2_cor_avg = x2_cor_avg / 1000

* 2a
use "TeachingRatings.dta", clear
reg course_eval beauty, r
* 2b
reg course_eval beauty intro onecredit female minority nnenglish, r
* 2c
reg course_eval intro onecredit female minority nnenglish, r
predict fit_c , xb
gen course_o = course_eval - fit_c
reg beauty intro onecredit female minority nnenglish, r
predict fit_b , xb
gen beauty_o = beauty - fit_b
reg course_o beauty_o, r

* 3b
reg yrsed dist, r
* 3c
reg yrsed dist bytest female black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80, r
