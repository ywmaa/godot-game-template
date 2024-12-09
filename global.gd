extends Node

#------------------ References ------------------#
var main : Main

func _enter_tree() -> void:
	pass

func _ready():
	_load_settings()
	## Godot uses different color-space for each renderer, sometimes tweaking this values makes the colors look very similar regardless of the renderer
	match current_renderer:
		"gl_compatibility":
			pass
			#postprocess.adjustment_brightness = 2.0
			#postprocess.adjustment_saturation = 2.0
			#postprocess.background_energy_multiplier = 0.25
			#postprocess.adjustment_contrast = 1.0
		"mobile":
			pass
			#postprocess.adjustment_brightness = 1.5
			#postprocess.adjustment_saturation = 1.5
			#postprocess.background_energy_multiplier = 0.5
			#postprocess.adjustment_contrast = 1.5
		"forward_plus":
			pass
			#postprocess.adjustment_brightness = 1.5
			#postprocess.adjustment_saturation = 1.0
			#postprocess.background_energy_multiplier = 1.0
			#postprocess.adjustment_contrast = 1.5

func _process(_delta):
	pass


#------------------ Global Enums ------------------#


#------------------ Helper Functions ------------------#
func map_range_clamped(value,InputMin,InputMax,OutputMin,OutputMax):
	value = clamp(value,InputMin,InputMax)
	return ((value - InputMin) / (InputMax - InputMin) * (OutputMax - OutputMin) + OutputMin)



#------------------ Game Settings ------------------#

var full_screen: bool = true:
	set(value):
		full_screen = value
		var window_mode: DisplayServer.WindowMode
		match value:
			true:
				window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			false:
				window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(window_mode)
		save_config("full_screen")
var use_fxaa: bool = true:
	get: return ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa")
	set(value):
		match value:
			true:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", 1)
			false:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", 0)
		ProjectSettings.save_custom(override_project_settings_save_file)
var use_taa: bool = true:
	get: return ProjectSettings.get_setting("rendering/anti_aliasing/quality/use_taa")
	set(value):
		match value:
			true:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", true)
			false:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", false)
		ProjectSettings.save_custom(override_project_settings_save_file)
const sizes: Array[Vector2] = [Vector2(1280, 720), Vector2(1920, 1080), Vector2(2560, 1440), Vector2(3840, 2160)]
const scales: Array[float] = [0.5, 0.59, 0.67, 0.77, 1.0, 1.5, 2.0]

static func window_clamp_to_screen(size: Vector2) -> Vector2:
	var screen_size: Rect2i = DisplayServer.screen_get_usable_rect()
	size.x = min(size.x, screen_size.size.x)
	size.y = min(size.y, screen_size.size.y)
	
	return size


static func center_window() -> void:
	var display_size: Vector2 = DisplayServer.screen_get_size()
	var window_size: Vector2 = DisplayServer.window_get_size()
	var target_pos: Vector2 = (display_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(target_pos)

var resolution_index : int = 1:
	set(v):
		resolution_index = v
		var size: Vector2 = sizes[resolution_index]
		size = window_clamp_to_screen(size)
		DisplayServer.window_set_size(size)
		center_window()
		save_config("resolution_index")
		
var fsr_index : int = 4:
	set(v):
		fsr_index = v
		var scale: float = scales[fsr_index]
		Global.res_scale = scale
		save_config("fsr_index")
const renederers : Array[String] = ["forward_plus", "mobile", "gl_compatibility"]
var renderer_index : int:
	set(v):
		renderer_index = v
		var renderer: String = renederers[renderer_index]
		Global.current_renderer = renderer
		save_config("renderer_index")
#var postprocess = preload("res://Levels/default_env.tres")

var sdfgi : bool = false:
	set(value):
		sdfgi = value
		#postprocess.sdfgi_enabled = sdfgi
		save_config("sdfgi")
var ssil : bool = false:
	set(value):
		ssil = value
		#postprocess.ssil_enabled = ssil
		save_config("ssil")
var ssao : bool = false:
	set(value):
		ssao = value
		#postprocess.ssao_enabled = ssao
		save_config("ssao")
var ssr : bool = false:
	set(value):
		ssr = value
		#postprocess.ssr_enabled = ssr
		save_config("ssr")

var show_debug_menu : bool = false:
	set(value):
		show_debug_menu = value
		update_debug_menu()
		save_config("show_debug_menu")
var show_fps : bool = false:
	set(value):
		show_fps = value
		update_debug_menu()
		save_config("show_fps")
func update_debug_menu():
	if show_debug_menu:
		DebugMenu.show_full_menu()
		return
	if show_fps:
		DebugMenu.show_fps_only()
		return
	DebugMenu.disable_menu()
var res_scale : float = 1.0:
	set(value):
		res_scale = value
		get_viewport().scaling_3d_scale = res_scale
var fsr_sharpness : float = 0.2:
	set(value):
		fsr_sharpness = value
		get_viewport().fsr_sharpness = 2.0 - fsr_sharpness
		save_config("fsr_sharpness")
		
var camera_fov : float = 100.0:
	set(value):
		camera_fov = clampf(value, 75.0, 120.0)
		save_config("camera_fov")
		camera_fov_changed.emit(camera_fov)
signal camera_fov_changed(fov:float)
var show_touch_ui: bool = OS.get_name() == "Android" or OS.get_name() == "iOS" 

var override_project_settings_save_file: String = "user://override.cfg"
var current_renderer:String:
	get: return ProjectSettings.get_setting("rendering/renderer/rendering_method")
	set(v):
		if v != ProjectSettings.get_setting("rendering/renderer/rendering_method"):
			var confirm_dialog : AcceptDialog = AcceptDialog.new()
			add_child(confirm_dialog)
			confirm_dialog.title = "Please Restart To Apply Settings"
			confirm_dialog.popup_centered(Vector2i(300,50))
			confirm_dialog.show()
		match v:
			"forward_plus":
				ProjectSettings.set_setting("rendering/renderer/rendering_method", "forward_plus")
			"mobile":
				ProjectSettings.set_setting("rendering/renderer/rendering_method", "mobile")
			"gl_compatibility":
				ProjectSettings.set_setting("rendering/renderer/rendering_method", "gl_compatibility")
		ProjectSettings.save_custom(override_project_settings_save_file)

const preferences_file : String = "user://player_preferences.cfg"
# Create new ConfigFile object.
var config = ConfigFile.new()
var in_game : bool:
	set(v):
		in_game = v
		if (DisplayServer.get_name() == "headless"):
			return
		if in_game:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


var sound_master_volume : float = 1.0:
	set(v):
		sound_master_volume = v
		AudioServer.set_bus_volume_db(0, linear_to_db(v))
		save_config("sound_master_volume")
	get: return sound_master_volume
var sound_master_mute : bool:
	set(v):
		sound_master_mute = v
		AudioServer.set_bus_mute(0, v)
		save_config("sound_master_mute")
var sound_music_volume : float = 1.0:
	set(v):
		sound_music_volume = v
		AudioServer.set_bus_volume_db(1, linear_to_db(v))
		save_config("sound_music_volume")
	get: return sound_music_volume
var sound_music_mute : bool:
	set(v):
		sound_music_mute = v
		AudioServer.set_bus_mute(1, v)
		save_config("sound_music_mute")
var sound_effects_volume : float = 1.0:
	set(v):
		sound_effects_volume = v
		AudioServer.set_bus_volume_db(2, linear_to_db(v))
		save_config("sound_effects_volume")
	get: return sound_effects_volume
var sound_effects_mute : bool:
	set(v):
		sound_effects_mute = v
		AudioServer.set_bus_mute(2, v)
		save_config("sound_effects_mute")
var sound_communication_volume : float = 1.0:
	set(v):
		sound_communication_volume = v
		AudioServer.set_bus_volume_db(3, linear_to_db(v))
		save_config("sound_communication_volume")
	get: return sound_communication_volume
var sound_communication_mute : bool:
	set(v):
		sound_communication_mute = v
		AudioServer.set_bus_mute(3, v)
		save_config("sound_communication_mute")
var sound_ui_volume : float = 1.0:
	set(v):
		sound_ui_volume = v
		AudioServer.set_bus_volume_db(4, linear_to_db(v))
		save_config("sound_ui_volume")
	get: return sound_communication_volume
var sound_ui_mute : bool:
	set(v):
		sound_ui_mute = v
		AudioServer.set_bus_mute(4, v)
		save_config("sound_ui_mute")
func _load_settings():
	config.load(preferences_file)
	for k in DEFAULT_CONFIG_PATH.keys():
		if !config.has_section_key(DEFAULT_CONFIG_PATH[k], k):
			save_config(k)
		else:
			set(k, config.get_value(DEFAULT_CONFIG_PATH[k], k))

const settings_key : String = "Settings"
const DEFAULT_CONFIG_PATH = {
	full_screen = settings_key,
	use_fxaa = settings_key,
	use_taa = settings_key,
	current_selected_hero_index = "Hero",
	sound_master_volume = settings_key,
	sound_master_mute = settings_key,
	sound_music_volume = settings_key,
	sound_music_mute = settings_key,
	sound_effects_volume = settings_key,
	sound_effects_mute = settings_key,
	sound_communication_volume = settings_key,
	sound_communication_mute = settings_key,
	sound_ui_volume = settings_key,
	sound_ui_mute = settings_key,
	sdfgi = settings_key,
	ssil = settings_key,
	ssao = settings_key,
	ssr = settings_key,
	show_debug_menu = settings_key,
	show_fps = settings_key,
	fsr_sharpness = settings_key,
	camera_fov = settings_key,
	fsr_index = settings_key,
	resolution_index = settings_key,
	renderer_index = settings_key,
}
func save_config(variable_name: String):
	config.set_value(DEFAULT_CONFIG_PATH[variable_name], variable_name, get(variable_name))
	config.save(preferences_file)
	
