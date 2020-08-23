extends GridMap


var tile_props = {
	"tile_desk": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_wall": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_wall_corner": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_wall_angle": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_table_1": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_table_2": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_armoire": { "init": null, "on_enter": null, "collision": "/root/Game/CollisionLib/C_full" },
	"tile_floor": {
		"init": null,
		"on_enter": null,
		"collision": null,
	},
	"tile_fire": {
		"init": funcref(self, "on_init_fire"),
		"on_enter": funcref(self, "on_enter_fire"),
		"collision": null,
	},
	"tile_exit": {
		"init": null,
		"on_enter": funcref(self, "on_enter_exit"),
		"collision": null,
	},
	"_": {
		"init": null,
		"on_enter": null,
		"collision": null,
	},
}

func _get_tile_props(tile_item_id: int):
	var name = mesh_library.get_item_name(tile_item_id)
	return tile_props.get(name, tile_props["_"])
		
func get_tile_at(pos: Vector2) -> Vector2:
	return Vector2(floor(pos.x), floor(pos.y))
	
func get_tile_at_vec3(pos: Vector3) -> Vector2:
	return get_tile_at(Vector2(floor(pos.x), floor(pos.z)))
	
	
func get_tile_center(tile_pos: Vector2) -> Vector2:
	return tile_pos + Vector2(0.5, 0.5)
	
func get_tile_center_vec3(tile_pos: Vector2) -> Vector3:
	return Vector3(tile_pos.x + 0.5, 0, tile_pos.y + 0.5)
	
func try_move(hedgehog: Node, direction: Vector2):
	var from_cell = get_tile_at(Vector2(hedgehog.translation.x, hedgehog.translation.z))
	var to_cell = from_cell + direction
	
	var to_cell_id = get_cell_item(to_cell.x, 0, to_cell.y)
	if to_cell_id == INVALID_CELL_ITEM:
		return false
		
	var ray_start = Vector3(hedgehog.translation.x, 1, hedgehog.translation.z)
	var ray_end = Vector3(to_cell.x + 0.5, 1, to_cell.y + 0.5)

	var space_state = get_world().direct_space_state
	var intersect = space_state.intersect_ray(ray_start, ray_end, [], 0b10)

	if intersect:
		hedgehog.bumpDirection(get_tile_center_vec3(from_cell), direction)
		return false
	
	# Move hedgehog
	var dest = get_tile_center(to_cell)
	#hedgehog.translation = Vector3(dest.x, 0, dest.y)
	hedgehog.walkToTile(self, to_cell)
	
	# OnEnter callback
	var tile_props = _get_tile_props(to_cell_id)
	if tile_props.on_enter != null:
		tile_props.on_enter.call_func(hedgehog)
		
	return true



func _ready():
	# Instanciate collision objects
	for tile_position in get_used_cells():
		var cell_id = get_cell_item(
			tile_position.x,
			tile_position.y,
			tile_position.z)
		var tile_center = tile_position + Vector3(0.5, 0, 0.5)
		var tile_props = _get_tile_props(cell_id)
		if tile_props.collision:
			var new_collision = get_node(tile_props.collision).duplicate()
			new_collision.translation = tile_center
			add_child(new_collision)
			
		if tile_props.init != null:
			tile_props.init.call_func(tile_center)



func on_init_fire(center: Vector3):
	var fire_scene = load("res://scenes/tile_fire.tscn")
	var fire_inst = fire_scene.instance()
	fire_inst.translation = center
	add_child(fire_inst)
	
func on_enter_fire(hedgehog: Node):
	hedgehog.roast()
	get_node("/root/Game").locked_hedgehogs = true


func on_enter_exit(hedgehog: Node):
	hedgehog.visible = false
	
	var finished = true
	for hedgehog in get_node("/root/Game/Level/hedgehogs").get_children():
		if hedgehog.visible == true:
			finished = false
			break
		
	
	if finished:
		get_node("/root/Game").locked_hedgehogs = true
		hedgehog.playSound("Victory")
		yield(get_tree().create_timer(1.0), "timeout")
		get_node("/root/Game").next_level()
	else:
		hedgehog.playSound("Exited")
	
	
	


