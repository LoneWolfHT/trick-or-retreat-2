extends KinematicBody2D

export (int) var MAX_BOUNDS = 1800
export (int) var MIN_BOUNDS = 120
export var dir = -1

var rng = RandomNumberGenerator.new()
var BOUNDS

func _ready():
	rng.randomize()
	BOUNDS = rng.randi_range(MIN_BOUNDS, MAX_BOUNDS)

	$Texture.flip_h = (dir == -1)

func _process(delta):
	self.position.x += dir * delta * 200

	if self.position.x >= BOUNDS:
		dir = -1
		$Texture.flip_h = true
	elif self.position.x <= -BOUNDS:
		$Texture.flip_h = false
		dir = 1

func _on_screen_exited():
	self.queue_free()
