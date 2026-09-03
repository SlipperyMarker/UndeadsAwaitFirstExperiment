class_name PlayerMovementLook
extends RefCounted

#-----Variables-----#
#Getter Variables (will be sourced from PlayerBrain)
var _Player:CharacterBody3D
var _Camera:Camera3D
var _HeadRotationSpeed:float
var _HeadRotationSpeedMultiplier:float
var _HeadRotationVerticalClamp:float
#Normal Variables
var HeadRotate:=0.0
var BodyRotate:=0.0
var Rotator:Vector3
var RotatorHead:Vector3
var RotatorBody:Vector3

#-----Getter Function-----#
#sourced from PlayerBrain
func VarHandler(Pl:CharacterBody3D,Cam:Camera3D,HRS:float,HRSM:float,HRVC:float)->void:
	_Player=Pl;_Camera=Cam;_HeadRotationSpeed=HRS;_HeadRotationSpeedMultiplier=HRSM;_HeadRotationVerticalClamp=HRVC

#-----Logic Functions-----#

func InputHandlerMouse (event:InputEvent)->void: #updates the screen movement per Mouse motion iputs.
	var Eye:InputEvent=event as InputEventMouseMotion
	HeadRotate=Eye.relative.y*(_HeadRotationSpeed*_HeadRotationSpeedMultiplier)
	BodyRotate=Eye.relative.x*(_HeadRotationSpeed*_HeadRotationSpeedMultiplier)

func MovementHandler()->void:
	Rotator.x=clamp(Rotator.x,_HeadRotationVerticalClamp*-1,_HeadRotationVerticalClamp)
	Rotator.x-=HeadRotate ; Rotator.y-=BodyRotate
	RotatorHead=Vector3(Rotator.x,0,0) ; RotatorBody=Vector3(0,Rotator.y,0)
	_Camera.transform.basis=Basis.from_euler(RotatorHead) ; _Camera.rotation.z=0
	_Player.basis=Basis.from_euler(RotatorBody)
	BodyRotate=0 ; HeadRotate=0

func MousePointerHandler()->void:
	if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	elif Input.mouse_mode==Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
