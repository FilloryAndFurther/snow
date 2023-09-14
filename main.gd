extends Node2D
var tilemap;
var total = 0
var timer = 0
var SNOW = 0
var GROUND = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node("TileMap")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var p = tilemap.local_to_map(event.position)
			add_snowflake(tilemap.local_to_map(event.position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= total:
		timer = 0
		snow_storm()
		update_snow()

func update_snow():
	var snow_flakes = tilemap.get_used_cells_by_id(0, SNOW)
	for sf in snow_flakes:
		var bot_pos = tilemap.get_neighbor_cell(sf, 4)
		var bot = tilemap.get_cell_tile_data(0, bot_pos)
		if bot == null:
			update_snowflake_pos(bot_pos, sf)

func add_snowflake(pos: Vector2):
	
	tilemap.set_cell(0, pos, SNOW, Vector2i(0, 0), 0)

func update_snowflake_pos(pos : Vector2, old_pos : Vector2):
	tilemap.set_cell(0, old_pos, -1)
	add_snowflake(pos)

func snow_storm():
	var snow_path = get_node("Path2D/cloud_pos")
	snow_path.progress_ratio = randf()
	var new_snow_tile_pos = tilemap.local_to_map(snow_path.position)
	add_snowflake(new_snow_tile_pos)
