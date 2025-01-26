extends CharacterBody3D

@onready var forward:  = $Ray_front
@onready var backward: = $Ray_back
@onready var camera    = $Camera3D

var rng = RandomNumberGenerator.new()

## The Player has three attributes:
# Strength   = affects Melee Attack
# Dexterity  = affects Defence (this much percentage to avoid an attack <-- TODO)
# Wisdom     = affects Spells Damage
# Eyesight   = affects Ranged Attack
#
# In the beginning they all sum up to 10.
var direction_vector = Vector3.FORWARD
var initial_vector = Vector3(0, 0.5, 1)
var initial_origin = Vector3(0, 0.5, 0)
var player_class    = Global.player_class.WARRIOR #TODO: this enum should be in player maybe?
## The following are Warrior Stats. With the original idea you would have different
#  for each class and you would do e.g. Str = Strength_per_class[PlayerClass]
var Str = 4
var Dex = 3
var Wis = 1
var Eye = 2
var max_HPs   = 0
var cur_HPs   = 0

## When it is created, it needs to rotate 180 degrees the first time :)
#
func _ready():
	rotate_y(deg_to_rad(180))
	direction_vector = -camera.global_transform.basis.z.normalized()


## This is used when you reset HP after you die
#  You get to keep all your stats changes. But HP, go back to starting ones.
#
func reset_HPs():
	max_HPs = Global.classes_HPs[player_class]
	cur_HPs = max_HPs
	Global.update_HP_bar(cur_HPs, max_HPs)


## Player is damaged. Returns TRUE if died
#  Check if evaded, then check for defence item reducing damage, getting the final value
#  Also: Prints out the final damage received.
#
func damaged_HPs(gone_HPs:int) -> bool:
	var final_gone_HPs = gone_HPs
	# evasion check
	var evasion_possibility = rng.randi_range(1,100)
	if evasion_possibility <= Dex:
		Global.print_text("Player has successfully evaded the hit!")
		return false
	# defence check
	if Inventory.has_defence_item():
		var defence_item = Inventory.get_defence_item()
		final_gone_HPs = defence_item.get_reduced_damage(gone_HPs, true)
	# final after modifiers/defence/etc
	cur_HPs = cur_HPs - final_gone_HPs
	Global.print_text("Damage received after defence = " + str(final_gone_HPs))
	Global.update_HP_bar(cur_HPs, max_HPs)
	return (cur_HPs <= 0)


## We are setting the class. Only acceptable when HP is <= 0
# TODO: This is obviously never called, since I never implemented the rest of the classes
#
func set_player_class(new_class:Global.player_class) -> void:
	if cur_HPs > 0:
		#print ("Attempting to change class mid-game!")
		return
	player_class = new_class
	max_HPs = Global.classes_HPs[new_class]
	cur_HPs = max_HPs
	#print ("PLAYER CLASS IS " + Global.classes_names[new_class] + " with hp: " + str(cur_HPs))
	Global.update_HP_bar(cur_HPs, max_HPs)


## This functions performs a collision check for a Direction Vector
#
func collision_check(direction_v) -> bool:
	if direction_v != null:
		return direction_v.is_colliding()
	else:
		return false


## This functions retuns the Direction Vector of the player
#
func get_direction_vector():
	return direction_vector.get_collider().global_transform.origin - global_transform.origin


## This function returns the location of the player in a 2D Vector
#
func get_location2D() -> Vector2i:
	return Vector2i(int(global_transform.origin.x), int(global_transform.origin.z))


## This functions moves the player forward, if it's not colliding (Ray_front)
#
func move_forward() -> void:
	var next_location:Vector2i
	next_location[0] = global_transform.origin.x + int(direction_vector.x)
	next_location[1] = global_transform.origin.z + int(direction_vector.z)
	if !forward.is_colliding() and not Global.enemies_at_location(next_location):
		global_transform.origin.x += int(direction_vector.x)
		global_transform.origin.z += int(direction_vector.z)
	## Removed because it floods the text-box
	#else:
	#	Global.print_text("The way forward is blocked!")


## This functions moves the player backward, if it's not colliding
#
func move_backward() -> void:
	if !backward.is_colliding():
		global_transform.origin.x -= int(direction_vector.x)
		global_transform.origin.z -= int(direction_vector.z)
	else:
		Global.print_text("The way back is blocked!")


## This functions moves/rotates the player according to button presses.
#  Down = Rotates 180 deg, SHIFT+Down=Go backwards
# Enemies will move after player's movement/actions
#
func _input(event) -> void:
	#not processing if input is paused globally
	if Global.pause_input:
		return

	# Terminal Actions (Quit, Restart)
	# At this point RESTART is a DEBUG action!
	#
	if event.is_action_pressed("ui_quit"):
		Global.quit()
		return
	if event.is_action_pressed("ui_restart"):
		Global.restart_game()
		return
	
	#normal movement processing
	
	## TODO: REMOVE DEBUG ESCAPE (when done debugging)
	if event.is_action_pressed("ui_cancel"):
		Global.goto_next_level()
		return
	if event.is_action_pressed("ui_up"):
		move_forward()
		return
	if event.is_action_pressed("ui_left"):
		rotate_y(deg_to_rad(90))
		direction_vector = -camera.global_transform.basis.z.normalized()
		return
	if event.is_action_pressed("ui_right"):
		rotate_y(deg_to_rad(-90))
		direction_vector = -camera.global_transform.basis.z.normalized()
		return
	if event.is_action_pressed("ui_down"):
		if event.shift_pressed:
			move_backward()
		else:
			rotate_y(deg_to_rad(180))
			direction_vector = -camera.global_transform.basis.z.normalized()
		return
	
	#Rounding to account for a 0.00001 angle which messes some things up
	global_transform.origin.x = round(global_transform.origin.x)
	global_transform.origin.z = round(global_transform.origin.z)
	
	if (Global.get_cell_type(global_transform.origin.x, global_transform.origin.z) == Global.cell_type.EXIT):
		Global.goto_next_level()
		return
	
	if event.is_action_pressed("ActionQ"):
		Inventory.use_itemQ()
	
	if event.is_action_pressed("ActionE"):
		Inventory.use_itemE()
	
	#Inventory actions (TODO: At the moment these have not been implemented)
	#
	if event.is_action_pressed("Item1"):
		Inventory.use_item(0)
		return
	if event.is_action_pressed("Item2"):
		Inventory.use_item(1)
		return
	if event.is_action_pressed("Item3"):
		Inventory.use_item(2)
		return
	if event.is_action_pressed("Item4"):
		Inventory.use_item(3)
		return
	if event.is_action_pressed("Item5"):
		Inventory.use_item(4)
		return
	if event.is_action_pressed("Item6"):
		Inventory.use_item(5)
		return
	if event.is_action_pressed("Item7"):
		Inventory.use_item(6)
		return


## Calculates the coords in front of the player and returns them.
#  (Player doesn't know the map bounds, this will be checked by caller)
#  Wrapping in "int", because otherwise it rounds up by cutting off decimals, instead of real rounding!! :( 
#
func get_coords_infront():
	var new_origin_x:int = int(global_transform.origin.x) + int(direction_vector.x)
	var new_origin_z:int = int(global_transform.origin.z) + int(direction_vector.z)
	return [new_origin_x, new_origin_z]


## resets the player position to initial (0, 0.5, 0)
#  and looking towrads the first corridor!
#
func reset_player_position() -> void:
	global_transform.origin = initial_origin
	look_at(initial_vector)
	direction_vector = initial_vector
