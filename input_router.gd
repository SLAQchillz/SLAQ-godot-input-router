## General input interpretation using the InputMap and Input singleton
## Intended to be used as a Global Node

extends Node

signal input_received_direction(Vector2)
signal input_received_accept()
signal input_received_select()
signal input_received_cancel()

var accepting_directional_input 		: bool = true
var accepting_basic_interactive_input	: bool = true

@export_group("Directional Input Actions")
@export var input_left 	: String = "ui_left"
@export var input_right : String = "ui_right"
@export var input_up	: String = "ui_up"
@export var input_down	: String = "ui_down"

@export_group("Basic Interactive Actions")
@export var input_accept	: String = "ui_accept"
@export var input_select	: String = "ui_select"
@export var input_cancel	: String = "ui_cancel"

@export_group("Debugging")
@export var print_console_messages : bool = false

func _process(delta: float) -> void:
	if accepting_directional_input:
		_directional_input_logic()
	if accepting_basic_interactive_input:
		_basic_interaction_input_logic()


func _basic_interaction_input_logic():
	if Input.is_action_just_pressed(input_accept):
		if print_console_messages:
			prints(self, "received accept input.")
		self.input_received_accept.emit()
	if Input.is_action_just_pressed(input_select):
		if print_console_messages:
			prints(self, "received select input.")
		self.input_received_select.emit()
	if Input.is_action_just_pressed(input_cancel):
		if print_console_messages:
			prints(self, "received cancel input.")
		self.input_received_cancel.emit()


func _check_input_mapping():
	# Directional input checks
	if not InputMap.has_action(input_left):
		push_error("InputRouter disabling directional input. No InputAction found for input_left: "+ input_left)
		accepting_directional_input = false
	if not InputMap.has_action(input_right):
		push_error("InputRouter disabling directional input. No InputAction found for input_right: "+ input_right)
		accepting_directional_input = false
	if not InputMap.has_action(input_up):
		push_error("InputRouter disabling directional input. No InputAction found for input_up: "+ input_up)
		accepting_directional_input = false
	if not InputMap.has_action(input_down):
		push_error("InputRouter disabling directional input. No InputAction found for input_down: "+ input_down)
		accepting_directional_input = false
	
	# Basic interaction checks
	if not InputMap.has_action(input_accept):
		push_error("InputRouter disabling basic interactions. No InputAction found for input_accept: "+ input_accept)
		accepting_basic_interactive_input = false
	if not InputMap.has_action(input_select):
		push_error("InputRouter disabling basic interactions. No InputAction found for input_select: "+ input_select)
		accepting_basic_interactive_input = false
	if not InputMap.has_action(input_cancel):
		push_error("InputRouter disabling basic interactions. No InputAction found for input_cancel: "+ input_cancel)
		accepting_basic_interactive_input = false


func _directional_input_logic():
	var input_dir = Input.get_vector(input_left, input_right, input_up, input_down)
	input_dir = input_dir.normalized()
	if input_dir:
		if print_console_messages:
			prints(self, "received movement input for vector:", input_dir)
		self.input_received_direction.emit(input_dir)
