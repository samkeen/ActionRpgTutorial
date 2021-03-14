extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
const HEART_ICON_WIDTH = 15

onready var heartUIEmpty = $HeartUIEmpty
onready var heartUIFull = $HearyUIFull


func set_hearts(value:int):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull:
		heartUIFull.rect_size.x = hearts * HEART_ICON_WIDTH
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty:
		heartUIEmpty.rect_size.x = max_hearts * HEART_ICON_WIDTH

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

