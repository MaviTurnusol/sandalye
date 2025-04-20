extends CanvasLayer

var healthbarOver
var pissbar
var healthbarUnder
var healthbarUnderTip
var healthbarOverTip
# Called when the node enters the scene tree for the first time.
func _ready():
	_draw_healthbar()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#_health_regen(delta)
	pass

func _draw_healthbar():
	await Engine.get_main_loop().process_frame
	
	healthbarOver = TextureRect.new()
	pissbar = TextureRect.new()
	healthbarUnder = TextureRect.new()
	
	healthbarUnder.texture = load("res://Common/HUD/hpBarEmpty.png")
	healthbarUnder.size = Vector2(GlobalScript.playerMaxHP, 16)
	healthbarUnder.position = Vector2(0, 10)
	healthbarUnder.z_index = -1
	
	healthbarUnderTip = TextureRect.new()
	healthbarUnderTip.texture = load("res://Common/HUD/hpBarEndEmpty.png")
	healthbarUnderTip.size = Vector2(3, 16)
	healthbarUnderTip.position = Vector2(GlobalScript.playerMaxHP-3, 0)
	
	$control/heart/bars.add_child(healthbarUnder)
	healthbarUnder.add_child(healthbarUnderTip)
	
	healthbarOver.texture = load("res://Common/HUD/hpBar.png")
	healthbarOver.size = Vector2(GlobalScript.playerHP, 16)
	healthbarOver.position = Vector2(0, 10)
	healthbarOver.z_index = -1
	
	healthbarOverTip = TextureRect.new()
	healthbarOverTip.texture = load("res://Common/HUD/hpBarEnd.png")
	healthbarOverTip.size = Vector2(3, 16)
	healthbarOverTip.position = Vector2(GlobalScript.playerMaxHP-3, 0)
	
	if GlobalScript.playerHP == GlobalScript.playerMaxHP:
		healthbarOverTip.visible = true
	else:
		healthbarOverTip.visible = false
	
	$control/heart/bars.add_child(healthbarOver)
	healthbarOver.add_child(healthbarOverTip)

func _update_healthbar():
	healthbarUnder.size = Vector2(GlobalScript.playerMaxHP, 16)
	healthbarUnderTip.position = Vector2(GlobalScript.playerMaxHP-3, 0)
	healthbarOver.size = Vector2(GlobalScript.playerHP, 16)
	healthbarOverTip.position = Vector2(GlobalScript.playerMaxHP-3, 0)
	
	if GlobalScript.playerHP == GlobalScript.playerMaxHP:
		healthbarOverTip.visible = true
	else:
		healthbarOverTip.visible = false

func _health_regen(delta):
	GlobalScript.playerHP = clamp(GlobalScript.playerHP+(delta*16), 0, GlobalScript.playerMaxHP)
	_update_healthbar()
