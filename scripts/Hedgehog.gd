extends Spatial

func playSound(sfx_name: String):
	get_node("Sfx/" + sfx_name).play()

func rollItself():
	$Animations.play("RollItself")

func roast():
	$Animations.play("Roast")

