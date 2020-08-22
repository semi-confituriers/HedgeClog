extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func moveHedgehogs(direction: Vector2):
	for hedgehog in $Level/hedgehogs.get_children():
		$Level/GridMap.try_move(hedgehog, direction)
		#hedgehog.translation += Vector3(direction.x, 0, direction.y)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		moveHedgehogs(Vector2(0, -1));
	elif Input.is_action_just_pressed("ui_left"):
		moveHedgehogs(Vector2(0, 1));
	elif Input.is_action_just_pressed("ui_up"):
		moveHedgehogs(Vector2(-1, 0));
	elif Input.is_action_just_pressed("ui_down"):
		moveHedgehogs(Vector2(1, 0));
		

