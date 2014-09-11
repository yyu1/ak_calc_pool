;Calculates different carbon pools.  Can take scalar or vector as inputs.

;Functions need to be able to handle scalar and vector inputs

Function calc_root, agb
  ;Use ratio from Mokany
  return, (agb le 75)*0.392*agb + (agb gt 75)*0.239*agb
End
