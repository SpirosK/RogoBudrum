extends BaseDefence
class_name BaseShield

## To be overriden in subsequent shields
var UI_ICON      = ResourceLoader.load("res://Game/weapons/shields/shield_01.png")

func _init():
	modifier_absolute = 1
	modifier_melee    = 0.9
	modifier_range    = 0.9
	extra_hp          = 0 
	
## This is used to produce a random shield
#  (TODO (Later): elemental defence, spell defence)
#
func randomize_shield(level:int):
	modifier_absolute = randi_range(1, level)
	modifier_melee    = 1.0 - randf_range(0.1, level/20.0)
	modifier_range    = 1.0 - randf_range(0.1, level/20.0)
	extra_hp          = randi_range(0, 2 * level)
	UI_ICON = ResourceLoader.load("res://Game/weapons/shields/shield_%02d.png" % [level])

## Returns the damage after all defence modifiers are applied
#
func get_reduced_damage(strike_damage:int, is_melee:bool) -> int:
	var reduced_damage = strike_damage
	var modifier = modifier_range
	if is_melee:
		modifier = modifier_melee
	
	reduced_damage = snappedi(float(strike_damage) * modifier, 1)-modifier_absolute
	if reduced_damage < 0:
		return 0
	return reduced_damage
