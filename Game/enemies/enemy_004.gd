extends BaseEnemy
class_name Enemy_004

func _ready():
	the_name = "Wolf"
	level = 2
	hit_points = 6
	perception_range = 5
	melee_attack_exists = true
	melee_damage_arr = [3, 5]
	ranged_attack_range = 0
	#range_damage_arr = [1 ,3]
	speed = 12
	
func _init():
	_ready()
