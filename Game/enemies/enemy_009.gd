extends BaseEnemy
class_name Enemy_009

func _ready():
	the_name = "Gnome Mage"
	level = 3
	hit_points = 11
	perception_range = 4
	melee_attack_exists = false
	melee_damage_arr = [0, 0]
	ranged_attack_range = 4
	range_damage_arr = [4, 7]
	speed = 18

func _init():
	_ready()

