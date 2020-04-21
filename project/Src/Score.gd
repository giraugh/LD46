extends Node2D

var score = 0
var high_score = 0

func _process(delta):
	# Set labels text to score and high score
	$ScoreLabel.text = "SCORE " + str(score)
	$HighScoreLabel.text = "HI " + str(high_score)
	
	if score > high_score:
		high_score = score

# Call when starting new game to
# reset current score
func new_game():
	score = 0

func add_score(amount):
	score += amount
