extends Label

@export var label_text : String
@export var variable_name : String
var current_value

func _process(_delta: float) -> void:
	var value = Global.get(variable_name)
	if current_value != value:
		current_value = value
		text = label_text + str(current_value)
