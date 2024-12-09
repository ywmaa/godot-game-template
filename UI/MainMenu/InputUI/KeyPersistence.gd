# This is an autoload (singleton) which will save
# the key maps in a simple way through a dictionary.
extends Node

var keymap_config = ConfigFile.new()
const keymaps_path = "user://keymaps.ini"
var keymaps: Dictionary


func _ready() -> void:
	# First we create the keymap dictionary on startup with all
	# the keymap actions we have.
	for action in InputMap.get_actions():
		var events : Array[InputEvent] = InputMap.action_get_events(action)
		keymaps[action] = events
		#for event in events:
			
	load_keymap()

func load_keymap() -> void:
	if keymap_config.load(keymaps_path) != OK:
		save_keymap() # There is no save file yet, so let's create one.
		return
	#warning-ignore:return_value_discarded
	#var file := FileAccess.open(keymaps_path, FileAccess.READ)
	var temp_keymap: Dictionary = keymap_config.get_value("Keybindings", "Keys")
	#file.close()
	# We don't just replace the keymaps dictionary, because if you
	# updated your game and removed/added keymaps, the data of this
	# save file may have invalid actions. So we check one by one to
	# make sure that the keymap dictionary really has all current actions.
	for action in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			# Whilst setting the keymap dictionary, we also set the
			# correct InputMap event
			InputMap.action_erase_events(action)
			#if keymaps[action] is Array:
				#InputMap.action_add_event(action, keymaps[action][0])
				#if keymaps[action].size() > 1:
					#InputMap.action_add_event(action, keymaps[action][1])
			#else:
			#print(temp_keymap[action])
			for event in temp_keymap[action]:
				InputMap.action_add_event(action, event)
			#if keymaps[action].size() > 1:
				


func save_keymap() -> void:
	# For saving the keymap, we just save the entire dictionary as a var.
	#var file := FileAccess.open(keymaps_path, FileAccess.WRITE)
	keymap_config.set_value("Keybindings", "Keys", keymaps)
	keymap_config.save(keymaps_path)
	#warning-ignore:return_value_discarded
	#file.store_var(keymaps, true)
	#file.close()
