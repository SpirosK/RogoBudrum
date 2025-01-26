extends BaseWeapon
class_name BaseMeleeWeapon

var UI_ICON = ResourceLoader.load("res://Game/weapons/swords/sword_01.png")

func _init():
	type_of_item = Inventory.item_type.MELEE_WEAPON
	modifier_total = 1.0       #A decimal which applies to final result (after all else) (1.0 ... 1+0.1*level)
	modifier_strength = 0.0    #Multiplies with strength (0..level/2)
	modifier_absolute = 0      #An integer which is added to final, before mod_total (0..level)
	min_damage = 0             #minimum damage (1...level)
	max_damage = 0             #maximum damage (min_dmg...level+3)
	modifier_eyesight = 0.0    #N/A

## Creates a new random (Melee) Weapon for the "level"-num level
#
func randomize_weapon(level:int):
	var max_mod_total:float = 1.0 + 0.1 * float(level)
	modifier_total = randf_range(1.0, max_mod_total)
	var max_mod_str:float = float(level) / 2.0
	modifier_strength = randf_range(0.0, max_mod_str)
	modifier_absolute = randi_range(0, level)
	min_damage = randi_range(1, level)
	max_damage = randi_range(min_damage, level+2)
	#print("res://Game/weapons/swords/sword_%02d.png" % [level])
	UI_ICON = ResourceLoader.load("res://Game/weapons/swords/sword_%02d.png" % [level])

## Returns the final damage of the strike (before defence)
#
func get_damage(player_strength:int) -> int:
	return int(modifier_total * (float(randi_range(min_damage, max_damage)) + modifier_strength * float(player_strength) + float(modifier_absolute)))
