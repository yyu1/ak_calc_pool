;Calculates carbon pools, taking in floating point type of AGB map

Pro calc_pool_flt, in_file, nlcd_file, out_dead_file, out_root_file, out_wd_file
	infile_info = file_info(in_file)

	file_size = infile_info.size

	;Calculate values in blocks of 1M pixels at a time

	n_blocks = file_size / (1000000ULL * 4ULL)

	remainder = (file_size mod (1000000ULL * 4ULL)) / 4ULL

	line = fltarr(1000000ULL)
	nlcd_line = bytarr(1000000ULL)
	out_dead_line = fltarr(1000000ULL)
	out_root_line = fltarr(1000000ULL)
	out_wd_line = fltarr(1000000ULL)

	print, 'Number of blocks to process:', n_blocks

	openr, in_lun, in_file, /get_lun
	openr, nlcd_lun, nlcd_file, /get_lun
	openw, dead_lun, out_dead_file, /get_lun
	openw, root_lun, out_root_file, /get_lun
	openw, wd_lun, out_wd_file, /get_lun

	for i=0ULL, n_blocks-1 do begin	
		print, i
		readu, in_lun, line
		readu, nlcd_lun, nlcd_line
		;trees
		out_dead_line[*] = 0
		out_root_line[*] = 0
		out_wd_line[*] = 0
		
		index = where((line gt 0) && ((nlcd_line eq 41) || (nlcd_line eq 42) || (nlcd_line eq 43)),count) 
		if (count gt 0) then begin
			out_dead_line[index] = calc_dead(line[index])
			out_root_line[index] = calc_root(line[index])
			out_wd_line[index] = calc_wd(line[index])
		endif
		
		index = where((line gt 0) && ((nlcd_line eq 51) || (nlcd_line eq 52)), count)
		if (count gt 0) then out_root_line[index] = calc_root_shrub(line[index])

		writeu, dead_lun, out_dead_line
		writeu, root_lun, out_root_line
		writeu, wd_lun, out_wd_line
	endfor

	if (remainder gt 0) then begin
		line = fltarr(remainder)
		nlcd_line = bytarr(remainder)
		out_dead_line = fltarr(remainder)
		out_root_line = fltarr(remainder)
		out_wd_line = fltarr(remainder)
		readu, in_lun, line
		readu, nlcd_lun, nlcd_line

		index = where((line gt 0) && ((nlcd_line eq 41) || (nlcd_line eq 42) || (nlcd_line eq 43)),count) 
		if (count gt 0) then begin
			out_dead_line[index] = calc_dead(line[index])
			out_root_line[index] = calc_root(line[index])
			out_wd_line[index] = calc_wd(line[index])
		endif
		
		index = where((line gt 0) && ((nlcd_line eq 51) || (nlcd_line eq 52)), count)
		if (count gt 0) then out_root_line[index] = calc_root_shrub(line[index])
		writeu, dead_lun, out_dead_line
		writeu, root_lun, out_root_line
		writeu, wd_lun, out_wd_line
	endif

	free_lun, in_lun
	free_lun, dead_lun
	free_lun, root_lun
	free_lun, wd_lun

	print, 'Done!'
End


