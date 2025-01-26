extends CharacterBody3D
class_name BaseEnemy

var the_name = ""
var ticks_passed = 0

var level:int                    #its level affects its damage and hit_points (TODO / Design Choice)
var hit_points:int
var position2D:Vector2i
var perception_range:int         #how far away can it sense the player from? (just a distance_to)
var melee_attack_exists:bool
var ranged_attack_range:int      #if it doesn't exist, range will be 0.
var melee_damage_arr = [0 ,0]    #min and max melee
var range_damage_arr = [0 ,0]    #min and max range
var speed            = 20        #every how many ticks does this enemy does sth (higher = slower)


## Called on every tick: inquires if the time to act has come!
#
func is_time_to_act():
	ticks_passed += 1
	if ticks_passed == speed:
		ticks_passed = 0
		return true
	return false

##Gets the damage of a melee strike (rng from min to max)
#
func get_melee_dmg_strike() -> int:
	return randi_range(melee_damage_arr[0], melee_damage_arr[1])

##Gets the damage of a ranged strike (rng from min to max)
#
func get_range_dmg_strike() -> int:
	return randi_range(range_damage_arr[0], range_damage_arr[1])

##Sets the map position of the enemy
# TODO: Check for collision with others?
#
func set_position2D(new_position:Vector2i) -> void:
	position2D.x = new_position.x
	position2D.y = new_position.y
	global_transform.origin.x = new_position.x
	global_transform.origin.z = new_position.y

## Enemy is damaged (reduce HP and check_for_death)
#
func damaged(dmg:int) -> void:
	hit_points = hit_points - dmg
	if hit_points <= 0:
		Global.print_text(the_name + " DIED!")
		died()

## Enemy is dead (remove)
#
func died() -> void:
	if Global.enemies.has(self):
		Global.enemies.remove_at(Global.enemies.find(self))
	queue_free()
