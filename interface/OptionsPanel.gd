extends Panel

func _on_FullscreenCheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_CheckBox2_pressed():
	OS.window_borderless = !OS.window_borderless
	pass 
