extends GridMap

var collision_id_dict = {
	0 : 'C_desk'
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_instantiate_collision_map()
	pass # Replace with function body.

func _instantiate_collision_map():
	for tile_position in get_used_cells(): 
		var item_index = get_cell_item(
			tile_position.x,
			tile_position.y,
			tile_position.z)
		var collision_shape = collision_id_dict.get(item_index)
		if collision_shape:
			var new_collision = get_node(collision_shape).duplicate()
			new_collision.translation = tile_position
			add_child(new_collision)
			

