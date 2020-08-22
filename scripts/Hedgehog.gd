extends Spatial

func playSound(sfx_name: String):
	get_node("Sfx/" + sfx_name).play()
