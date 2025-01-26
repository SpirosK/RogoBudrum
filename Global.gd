extends Node

## Useful Variables
#
var current_lvl = 1      #holds the current level number
var current_map:Array2D  #holds the current map.
var pause_input = false  #is player input paused?
var cells = []           #the maze cells
var enemies = []         #the enemies
var enemy_locations = [] #the STARTING location of enemies 
						 #(current one is handled in every enemy in the "enemies" array)
var rng = RandomNumberGenerator.new()

## Useful objects
#
var the_player
var the_UI_label:TextEdit
var the_UI_attack:Sprite2D
var the_UI_attack_player:Sprite2D
var the_UI_HP:ProgressBar
var worldTimer:Timer
var in_between_dialog = preload("res://Game/UI/UiBetweenLevels.tscn")

## Useful UIs
#
var STR_UI:Button
var DEX_UI:Button
var WIS_UI:Button
var EYE_UI:Button


## Constants that control the configuration
#
const GRID_SIZE = 1
const MAP_SIZE  = 30
const CELL            = preload("res://Game/cell/cell.tscn")
const CELL_STONELIGHT = preload("res://Game/cell/cell_stonelight.tscn")
const CELL_TORCHES    = preload("res://Game/cell/cell_torches.tscn")
const CELL_EXIT       = preload("res://Game/cell/cell_exit.tscn")
const THE_ENEMIES = [preload("res://Game/enemies/enemy_001.tscn"), preload("res://Game/enemies/enemy_002.tscn"),
preload("res://Game/enemies/enemy_003.tscn"), preload("res://Game/enemies/enemy_004.tscn"),
preload("res://Game/enemies/enemy_005.tscn"), preload("res://Game/enemies/enemy_006.tscn"),
preload("res://Game/enemies/enemy_007.tscn"), preload("res://Game/enemies/enemy_008.tscn"),
preload("res://Game/enemies/enemy_009.tscn"), preload("res://Game/enemies/enemy_010.tscn"),
preload("res://Game/enemies/enemy_011.tscn"), preload("res://Game/enemies/enemy_012.tscn"),
preload("res://Game/enemies/enemy_013.tscn"), preload("res://Game/enemies/enemy_014.tscn"),
preload("res://Game/enemies/enemy_015.tscn"), preload("res://Game/enemies/enemy_016.tscn"),
preload("res://Game/enemies/enemy_017.tscn"), preload("res://Game/enemies/enemy_018.tscn"),
preload("res://Game/enemies/enemy_boss.tscn")]
const THE_MAP         = preload("res://Game/Map/map.tscn")


## Useful ENUMerations 
#
enum player_class {
	CLERIC,
	MAGE,
	RANGER,
	WARRIOR
}

enum attacks_enum {
	MELEE,
	RANGE
}

# The Cell Types in this game
enum cell_type {
	NORMAL,
	EXIT,
	TORCHES,
	STONELIGHT
}


## TODO: For when having all 4 classes
#
var classes_HPs = {
	player_class.CLERIC: 13,
	player_class.MAGE: 9,
	player_class.WARRIOR: 15,
	player_class.RANGER: 11
}

var classes_names = {
	player_class.CLERIC: "Cleric",
	player_class.MAGE: "Mage",
	player_class.WARRIOR: "Warrior",
	player_class.RANGER: "Ranger"	
}


## Updates the UI to have the correct numbers
#
func update_stats_UI() -> void:
	STR_UI.text = str(the_player.Str)
	DEX_UI.text = str(the_player.Dex)
	WIS_UI.text = str(the_player.Wis)
	EYE_UI.text = str(the_player.Eye)


## Setting the current map
#
func set_current_map(new_map: Array2D) -> void:
	if current_map:
		current_map.clear()
	current_map = new_map


## This is called when the player dies.
# Prints message and resets the world to level 1
#
func the_player_died() -> void:
	print_text("Through the blackness, you head towards the light tunnel...")
	goto_first_level()


## Updating the Current and Max HPs
#
func update_HP_bar(new_cur_HPs, new_max_HPs) -> void:
	if the_UI_HP:   #The very first time, it might be called before the UI is ready!
		the_UI_HP.max_value = new_max_HPs
		the_UI_HP.value     = new_cur_HPs


## Prints text in the text-box
#
func print_text(new_text:String) -> void:
	the_UI_label.text = ("  " + new_text + "\n") + the_UI_label.text


## Gets the cell type at the current coordinates
#
func get_cell_type(x: int, y: int) -> cell_type: 
	if current_map.get_cell(x, y) == 2:
		return cell_type.EXIT
	elif current_map.get_cell(x, y) == 3:
		return cell_type.TORCHES
	elif current_map.get_cell(x, y) == 4:
		return cell_type.STONELIGHT
	return cell_type.NORMAL


## Process to go to the next level 
#  (before in-between)
#  1. pause player input
#  2. load the in-between levels scene AND PAUSE
#  (after the in-between scene unpauses and leaves)
#  3. create new map
#  4. position player to start of new map
#  5. (TODO: optional) play a video or fade-in animation
#  6. unpause player input
#
func goto_next_level():
	pause_the_input()
	current_lvl += 1     #Check for last level here (TODO) >> Special design maybe with boss maybe.
	get_parent().add_child(in_between_dialog.instantiate())  #it's our sibling!
	get_tree().paused = true  #the in_between_scene will unpause this
	var map = THE_MAP.instantiate()
	var new_map = map.create_map(current_lvl)
	set_current_map(new_map)
	the_player.reset_player_position()
	# Heal the player 10-20 percent of his max HPs
	var heal_perecentage = rng.randi_range(10, 20)
	var heal_hp:int = int(float(the_player.max_HPs) / 100.0 * float(heal_perecentage))
	heal_hp = heal_hp if the_player.max_HPs - the_player.cur_HPs > heal_hp else the_player.max_HPs - the_player.cur_HPs
	the_player.cur_HPs += heal_hp
	update_HP_bar(the_player.cur_HPs, the_player.max_HPs)
	print_text("You heal for " + str(heal_hp) + " HPs")
	# Create the map and the enemies for the next level
	create_world(current_map)
	enemies_create(map.enemies_starting_locations, current_lvl)
	print_text("Welcome to level " + str(current_lvl) + " !")
	unpause_the_input()
	#print (map.enemies_starting_locations)


## Process to go to the first level after death.
# 1. You keep all levelling up (STR, DEX, etc)
# 2. Level goes back to being 1
# 3. Equipment resets to the starting one
# 4. Otherwise the same as "goto_next_level()s"
#
func goto_first_level():
	pause_the_input()
	current_lvl = 1 
	the_player.reset_HPs()
	var map = THE_MAP.instantiate()
	var new_map = map.create_map(current_lvl)
	set_current_map(new_map)
	the_player.reset_player_position()
	Inventory.reset_weapons()
	create_world(current_map)
	enemies_create(map.enemies_starting_locations, 1)
	print_text("This feels very familiar... Were you here before?")
	unpause_the_input()	
	#TODO: maybe add an animation of lgiht tunnel


## Process to go to the restart the game.
#  1. pause player input
#  2. create new map
#  3. position player to start of new map
#  4. (TODO IF inventory implemented) Reset the player's imvemtory to empty!
#  6. unpause player input
#
#  NOTES: Player keeps all stats, but the equipment is reset to the starting one.
#  TODO:  If it becomes non-debug, player's stats must be reset as well
#
func restart_game():
	pause_the_input()
	current_lvl = 1
	var map = THE_MAP.instantiate()
	var new_map = map.create_map(current_lvl)
	set_current_map(new_map)
	the_player.reset_player_position()
	Inventory.reset_to_starting()
	create_world(current_map)
	the_UI_label.text = ("Welcome to level 1 again!\n Seems like you found this dungeon very hard?")
	unpause_the_input()


## Indication that input is paused
#
func pause_the_input() -> void:
	pause_input = true
	worldTimer.stop()


## Indication that input is non-paused
#
func unpause_the_input() -> void:
	pause_input = false
	worldTimer.start()


## Creates the World (3D areas) from the 2D map
#
func create_world(grid_map: Array2D) -> void:
	# Free older cells if exist
	for cell in cells:
		cell.free()
	cells.clear()

	var used_tiles = grid_map.get_cells_without_value(0) #used to be "with_value", but then we added special types

	## Making the 3D Cell maze 
	# 1. Reading the tiles
	# 2. Adding each cell to its 3D position by multiplying coords with size
	# 3. Updating Faces to remove walls of neighbours
	#
	for tile in used_tiles:
		var cell
		# TODO: Now that they have become a lot, it would be better to have a dict for these instead of ifs.
		#
		if grid_map.get_cell(tile.x, tile.y) == 2:
			#print ("EXIT AT: " + str(tile.x) + " x " + str(tile.y))
			cell = CELL_EXIT.instantiate()
		elif grid_map.get_cell(tile.x, tile.y) == 3:
			cell = CELL_TORCHES.instantiate()
		elif grid_map.get_cell(tile.x, tile.y) == 4:
			cell = CELL_STONELIGHT.instantiate()
		else:
			cell = CELL.instantiate()
		add_child(cell)
		cells.append(cell)
		#print ("USED: " + str(tile.x) + " x " + str(tile.y))
		cell.global_transform.origin = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)

	for cell in cells:
		cell.update_faces(used_tiles)


## Clears up any remaining enemies!
#
func enemies_clear():
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	enemy_locations.clear()


## Shows the enemy attack PNG and then starts a timer to hide it
#
func show_UI_attack(attack_type:attacks_enum) -> void:
	if attack_type == attacks_enum.MELEE:
		the_UI_attack.change_to_melee()
	elif attack_type == attacks_enum.RANGE:
		the_UI_attack.change_to_range()

	the_UI_attack.visible = true
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(hide_UI_attack)


## Shows the player attack PNG and then starts a timer to hide it
#
func show_UI_attack_player(attack_type:attacks_enum) -> void:
	if attack_type == attacks_enum.MELEE:
		the_UI_attack_player.change_to_melee()
	elif attack_type == attacks_enum.RANGE:
		the_UI_attack_player.change_to_range()

	the_UI_attack_player.visible = true
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(hide_UI_attack_player)


## Hides the enemy attack PNG (from timer)_
#
func hide_UI_attack() -> void:
	the_UI_attack.visible = false


## Hides the player attack PNG (from timer)_
#
func hide_UI_attack_player() -> void:
	the_UI_attack_player.visible = false


## Is the X line between enemy and player clear? (used to check range hits and enemy-sight)
#
func has_clear_X_sight(x_line, enemy_location_y, player_location_y) -> bool:
	var starting_y = enemy_location_y
	var ending_y   = player_location_y
	if ending_y < starting_y:
		starting_y = player_location_y
		ending_y   = enemy_location_y
	for cell_y in range(starting_y, ending_y):
		if enemies_at_location_xy(x_line, cell_y) or not has_cell_at_xy(x_line, cell_y):
			#print("Blocked at " + str(x_line) + "," + str(cell_y))
			return false
	return true


## Is the Y line between enemy and player clear? (used to check range hits and enemy-sight)
#
func has_clear_Y_sight(y_line, enemy_location_x, player_location_x) -> bool:
	var starting_x = enemy_location_x
	var ending_x   = player_location_x
	if ending_x < starting_x:
		starting_x = player_location_x
		ending_x   = enemy_location_x
	for cell_x in range(starting_x, ending_x):
		if enemies_at_location_xy(cell_x, y_line) or not has_cell_at_xy(cell_x, y_line):
			#print("Blocked at " + str(cell_x) + "," + str(y_line))
			return false
	return true


## Checks if given coords are out of bounds
#  (we know that it is always called with a two-pos array, let's not get paranoid)
#
func is_out_of_bounds(check_coords):
	if (check_coords[0] < 0 or check_coords[0] >= MAP_SIZE or check_coords[1] < 0 or check_coords[1] >= MAP_SIZE):
		#print ("OUT OF BOUNDS: " + str(check_coords[0]) + "," + str(check_coords[1]))
		return true
	return false


## The player attacks with Melee Weapon "mel_weap"
#  What happens:
#  1. is it melee weapon?
#  2. Calculate WHERE is in front
#  3. Is enemy there?
#  4. If Enemy There. draw Slash2 (timed)
#  5. Damage Enemy 
#
func calculate_melee_hit(mel_weap):
	#1.
	if mel_weap.type_of_item != Inventory.item_type.MELEE_WEAPON:
		Global.print_text("!!!!!Can't melee hit with that!!!!!")
		return
	#2.
	var hit_coords = the_player.get_coords_infront()
	if is_out_of_bounds(hit_coords):
		return
	#3.
	if not enemies_at_location_xy(hit_coords[0], hit_coords[1]):
		return
	#4.
	show_UI_attack_player(attacks_enum.MELEE)
	#5.
	var damage_done = mel_weap.get_damage(the_player.Str)
	Global.print_text("You attack for " + str(damage_done) + " damage!")
	var enemy_at_location = get_enemy_at_location(hit_coords[0], hit_coords[1])
	if enemy_at_location == null:
		print ("ENEMY_AT_LOCATION SHOULD NOT BE NULL!! BUG FOUND?")
		return
	enemy_at_location.damaged(damage_done)


## Actions all the enemies
# Actions can be: movement to player and/or attacking player
# IDEA:: Initially I thought of using any path algorithm to make the enemy head towards the player
#        I had also thought of having the enemies actually hear/see the player. 
#        However when I started designing this "apparent AI", I realised it would be an overkill for this env.
#        Also, the single-corridors style of it, would lead to enemies being queued one behind the other in larger levels,
#        which would degrade the experience for the player as well IMO.
#        So, I opted for a simple "cheat": if the gamer is within +-10 squares the enemy will try to move towards them.
#        It will do so in the dumbest way possible (so as to remain in the same area and not queue up, but also move to them if within 'sight')
#        ((Thank you for attending my TED talk))
#
func enemies_action():
	var player_location:Vector2 = the_player.get_location2D()
	for enemy:BaseEnemy in enemies:
		if not enemy.is_time_to_act():
			continue 

		var enemy_location:Vector2 = enemy.position2D
		#print ("Enemy  stands at: " + str(enemy_location.x) + "x" + str(enemy_location.y))
		#print ("Player stands at: " + str(player_location.x) + "x" + str(player_location.y))
		#print ("Their distance is = " + str(player_location.distance_to(enemy_location)))
		var enemy_attacked = false

		#print ("MOVING ON TO CHECK MELEE -- START")
		# CHECK IF ENEMY HAS MELEE AND IS NEXT TO PLAYER, THEN STRIKE!
		if enemy.melee_attack_exists:
			if  (abs(player_location.x - enemy_location.x) == 1 and abs(player_location.y - enemy_location.y) == 0) or (abs(player_location.x - enemy_location.x) == 0 and abs(player_location.y - enemy_location.y) == 1):
				show_UI_attack(attacks_enum.MELEE)
				var enemy_damage = enemy.get_melee_dmg_strike()
				print_text(enemy.the_name + " attacks for " + str(enemy_damage) + " damage.")
				if the_player.damaged_HPs(enemy_damage):
					the_player_died()
				enemy_attacked = true
		#print ("MOVING ON TO CHECK MELEE -- ENDED")

		#print ("MOVING ON TO CHECK RANGED -- START")
		if not enemy_attacked and enemy.ranged_attack_range > 0:
			# Check 1: Is the enemy at same X or Y as player? (on same line)
			if player_location.x == enemy_location.x or player_location.y == enemy_location.y:
				# Check 2: Is the enemy in range distance? [could be first, but more computations involved]
				if player_location.distance_to(enemy_location) <= enemy.ranged_attack_range:
					# Check 3: Is the line between them clear of enemies/walls?
					if (player_location.x == enemy_location.x and has_clear_X_sight(enemy_location.x, enemy_location.y, player_location.y)) or (player_location.y == enemy_location.y and has_clear_Y_sight(enemy_location.y, enemy_location.x, player_location.x)):
						show_UI_attack(attacks_enum.RANGE)
						var enemy_damage = enemy.get_range_dmg_strike()
						print_text(enemy.the_name + " ranges for " + str(enemy_damage) + " damage.")
						if the_player.damaged_HPs(enemy_damage):
							the_player_died()
						enemy_attacked = true
		#			else:
		#				print("Enemy not attacked!")
		#		else:
		#			print ("Enemy not in range")
		#	else:
		#		print ("Enemy not in same line")		
		#print ("MOVING ON TO CHECK RANGED -- ENDED")
		
		#print ("MOVING ON TO CHECK MOVES -- START")
		var enemy_togo_location:Vector2i
		enemy_togo_location.x = enemy_location.x
		enemy_togo_location.y = enemy_location.y
		#due to how maze is constructed, at the beginning at least, order of enemies is from closer to player to further away
		if (not enemy_attacked) and player_location.distance_to(enemy_location) <= enemy.perception_range:
			#print ("I AM COMING FOR YOU....!?" + str(abs(player_location.x - enemy_location.x)) + "-" + str(abs(player_location.y - enemy_location.y)))
			#Check for X movement
			if player_location.x < enemy_location.x:
				enemy_togo_location.x = round(enemy_location.x) - 1
			elif player_location.x > enemy_location.x:
				enemy_togo_location.x = round(enemy_location.x) + 1
			#Check for Y movement (after X -- no diagonal moves)
			elif player_location.y < enemy_location.y:
				enemy_togo_location.y = round(enemy_location.y) - 1
			elif player_location.y > enemy_location.y:
				enemy_togo_location.y = round(enemy_location.y) + 1
			#Now check if it can ACTUALLY move there!
			if (not enemy_attacked) and not enemies_at_location(enemy_togo_location) and not player_at_location(enemy_togo_location) and has_cell_at(enemy_togo_location):
				enemy.set_position2D(enemy_togo_location)
				#print ("ENEMY WILL GO TO >>>>> " + str(enemy_togo_location))
		#print ("MOVING ON TO CHECK MOVES -- END")
			
			
			#if enemy has range and NOT next to player and has DIRECT (hor or ver) line of sight, it might fire
			#if decies to move: go down, with melee ones
			#enemy_wants_to_move_to = get_next_enemy_move()
			#if can_move_to(): 
			#   enemy_move()


## Creates the enemies (3D sprites) from the Enemies Array
#
func enemies_create(new_enemy_locations:Array, current_lvl:int) -> void:
	enemies_clear()
	for new_enemy_location in new_enemy_locations:
		enemy_locations.append(new_enemy_location)
		var new_enemy = THE_ENEMIES[randi_range(0, current_lvl-1)].instantiate()
		new_enemy.set_position2D(new_enemy_location)
		add_child(new_enemy)
		enemies.append(new_enemy)
		new_enemy.global_transform.origin = Vector3(new_enemy_location.x*Global.GRID_SIZE, 0, new_enemy_location.y*Global.GRID_SIZE)
	#for enemy in enemies:
	#	print (enemy.position2D)


## Check if any enemies exist at x,y
#
func enemies_at_location_xy(x:int, y:int) -> bool:
	var check_enemy_location = Vector2i(x,y)
	return enemies_at_location(check_enemy_location)


## Check if any enemies exist at check_enemy_location
#
func enemies_at_location(check_enemy_location:Vector2i) -> bool:
	#print (check_enemy_location)
	for enemy in enemies:
		var enemy_location:Vector2i = enemy.position2D
		#print (enemy_location)
		if check_enemy_location.x == enemy_location.x and check_enemy_location.y == enemy_location.y:
			return true
	return false


## Returns the enemy at the given location OR null
#
func get_enemy_at_location(check_location_x, check_location_y) -> BaseEnemy:
	for enemy in enemies:
		var enemy_location:Vector2i = enemy.position2D
		if check_location_x == enemy_location.x and check_location_y == enemy_location.y:
			return enemy
	return null


## Check if the player stands at check_enemy_location
#
func player_at_location(check_enemy_location:Vector2i) -> bool:
	var player_location = the_player.get_location2D()
	if check_enemy_location.x == player_location.x and check_enemy_location.y == player_location.y:
		return true
	return false


## Check if the map has an actual cell at the location requested
#
func has_cell_at(check_location:Vector2i) -> bool:
	if not current_map.has_cellv(check_location):
		return false
	return (current_map.get_cellv(check_location) != 0)


## Check if the map has an actual cell at the location requested (x,y)
#
func has_cell_at_xy(x:int, y:int) -> bool:
	var check_location = Vector2i(x, y)
	return has_cell_at(check_location)


## Quit the current game to MSDOS :)
# (with 1 second delay to write the message in the text box)
#
func quit() -> void:
	the_UI_label.text = ("\n OK, BYE you cruel player!\n\n") + the_UI_label.text
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
