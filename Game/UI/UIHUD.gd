extends CanvasLayer

func _ready():
	Inventory.the_UI_Q_btn = %itemQ_btn
	Inventory.the_UI_E_btn = %itemE_btn
	Global.STR_UI = %STR_UI
	Global.DEX_UI = %DEX_UI
	Global.WIS_UI = %WIS_UI
	Global.EYE_UI = %EYE_UI
	Global.update_stats_UI()

## TODO: The inventory system
#
func _on_item_pressed(button_item):
	Inventory.use_item(button_item)
	pass
