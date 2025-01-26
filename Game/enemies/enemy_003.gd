extends BaseEnemy
class_name Enemy_003

func _ready():
	the_name = "Skeleton"
	level = 1
	hit_points = 6
	perception_range = 3
	melee_attack_exists = true
	melee_damage_arr = [2, 4]
	ranged_attack_range = 0
	speed = 18

func _init():
	_ready()
