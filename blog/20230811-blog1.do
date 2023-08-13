### Bayesian flexible survival models with morgana and stmerlin



<<dd_do>>
set seed 72549
clear
set obs 1000
gen id1 = _n
gen trt = runiform()>0.5
gen age = rnormal(55,5)
<</dd_do>>

<<dd_do>>
survsim stime died , dist(weib) lambda(0.1) gamma(1) cov(trt -0.5 age 0.01) maxt(5)
<</dd_do>>

<<dd_do>>
stset stime, f(died)
<</dd_do>>

<<dd_do>>
stmerlin trt age , dist(rcs) df(3)
<</dd_do>>


<<dd_do>>
morgana : stmerlin trt age , dist(rp) df(3)
<</dd_do>>


<<dd_do>>
morgana, prior({trt}, normal(-0.2,0.1)): stmerlin trt age , dist(rp) df(3)
<</dd_do>>

<<dd_do>>
bayesgraph diagnostic {trt}
<</dd_do>>
