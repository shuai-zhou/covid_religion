*==========================================================
* set up
*==========================================================
clear
set more off
macro drop _all
set scheme lean1 // plotplain s2mono s1color s1mono lean1

cap cd "C:/Users/Neo/Desktop/Religion_COVID"
global data = "$pwd" + "data"
global results = "$pwd" + "results"

*==========================================================
* start logging
*==========================================================
log close _all
log using "$results/table2.log", replace

*==========================================================
* all counties
*==========================================================
** merge datasets
use "$data/acs.dta", clear
merge 1:1 countyfips using "$data/voting.dta", gen(mg1)
drop mg1
replace trump = 9.28125 if countyfips == "46102"
replace popden = 6.81935 if countyfips == "46113"
replace income1000 = 31.423 if countyfips == "46113"
replace countyname = "Oglala Lakota County, South Dakota" if countyfips == "46113"
gen stfips = substr(countyfips, 1, 2)
drop if inlist(stfips, "02","15","72")
drop stfips
drop if countyfips == "36000"
drop if countyfips == "46102"
unique countyfips

merge 1:m countyfips using "$data/covid.dta", gen(mg3)
gen stfips = substr(countyfips, 1, 2)
drop if inlist(stfips, "02", "15", "66", "72", "78")
unique countyfips

tempfile all_county
save `all_county'

** monthly vaccination rate
use `all_county', clear
keep countyfips monthly income1000 trump met countynum day week month year pop
bysort countyfips monthly: gen var1 = _n
keep if var1 == 1
drop var1
tempfile county_data_monthly
save `county_data_monthly'

use `all_county', clear
keep countyfips monthly dr pop
collapse (mean) mr = dr [w=pop], by(countyfips monthly)
tempfile vac_monthly
save `vac_monthly'

use `county_data_monthly', clear
merge 1:1 countyfips monthly using `vac_monthly', gen(mg)
tab mg, mi
drop mg
label variable mr "Monthly vaccination rate"
order countyfips monthly mr

** generate regions based on census
gen sfips = substr(countyfips, 1, 2)
destring sfips, replace
gen region = 1 if inlist(sfips, 9,23,25,33,44,50,34,36,42)
replace region = 2 if inlist(sfips, 18,17,26,39,55,19,20,27,29,31,38,46)
replace region = 3 if inlist(sfips, 4,8,16,35,30,49,32,56,6,41,53)
replace region = 4 if region == .
label define region 1 "Northeast" 2 "Midwest" 3 "West" 4 "South"
label values region region

** merge with racial composition data
merge 1:1 countyfips monthly using "$data/resdata_for_desc.dta", gen(mg)
keep if mg == 3
drop mg

** re-scale percentage
foreach v of varlist trump pcthis pctbla pctwhi pctasi pctcol {
	replace `v' = `v' / 100
}

*==========================================================
* all counties
*==========================================================
** independent variables to macro
local ivs_allcounty trump income1000

xtset countynum monthly
xtnbreg mr `ivs_allcounty' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", replace stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("All counties") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

*==========================================================
* county with different religions
*==========================================================
** independent variables to macro
local ivs_religion pct2020 trump income1000

** Black Protestant
use "$data/resdata_all_religions.dta", clear
keep if cate == 1
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Black Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Catholic
use "$data/resdata_all_religions.dta", clear
keep if cate == 2
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Catholic") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Evangelical Protestant
use "$data/resdata_all_religions.dta", clear
keep if cate == 3
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Evangelical Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Islam
use "$data/resdata_all_religions.dta", clear
keep if cate == 4
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Islam") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Mainline Protestant
use "$data/resdata_all_religions.dta", clear
keep if cate == 5
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Mainline Protestant") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** Mormons
use "$data/resdata_all_religions.dta", clear
keep if cate == 6
foreach v of varlist trump pct2020 {
	replace `v' = `v' / 100
}
xtset countynum monthly
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Mormons") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** black protestant urban
use "$data/resdata_all_religions.dta", clear
keep if cate == 1
merge m:1 countyfips using "$data/county_new_vars.dta", gen(mg)
keep if mg == 3
keep if metro == 1
xtset countynum monthly
foreach v of varlist pct2020 trump pcthis pctbla pctwhi pctasi pctcol {
	replace `v' = `v' / 100
}
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Black Protestant Urban") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** black protestant south
use "$data/resdata_all_religions.dta", clear
keep if cate == 1
merge m:1 countyfips using "$data/county_new_vars.dta", gen(mg)
keep if mg == 3
keep if inlist(sfips, 12, 13, 45, 37, 51, 24, 10, 21, 47, 1, 28, 22, 5, 29, 40, 48)
xtset countynum monthly
foreach v of varlist pct2020 trump pcthis pctbla pctwhi pctasi pctcol {
	replace `v' = `v' / 100
}
xtnbreg mr `ivs_religion' i.b1.met, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Black Protestant South") ///
	dec(3) alpha(0.001, 0.01, 0.05) symbol(***, **, *)

** islam urban
use "$data/resdata_all_religions.dta", clear
keep if cate == 4
merge m:1 countyfips using "$data/county_new_vars.dta", gen(mg)
keep if mg == 3
keep if metro == 1
xtset countynum monthly
foreach v of varlist pct2020 trump {
	replace `v' = `v' / 100
}
xtnbreg mr `ivs_religion' i.b1.met i.region, pa vce(robust)

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

outreg2 using "$results/table2.doc", append stats(coef se) ///
	addstat("Mean VIF", `meanvif', "R2", `r2') ///
	label nodepvar ctitle("Islam Urban") ///
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

