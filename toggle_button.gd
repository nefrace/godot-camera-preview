tool

extends MenuButton

var search_mode = 0
var search_mode_offset = 2
var pop : PopupMenu
var is_visible: bool = false
var search_name: String = "Camera*"

signal preview_toggled(visible)
signal preview_clear()

func _enter_tree():
	pop = get_popup()
	pop.clear()
	pop.add_check_item("Visible")
	pop.add_separator("Search node")
	pop.add_radio_check_item("Disabled")
	pop.add_radio_check_item("By name")
	pop.add_radio_check_item("By class")
	pop.add_separator()
	pop.add_item("Change search pattern")
	pop.add_item("Clear preview")
	pop.connect('id_pressed', self, 'item_pressed')
	pop.set_item_checked(2, true)
	
func _exit_tree():
	pop.disconnect('id_pressed', self, 'item_pressed')
	
func select_search_mode(id):
	pop.set_item_checked(search_mode + search_mode_offset, false)
	search_mode = id - search_mode_offset
	pop.set_item_checked(id, true)
	
func toggle_visibility():
	is_visible = !is_visible
	pop.set_item_checked(0, is_visible)
	emit_signal("preview_toggled", is_visible)
	
	
func item_pressed(id):
	if id == 0:
		toggle_visibility()
		return
	if id >= 2 and id <= 4:
		select_search_mode(id)
		return
	if id == 6:
		$WindowDialog.popup_centered()
		$WindowDialog/VBoxContainer/TextEdit.text = search_name
		return
	if id == 7:
		emit_signal("preview_clear")


func set_search_text():
	search_name = $WindowDialog/VBoxContainer/TextEdit.text
	$WindowDialog.hide()

func _on_change_search_pressed():
	set_search_text()

func _on_TextEdit_text_entered(new_text):
	set_search_text()

