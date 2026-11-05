class_name Cowboy extends Node2D

@export var actionName = 'p1_shoot'
@export var pAnimation: AnimationPlayer
@export var soundPlayer: AudioStreamPlayer
@export var keySprit: Sprite2D
@export var winLabel: Label

signal shotGun(action)

enum State {Waiting, Shooting, Dying, Fumbling, Holstering}

var state: State = State.Waiting
var isAllowedToShoot = false

func _ready() -> void:
	winLabel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Global.gameOver and state == State.Waiting and Input.is_action_just_pressed(actionName):
		if isAllowedToShoot:
			shoot()
		else:
			fumble()

func shoot() -> void:
	state = State.Shooting
	shotGun.emit(actionName)
	soundPlayer.play()
	keySprit.visible = false
	pAnimation.play('shoot')
	await pAnimation.animation_finished
	winLabel.visible = true
	holster()

func kill() -> void:
	state = State.Dying
	pAnimation.play('death')
	keySprit.visible = false

func fumble() -> void:
	state = State.Fumbling
	pAnimation.play('fumble')
	await pAnimation.animation_finished
	wait()

func holster() -> void:
	state = State.Holstering
	pAnimation.play('holster')
	await pAnimation.animation_finished
	wait()

func wait() -> void:
	state = State.Waiting
	pAnimation.play('idle')

func reset() -> void:
	wait()
	isAllowedToShoot = false
	keySprit.visible = true
	winLabel.visible = false
