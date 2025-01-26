extends Node2D

var new_item_q = null
var old_item_q = null
var new_item_e = null
var old_item_e = null

var to_upgrade_QE   = ""
var to_upgrade_Attr = ""

## The UI is populated!
#
func _ready():
	%QE_Descriptions.text = "Click on Item to get info & pic about it and choose it!\n"
	create_new_itemQ(Global.current_lvl)
	%itemQ_btn.icon = new_item_q.UI_ICON
	create_new_itemE(Global.current_lvl)
	%itemE_btn.icon = new_item_e.UI_ICON
	old_item_e = Inventory.itemE
	old_item_q = Inventory.itemQ

## Creates the Primary (Q) Item [melee or range or spell]
#  At the moment, it's a melee weapon because we only have Warrior class
#
func create_new_itemQ(world_level:int):
	new_item_q = BaseMeleeWeapon.new()
	new_item_q.randomize_weapon(world_level)

## Creates the Secondary (E) Item [range or defence or spell]
#  At the moment, it's a shield because we only have Warrior class
#
func create_new_itemE(world_level:int):
	new_item_e = BaseShield.new()
	new_item_e.randomize_shield(world_level)

## When the user chooses to keep the new Q
#
func _on_item_q_btn_pressed():
	to_upgrade_QE = "Q"
	check_ok_btn()

	%QE_Descriptions.text = "New Sword Statistics\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod Total = " + str(new_item_q.modifier_total) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod STR = " + str(new_item_q.modifier_strength) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod ABS = " + str(new_item_q.modifier_absolute) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Min DMG = " + str(new_item_q.min_damage) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Max DMG = " + str(new_item_q.max_damage) + "\n"
	if old_item_q != null:
		%QE_Descriptions.text = %QE_Descriptions.text + "VS Old Sword Statistics\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod Total = " + str(old_item_q.modifier_total) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod STR = " + str(old_item_q.modifier_strength) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod ABS = " + str(old_item_q.modifier_absolute) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Min DMG = " + str(old_item_q.min_damage) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Max DMG = " + str(old_item_q.max_damage) + "\n"


## When the user chooses to keep the new E
#
func _on_item_e_btn_pressed():
	to_upgrade_QE = "E"
	check_ok_btn()

	%QE_Descriptions.text = "New Shield Statistics\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod MEL = " + str(new_item_e.modifier_melee) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod RNG = " + str(new_item_e.modifier_range) + "\n"
	%QE_Descriptions.text = %QE_Descriptions.text + "New Mod ABS = " + str(new_item_e.modifier_absolute) + "\n"
	#%QE_Descriptions.text = %QE_Descriptions.text + "Extra HP = " + str(new_item_e.extra_hp) + "\n"
	if old_item_e != null:
		%QE_Descriptions.text = %QE_Descriptions.text + "VS Old Sword Statistics\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod MEL = " + str(old_item_e.modifier_melee) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod RNG = " + str(old_item_e.modifier_range) + "\n"
		%QE_Descriptions.text = %QE_Descriptions.text + "Old Mod ABS = " + str(old_item_e.modifier_absolute) + "\n"
		#%QE_Descriptions.text = %QE_Descriptions.text + "Extra HP = " + str(old_item_e.extra_hp) + "\n"


## When the user chooses to upgrad STRength
#
func _on_str_upg_btn_pressed():
	to_upgrade_Attr = "STR"
	%Attr_upg_desc.text = "Strength to be upgraded by 1 to " + str(Global.the_player.Str + 1)
	check_ok_btn()


## When the user chooses to upgrad DEXterity
#
func _on_dex_upg_btn_pressed():
	to_upgrade_Attr = "DEX"
	%Attr_upg_desc.text = "Dexterity to be upgraded by 1 to " + str(Global.the_player.Dex + 1)
	check_ok_btn()


## When the user chooses to upgrad WISdom
#
func _on_wis_upg_btn_pressed():
	to_upgrade_Attr = "WIS"
	%Attr_upg_desc.text = "Wisdom to be upgraded by 1 to " + str(Global.the_player.Wis + 1)
	check_ok_btn()


## When the user chooses to upgrad EYEsight
#
func _on_eye_upg_btn_pressed():
	to_upgrade_Attr = "EYE"
	%Attr_upg_desc.text = "Eyesight to be upgraded by 1 to " + str(Global.the_player.Eye + 1)
	check_ok_btn()


## Checks if OK Button should be enabled
#
func check_ok_btn() -> void:
	if to_upgrade_QE != "" and to_upgrade_Attr != "":
		%OK_btn.disabled = false

## When the user chooses to move on to the game again
#
func _on_ok_btn_pressed():
	if to_upgrade_QE == "" or to_upgrade_Attr == "":
		print ("THIS SHOULD NEVER HAVE HAPPENED at: _on_ok_btn_pressed. Please contact the Developer(s).")
		return

	#Updating the attributes/weapons and unpausing the tree	
	match to_upgrade_Attr:
		"STR":
			Global.the_player.Str += 1
		"DEX":
			Global.the_player.Dex += 1
		"WIS":
			Global.the_player.Wis += 1
		"EYE":
			Global.the_player.Eye += 1

	match to_upgrade_QE:
		"Q":
			Inventory.itemQ = new_item_q
			Inventory.the_UI_Q_btn.icon = new_item_q.UI_ICON
			Inventory.the_UI_E_btn.icon = Inventory.itemE.UI_ICON
		"E":
			Inventory.itemE = new_item_e
			Inventory.the_UI_Q_btn.icon = Inventory.itemQ.UI_ICON
			Inventory.the_UI_E_btn.icon = new_item_e.UI_ICON

	Inventory.cooldownE = -1	
	Inventory.cooldownQ = -1
	
	Global.update_stats_UI()
	get_tree().paused = false #UNPAUSE TREE
	self.queue_free ()
