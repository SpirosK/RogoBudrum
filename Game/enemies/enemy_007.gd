extends BaseEnemy
class_name Enemy_007


func _ready():
	the_name = "Barbarian"
	level = 3
	hit_points = 14
	perception_range = 3
	melee_attack_exists = true
	melee_damage_arr = [7, 10]
	ranged_attack_range = 0
	#range_damage_arr = [1 ,3]
	speed = 24

func _init():
	_ready()

