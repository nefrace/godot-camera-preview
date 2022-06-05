tool
extends Control

onready var window: Panel = $window
onready var vp: Viewport = $window/container/vp
onready var container: ViewportContainer = $window/container


func _ready():
	resize_vp()

func get_vp() -> Viewport:
	return vp
	
func toggle_window(toggle):
	window.visible = toggle
	
func toggle_vp(toggle):
	container.visible = toggle

func _on_window_resized():
	resize_vp()
	
func resize_vp():
	vp.size = window.rect_size
	
