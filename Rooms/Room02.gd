extends Spatial

var has_rotated
var go_eagle_first_time = true

func _ready():
	$Player.Jump_Speed = 0
	$CollisionGridmap.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	LevelManager.current_level = 2
	SoundManager.stop_music()

func _process(delta):
	if has_rotated:
		$Player/POLYMAN_ARMATURE.show()
		$Player/AnimatedSprite3D.hide()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_P:
			rotate_camera_R()
			has_rotated = true
			$Player.Jump_Speed = 15
		if event.pressed and event.scancode == KEY_O:
			rotate_camera_L()
			has_rotated = true
			$Player.Jump_Speed = 15
		if event.pressed and event.scancode == KEY_ESCAPE:
			$Control/Sprite/AnimationPlayer.play("Devil@EscapeLaugh")

var current_rotation = -90

func rotate_camera_R():
	if go_eagle_first_time:
		SoundManager.play_succes()
		go_eagle_first_time = false

	var tween = get_node("SpringArm/SpringArmTween")
	var rot = 0	
	match current_rotation:
		-90:
			rot = 0
		0: 
			rot = 90
		90:
			rot = 180
		180:
			rot = 270
		270:			
			$SpringArm.set_rotation_degrees(Vector3(-45,-90,0))
			rot = 0
	tween.interpolate_property($SpringArm, "rotation_degrees",
			$SpringArm.rotation_degrees, Vector3(-45,rot,0) , 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	current_rotation = rot
	$Player/SpringArm.rotate_y(deg2rad(90))
	
func rotate_camera_L():
	if go_eagle_first_time:
		SoundManager.play_succes()
		go_eagle_first_time = false
	var tween = get_node("SpringArm/SpringArmTween")
	var rot = 0	
	match current_rotation:
		-90:
			$SpringArm.set_rotation_degrees(Vector3(-45,270,0))
			rot = 180
		0: 
			rot = -90
		90:
			rot = 0
		180:
			rot = 90
		270:
			rot = 180
	tween.interpolate_property($SpringArm, "rotation_degrees",
			$SpringArm.rotation_degrees, Vector3(-45,rot,0) , 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	if rot == -180:
		rot = -rot
	current_rotation = rot
	$Player/SpringArm.rotate_y(deg2rad(-90))

func _on_SphereCollider_body_entered(body):
	if body is MainCharacter:
		Transition.fade_to("res://Rooms/Room03.tscn")
	pass
