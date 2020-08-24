extends Spatial

var tile: Vector2
var moving: bool = false
var dead : bool = false
var elapsed: float = 0

func _ready():
	elapsed = rand_range(-5, 0)
				
func _process(delta):
	elapsed += delta
	if elapsed > 5.2:
		if $Sprite.get_animation() == "idle.1":
			$Sprite.set_animation("idle")
		elapsed = rand_range(-1, 0)
	if elapsed > 5.0:
		if $Sprite.get_animation() == "idle":
			$Sprite.set_animation("idle.1")
			

func playSound(sfx_name: String):
	get_node("Sfx/" + sfx_name).play()

func rollItself():
	$Animations.play("RollItself")

func roast():
	$Animations.play("Roast")
	dead = true
	
func walkToTile(grid: GridMap, dest: Vector2, sliding: bool = false):
	moving = true
	
	var from = grid.get_tile_center_vec3(tile)
	var to = grid.get_tile_center_vec3(dest)
	tile = dest
	
	var speed = 0.2
	if sliding:
		speed = 0.2 * (to - from).length()
		
#		$Tween.interpolate_property(self, "rotation:x",
#			0, 0.4, speed,
#			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	$Tween.interpolate_property(self, "translation",
		from, to, speed,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	if sliding:
		yield(get_tree().create_timer(0.2), "timeout")
		playSound("SlideStart")
		playSound("SlideLoop")
		
		yield($Tween, "tween_all_completed")
		get_node("Sfx/SlideLoop").stop()
		
#		$Tween.interpolate_property(self, "rotation:x",
#			0.4, 0, 0.1,
#			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#		$Tween.start()
	else:
		yield($Tween, "tween_all_completed")
	
	moving = false

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
