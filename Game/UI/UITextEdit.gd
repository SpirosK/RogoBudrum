extends TextEdit

## When starting: declares itself to the "management Singleton"
#
func _ready():
	Global.the_UI_label = self
