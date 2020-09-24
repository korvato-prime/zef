extends KinematicBody

class_name MainCharacter

export var Sensitivity_X: float = 0.01
export var Sensitivity_Y: float = 0.01

export var Jump_Speed: float = 15.0
export var Acceleration: float = 10
export var Walk_Max_Speed: float = 6
export var Sprint_Max_Speed: float = 10
export var Rotate_Model_Step: float = PI * 2.0
export var GravityFloorMul: float = 20.0
export var GravityFlyMul: float = 3.0
export var GravityExternalMul: float = 1.0
const ZOOM_MIN = 0.5
const ZOOM_MAX = 5
const Zoom_Step: float = 0.3
const MIN_ROT_Y = -1.55
const MAX_ROT_Y = 0.79
const GRAVITY = 9.8

onready var camera_node: Spatial = $SpringArm
onready var model_node: Spatial = $POLYMAN_ARMATURE/Armature/Skeleton
onready var state_machine: AnimationTree = $POLYMAN_ARMATURE/AnimationTree2

var move_dir: Vector2 = Vector2()
var velocity: Vector3 = Vector3()
var max_speed: float = Walk_Max_Speed
var current_speed: float = 0.0
var jumping: bool = false setget _set_jumping
var gravity: float
var target_angle_model: float = 0.0
var rot_model: float = 0.0
var old_angle_model:float = 0.0

var is_playing_step = false

var last_move_dir = Vector2(0,0)

var GUI_management: bool = false;

func _input(event):
	var temp: Vector2 = Vector2()
	temp = move_dir
	move_dir = Vector2(Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"),
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")).normalized()		
	if move_dir!= temp: 
		rot_model =0
		old_angle_model = target_angle_model
		if move_dir.x < 0 and move_dir.y ==0:
			target_angle_model = 0
		if move_dir.x > 0 and move_dir.y ==0:
			target_angle_model = PI
		if move_dir.x == 0 and move_dir.y >0:
			target_angle_model = -PI/2
		if move_dir.x == 0 and move_dir.y <0:
			target_angle_model = PI/2
		if move_dir.x < 0 and move_dir.y >0:
			target_angle_model = -PI/4
		if move_dir.x < 0 and move_dir.y <0:
			target_angle_model = PI/4
		if move_dir.x > 0 and move_dir.y >0:
			target_angle_model = -PI*3/4
		if move_dir.x > 0 and move_dir.y <0:
			target_angle_model= PI*3/4
		
		if target_angle_model - old_angle_model >PI:
			old_angle_model +=2*PI
		if target_angle_model - old_angle_model < -PI:
			old_angle_model -=2*PI
	
	if event.is_action_pressed("jump") and is_on_floor():
		jumping = true	

func _physics_process(delta):
	if is_on_floor():
		gravity = GRAVITY * GravityFloorMul * GravityExternalMul
		if max_speed < current_speed or move_dir ==Vector2.ZERO:
			current_speed -= Acceleration*delta
		else:
			current_speed += Acceleration*delta
		current_speed = clamp(current_speed,0,Sprint_Max_Speed)
		
		if move_dir !=Vector2.ZERO:
			velocity.z = move_dir.x*current_speed
			velocity.x = move_dir.y*current_speed
			velocity = velocity.rotated(Vector3.UP, camera_node.rotation.y)
			model_node.rotation.y = camera_node.rotation.y+PI
			rot_model = min(rot_model+delta*Rotate_Model_Step, 1)
			model_node.rotation.y += lerp(old_angle_model, target_angle_model, rot_model)
			if model_node.rotation.y >PI:
				model_node.rotation.y -= PI*2
			if model_node.rotation.y < -PI:
				model_node.rotation.y += PI*2
		else:
			velocity=velocity.normalized() #Сохраняем старое направление движения, потому что мы отпустили кнопки и замедляемся
			velocity.x = velocity.x*current_speed
			velocity.z = velocity.z*current_speed
		if jumping:
			velocity.y += Jump_Speed
			jumping = false
			
		state_machine.set("parameters/Moving/blend_position", Vector2(velocity.x,velocity.z).length())
		
		set_pixelman_animation()		
	
	else:
		gravity = GRAVITY * GravityFlyMul * GravityExternalMul
	
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP,true)
	
	state_machine.set("parameters/conditions/is_floor", is_on_floor())
	state_machine.set("parameters/conditions/is_not_floor", !is_on_floor())

func _set_jumping(_jumping: bool):
	jumping = _jumping
	state_machine.set("parameters/conditions/is_jump", _jumping)
	pass

#Hacky code
func set_pixelman_animation():
	#PIXELMAN	
	if LevelManager.current_level == 1:
		if current_speed > 0:
			if move_dir.y == -1:
				last_move_dir = Vector2(0,-1)
				if !($AnimatedSprite3D.animation == "WALKING_UP"):
						$AnimatedSprite3D.play("WALKING_UP")
			if move_dir.y == 1:
				last_move_dir = Vector2(0,1)
				if !$AnimatedSprite3D.animation == "WALKING_DOWN":
					$AnimatedSprite3D.play("WALKING_DOWN")
			if move_dir.x == 1:
				last_move_dir = Vector2(1,0)
				$AnimatedSprite3D.flip_h = true
				if !$AnimatedSprite3D.animation =="WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
			if move_dir.x == -1:
				last_move_dir = Vector2(-1,0)
				$AnimatedSprite3D.flip_h = false
				if !$AnimatedSprite3D.animation == "WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
		else:
			if last_move_dir == Vector2(1,0):
				if $AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(-1,0):
				if !$AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(0,1):
				if !$AnimatedSprite3D.animation =="IDLE_DOWN":
					$AnimatedSprite3D.play("IDLE_DOWN")
			if last_move_dir == Vector2(0,-1):
				if !$AnimatedSprite3D.animation == "IDLE_UP":
					$AnimatedSprite3D.play("IDLE_UP")					
	if LevelManager.current_level == 2:
		if current_speed > 0:
			if move_dir.y == -1:
				last_move_dir = Vector2(1,0)
				$AnimatedSprite3D.flip_h = true
				if !$AnimatedSprite3D.animation =="WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
			if move_dir.y == 1:
				last_move_dir = Vector2(-1,0)
				$AnimatedSprite3D.flip_h = false
				if !$AnimatedSprite3D.animation == "WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
			if move_dir.x == 1:
				last_move_dir = Vector2(0,1)
				if !$AnimatedSprite3D.animation == "WALKING_DOWN":
					$AnimatedSprite3D.play("WALKING_DOWN")
			if move_dir.x == -1:							
				last_move_dir = Vector2(0,-1)	
				if !($AnimatedSprite3D.animation == "WALKING_UP"):
						$AnimatedSprite3D.play("WALKING_UP")
		else:
			if last_move_dir == Vector2(1,0):
				if $AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(-1,0):
				if !$AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(0,1):
				if !$AnimatedSprite3D.animation =="IDLE_DOWN":
					$AnimatedSprite3D.play("IDLE_DOWN")
			if last_move_dir == Vector2(0,-1):
				if !$AnimatedSprite3D.animation == "IDLE_UP":
					$AnimatedSprite3D.play("IDLE_UP")
					
	if LevelManager.current_level == 3:
		if current_speed > 0:
			if move_dir.y == -1:
				last_move_dir = Vector2(1,0)
				$AnimatedSprite3D.flip_h = true
				if !$AnimatedSprite3D.animation =="WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
			if move_dir.y == 1:
				last_move_dir = Vector2(-1,0)
				$AnimatedSprite3D.flip_h = false
				if !$AnimatedSprite3D.animation == "WALKING_SIDE":
					$AnimatedSprite3D.play("WALKING_SIDE")
			if move_dir.x == 1:
				last_move_dir = Vector2(0,1)
				if !$AnimatedSprite3D.animation == "WALKING_DOWN":
					$AnimatedSprite3D.play("WALKING_DOWN")
			if move_dir.x == -1:							
				last_move_dir = Vector2(0,-1)	
				if !($AnimatedSprite3D.animation == "WALKING_UP"):
						$AnimatedSprite3D.play("WALKING_UP")
		else:
			if last_move_dir == Vector2(1,0):
				if $AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(-1,0):
				if !$AnimatedSprite3D.flip_h:
					$AnimatedSprite3D.play("IDLE_SIDE")
			if last_move_dir == Vector2(0,1):
				if !$AnimatedSprite3D.animation =="IDLE_DOWN":
					$AnimatedSprite3D.play("IDLE_DOWN")
			if last_move_dir == Vector2(0,-1):
				if !$AnimatedSprite3D.animation == "IDLE_UP":
					$AnimatedSprite3D.play("IDLE_UP")

