extends Node2D

var SPEED = 2000
var rotate = false

func _process(delta):
	if rotate:
		print($Camera2D/UhOh.rect_scale)
		if $Camera2D/UhOh.rect_scale.x < 0.1:
			$Camera2D/UhOh.rect_scale += Vector2(delta / 20, delta / 20)
		return

	var moving = false

	if Input.is_action_pressed("up"):
		moving = true
		self.position.y += -delta * SPEED;
	elif Input.is_action_pressed("down"):
		moving = true
		self.position.y += delta * SPEED;

	if Input.is_action_pressed("left"):
		moving = true
		self.position.x += -delta * SPEED
	elif Input.is_action_pressed("right"):
		moving = true
		self.position.x += delta * SPEED

	if moving:
		if $Timer.is_stopped():
			$Timer.start()

		if !$Camera2D/Weeee.visible:
			$Camera2D/Weeee.visible = true
	else:
		if $Camera2D/Weeee.visible:
			$Camera2D/Weeee.visible = false

func _on_Timer_timeout():
	rotate = true
	$Anim.play("rot")
	$Camera2D/Weeee.visible = false
	$Camera2D/UhOh.visible = true
	$Camera2D/UhOh.rect_scale = Vector2(0.01, 0.01)
	$Camera2D/TRButton.visible = true
	Audio.play_low("ship_hit", -10)
