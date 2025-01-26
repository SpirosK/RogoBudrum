extends BaseEnemy
class_name Enemy_013

func _ready():
	the_name = "Land Jelly"
	level = 5
	hit_points = 25
	perception_range = 3
	melee_attack_exists = true
	melee_damage_arr = [8, 10]
	ranged_attack_range = 2
	range_damage_arr = [5 ,9]
	speed = 30

func _init():
	_ready()

