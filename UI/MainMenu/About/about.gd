extends Window

@onready var application_name_label = $HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/ApplicationName
@onready var authors_grid = $HBoxContainer/VBoxContainer/VBoxContainer/Authors/List
@onready var patrons_list = $HBoxContainer/VBoxContainer/VBoxContainer/Donors/VBoxContainer/Patrons

const CONTRIBUTORS = [
#	{ name="ywmaa", contribution="Lead developer" },
]

const PATRONS = [
]

func _ready() -> void:
	application_name_label.text = ProjectSettings.get_setting("application/config/name")
	for c in CONTRIBUTORS:
		var label : Label = Label.new()
		label.text = c.name
		authors_grid.add_child(label)
		label = Label.new()
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.text = c.contribution
		authors_grid.add_child(label)
	for p in PATRONS:
		patrons_list.add_item(p)

func open_url(url) -> void:
	OS.shell_open(url)
