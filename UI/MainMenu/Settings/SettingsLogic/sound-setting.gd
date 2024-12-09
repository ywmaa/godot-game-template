@tool
extends HBoxContainer


var bus_name: String = "[NONE]": set = set_bus_name
@export var bus_variable_name : String 
@export var label : Label
func _ready():
	#var bus_index: int = AudioServer.get_bus_index(bus_name)
	$Slider.value = Global.get(bus_variable_name+"_volume")*100
	$Button.button_pressed = Global.get(bus_variable_name+"_mute")
	$Slider.connect("value_changed", set_volume)
	$Button.connect("toggled", mute_volume)
	label.text = bus_name + " Volume:"
func set_volume(value: float):
	Global.set(bus_variable_name+"_volume", value/100)
func mute_volume(toggled_on: bool):
	Global.set(bus_variable_name+"_mute", toggled_on)


func set_bus_name(value: String) -> void:
	bus_name = value
	
	
func _get_property_list() -> Array[Dictionary]:
	
	var hint_string: String = ",".join(_get_audio_buses())
	return [{
		"name": "bus_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]
func _get_audio_buses() -> PackedStringArray:
	var buses: PackedStringArray = ["[NONE]"]
	for bus_index in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_index)
		buses.append(bus)
	
	return buses
