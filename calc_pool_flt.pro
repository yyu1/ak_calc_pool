;Calculates carbon pools, taking in floating point type of AGB map

Pro calc_pool_flt, in_file, out_dead_file, out_root_file, out_wd_file
	infile_info = file_info(in_file)

	file_size = infile_info.size

	;Calculate values in blocks of 1M pixels at a time

	n_blocks = file_size / (1000000ULL * 4ULL)

	remainder = (file_size mod (1000000ULL * 4ULL)) / 4ULL

	line = fltarr(1000000ULL)

	printf, 'Number of blocks to process:', n_blocks

	openr, in_lun, in_file, /get_lun
	openw, dead_lun, out_dead_file, /get_lun
	openw, root_lun, out_root_file, /get_lun
	openw, wd_lun, out_wd_file, /get_lun

	for i=0ULL, n_blocks-1 do begin	
		print, i
		readu, in_lun, line
		writeu, dead_lun, calc_dead(line)
		writeu, root_lun, calc_root(line)
		writeu, wd_lun, calc_wd(line)
	endfor

	if (remainder gt 0) then begin
		line = fltarr(remainder)
		readu, in_lun, line
		writeu, dead_lun, calc_dead(line)
		writeu, root_lun, calc_root(line)
		writeu, wd_lun, calc_wd(line)
	endif

	free_lun, in_lun
	free_lun, dead_lun
	free_lun, root_lun
	free_lun, wd_lun

	print, 'Done!'
End


