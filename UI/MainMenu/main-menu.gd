extends Control
class_name MainMenu

####################### UI

@export var resume_button : Button
@export var play_button : Button
@export var options_button : Button
@export var credits_button : Button
@export var exit_button : Button
@export var leave_button : Button

@export var OptionsMenu : PackedScene
@export var PlayMenu : PackedScene
@export var Loading: PackedScene


var loading_screen : Control


####################### Gameplay


func _ready():
	#resume_button.connect("pressed", main_menu_visibility.bind(false))
	#play_button.connect("pressed", play)
	options_button.connect("pressed", options)
	credits_button.connect("pressed", credits)
	exit_button.connect("pressed", exit)
	#leave_button.connect("pressed", leave_game)

func show_loading_screen() -> void:
	clear_panels()
	loading_screen = Loading.instantiate()
	create_window().add_child(loading_screen)

func show_fake_loading_screen() -> void:
	clear_panels()
	var fake_loading_screen = Loading.instantiate()
	create_window().add_child(fake_loading_screen)
	fake_loading_screen.waiting_for_server = true

func main_menu_mode():
	$ColorRect.visible = true
	resume_button.visible = false
	leave_button.visible = false
	play_button.visible = true
	exit_button.visible = true

func options() -> void:
	clear_panels()
	var options_menu : Node = OptionsMenu.instantiate()
	create_window().add_child(options_menu)

var embeded_windows : Array[Window]
func create_window() -> Window:
	var window : Window = preload("res://UI/MainMenu/window.tscn").instantiate()
	add_child(window)
	
	window.size = get_viewport().size-Vector2i(0,30)
	window.position = Vector2i(0,30)
	embeded_windows.append(window)
	window.close_requested.connect(func() -> void:embeded_windows.erase(window))
	return window

func credits():
	clear_panels()
	var about_box = preload("res://UI/MainMenu/About/about.tscn").instantiate()
	add_child(about_box)
	about_box.connect("popup_hide", about_box.queue_free)
	about_box.popup_centered()

func exit():
	get_tree().quit()

func clear_panels():
	for w in embeded_windows:
		w.close_requested.emit()

func _on_main_menu_pressed():
	main_menu_visibility(true)

func main_menu_visibility(value:bool):
	clear_panels()
	Global.in_game = !value
	main_menu_fade(value)

func game_menu_mode():
	$ColorRect.visible = false
	resume_button.visible = true
	leave_button.visible = true
	play_button.visible = false
	exit_button.visible = false

func leave_game() -> void:
	Global.main.leave_game()


func main_menu_fade(v:bool):
	if v:
		visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate",Color(1,1,1,1 if v else 0),0.5)
	tween.tween_callback(main_menu_set_visibilty)

func main_menu_set_visibilty():
	if modulate.a == 1:
		visible = true
	else:
		visible = false
