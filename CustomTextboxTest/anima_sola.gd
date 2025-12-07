extends AnimationPlayer

## A custom script/node that adds some animations to the textbox.

# Careful: Sync these with the ones in the root script!
enum AnimationsIn {NONE, POP_IN, FADE_UP}
enum AnimationsOut {NONE, POP_OUT, FADE_DOWN}
enum AnimationsNewText {NONE, WIGGLE}

var animation_in: AnimationsIn
var animation_out: AnimationsOut
var animation_new_text: AnimationsNewText

var full_clear := true

func _ready() -> void:
	var text_system: Node = DialogicUtil.autoload().get(&'Text')
	text_system.connect(&'animation_textbox_show', _on_textbox_show)

func _on_textbox_show() -> void:
	if animation_in == AnimationsIn.NONE:
		return
	play('RESET')
	var animation_system: Node = DialogicUtil.autoload().get(&'Animations')
	animation_system.call(&'start_animating')
	$"../AnimationParent".get_parent().get_parent().set(&'modulate', Color.TRANSPARENT)
	%DialogicNode_DialogText.text = ""
	match animation_in:
		AnimationsIn.POP_IN:
			play("textbox_fade_up")
		AnimationsIn.FADE_UP:
			play("textbox_fade_up")
	if not animation_finished.is_connected(Callable(animation_system, &'animation_finished')):
		animation_finished.connect(Callable(animation_system, &'animation_finished'), CONNECT_ONE_SHOT)
