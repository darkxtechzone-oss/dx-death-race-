extends Control
# DarkX on-screen touch controls: injects the same actions the keyboard uses.

var buttons:Array = []
var touch_to_btn:Dictionary = {}
var btn_count:Dictionary = {}
var font:Font = null

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect_position = Vector2.ZERO
	rect_size = Vector2(1920, 1080)
	font = load("res://assets/fonts/mainfont_36.tres")
	var white:Color = Color(1, 1, 1)
	_add("left", Rect2(30, 830, 180, 180), ["left", "ui_left"], "<", white)
	_add("right", Rect2(230, 830, 180, 180), ["right", "ui_right"], ">", white)
	_add("brake", Rect2(1330, 880, 150, 150), ["backward", "ui_down"], "BRK", Color(1, 0.6, 0.2))
	_add("gas", Rect2(1500, 860, 200, 170), ["forward", "ui_up"], "GAS", Color(0.3, 1, 0.4))
	_add("fire", Rect2(1720, 880, 160, 150), ["shoot"], "FIRE", Color(1, 0.3, 0.3))
	_add("mine", Rect2(1330, 700, 150, 150), ["mine"], "MINE", Color(1, 0.8, 0.2))
	_add("nitro", Rect2(1500, 700, 170, 140), ["nitro"], "NITRO", Color(0.3, 0.7, 1))
	_add("hb", Rect2(1690, 700, 190, 150), ["handbrake"], "DRIFT", Color(0.8, 0.5, 1))
	_add("cam", Rect2(30, 20, 130, 90), ["camera"], "CAM", white)
	_add("lights", Rect2(180, 20, 130, 90), ["reflectors"], "LIGHT", white)
	_add("back", Rect2(1330, 20, 140, 90), ["ui_cancel"], "BACK", Color(1, 0.5, 0.5))
	_add("ok", Rect2(1490, 20, 140, 90), ["ui_select"], "OK", Color(0.5, 1, 0.5))
	_add("help", Rect2(1650, 20, 110, 90), ["help"], "?", white)
	_add("pause", Rect2(1780, 20, 110, 90), ["pause"], "II", white)

func _add(id:String, rect:Rect2, actions:Array, label:String, color:Color) -> void:
	buttons.append({"id": id, "rect": rect, "actions": actions, "label": label, "color": color})
	btn_count[id] = 0

func _btn_at(pos:Vector2) -> int:
	for i in buttons.size():
		if buttons[i]["rect"].has_point(pos):
			return i
	return -1

func _send(action:String, pressed:bool) -> void:
	var ev:InputEventAction = InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	ev.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(ev)

func _press(i:int) -> void:
	var id:String = buttons[i]["id"]
	btn_count[id] += 1
	if btn_count[id] == 1:
		for a in buttons[i]["actions"]:
			_send(a, true)
		update()

func _release(i:int) -> void:
	var id:String = buttons[i]["id"]
	btn_count[id] = max(0, btn_count[id] - 1)
	if btn_count[id] == 0:
		for a in buttons[i]["actions"]:
			_send(a, false)
		update()

func _input(event:InputEvent) -> void:
	if !visible:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			var i:int = _btn_at(event.position)
			if i >= 0:
				touch_to_btn[event.index] = i
				_press(i)
				get_tree().set_input_as_handled()
		elif touch_to_btn.has(event.index):
			_release(touch_to_btn[event.index])
			touch_to_btn.erase(event.index)
			get_tree().set_input_as_handled()
	elif event is InputEventScreenDrag:
		if touch_to_btn.has(event.index):
			var cur:int = touch_to_btn[event.index]
			var i:int = _btn_at(event.position)
			if i != cur:
				_release(cur)
				if i >= 0:
					touch_to_btn[event.index] = i
					_press(i)
				else:
					touch_to_btn.erase(event.index)

func _draw() -> void:
	for b in buttons:
		var c:Color = b["color"]
		var down:bool = btn_count[b["id"]] > 0
		draw_rect(b["rect"], Color(c.r, c.g, c.b, 0.55 if down else 0.22), true)
		draw_rect(b["rect"], Color(c.r, c.g, c.b, 0.8), false, 3.0)
		if font != null:
			var sz:Vector2 = font.get_string_size(b["label"])
			var pos:Vector2 = b["rect"].position + (b["rect"].size - sz) / 2.0 + Vector2(0, font.get_ascent())
			draw_string(font, pos, b["label"], Color(1, 1, 1, 0.9))
