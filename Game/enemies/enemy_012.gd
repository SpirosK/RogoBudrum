extends BaseEnemy
class_name Enemy_012

func _ready():
	the_name = "Demon"
	level = 4
	hit_points = 18
	perception_range = 7
	melee_attack_exists = true
	melee_damage_arr = [4, 8]
	ranged_attack_range = 6
	range_damage_arr = [4 ,8]
	speed = 14

func _init():
	_ready()

