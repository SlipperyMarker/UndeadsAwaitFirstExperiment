class_name PlayerMovementLook
extends RefCounted

#-----Variables-----#
#Getter Variables (will be sourced from PlayerBrain)
var _Player:CharacterBody3D
var _Camera:Camera3D
var _HeadRotationSpeed:float
var _HeadRotationSpeedMultiplier:float
var _HeadRotationVerticalClamp:float

#-----Getter Function-----#
#sourced from PlayerBrain
func VarHandler(Pl:CharacterBody3D,Cam:Camera3D,HRS:float,HRSM:float,HRVC:float)->void:
	_Player=Pl;_Camera=Cam;_HeadRotationSpeed=HRS;_HeadRotationSpeedMultiplier=HRSM;_HeadRotationVerticalClamp=HRVC

#-----Logic Functions-----#
