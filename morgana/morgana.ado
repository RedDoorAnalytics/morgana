*! version 1.0.0 ?????2023

/*
Notes

- starting values need syncing, i.e. always fit the fixed effect model
	-> standard merlin model will use zero vector for a fixed effect only model

*/

program morgana
	version 18
	
	gettoken colon merlin : 0 , parse(":")

	if "`colon'"!=":" {
		gettoken comma opts : colon , parse(",")	
		gettoken colon merlin : merlin, parse(":")
		
		if "`colon'"!=":" {
			di as error "morgana is a prefix command and requires a :"
			exit 198
		}
	}

	set prefix morgana
	
	if "`: word 1 of `merlin''"!="stmerlin" {
		di as error "{bf:morgana} currently only supports use with {bf:stmerlin}"
		exit 198
	}
	
	//fill up struct and bail out before estimation
	`merlin'

	//global opts
	global object `e(object)'
	
	//hard coded for 1 model 

		local i = 1
		local responses `responses' (`: word 1 of `e(response`i')'')
		
		local labels `e(cmplabels`i')'
		
		local cmp = 1
		foreach var in `labels' {
			local cmpj : word `cmp' of `e(Nvars_`i')'
			if `cmpj'==1 {			
				local eqns `eqns' `var'
				local params `params' {`var'}
				local priors `priors' prior({`var'}, normal(0,10000))
				local block`i' `block`i'' {`var'}
			}			
			else {
				local var = subinstr("`var'","()","",.)
				forvalues j=1/`cmpj' {
					local eqns `eqns' `var'`j'
					local params `params' {`var'`j'}
					local priors `priors' prior({`var'`j'}, normal(0,10000))
					local block`i' `block`i'' {`var'`j'}
				}
			}
			local cmp = `cmp' + 1
		}
		
		if `e(constant`i')'==1 {
			local eqns `eqns' _cons`i'
			local params `params' {_cons`i'}
			local priors `priors' prior({_cons`i'}, normal(0,10000))
			local block`i' `block`i'' {_cons`i'}
		}
		local blocks `blocks' block(`block`i'')
		
		local block`i'
		if `e(ndistap`i')'>0 {
			
			if "`e(family`i')'"=="rp" {
				forvalues dap = 1/`e(ndistap`i')' {
					local eqns `eqns' _rcs`dap'
					if `dap'==1 {
						local params `params' {_rcs_`i'_`dap'=1}
					}
					else {
						local params `params' {_rcs_`i'_`dap'}
					}
					
					local priors `priors' prior({_rcs_`i'_`dap'}, normal(0,10000))
					local block`i' `block`i'' {_rcs_`i'_`dap'}
				}	
			}
			
			
		}
		local blocks `blocks' block(`block`i'')
		
		if `e(nap`i')'>0 {
			forvalues ap = 1/`e(nap`i')' {
				local eqns `eqns' mod`i'_ap`ap'
				local params `params' {mod`i'_ap`ap'}
				local priors `priors' prior({mod`i'_ap`ap'}, normal(0,10000))
			}
		}
	
// 	forvalues i=1/`e(Nmodels)' {
		
// 		local responses `responses' (`: word 1 of `e(response`i')'')
		
// 		local c = 1
// 		foreach nvars in `e(Nvars_`i')' {
// 			forvalues el=1/`nvars' {
// 				local eqns `eqns' mod`i'_cmp`c'_el`el'
// 				local params `params' {mod`i'_cmp`c'_el`el'}
// 				local priors `priors' prior({mod`i'_cmp`c'_el`el'}, normal(0,10000))
// 				local block`i' `block`i'' {mod`i'_cmp`c'_el`el'}
// 			}
// 			local c = `c' + 1
// 		}
		
// 		if `e(constant`i')'==1 {
// 			local eqns `eqns' cons`i'
// 			local params `params' {cons`i'}
// 			local priors `priors' prior({cons`i'}, normal(0,10000))
// 			local block`i' `block`i'' {cons`i'}
// 		}
// 		local blocks `blocks' block(`block`i'')
		
// 		local block`i'
// 		if `e(ndistap`i')'>0 {
// 			forvalues dap = 1/`e(ndistap`i')' {
// 				local eqns `eqns' mod`i'_dap`dap'
// 				if `dap'==1 & "`e(family`i')'"=="rp" {
// 					local params `params' {mod`i'_dap`dap'=1}
// 				}
// 				else {
// 					local params `params' {mod`i'_dap`dap'}
// 				}
				
// 				local priors `priors' prior({mod`i'_dap`dap'}, normal(0,10000))
// 				local block`i' `block`i'' {mod`i'_dap`dap'}
// 			}
// 		}
// 		local blocks `blocks' block(`block`i'')
		
// 		if `e(nap`i')'>0 {
// 			forvalues ap = 1/`e(nap`i')' {
// 				local eqns `eqns' mod`i'_ap`ap'
// 				local params `params' {mod`i'_ap`ap'}
// 				local priors `priors' prior({mod`i'_ap`ap'}, normal(0,10000))
// 			}
// 		}
// 	}

	global eqns `eqns'
	cap pr drop morgana_ll
	cap n bayesmh `responses', 				///
		noconstant					///
		llevaluator(morgana_ll, parameters(`params'))	///
		`priors'					///
		`blocks'					///
		`opts'
		
	mata: merlin_cleanup(st_global("object"))
	if _rc>0 {
		exit `rc'
	}
	
end

