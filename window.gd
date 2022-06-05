tool
extends Panel

var dragging = false
var resizing = false
var mouse_offset : Vector2


func _process(_delta) -> void:
	if dragging:
		var movement = get_local_mouse_position() - mouse_offset
		set_position(rect_position + movement)
	if resizing:
		var new_size = get_local_mouse_position()
		set_size(new_size)


func _on_window_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			dragging = event.pressed
			mouse_offset = get_local_mouse_position()


func _on_resize_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			resizing = event.pressed
			mouse_offset = get_local_mouse_position()
