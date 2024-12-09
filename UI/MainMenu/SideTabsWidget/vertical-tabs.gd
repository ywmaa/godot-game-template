@tool
extends HBoxContainer

@export var tab_container : TabContainer
@export var vertical_tabs_container : VBoxContainer
var vertical_tabs : Array[Button]


func _enter_tree():
	for child in vertical_tabs_container.get_children():
		child.queue_free()
	vertical_tabs.clear()
	for i : int in tab_container.get_tab_count():
		var tab_name : String = tab_container.get_tab_title(i)
		var button := Button.new() 
		vertical_tabs_container.add_child(button)
		button.text = tab_name
		button.toggle_mode = true
		button.custom_minimum_size = Vector2(200,75)
		button.pressed.connect(func(): tab_container.current_tab = i)
		vertical_tabs.append(button)
	

func _ready():
	tab_container.tab_changed.connect(func(i): release_all_buttons();vertical_tabs[i].button_pressed = true)
	tab_container.current_tab = tab_container.current_tab

func release_all_buttons():
	for button in vertical_tabs:
		button.button_pressed = false
