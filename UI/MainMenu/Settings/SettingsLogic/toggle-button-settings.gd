extends CheckButton

@export var variable_name : String


func _ready():
	button_pressed = Global.get(variable_name)
	toggled.connect(func(v): Global.set(variable_name, v))
