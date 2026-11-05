extends Node2D

@export var player1: Cowboy
@export var player2: Cowboy
@export var timer: Timer
@export var label: Label
@export var bgMusicPlayer: AudioStreamPlayer
@export var gameOverLabel: Label
@export var quitBtn: Button
@export_category('variables')
@export var timeRange = {'min': 2.0, 'max': 10.0}
@export var bgMusicNormal: AudioStream
@export var bgMusicEnd: AudioStream

var startLabelTxt = 'STEADY'

func _ready() -> void:
	# setup signals
	quitBtn.pressed.connect(quitGame)
	timer.timeout.connect(startDuel)
	
	# setup bg music looping
	bgMusicNormal.loop = true
	bgMusicEnd.loop = false
	
	# get things started!
	startGame()

func _process(delta: float) -> void:
	if (Global.gameOver and Input.is_action_just_pressed('reset_game')):
		resetGame()

func startGame() -> void:
	Global.gameOver = false
	gameOverLabel.visible = false
	quitBtn.visible = false
	label.modulate = Color.BLACK
	label.text = startLabelTxt
	
	bgMusicPlayer.stream = bgMusicNormal
	bgMusicPlayer.play()
	
	# pick random time
	var sec = randf_range(timeRange['min'], timeRange['max'])
	timer.wait_time = sec
	
	timer.start()

func resoveDuel(action: String) -> void:
	if (action == 'p2_shoot'):
		player1.kill()
	
	if (action == 'p1_shoot'):
		player2.kill()
	
	gameOver()

func startDuel() -> void:
	label.modulate = Color.CHARTREUSE
	label.text = 'SHOOT!'

	player1.isAllowedToShoot = true
	player2.isAllowedToShoot = true

func gameOver() -> void:
	quitBtn.visible = true
	Global.gameOver = true
	gameOverLabel.visible = true
	
	bgMusicPlayer.stream = bgMusicEnd
	bgMusicPlayer.play()

func resetGame() -> void:
	player1.reset()
	player2.reset()
	
	startGame()

func quitGame() -> void:
	get_tree().quit()
