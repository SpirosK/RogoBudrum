class_name Array2D
extends RefCounted
# original author: willnationsdev
# modifications: SpirosK
# description: A 2D Array class
# note: the original file has many more functions. I have only kept the ones I needed.

var data: Array = []


## Creates a rows X cols Array, with zeroes
#
func _init_size(rows: int, cols:int):
	clear()
	for i in range(cols): 
		data.append([])
		for j in range(rows): 
			data[i].append(0)


## Initializes an array by deep-copy or by reference
#
func _init(p_array: Array = [], p_deep_copy : bool = true):
	if p_deep_copy:
		for row in p_array:
			if row is Array:
				data.append(row.duplicate())
	else:
		data = p_array


## Does cell [p_row,p_col] exist?
#
func has_cell(p_row: int, p_col: int) -> bool:
	return len(data) > p_row and len(data[p_row]) > p_col


## Change the value of cell [p_row,p_col]
#  (no check if it exists)
#
func set_cell(p_row: int, p_col: int, p_value):
	data[p_row][p_col] = p_value


## Get the value of cell [p_row,p_col]
#
func get_cell(p_row: int, p_col: int):
	assert(has_cell(p_row, p_col))
	return data[p_row][p_col]


## Does cell [p_pos.x,p_pos.y] exist?
#
func has_cellv(p_pos: Vector2) -> bool:
	return len(data) > p_pos.x and len(data[p_pos.x]) > p_pos.y


## Change the value of cell [p_pos.x,p_pos.y]
#  (no check if it exists)
#
func set_cellv(p_pos: Vector2, p_value):
	data[p_pos.x][p_pos.y] = p_value


## Get the value of cell [p_pos.x,p_pos.y]
#
func get_cellv(p_pos: Vector2):
	assert(has_cellv(p_pos))
	return data[p_pos.x][p_pos.y]


## Retruns the hash!
#
func hash() -> int:
	return hash(self)


## Empties the array
#
func empty() -> bool:
	return len(data) == 0


## Returns the number of elements in the array
#
func size() -> int:
	if len(data) <= 0:
		return 0
	return len(data) * len(data[0])


## Clears the array completely
#
func clear():
	data = []


## Checks if the p_value exists
#
func has(p_value) -> bool:
	for a_row in data:
		for a_col in a_row:
			if p_value == data[a_row][a_col]:
				return true
	return false


## Returns the location of p_value
# (or [-1, -1] for not found
#
func find(p_value) -> Vector2:
	for a_row in data:
		for a_col in a_row:
			if p_value == data[a_row][a_col]:
				return Vector2(a_row, a_col)
	return Vector2(-1, -1)


## Converts Array to string
#
func _to_string() -> String:
	var ret: String
	var width: int = len(data)
	var height: int = len(data[0])
	for h in range(height):
		for w in range(width):
			ret += str(data[w][h])
			if w == width - 1 and h != height -1:
				ret += "\n"
			else:
				if w == width - 1:
					ret += "\n"
				else:
					ret += ", "
	return ret


## SpirosK Addition: returns all cells which have the p_value
## in an array of Vector2i (x = row and y = col)
#
func get_cells_with_value(p_value) -> Array:
	var cells = []
	for a_row in range(data.size()):
		for a_col in range(data[a_row].size()):
			if data[a_row][a_col] == p_value:
				cells.append(Vector2i(a_row, a_col))
	return cells


## SpirosK Addition: returns all cells which DON'T have the p_value
## in an array of Vector2i (x = row and y = col)
#
func get_cells_without_value(p_value) -> Array:
	var cells = []
	for a_row in range(data.size()):
		for a_col in range(data[a_row].size()):
			if data[a_row][a_col] != p_value:
				cells.append(Vector2i(a_row, a_col))
	return cells
