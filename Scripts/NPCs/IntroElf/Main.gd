extends Button

@onready var elf: Button = $"."

var char_name: String = "Elfen girl"
var curr_pos: Vector2

signal tween_fin

var lines: Array[String] = [
	"You finally made it into the shop!",
	"You can come here during market times and sell potions!",
	"How cool is that?",
	"I mean it's your only way to pay me back after all.",
	"But hey! I'm sure you'll get a hang of it in no time.",
	"To start of, interact with me and take my order to get started!"
]
