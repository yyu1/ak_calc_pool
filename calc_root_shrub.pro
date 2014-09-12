;Calculates different carbon pools.  Can take scalar or vector as inputs.

;For shrub root

;Functions need to be able to handle scalar and vector inputs

Function calc_root_shrub, agb
  ;Use ratio from Mokany
	return, 1.837 * agb
End
