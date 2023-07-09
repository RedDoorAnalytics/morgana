{smcl}
{* *! version 1.0.0}{...}
{vieweralsosee "morgana" "help morgana"}{...}
{vieweralsosee "stmerlin" "help stmerlin"}{...}
{vieweralsosee "merlin" "help merlin"}{...}
{vieweralsosee "bayesmh" "help bayesmh"}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col:{helpb morgana} {hline 2}}prefix commmand for estimating a Bayesian {helpb stmerlin} survival model{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:morgana} [, {it:options}] {cmd::} {it:stmerlin_model}


{synoptset 27}{...}
{marker options}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt nomodelsummary}}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:morgana} prefix commmand fits Bayesian versions of survival models available with the {helpb stmerlin} command.
{p_end}

{pstd}
{cmd:stmerlin} fits survival models, including a range of parametric distributions, flexible spline-based models, and the 
Cox model. It is a convenience wrapper of the more powerful {helpb merlin} command, but with a much more user-friendly 
syntax. Time-dependent effects can be specified using restricted cubic splines.
{p_end}

{pstd}
The {helpb merlin} command fits an extremely broad class of mixed effects regression models for linear, non-linear and 
user-defined outcomes. For full details and many tutorials, take a look at the accompanying website: 
{browse "https://reddooranalytics.se/products/merlin":reddooranalytics.se/products/merlin}
{p_end}


{marker options}{...}
{title:Options}

{phang}{opt nomodelsummarry} 


{title:Example}

{phang}Setup{p_end}
{phang}{cmd:. webuse brcancer, clear}{p_end}

{phang}Estimate a Bayesian flexible parametric Royston-Parmar model:{p_end}
{phang}{cmd:. morgana : stmerlin hormon , dist(rp) df(3)}{p_end}


{title:Author}

{p 5 12 2}
{bf:Michael J. Crowther}{p_end}
{p 5 12 2}
Red Door Analytics AB{p_end}
{p 5 12 2}
Stockholm, Sweden{p_end}
{p 5 12 2}
michael@reddooranalytics.se{p_end}

