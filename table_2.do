*==========================================================
* set up
*==========================================================
clear
set more off
macro drop _all
// set scheme lean1 // plotplain s2mono s1color s1mono lean1
cap cd "F:/OneDrive - southalabama.edu/covid_religion/"
global data = "$pwd" + "data"
global results = "$pwd" + "results"

*==========================================================
* start logging
*==========================================================
log close _all
log using "$results/table2_v6.log", replace

*==========================================================
* all counties
*==========================================================
** independent variables to macro
local ivs_allcounty trump income1000 uninsur coll pcthis pctbla pctwhi pctasi

** all counties model
use "$data/resdata_all_counties_with_newvars.dta", clear

xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_allcounty' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_all.dta", pval ci replace

collin `ivs_allcounty' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", replace stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("All counties") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

*==========================================================
* county with different religions
*==========================================================
** independent variables to macro
local ivs_religion pct2020 trump income1000 uninsur coll pcthis pctbla pctwhi pctasi

** Black Protestant
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 1
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_bp.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Black Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Catholic
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 2
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_ca.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Catholic") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Evangelical Protestant
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 3
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_ep.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Evangelical Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Islam
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 4
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_is.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Islam") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Mainline Protestant
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 5
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_mp.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Mainline Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Mormons
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 6
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_mo.dta", pval ci replace

collin `ivs_religion' met
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Mormons") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** black protestant urban
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 1
keep if metro == 1
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_bpu.dta", pval ci replace

collin `ivs_religion'
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Black Protestant Urban") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** black protestant south
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 1
keep if inlist(sfips, 12, 13, 45, 37, 51, 24, 10, 21, 47, 1, 28, 22, 5, 29, 40, 48)
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_bps.dta", pval ci replace

collin `ivs_religion'
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Black Protestant South") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** islam urban
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
keep if cate == 4
keep if metro == 1
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr `ivs_religion' i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_isu.dta", pval ci replace

collin `ivs_religion'
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Islam Urban") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** islam-foreign born interaction
use "$data/resdata_all_religions_with_newvars.dta", clear
merge m:1 countyfips year using "$data/county_newvars_racial_composition.dta", gen(mg)
tab mg, mi
keep if mg == 3
gen pct2020_fborn = pct2020 * fborn
keep if cate == 4
xtset countynum monthly
gen loginsur = log(insur)
gen stfips = substr(countyfips, 1, 2)
destring stfips, replace
xtnbreg mr pct2020 c.pct2020#c.fborn trump income1000 uninsur fborn coll pcthis pctbla pctwhi pctasi i.b1.met i.monthly i.stfips i.region, pa vce(robust)

regsave using "$data/reg_results_isfborn.dta", pval ci replace

collin pct2020 pct2020_fborn trump income1000 uninsur fborn coll
return list
local meanvif = r(m_vif)

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]
local r2 = 1 - ssr[_N] / sst[_N]

outreg2 using "$results/table2_v6.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') drop(i.monthly i.stfips) noomit ///
	label nodepvar ctitle("Islam-Foreign born Interaction") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

*==========================================================
* delete txt file
*==========================================================
cd "$results"
local txtfiles: dir . files "*.txt"
foreach txt of local txtfiles {
	erase `txt'
}

*==========================================================
* end logging
*==========================================================
// clear
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

