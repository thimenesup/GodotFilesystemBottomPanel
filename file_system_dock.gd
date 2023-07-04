@tool
extends EditorPlugin

const PluginName := "FileSystemBottomPanel"

const FirstPlaceButton := true

var _file_system_node_name := "FileSystem"
var _file_system_dock: Control = null
var _tool_button: Button = null
var _original_index: int = -1

func _ready() -> void:
	#Wait a frame to ensure that the editor has correctly initialized the file system to prevent crashes on boot
#	await(get_tree(), "idle_frame")ToolButton
	await get_tree().create_timer(1).timeout

	
	_file_system_dock = find_file_system_dock_node()
	if not _file_system_dock:
		printerr("Couldn't find Filesystem Dock")
		return
	
	remove_control_from_docks(_file_system_dock)
	_tool_button = add_control_to_bottom_panel(_file_system_dock, _file_system_dock.name)
	_original_index = _tool_button.get_index()
	
	#Make the FileSystem button to appear first in the bottom panel
	if FirstPlaceButton:
		_tool_button.get_parent().move_child(_tool_button, 0)

func _exit_tree() -> void:
	if not _file_system_dock:
		return
	
	#The editor expects the original index, so move it back for proper deinitialization
	if _tool_button.get_index() != _original_index:
		_tool_button.get_parent().move_child(_tool_button, _original_index)
	
	remove_control_from_bottom_panel(_file_system_dock)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, _file_system_dock)


func get_plugin_name() -> String:
	return PluginName

func get_plugin_icon() -> Texture:
	return get_editor_interface().get_base_control().get_icon("File", "EditorIcons")


func find_file_system_dock_node() -> Node:
	var dummy = Control.new()
	
	for dock_slot in range(EditorPlugin.DOCK_SLOT_MAX):
		add_control_to_dock(dock_slot, dummy)
		for node in dummy.get_parent().get_children():
			if node.name == _file_system_node_name:
				remove_control_from_docks(dummy)
				dummy.free()
				return node
		remove_control_from_docks(dummy)
	
	dummy.free()
	return null
