script practicemode_init 
	if ($game_mode = training)
		if NOT ($current_speedfactor = 1.0)
			setnotemappings \{section = drums
				mapping = $practice_notemapping}
		endif
		hide_band
	endif
	createscreenelement \{type = containerelement
		parent = root_window
		id = practice_container
		pos = (0.0, 0.0)}
	createscreenelement {
		type = textelement
		parent = practice_container
		id = practice_sectiontext
		scale = (1.1, 0.9)
		pos = (640.0, 160.0)
		font = ($practice_font)
		rgba = [255 255 255 255]
		alpha = 0
		just = [center top]
		z_priority = 3
	}
	spawnscriptnow \{practicemode_section}
endscript

script practicemode_section 
	current_section_index = 0
	begin
	getsongtimems
	if (<time> > $current_starttime)
		practice_sectiontext :setprops text = ($current_section_array [($current_section_array_entry)].marker)
		practice_sectiontext :domorph \{alpha = 1.0
			time = 0.5}
		current_section_index = ($current_section_array_entry)
		break
	endif
	wait \{1
		gameframe}
	repeat
	begin
	getsongtimems
	if (<time> > $current_endtime)
		practice_sectiontext :domorph \{alpha = 0.0
			time = 0.5}
		break
	elseif NOT (<current_section_index> = ($current_section_array_entry))
		practice_sectiontext :domorph \{alpha = 0.0
			time = 0.5}
		wait \{0.5
			second}
		practice_sectiontext :setprops text = ($current_section_array [($current_section_array_entry)].marker)
		practice_sectiontext :domorph \{alpha = 1.0
			time = 0.5}
		current_section_index = ($current_section_array_entry)
	endif
	wait \{1
		gameframe}
	repeat
endscript

script practicemode_deinit 
	if ($game_mode = training)
		clearnotemappings \{section = practice}
	endif
	killspawnedscript \{name = practicemode_section}
	if screenelementexists \{id = practice_container}
		destroyscreenelement \{id = practice_container}
	endif
endscript
