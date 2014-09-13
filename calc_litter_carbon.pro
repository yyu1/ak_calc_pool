;This function calculates carbon in litter from AGB
;Note return value is in units of carbon

Function calc_litter_carbon  
	return, 19.142 + 0.043642*agb   ;calculated from FIA single condition plots of softwood only

End
