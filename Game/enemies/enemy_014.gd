extends BaseEnemy
class_name Enemy_014

func _ready():
	the_name = "Undead Warrior"
	level = 5
	hit_points = 30
	perception_range = 4
	melee_attack_exists = true
	melee_damage_arr = [12, 14]
	ranged_attack_range = 0
	range_damage_arr = [0 ,0]
	speed = 12

func _init():
	_ready()

