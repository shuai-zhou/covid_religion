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
log using "$results/table1.log", replace

*==========================================================
* descriptive statistics
*==========================================================
** religious population
use "$data/resdata_all_religions.dta", clear
tab cate, mi
keep countyfips pct2020 cate
bysort countyfips cate: gen ord = _n
keep if ord == 1
des, s
nmissing
sum pct2020
drop ord
label list cate
reshape wide pct2020, i(countyfips) j(cate)
rename pct20201 pct_bp
rename pct20202 pct_ca
rename pct20203 pct_ep
rename pct20204 pct_is
rename pct20205 pct_mp
rename pct20206 pct_mo
sum

tempfile religion
save `religion'

** research data
use "$data/resdata_for_desc.dta", clear
des, s
merge m:1 countyfips using `religion', gen(mg)
tab mg, mi

** merge insurance, foreign born, and hospital data
merge m:1 countyfips year using "$data/county_newvars_fborn_uninsur_edu.dta", gen(mg1)
merge m:1 countyfips year using "$data/county_newvars_hosp.dta", gen(mg2)
tab mg1, mi
tab mg2, mi
keep if mg1 == 3
des, s
keep countyfips mr pct_bp pct_ca pct_ep pct_is pct_mp pct_mo trump income1000 uninsur fborn coll pcthis pctbla pctwhi pctasi metro region
order countyfips mr pct_bp pct_ca pct_ep pct_is pct_mp pct_mo trump income1000 uninsur fborn coll pcthis pctbla pctwhi pctasi metro region
sum
tab region, mi
outreg2 mr pct_bp pct_ca pct_ep pct_is pct_mp pct_mo trump income1000 uninsur fborn pcthis pctbla pctwhi pctasi metro region ///
	using "$results/table1.doc", replace label dec(2) sum(log) eqkeep(N mean sd min max)

** please note, the max for % of evangelican protestant was originally 452.45
** which does not make sense, since this is a percentage measure at the county level
** and it was replaced with 100 in table 1

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

