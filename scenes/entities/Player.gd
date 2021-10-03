extends KinematicBody2D

export var Y_LIMITS = 1280
export var BIRB_MURDER_FINE = 18 + (3 * Settings.difficulty_mult)
var SPEED = 666

var immune = true
var _DEAD = false

func _on_button_activate(_button):
	Audio.stop("mainloop")

func start_immune():
	immune = true
	$ImmunityTimer.start()

var is_beam_on = true
func beam_on():
	Audio.play("beam")
	$CollectTimer.start()
	$BeamArea/Beam.visible = true
	$BeamArea.space_override = Area2D.SPACE_OVERRIDE_REPLACE
	is_beam_on = true

func beam_off():
	Audio.stop("beam")
	$CollectTimer.stop()
	$BeamArea/Beam.visible = false
	$BeamArea.space_override = Area2D.SPACE_OVERRIDE_DISABLED
	is_beam_on = false

func die():
	beam_off()
	Audio.stop("mainloop")
	Audio.play("death")
	_DEAD = true
	$LockTimer.stop()
	$Progress/Bar.visible = false
	dead_rotation = true
	deadvel = Vector2((randf() - 0.5) * SPEED, SPEED * 2)
	$AnimationPlayer.stop(true)
	$AnimationPlayer.seek(0.5, true)
	$CandyParticles.color = ColorN("orange", 1)
	$CandyParticles.one_shot = false
	$CandyParticles.emitting = true
	$CandyParticles.local_coords = false
	$CandyParticles.scale *= 5
	$CandyParticles.explosiveness = 0
	$CandyParticles.amount = 100
	$CandyParticles.spread = 360

	$Progress/Info.text = "You became a little too unstable and crashed"
	$Progress/Info.visible = true
	$Progress/SmallExitMenu.visible = false
	$Progress/Danger.visible = false

func win():
	beam_off()
	Audio.stop("mainloop")
	Audio.play("win")
	_DEAD = true
	$Progress/Bar.visible = false
	deadvel = Vector2(0, -SPEED)
	$AnimationPlayer.stop(true)
	$AnimationPlayer.seek(0.5, true)
	$LockTimer.start(5)

	if Settings.difficulty_mult > 1:
		$Progress/Info.text = "You make the journey home...\nCongrats on winning hard mode!"
	else:
		$Progress/Info.text = "You got enough fuel to make the journey home!"

func _ready():
	beam_off()

var deadvel
var dead_rotation = false
func _process(delta):
	if _DEAD:
		var _pass = self.move_and_collide(deadvel * delta)

		if dead_rotation:
			self.rotation_degrees += 10
		return

	var dirvec = Vector2()

	if $Progress/Bar.value <= $Progress/Bar.min_value:
		return die()
	elif $Progress/Bar.value >= $Progress/Bar.max_value:
		return win()
	elif $Progress/Bar.value <= $Progress/Bar.min_value + 5:
		$Progress/Danger.visible = true
		Audio.stop("mainloop")
	elif $Progress/Danger.visible:
		$Progress/Danger.visible = false
		Audio.resume("mainloop")

	print(self.position.y)
	self.position.y = clamp(self.position.y, -Y_LIMITS, Y_LIMITS)

	$Progress/Bar.value -= delta

	if Input.is_action_pressed("up"):
		dirvec.y = -delta * SPEED * 0.4;
	elif Input.is_action_pressed("down"):
		dirvec.y = delta * SPEED * 0.4;

	if Input.is_action_pressed("left"):
		dirvec.x = -delta * SPEED
	elif Input.is_action_pressed("right"):
		dirvec.x = delta * SPEED

	var collision = self.move_and_collide(dirvec, false)

	if !immune && collision:
		start_immune()
		Audio.play("ship_hit")
		Audio.play("bird")
		$Progress/Bar.value -= BIRB_MURDER_FINE
		collision.collider.set_angular_velocity(89.5)
		collision.collider.set_axis_velocity(Vector2(dirvec.x * 3, -300))

var beam_target = false
func _on_BeamArea_entered(body):
	if body.is_in_group("treater"):
		if !_DEAD && !is_beam_on:
			$LockTimer.start()
			beam_on()
			beam_target = body

func _on_LockTimer_timeout():
	if !_DEAD:
		if !beam_target || !$BeamArea.overlaps_body(beam_target):
			beam_off()
			beam_target = false
		else:
			$LockTimer.start()
	else:
		$Progress/Info.visible = true
		$Camera/NightBg/NightBg/Stars.direction = Vector2(0, 1)
		$Camera/NightBg/NightBg/Stars.initial_velocity = 300
		$Camera/NightBg/NightBg/Stars.lifetime = 3
		$Camera/NightBg/NightBg/Stars.speed_scale = 2.4
		$Sprite/Exhaust.emitting = true

func _on_CollectTimer_finish():
	Audio.play("pickup")
	$Progress/Bar.value += $CollectTimer.wait_time * 7
	var particle_pos = $BeamRay.get_collider()

	if particle_pos:
		$CandyParticles.position.y = (particle_pos.position.y - self.position.y) + 10
	$CandyParticles.emitting = true
	beam_off()
	beam_target.queue_free()
	beam_target = false

func _on_ImmunityTimer_timeout():
	immune = false
