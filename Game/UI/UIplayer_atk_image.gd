extends Sprite2D

var melee_texture = preload("res://Game/UI/slasher.png")
var range_texture = preload("res://Game/UI/striked.png")

## When starting: declares itself to the "management Singleton"
#
func _ready():
	Global.the_UI_attack_player = self

## Changes the texture shown to the melee slash
#
func change_to_range():
	self.texture = range_texture
	
## Changes the texture shown to the range strike
#
func change_to_melee():
	self.texture = melee_texture
