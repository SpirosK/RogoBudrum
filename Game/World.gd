extends Node3D

@export var Map: PackedScene

## So many things to do when first starting!
#  * create map and world
#  * Create enemies
#  * Setup the UI and first weapons/shields[/spells(TODO)]
#  * Start the Timer and GO!
#
func _ready():
	var map = Map.instantiate()
	var grid_map = map.create_map(Global.current_lvl)
	
	Global.create_world(grid_map)
	Global.enemies_create(map.enemies_starting_locations, 1)
	Global.set_current_map(grid_map)
	Global.worldTimer = %WorldTimer

	#Setting the starting weapons 
	var first_sword = BaseMeleeWeapon.new()
	first_sword.min_damage = 1
	first_sword.max_damage = 3
	Inventory.itemQ = first_sword
	Inventory.firstItemQ = first_sword
	var first_shield = BaseShield.new()
	Inventory.itemE = first_shield
	Inventory.firstItemE = first_shield
	
	$ThePlayer.set_player_class(Global.player_class.WARRIOR)
	Global.the_player = $ThePlayer
	%WorldTimer.start()
	map.free()


## At timeout: Enemies' Movemeents and Item Cooldowns are being calculated.
#  Enemies have different speeds (ticket per move), so this balances out.
#
func _on_enemies_timer_timeout():
	#var time = Time.get_time_dict_from_system()
	#print ("### TIMER FIRED ### %02d:%02d:%02d" % [time.hour, time.minute, time.second])
	Global.enemies_action()
	Inventory.update_cooldowns()
	pass
