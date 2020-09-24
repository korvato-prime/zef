extends Spatial

var pixelman_jumpspeed = 0
var current_form = 0

func _ready():
	$Camera/AnimationPlayer.play("New Anim")
	LevelManager.current_level = 3
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_P:
			change_yourself()
		if event.pressed and event.scancode == KEY_O:
			change_yourself()
		if event.pressed and event.scancode == KEY_ESCAPE:
			$Options.show()
			$ViewportContainer.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
			pass

func change_yourself():
	if current_form == 0:		
		if $Player/AnimatedSprite3D.visible == false:
			$Player/POLYMAN_ARMATURE.hide()
			$Player/AnimatedSprite3D.show()
			$FakePillar/AnimationPlayer.play("FakePillar@Move")
			$Player.Jump_Speed = pixelman_jumpspeed	
			current_form = 1
	else:
		if $Player/POLYMAN_ARMATURE.visible == false:
			$Player/POLYMAN_ARMATURE.show()
			$Player/AnimatedSprite3D.hide()
			$FakePillar/AnimationPlayer.play_backwards("FakePillar@Move")
			$Player.Jump_Speed = 15
			current_form = 0

func _on_SphereCollider_body_entered(body):
	if body is MainCharacter:
		Transition.fade_to("res://Rooms/Room04.tscn")
	pass

func _on_CheckBox_pressed():
	$Options/CheckBox.text = "PIXELMAN CAN --NOT-- JUMP"

func _on_Button_pressed():
	$Options.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	$ViewportContainer.hide()
	pass

func _on_FakeExit_pressed():
	$Options/FakeExit.text = "NO YOU DON'T!!"
	pass
	
func _on_Area2D_body_entered(body):
	if body is NotDragable:
		pixelman_jumpspeed = 15
		$Player.Jump_Speed = pixelman_jumpspeed
		SoundManager.play_succes()
		body.queue_free()
