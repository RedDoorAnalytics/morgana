local drive /Users/Michael/My Drive/products
cd "`drive'/merlin"
adopath ++ "`drive'/merlin"
adopath ++ "`drive'/merlin/merlin"
adopath ++ "`drive'/stmerlin"
adopath ++ "`drive'/stmerlin/stmerlin"
clear all

do ./build/buildmlib.do
mata mata clear

adopath ++ "`drive'/morgana"
adopath ++ "`drive'/morgana/morgana"

pr drop _all
 
set seed 72549
clear
set obs 1000
gen id1 = _n
gen trt = runiform()>0.5
gen age = rnormal(55,5)

survsim stime died , dist(weib) lambda(0.1) gamma(1) ///
	cov(trt -0.5 age 0.01) maxt(5)

stset stime, f(died)

// streg trt age, dist(weib) nohr
timer clear
timer on 1
// bayes : streg trt age, dist(weib) nohr
stmerlin trt age , dist(rcs) df(3)
timer off 1

timer on 2
// morgana : merlin (_t trt age , family(rp, failure(_d) df(3)))
morgana, prior({trt}, normal(-0.2,0.1)): stmerlin trt age , dist(rp) df(3) 
// morgana, prior({trt}, normal(-0.2,0.1)): stmerlin trt age , dist(rp) df(3) 
timer off 2

timer list

bayesgraph diagnostics {age}

graph export morgana-plot.png, as(png) replace
