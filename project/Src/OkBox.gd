extends AnimatedSprite

var cooldownTimer = 0
var cooldownDuration = .25

func _process(delta):
	# if not neutral then increase the cooldown timer
	if animation != 'neutral':
		cooldownTimer += delta
	else:
		cooldownTimer = 0
	
	# if cooldown is up then go back to neutral colour
	if cooldownTimer >= cooldownDuration:
		cooldownTimer = 0
		animation = 'neutral'
