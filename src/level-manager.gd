extends Node
class_name LevelManager
## call load_level(path:String) to load a new level
## you can wait for the signal level_loaded to know that the level is now present in the scene
##
##

var current_level_scene : Node

@onready var level_spawner : MultiplayerSpawner = $LevelSpawner
@export var spawn_location : Node
@export var maps : Array[map_data]
# could be useful for small level transition during main level loading
#var transition_maps : Array[map_data]

enum {LEVEL_NULL, LEVEL_LOADING, LEVEL_LOADED, LEVEL_ERROR}

var level_status : int = LEVEL_NULL:
	set(v):
		level_status = v
		if level_status == LEVEL_LOADING:
			level_loading.emit()
			Logger.info("Level Loading...", Logger.CATEGORY_GAME)
		if level_status == LEVEL_LOADED and current_level_scene.is_inside_tree():
			level_loaded.emit()
			Logger.info("Level Loaded!", Logger.CATEGORY_GAME)
var loading_progress : float

signal level_loading 
signal level_loaded


func _ready():
	level_spawner.connect("despawned", network_client_level_unloaded)
	level_spawner.connect("spawned", network_client_level_loaded)
	level_spawner.spawn_path = level_spawner.get_path_to(spawn_location)
	for map in maps:
		level_spawner.add_spawnable_scene(map.path.resource_path)

func _process(_delta):
	############# Loading 
	if level_status == LEVEL_LOADED:
		return
	if level_status == LEVEL_LOADING:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(Global.current_selected_map.path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading_progress = progress[0] * 100
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			loading_progress = 100
			await get_tree().create_timer(0.5).timeout
			call_deferred("_load_scene", ResourceLoader.load_threaded_get(Global.current_selected_map.path))
		else:
			Logger.error("Error while loading level: " + str(status), Logger.CATEGORY_GAME)
			level_status = LEVEL_ERROR
	############# Loading 

func load_level_using_name(p_level_name:String):
	for level in maps:
		if level.map_name == p_level_name:
			load_level(level.path)
			return OK
	Logger.error("Level Not Found")
	level_status = LEVEL_ERROR

func load_level(path:PackedScene):
	unload_level()
	ResourceLoader.load_threaded_request(path.resource_path, "", false)
	level_status = LEVEL_LOADING
#	if ResourceLoader.has_cached(path):
#		print("cached")
#		call_deferred("load_scene", ResourceLoader.load_threaded_get(path))
#	else:
#	print("loading")
	
func unload_level():
	if current_level_scene:
		if current_level_scene.is_queued_for_deletion():
			return
		current_level_scene.queue_free()
		current_level_scene = null

func _load_scene(resource : Resource):
	if !resource:
		level_status = LEVEL_ERROR
		return
	current_level_scene = resource.instantiate()
	spawn_location.add_child(current_level_scene)
	level_status = LEVEL_LOADED

func network_client_level_loaded(spawned_node: Node3D):
	current_level_scene = spawned_node
	level_status = LEVEL_LOADED
func network_client_level_unloaded(_despawned_node: Node3D):
	level_status = LEVEL_NULL
