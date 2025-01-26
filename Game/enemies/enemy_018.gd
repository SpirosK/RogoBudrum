extends BaseEnemy
class_name Enemy_018

func _ready():
	the_name = "Evil Wizard"
	level = 6
	hit_points = 15
	perception_range = 10
	melee_attack_exists = false
	melee_damage_arr = [0, 0]
	ranged_attack_range = 5
	range_damage_arr = [30, 40]
	speed = 15

func _init():
	_ready()

