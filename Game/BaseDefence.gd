class_name BaseDefence

var type_of_item = Inventory.item_type.SHIELD

var modifier_melee:float    = 0.0  #multiplier for melee damage
var modifier_range:float    = 0.0  #multiplier for range damage
var modifier_absolute:float = 0    #subtracted after multipliers
var extra_hp:int            = 0    #how many HPs does it add holding it? (TODO: Not implemented)
var cooldown:int            = -1   #so that no special ifs are needed in code
