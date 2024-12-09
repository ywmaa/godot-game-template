extends HSlider

@export var variable_name : String


func _ready():
	value = Global.get(variable_name)
	value_changed.connect(func(v): Global.set(variable_name, v))
