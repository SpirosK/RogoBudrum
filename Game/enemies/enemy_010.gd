extends BaseEnemy
class_name Enemy_010

func _ready():
	the_name = "Strange Thing"
	level = 4
	hit_points = 15
	perception_range = 6
	melee_attack_exists = true
	melee_damage_arr = [5, 8]
	ranged_attack_range = 3
	range_damage_arr = [2 ,4]
	speed = 10

func _init():
	_ready()

