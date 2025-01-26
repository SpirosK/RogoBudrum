extends BaseEnemy
class_name Enemy_017

func _ready():
	the_name = "Evil Fairy"
	level = 6
	hit_points = 30
	perception_range = 8
	melee_attack_exists = true
	melee_damage_arr = [15, 20]
	ranged_attack_range = 2
	range_damage_arr = [10, 15]
	speed = 10

func _init():
	_ready()

