extends ProgressBar

## When starting: declares itself to the "management Singletons"
#
func _ready():
	Global.the_UI_HP = self
	Inventory.the_UI_HP = self
