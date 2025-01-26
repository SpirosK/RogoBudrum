extends BaseEnemy
class_name Enemy_Boss

func _ready():
	the_name = "Evil Eyes"
	level = 7
	hit_points = 300
	perception_range = 12
	melee_attack_exists = true
	melee_damage_arr = [30, 50]
	ranged_attack_range = 7
	range_damage_arr = [40, 60]
	speed = 8 #ultra fast attacks!

func _init():
	_ready()
