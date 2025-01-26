extends BaseEnemy
class_name Enemy_005

func _ready():
	the_name = "Giant Snake"
	level = 2
	hit_points = 7
	perception_range = 7
	melee_attack_exists = true
	melee_damage_arr = [4, 6]
	ranged_attack_range = 0
	#range_damage_arr = [1 ,3]
	speed = 30 		#should be very slow!

func _init():
	_ready()
