//local drive Z:/
local drive /Users/Michael
cd "`drive'/merlin"
adopath ++ "`drive'/merlin"
adopath ++ "`drive'/merlin/merlin"
adopath ++ "`drive'/merlin/stmerlin"
clear all

do ./build/buildmlib.do
mata mata clear

local drive /Users/Michael/My Drive/products/morgana
adopath ++ "`drive'/morgana"

local file "`drive'/blog/20230811-blog1"

dyntext "`file'.do", saving("`file'.md")
