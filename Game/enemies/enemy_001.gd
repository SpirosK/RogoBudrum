extends BaseEnemy
class_name Enemy_001

func _ready():
	the_name = "Goblin"
	level = 1
	hit_points = 3
	perception_range = 2
	melee_attack_exists = true
	melee_damage_arr = [1, 2]
	ranged_attack_range = 0
	speed = 20

func _init():
	_ready()
