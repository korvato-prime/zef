extends Spatial

var first_time = true

func _ready():
	$Player.Jump_Speed = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	SoundManager.stop_music()
	LevelManager.current_level = 1

func _process(delta):
	if Input.is_action_pressed("gui_management"):
		$OptionsPanel.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
		
func _on_HSlider_value_changed(value):
	if value < 3:
		$Player/AnimatedSprite3D.show()
		$Player/POLYMAN_ARMATURE.hide()
		$Player/Collider.disabled = true
		get_node("Player/2DCollider").disabled = false
		if first_time:
			SoundManager.play_succes()
			first_time = false
	if value == 5:
		$Player/AnimatedSprite3D.hide()
		$Player/POLYMAN_ARMATURE.show()
		$Player/Collider.disabled = false
		get_node("Player/2DCollider").disabled = true
	
func _on_Button_pressed():
	$OptionsPanel.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
func _on_CameraChange_body_entered(body):
	if body is MainCharacter:
		$Camera2.make_current()
	
func _on_CameraChange_body_exited(body):
	if body is MainCharacter:
		var tween = $Player/SpringArm/Tween
		tween.interpolate_property($Player/SpringArm, "rotation_degrees",
		$Player/SpringArm.rotation_degrees, Vector3(0,90,0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func _on_SphereCollider_body_entered(body):
	if body is MainCharacter:
		$AnimationPlayer.play("New Anim")
		Transition.fade_to("res://Rooms/Room02.tscn")

func _on_FirstCameraChangeArea_body_entered(body):			
	var tween = $Player/SpringArm/Tween
	tween.interpolate_property($Player/SpringArm, "rotation_degrees",
	$Player/SpringArm.rotation_degrees, Vector3(0,0,0), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	$Camera.current = true
