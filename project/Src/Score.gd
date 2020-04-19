extends Node2D

var score = 0
var high_score = 0

func _process(delta):
	# Set labels text to score and high score
	$ScoreLabel.text = str(score)
	$HighScoreLabel.text = "HI " + str(high_score)
	pass

# Call when starting new game to
# record high score and reset current score
func new_game():
	if score > high_score:
		high_score = score
	score = 0
