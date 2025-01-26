extends BaseEnemy
class_name Enemy_008

func _ready():
	the_name = "Dark Mage"
	level = 3
	hit_points = 14
	perception_range = 3
	melee_attack_exists = false
	melee_damage_arr = [0, 0]
	ranged_attack_range = 4
	range_damage_arr = [4, 7]
	speed = 24

func _init():
	_ready()

