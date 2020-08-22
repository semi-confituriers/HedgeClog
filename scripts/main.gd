extends Spatial

var locked_hedgehogs = false
var current_level_id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(current_level_id)

func restart_level():
	load_level(current_level_id)
	
func next_level():
	load_level(current_level_id + 1)
	
func load_level(level: int):
	var current_level = $Level
	if current_level:
		current_level.name = "_______Level"
		current_level.queue_free()
		
	locked_hedgehogs = false
	current_level_id = level
	
	var new_level_res = load("res://levels/level" + str(level) + ".tscn")
	var new_level = new_level_res.instance()
	new_level.name = "Level"
	add_child(new_level)

func moveHedgehogs(direction: Vector2):
	for hedgehog in $Level/hedgehogs.get_children():
		$Level/GridMap.try_move(hedgehog, direction)
		
	# Hedgehog proximity detection
	# o(n²) in all its glory !
	for hedgehog in $Level/hedgehogs.get_children():
		if hedgehog.visible == false:
			continue
		
		for hedgehog_friend in $Level/hedgehogs.get_children():
			if hedgehog == hedgehog_friend:
				continue
			
			if hedgehog_friend.visible == false:
				continue
			
			var dist = hedgehog_friend.translation - hedgehog.translation
			if dist.length() < 1.1:
				locked_hedgehogs = true
				hedgehog.get_node('Sprite').play('rolled')
				hedgehog_friend.get_node('Sprite').play('rolled')
				hedgehog.playSound("SpikeBall")
				break
		
		if locked_hedgehogs == true:
			break
		

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
		

