;Calculates carbon pools, taking in floating point type of AGB map

Pro calc_pool_int, in_file, nlcd_file, out_dead_file, out_root_file, out_wd_file, out_litter_file
	infile_info = file_info(in_file)

	file_size = infile_info.size

	;Calculate values in blocks of 1M pixels at a time

	n_blocks = file_size / (1000000ULL * 2ULL)

	remainder = (file_size mod (1000000ULL * 2ULL)) / 2ULL

	line = intarr(1000000ULL)
	flt_line = fltarr(1000000ULL)
	nlcd_line = bytarr(1000000ULL)
	out_dead_line = intarr(1000000ULL)
	out_root_line = intarr(1000000ULL)
	out_wd_line = intarr(1000000ULL)
	out_litter_line = intarr(1000000ULL)

	print, 'Number of blocks to process:', n_blocks

	openr, in_lun, in_file, /get_lun
	openr, nlcd_lun, nlcd_file, /get_lun
	openw, dead_lun, out_dead_file, /get_lun
	openw, root_lun, out_root_file, /get_lun
	openw, wd_lun, out_wd_file, /get_lun
	openw, litter_lun, out_litter_file, /get_lun

	for i=0ULL, n_blocks-1 do begin	
		print, i
		readu, in_lun, line
		flt_line[*] = float(line)/10.
		readu, nlcd_lun, nlcd_line
		;trees
		out_dead_line[*] = 0
		out_root_line[*] = 0
		out_wd_line[*] = 0
		out_litter_line[*] = 0
		
		index = where((line gt 0) and ((nlcd_line eq 41) or (nlcd_line eq 42) or (nlcd_line eq 43) or (nlcd_line eq 90)),count) 
		if (count gt 0) then begin
			out_dead_line[index] = fix(calc_dead(flt_line[index])*10)
			out_root_line[index] = fix(calc_root(flt_line[index])*10)
			out_wd_line[index] = fix(calc_wd(flt_line[index])*10)
			out_litter_line[index] = fix(calc_litter_carbon(flt_line[index])*10)
		endif
		
		index = where((line gt 0) and (nlcd_line eq 51), count)
		if (count gt 0) then out_root_line[index] = fix(calc_root_shrub(flt_line[index])*10)

		writeu, dead_lun, out_dead_line
		writeu, root_lun, out_root_line
		writeu, wd_lun, out_wd_line
		writeu, litter_lun, out_litter_line
	endfor

	if (remainder gt 0) then begin
		line = intarr(remainder)
		nlcd_line = bytarr(remainder)
		out_dead_line = intarr(remainder)
		out_root_line = intarr(remainder)
		out_wd_line = intarr(remainder)
		out_litter_line = intarr(remainder)
		readu, in_lun, line
		flt_line = float(line)/10.
		readu, nlcd_lun, nlcd_line

		index = where((line gt 0) and ((nlcd_line eq 41) or (nlcd_line eq 42) or (nlcd_line eq 43) or (nlcd_line eq 90) or (nlcd_line eq 52)),count) 
		if (count gt 0) then begin
			out_dead_line[index] = fix(calc_dead(flt_line[index])*10)
			out_root_line[index] = fix(calc_root(flt_line[index])*10)
			out_wd_line[index] = fix(calc_wd(flt_line[index])*10)
			out_litter_line[index] = fix(calc_litter_carbon(flt_line[index])*10)
		endif
		
		index = where((line gt 0) and ((nlcd_line eq 51) or (nlcd_line eq 52)), count)
		if (count gt 0) then out_root_line[index] = fix(calc_root_shrub(flt_line[index])*10)
		writeu, dead_lun, out_dead_line
		writeu, root_lun, out_root_line
		writeu, wd_lun, out_wd_line
		writeu, litter_lun, out_litter_line
	endif

	free_lun, in_lun
	free_lun, dead_lun
	free_lun, root_lun
	free_lun, wd_lun
	free_lun, litter_lun

	print, 'Done!'
End


