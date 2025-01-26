extends BaseEnemy
class_name Enemy_011

func _ready():
	the_name = "Water Elemental"
	level = 4
	hit_points = 12
	perception_range = 4
	melee_attack_exists = true
	melee_damage_arr = [2, 4]
	ranged_attack_range = 3
	range_damage_arr = [5 ,7]
	speed = 15

func _init():
	_ready()

