extends CanvasLayer

var path = ""

func fade_to(scn_path):
	path = scn_path
	get_node("AnimationPlayer").play("Fade")

func change_scene():
	if path != "":
		get_tree().change_scene(path)
		
func yellow_fade_to(scn_path):
	path = scn_path
	get_node("AnimationPlayer").play("YellowFade")
