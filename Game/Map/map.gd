extends Node2D


var enemies_starting_locations = []           # each level has an enemy at the end of each tunnel (if possible). 
											  # So max_enemies==level+1 (stored in array of Vector2's)

## Checks if enemy exists at the given location
#  by going through the locations and check them
#
func enemy_exists_at_location(x1, y1) -> bool:
	for location in enemies_starting_locations:
		if location.x == x1 and location.y == y1:
			return true
	return false


## Adds enemy at location (x1,y1)
#  by creating a new Vector2i and adding it to the list
#
func add_enemy_at_location(x1, y1) -> void:
	var new_location = Vector2i(x1, y1)
	enemies_starting_locations.append(new_location)



## Dungeon Generation using: Random Walk Algorithm
# Adjusted and Corrected, starting from the link below:
# https://www.freecodecamp.org/news/how-to-make-your-own-procedural-dungeon-map-generator-using-the-random-walk-algorithm-e0085c8aa9a/
#  width and height of the map (square) = Global.MAP_SIZE x Global.MAP_SIZE
#
## ARGUMENTS:
# level = which level of dungeon we are in (affects maxTunnels and maxLength)
#
## VALUES IN MAP
# 1 = normal cell
# 2 = exit cell
# 3 = torches cell
#
func create_map(level) -> Array2D:
	var dimensions = Global.MAP_SIZE
	var maxTunnels = level + 1
	var maxLength = level + 3
	var currentRow = 0
	var currentColumn = 0
	var directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]  # the four directions we can go! (UP, DOWN, LEFT, RIGHT)
	var lastDirection = [-1, -1]                  # save the last direction we went
	var currentDirection = [0 ,1]                 # ALWAYS start with a dash to the right
	var remainingTunnels = maxTunnels
	var first_end_column = 0

	var map1 = Array2D.new()
	map1._init_size(Global.MAP_SIZE,Global.MAP_SIZE)
	var rng = RandomNumberGenerator.new()
	enemies_starting_locations.clear()


	##Keeping the last set coords in order to set the exit at the end.
	# DESIGN NOTES: 
	# Initially thought of getting all cells and setting the exit at the remotest one,
	# also setting a random cell for the exit key. However decided against having keys
	# so just settled on the last set cell to be the exit (unless it's 0,0 in which case it will be 0,2)
	#
	var lastSetRow = 0
	var lastSetColumn = 0
	var targetLength = 0 #target length of tunnel for this iteration
	var tunnelLength = 0 #current length of tunnel being created
	while remainingTunnels > 0:
		# lets get a random direction - until it is a perpendicular to our lastDirection
		# if the last direction = left or right, then our new direction has to be up or down,  AND vice versa
		#
		# SpirosK addition: There was a nasty edge case, if you picked a direction which was valid, 
		#                    but had no case to grow, then the next direction would be the same or reverse 
		#                    of the current/last one! Guarding against this with unique directions, then.
		#
		if lastDirection != [-1, -1]: #no value the first time
			if ((lastDirection[0] == 0) && (currentRow == 0)):
				currentDirection[0] = 1
				currentDirection[1] = 0
			elif ((lastDirection[0] == 0) && (currentRow == dimensions - 1)):
				currentDirection[0] = -1
				currentDirection[1] = 0
			elif ((lastDirection[1] == 0) && (currentColumn == 0)):
				currentDirection[0] = 0
				currentDirection[1] = 1
			elif ((lastDirection[1] == 0) && (currentColumn == dimensions - 1)):
				currentDirection[0] = 0
				currentDirection[1] = -1
			else:
				while (currentDirection[0] == -lastDirection[0] && currentDirection[1] == -lastDirection[1]) || (currentDirection[0] == lastDirection[0] && currentDirection[1] == lastDirection[1]):
					var new_dir = rng.randi_range(0,3)
					currentDirection[0] = directions[new_dir][0];
					currentDirection[1] = directions[new_dir][1];

		targetLength = 1 + rng.randi_range(2, maxLength)
		tunnelLength = 0
		

		# looping until our tunnel is long enough or until we hit an edge
		while tunnelLength < targetLength:
			#break the loop if it is going out of bounds
			if (((currentRow == 0) && (currentDirection[0] == -1)) ||
			((currentColumn == 0) && (currentDirection[1] == -1)) ||
			((currentRow == dimensions - 1) && (currentDirection[0] == 1)) ||
			((currentColumn == dimensions - 1) && (currentDirection[1] == 1))):
				break
			else:
				#30% chance to have a cell with lights!
				# Then 50% chance for the light to be either torch or stone fire
				var cell_value = 1
				if rng.randi_range(1, 3) == 3:
					if rng.randi_range(1, 2) == 1:
						cell_value =3 
					else:
						cell_value =4

				map1.set_cell(currentRow, currentColumn, cell_value)   #Cell with torches!
				lastSetRow = currentRow
				lastSetColumn = currentColumn
				currentRow += currentDirection[0]              #add the value from currentDirection to row and col (-1, 0, or 1) to update our location
				currentColumn += currentDirection[1];
				tunnelLength+=1                               #the tunnel is now one longer, so lets increment that variable

		# Adding an enemy at the end of the tunnel if no other enemy exists
		#
		if not enemy_exists_at_location(lastSetRow, lastSetColumn):
			if (not (lastSetRow == 0 and lastSetColumn == 0)) and remainingTunnels >= 1:
				add_enemy_at_location(lastSetRow, lastSetColumn)
				
		#Setting the first end, in case we end up at the first row at the end!
		#lastDirection = what way we went
		if lastDirection == [-1, -1]: 
			first_end_column = currentColumn
		lastDirection[0] = currentDirection[0]
		lastDirection[1] = currentDirection[1]
		remainingTunnels-=1                                   #we created a whole tunnel so lets decrement by 1
	
	#ADDDING AN EXIT!
	if lastSetRow == 0 and lastSetColumn < first_end_column:
		lastSetColumn = first_end_column
	map1.set_cell(lastSetRow, lastSetColumn, 2)  

	##DEBUG prints
	#print(map1)
	#print (enemies_starting_locations)
	#print ("Map Completed!")
	return map1
