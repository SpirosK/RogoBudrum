extends BaseEnemy
class_name Enemy_015

func _ready():
	the_name = "Orc"
	level = 5
	hit_points = 32
	perception_range = 2
	melee_attack_exists = true
	melee_damage_arr = [16, 20]
	ranged_attack_range = 0
	range_damage_arr = [0 ,0]
	speed = 17

func _init():
	_ready()

