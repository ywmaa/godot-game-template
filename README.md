# godot-game-template

##### Godot Version is 4.3 Stable

This template serves as a base for most games in Godot, it gets you up and running with 
basic main menu, settings, credits window, Debug UI (FPS debugging, etc), Logger (for better logging and ability to save to file) 
better keybindings system and easy to extend.

### (TODO)
contains support for multiplayer connections and level loading.

### features:
	- Main Menu
	- LevelManager
	- Loading Screen or Transition Level (TODO)
	- Settings Menu (includes: sound settings, keybindings, graphics, display) Auto saves
	- Credits window
	- Multiplayer Support (TODO)

### Addons used:
	- Debug Menu (Calinou)
	- godot-stuff Logger (Paul Hocker)
	- Input Helper (Nathan Hoad)

## Docs

### Entry Point
Game entry point is main.tscn and main.gd


### Naming Conventions
```
Files               kebab-case (any file on disk that is not a folder)
Folders             PascalCase

Classes             PascalCase
Nodes               PascalCase

Macros              ALL_CAPS

Enum                E_ALL_CAPS
Enum Members        ALL_CAPS

Normal functions    lower_case
Private functions   _lower_case
Trivial variables   i,x,n,f etc...
Local variables     lower_case
Global variables    g_lower_case (searchable by g_ prefix)
```
#### Variables
variables must/should be named snake_case.

examples:
```
var this_is_int : int = 42
var this_is_a_float : float = 3.14159265359
var this_is_a_bool : bool = true
```
#### Functions
functions must/should be named snake_case.

examples:
```
func function_name(args) -> void:
	pass
```

#### Enums
any enum must be named all upper case.

examples:
```
enum E_LEVEL_STATE {
	LEVEL_NULL,
	LEVEL_LOADING,
	LEVEL_LOADED
}
```
Why ? This helps differentiating the enum variable name from the enum type, the name is in all snake_case, and the type is UPPER_CASE
