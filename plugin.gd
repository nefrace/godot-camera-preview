tool
extends EditorPlugin 

const CamPreview = preload("./cam_preview.tscn")
const PreviewButton = preload("./preview_button.tscn")
var cam_preview_instance
var button_instance

var cam_selected: Camera
var pcam: Camera
var rt: RemoteTransform

var eds = get_editor_interface().get_selection()

func _enter_tree():
	connect("main_screen_changed", self, "main_screen_changed")
	cam_preview_instance = CamPreview.instance()
	get_editor_interface().get_editor_viewport().add_child(cam_preview_instance)
	cam_preview_instance.toggle_window(false)
	
	button_instance = PreviewButton.instance()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button_instance)
#	button_instance.connect("toggled", self, "preview_pressed")
	button_instance.connect("preview_toggled", self, "preview_pressed")
	button_instance.connect("preview_clear", self, "preview_free")
	
	eds.connect("selection_changed", self, "selection_changed")
	
func _exit_tree():
	disconnect("main_screen_changed", self, "main_screen_changed")
	button_instance.disconnect("preview_clear", self, "preview_free")
	button_instance.disconnect("preview_toggled", self, "preview_pressed")
	preview_free()
	if cam_preview_instance:
		cam_preview_instance.queue_free()
	if button_instance:
		button_instance.queue_free()
		
func _process(_delta):
	if cam_selected and pcam:
		pcam.fov = cam_selected.fov
		pcam.projection = cam_selected.projection
		pcam.size = cam_selected.size
		
func find_a_camera(root) -> Camera:
	if root is Camera:
		return root
	match button_instance.search_mode:
		1:
			return root.find_node(button_instance.search_name, true, false) as Camera
		2:
			return get_cam_recursive(root)
	return null 
	
func get_cam_recursive(root):
	var cam: Camera
	for child in root.get_children():
		if child is Camera:
			return child
		cam = get_cam_recursive(child)
	return cam
		
func selection_changed():
	var selected = eds.get_selected_nodes()
	if not selected.empty():
		var cam = find_a_camera(selected[0])
		if cam:
			if cam_selected:
				cam_selected.disconnect("tree_exiting", self, "cam_deleted")
			cam_selected = cam
			#remove old camera and remote transform
			preview_free()
			pcam = Camera.new()
			rt = RemoteTransform.new()
			cam_preview_instance.get_vp().add_child(pcam)
			cam_preview_instance.toggle_vp(true)
			cam.add_child(rt)
			cam.connect("tree_exiting", self, "cam_deleted")
			rt.remote_path = pcam.get_path()
			rt.use_global_coordinates = true

func cam_deleted():
	preview_free()
	cam_preview_instance.toggle_vp(false)
	cam_selected.disconnect("tree_exiting", self, "cam_deleted")

func preview_free():
	if pcam:
		pcam.queue_free()
	if rt:
		rt.queue_free()
	cam_preview_instance.toggle_vp(false)

func show_all():
	if cam_preview_instance:
		cam_preview_instance.show()
	if button_instance:
		button_instance.show()

func hide_all():
	if cam_preview_instance:
		cam_preview_instance.hide()
	if button_instance:
		button_instance.hide()
		
func main_screen_changed(screen):
	if screen == "3D":
		show_all()
	else:
		hide_all()

func preview_pressed(toggle):
	cam_preview_instance.toggle_window(toggle)
