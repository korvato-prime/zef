extends Panel

func _on_Button3_pressed():
	$HBoxContainer/Button3.text = "ESCAPE"

func _on_Button2_pressed():
	$HBoxContainer/Button2.text = "NO"

func _on_Button_pressed():
	$VBoxContainer/Button.text = "U AR4 TrAppEd"

func _on_FullscreenCheckBox_pressed():
	$VBoxContainer/FullscreenCheckBox.text = "YOU ARE"

func _on_CheckBox2_pressed():
	$VBoxContainer/CheckBox2.text = "FAT"
