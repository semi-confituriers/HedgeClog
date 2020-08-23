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

func bumpDirection(from_pos: Vector3, dir: Vector2):
	var bump = from_pos + Vector3(dir.x, 0, dir.y) * 0.2
	
	$Tween.interpolate_property(self, "translation",
		from_pos, bump, 0.05,
		Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	playSound("Bump")
	$Tween.interpolate_property(self, "translation",
		bump, from_pos, 0.15,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
