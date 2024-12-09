extends VBoxContainer


@onready var low_graphics = $HBoxContainer/LowGraphics
@onready var medium_graphics = $HBoxContainer/MediumGraphics
@onready var high_graphics = $HBoxContainer/HighGraphics
@onready var sdfgi = $sdfgiButton
@onready var ssil = $ssilButton
@onready var ssao = $ssaoButton
@onready var ssr = $ssrButton

@onready var fxaa_button: CheckButton = $FXAAButton
@onready var taa_button: CheckButton = $TAAButton



func _ready():
	low_graphics.connect("pressed",low)
	medium_graphics.connect("pressed",medium)
	high_graphics.connect("pressed",high)
	#sdfgi.visibility_changed.connect(func() -> void: if !sdfgi.visible: sdfgi.button_pressed = false)
	#ssil.visibility_changed.connect(func() -> void: if !ssil.visible: ssil.button_pressed = false)
	#ssao.visibility_changed.connect(func() -> void: if !ssao.visible: ssao.button_pressed = false)
	#ssr.visibility_changed.connect(func() -> void: if !ssr.visible: ssr.button_pressed = false)

func _process(_delta: float) -> void:
	pass
	#match Global.renderer_index:
		#0: # These Graphics Only work in Forward+
			#sdfgi.visible = true
			#ssil.visible = true
			#ssao.visible = true
			#ssr.visible = true
			#fxaa_button.visible = true
			#taa_button.visible = true
		#_:
			#sdfgi.visible = false
			#ssil.visible = false
			#ssao.visible = false
			#ssr.visible = false
			#fxaa_button.visible = false
			#taa_button.visible = false

func low():
	pass
	#sdfgi.button_pressed = false
	#ssil.button_pressed = false
	#ssao.button_pressed = false
	#ssr.button_pressed = false
func medium():
	pass
	#sdfgi.button_pressed = false
	#ssil.button_pressed = false
	#if Global.renderer_index == 0: # These Graphics Only work in Forward+
		#ssao.button_pressed = true
	#ssr.button_pressed = false
	
func high():
	pass
	#if Global.renderer_index == 0: # These Graphics Only work in Forward+
		#sdfgi.button_pressed = true
		#ssil.button_pressed = true
		#ssao.button_pressed = true
		#ssr.button_pressed = true
