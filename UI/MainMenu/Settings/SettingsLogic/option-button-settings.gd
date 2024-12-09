extends OptionButton


@export var variable_name : String


func _ready():
	selected = Global.get(variable_name)
	item_selected.connect(func(v): Global.set(variable_name, v))
