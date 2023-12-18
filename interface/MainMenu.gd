extends Spatial

func _on_TutorialButton_pressed():
	$CanvasLayer/Control/TutorialPanel.show()	
	$CanvasLayer/Control/VBoxContainer.hide()

func _on_StartButton_pressed():
	Transition.yellow_fade_to("res://Rooms/Room01.tscn")
	$CanvasLayer/Control.hide()
	SoundManager.play_start()

func _on_OptionsButton_pressed():
	$CanvasLayer/Control/OptionsPanel.show()
	$CanvasLayer/Control/VBoxContainer.hide()
	pass

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_TutorialReturn_pressed():
	$CanvasLayer/Control/TutorialPanel.hide()
	$CanvasLayer/Control/VBoxContainer.show()
	pass

func _on_Button2_pressed():
	$CanvasLayer/Control/OptionsPanel.hide()
	$CanvasLayer/Control/VBoxContainer.show()
	pass

func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	pass

func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	pass

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	pass
