extends Spatial

func _ready():
	LevelManager.current_level = 5
	SoundManager.play_ending()
	pass
	
func _on_Area_body_entered(body):
	if body is MainCharacter:
		$Player.queue_free()
		$TextureRect/AnimationPlayer.play("Ending")
	pass
