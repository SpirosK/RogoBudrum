extends BaseEnemy
class_name Enemy_002

func _ready():
	the_name = "Cultist"
	level = 1
	hit_points = 5
	perception_range = 3
	melee_attack_exists = true
	melee_damage_arr = [1, 3]
	ranged_attack_range = 0
	speed = 15

func _init():
	_ready()
