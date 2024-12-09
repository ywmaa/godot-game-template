extends ColorPickerButton

@export var variable_name : String


func _ready():
	color = Global.get(variable_name)
	color_changed.connect(func(v): Global.set(variable_name, v))
