extends Node3D

@onready var topFace: = $Top
@onready var northFace: = $North
@onready var eastFace: = $East
@onready var southFace: = $South
@onready var westFace: = $West
@onready var bottomFace: = $Bottom
var value = 1

## Set any special cell types 
#
func set_special_cell(special_cell_type) -> void:
	if (special_cell_type == Global.cell_type.EXIT):
		value = 2

## When there is a neighbouring tile in any direction, then the face is removed!
#
func update_faces(cell_list) -> void:
	var my_grid_position = Vector2i(global_transform.origin.x / Global.GRID_SIZE, global_transform.origin.z / 1)
	
	# delete face when there is another cell
	if cell_list.has(my_grid_position+Vector2i.RIGHT):
		eastFace.queue_free()
	if cell_list.has(my_grid_position+Vector2i.LEFT):
		westFace.queue_free()
	if cell_list.has(my_grid_position+Vector2i.DOWN):
		southFace.queue_free()
	if cell_list.has(my_grid_position+Vector2i.UP):
		northFace.queue_free()
