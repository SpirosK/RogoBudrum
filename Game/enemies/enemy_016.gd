extends BaseEnemy
class_name Enemy_016

func _ready():
	the_name = "Minotaur"
	level = 6
	hit_points = 40
	perception_range = 3
	melee_attack_exists = true
	melee_damage_arr = [20, 30]
	ranged_attack_range = 0
	range_damage_arr = [0 ,0]
	speed = 24

func _init():
	_ready()

