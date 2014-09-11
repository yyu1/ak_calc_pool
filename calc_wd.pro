;Calculates different carbon pools.  Can take scalar or vector as inputs.

;Functions need to be able to handle scalar and vector inputs
Function calc_wd, agb
  return, 6.0893 + 0.04265*agb
End
