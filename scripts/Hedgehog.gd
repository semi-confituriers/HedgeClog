extends Spatial

var tile: Vector2

func playSound(sfx_name: String):
	get_node("Sfx/" + sfx_name).play()

func rollItself():
	$Animations.play("RollItself")

func roast():
	$Animations.play("Roast")
	
func walkToTile(grid: GridMap, dest: Vector2, sliding: bool = false):
	var from = translation
	var to = grid.get_tile_center_vec3(dest)
	tile = dest
	
	var speed = 0.2
	if sliding:
		speed = 0.2 * (to - from).length()
	
	$Tween.interpolate_property(self, "translation",
		from, to, speed,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	if sliding:
		yield(get_tree().create_timer(0.2), "timeout")
		playSound("SlideStart")
		playSound("SlideLoop")
		yield($Tween, "tween_completed")
		get_node("Sfx/SlideLoop").stop()

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
