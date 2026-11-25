extends CanvasLayer
# Autoload: shows touch buttons on phones/tablets (or after the first screen touch).

var pad:Control

func _ready() -> void:
	layer = 100
	pause_mode = PAUSE_MODE_PROCESS
	pad = Control.new()
	pad.set_script(load("res://src/TouchPad.gd"))
	add_child(pad)
	pad.visible = OS.has_touchscreen_ui_hint() || OS.has_feature("mobile")

func _input(event:InputEvent) -> void:
	if event is InputEventScreenTouch && !pad.visible:
		pad.visible = true
