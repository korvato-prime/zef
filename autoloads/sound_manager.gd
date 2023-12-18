extends Node

func _ready():
	$AudioStreamPlayer_Music.play()
	pass
	
func stop_music():
	$AudioStreamPlayer_Music.stop()
	
func play_level_ambient():
	$AudioStreamPlayer_Music.stream = load("res://Music/AMBIENT01.wav")
	$AudioStreamPlayer_Music.play()
	
func play_ending():
	$AudioStreamPlayer_Music.stream = load("res://Music/ENDING.wav")
	$AudioStreamPlayer_Music.play()
	
func play_succes():
	$AudioStreamPlayer_SFX.stream = load("res://SFX/PUZZLESOLVED.wav")
	$AudioStreamPlayer_SFX.play()

func play_start():
	$AudioStreamPlayer_SFX.stream = load("res://assets_shared/sound/sfx/START.wav")
	$AudioStreamPlayer_SFX.play()
