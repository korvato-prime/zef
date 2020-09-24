extends Spatial

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if $Player/Head/Camera.rotation_degrees.x < -80:
				go_eagle()
			
func go_eagle():	
	SoundManager.play_succes()
	$Player.can_rotate = false
	$Camera.transform
	var tween = $Player/Head/Camera/CameraTween
	tween.interpolate_property($Player/Head/Camera, "translation",
		$Player/Head/Camera.translation, Vector3(6,16,-2), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	tween.interpolate_property($Player/Head/Camera, "projection",
		$Player/Head/Camera.projection,1, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property($Player/Head/Camera, "transform",
	$Player/Head/Camera.transform,$Camera.transform, 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween.interpolate_property($Player/Head/Camera, "rotation_degrees",
	$Player/Head/Camera.rotation_degrees, Vector3(-90,0,0), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_CameraTween_tween_all_completed():
	$Spatial7.queue_free()
	$Player/Head/Camera/Control/Control/Crosshair.hide()
	$Player/Sprite3D.show()

func _on_SphereCollider_body_entered(body):
	if body is MainCharacterFP:
		Transition.fade_to("res://Rooms/Room05.tscn")
