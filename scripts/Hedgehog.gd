extends Spatial

func playSound(sfx_name: String):
	get_node("Sfx/" + sfx_name).play()

func rollItself():
	$Animations.play("RollItself")

func roast():
	$Animations.play("Roast")
	
func walkToPos(dest: Vector3):
	var from = translation
	$Tween.interpolate_property(self, "translation",
		from, dest, 0.2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
