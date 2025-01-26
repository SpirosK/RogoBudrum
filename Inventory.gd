extends Node 

const INVENTORY_POSITIONS = 7

enum item_type {
	MELEE_WEAPON,
	RANGE_WEAPON,
	SHIELD
}

const SHIELD_QUOTES = ["You look at your Shield. You like it!",
"Stay strong shield. We have work to do!",
"Don't break on me please!!",
"Your shield doesn't talk back. It doesn't talk at all.",
"1, 2, 3! Let's go, Shield!",
"A sturdy shield, it will do the job!"]


## Items and weapons
#
# TODO: This would be the iventory. Some enemies would drop potions/items, that you would 
#       pick up automatically and be able to use by pressing the respective number on keyboard
#       (or click on the position)
var inventory = [null, null, null, null, null, null, null]  #empty inventory
var itemQ = null       #melee weapon or spell
var itemE = null       #shield or bow or spell
var firstItemQ = null  #the starting melee weapon or spell
var firstItemE = null  #the starting shield or bow or spell
var cooldownQ = -1     #how many ticks to cooldown for Q
var cooldownE = -1     #how many ticks to cooldown for E

## UI Elements
#
var the_UI_HP:ProgressBar
var the_UI_Q_btn
var the_UI_E_btn
var X_UI_ICON = ResourceLoader.load("res://Game/UI/X_weapons.png")


##Resets weapon to their first ones (when player dies)
#
func reset_weapons() -> void:
	itemQ = firstItemQ
	itemE = firstItemE
	the_UI_Q_btn.icon = itemQ.UI_ICON
	the_UI_E_btn.icon = itemE.UI_ICON


## Q Item: is always either a melee or a range weapon, depends on class (Design Choice)
#
func use_itemQ():
	if cooldownQ > -1:
		#print ("in cooldown!")
		return
	if itemQ.type_of_item == item_type.MELEE_WEAPON:
		Global.calculate_melee_hit(itemQ)
	elif itemQ.type_of_item == item_type.RANGE_WEAPON:
		Global.calculate_range_hit(itemE)
	#ACTIVATE Cooldown
	cooldownQ = itemQ.cooldown
	the_UI_Q_btn.icon = X_UI_ICON


## E Item: is always a range weapon/spell or defence item/Shield, depends on class (Design Choice)
#
func use_itemE():
	if cooldownE > -1:
		return
	if itemE.type_of_item == item_type.RANGE_WEAPON:
		Global.calculate_range_hit(itemE)
		cooldownE = itemE.cooldown
	elif itemE.type_of_item == item_type.SHIELD:
		#Shield is a passive item. You cannot "use" it. 
		#PS: YES I could use it as 2-3dmg melee weapon (bash), but... (Design Choice)
		Global.print_text(SHIELD_QUOTES[randi() % 6])
		#No cooldown for shield, spam the text box


## This would use a potion/item from the Inventory
#
func use_item(position:int) -> void:
	if (position < 0 or position >= INVENTORY_POSITIONS):
		print ("Possible Bug! use_item with invalid index called: " + str(position))
		return
	if inventory[position] == null:
		Global.print_text("No Item in position" + str(position+1))
		return


## Checks if the user has a Defence Item 
#
func has_defence_item() -> bool:
	if itemE != null and itemE.type_of_item == item_type.SHIELD:
		return true
	return false


##Returns the defence item, if exists
#
func get_defence_item():
	if has_defence_item():
		return itemE
	return null


## This function upodates the cooldowns of the weapons (if in effect)
#
func update_cooldowns() -> void:
	if cooldownQ > -1:
		cooldownQ -= 1
		#print ("Lowered Cooldown Q " + str(cooldownQ))
		if cooldownQ == -1:
			the_UI_Q_btn.icon = itemQ.UI_ICON
	if cooldownE > -1:
		cooldownE -= 1
		#print ("Lowered Cooldown E " + str(cooldownQ))
		if cooldownE == -1:
			the_UI_E_btn.icon = itemE.UI_ICON


## TODO
#func reset_to_starting() -> void
