extends Spatial

var current_level_id = 1

var locked_hedgehogs = false
var level_max = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(current_level_id)
	
	$Gui/Prev.connect("pressed", self, "prev_level")
	$Gui/Next.connect("pressed", self, "next_level")
	$Gui/Restart.connect("pressed", self, "restart_level")

func restart_level():
	load_level(current_level_id)
	
func prev_level():
	load_level(current_level_id - 1)
	
func next_level():
	if current_level_id == level_max:
		load_level(1)
	else:
		load_level(current_level_id + 1)
		
	
func load_level(level: int):
	var current_level = $Level
	if current_level:
		current_level.name = "_______Level"
		current_level.queue_free()
		
	locked_hedgehogs = false
	current_level_id = level
	
	print("Loading level ", level)
	var new_level_res = load("res://levels/level" + str(level) + ".tscn")
	var new_level = new_level_res.instance()
	new_level.name = "Level"
	add_child(new_level)
	
	var grid = new_level.get_node("GridMap")
	for hedgehog in new_level.get_node("hedgehogs").get_children():
		var tile_pos = grid.get_tile_at_vec3(hedgehog.translation)
		hedgehog.tile = tile_pos
		hedgehog.translation = grid.get_tile_center_vec3(tile_pos)
		
	# Gui updating
	$Gui/Level.text = "Level " + str(current_level_id) + " / " + str(level_max)
	$Gui/Prev.disabled = current_level_id == 1
	$Gui/Next.disabled = current_level_id == level_max
		
func hasMovingHedgehogs():
	for hedgehog in $Level/hedgehogs.get_children():
		if hedgehog.moving:
			return true
	return false

func moveHedgehogs(direction: Vector2):
	if hasMovingHedgehogs():
		return
		
	for hedgehog in $Level/hedgehogs.get_children():
		if hedgehog.visible == false:
			continue
		$Level/GridMap.try_move(hedgehog, direction)
		
	while hasMovingHedgehogs():
		yield(get_tree().create_timer(0.05), "timeout")
		
	# Hedgehog proximity detection
	# o(n²) in all its glory !
	for hedgehog in $Level/hedgehogs.get_children():
		if hedgehog.visible == false or hedgehog.dead == true:
			continue
		
		for hedgehog_friend in $Level/hedgehogs.get_children():
			if hedgehog == hedgehog_friend:
				continue
			
			if hedgehog_friend.visible == false or hedgehog.dead == true:
				continue
			
			var dist = hedgehog_friend.tile - hedgehog.tile
			if dist.length() < 1.1:
				locked_hedgehogs = true
				hedgehog.rollItself()
				yield(get_tree().create_timer(0.15), "timeout")
		

func _process(delta):
	if locked_hedgehogs == false:
		if Input.is_action_just_pressed("ui_right"):
			moveHedgehogs(Vector2(0, -1));
		elif Input.is_action_just_pressed("ui_left"):
			moveHedgehogs(Vector2(0, 1));
		elif Input.is_action_just_pressed("ui_up"):
			moveHedgehogs(Vector2(-1, 0));
		elif Input.is_action_just_pressed("ui_down"):
			moveHedgehogs(Vector2(1, 0));
	
	if Input.is_action_just_pressed("ui_restart"):
		restart_level()
		

