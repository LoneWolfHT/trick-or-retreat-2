extends RigidBody2D

export var dir = 1

func _ready():
	$Anim.flip_h = (dir == 1)
	Audio.play("bird")

func _process(_delta):
	self.set_axis_velocity(Vector2(dir * 400 * Settings.difficulty_mult, (randf() * 100) -25))

func _on_screen_exited():
	self.queue_free()
