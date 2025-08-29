extends Control

@onready var info_label: Label = $Label
@onready var test_timer: Timer = $Timer

# Default bindings (you can replace these with player-configured ones)
var key_jump: int = KEY_SPACE
var key_sprint: int = KEY_SHIFT
var key_forward: int = KEY_W

func _ready() -> void:
    # Configure the test timer
    test_timer.wait_time = 0.1 # check 10 times per second
    test_timer.autostart = true
    test_timer.one_shot = false
    test_timer.start()

    info_label.text = "Testing key rollover for: " \
        + OS.get_keycode_string(key_forward) + " + " \
        + OS.get_keycode_string(key_sprint) + " + " \
        + OS.get_keycode_string(key_jump)

func _on_Timer_timeout() -> void:
    # Check if all three keys are pressed simultaneously
    var forward_pressed = Input.is_key_pressed(key_forward)
    var sprint_pressed = Input.is_key_pressed(key_sprint)
    var jump_pressed = Input.is_key_pressed(key_jump)

    if forward_pressed and sprint_pressed and jump_pressed:
        info_label.text = "[OK] All three keys register ✅"
        info_label.add_theme_color_override("font_color", Color.GREEN)
    elif forward_pressed or sprint_pressed or jump_pressed:
        info_label.text = "[WARNING] One or more keys missing ⚠️\n" \
            + "Try pressing all three together"
        info_label.add_theme_color_override("font_color", Color.ORANGE)
    else:
        info_label.text = "Press all three keys to test..."
        info_label.add_theme_color_override("font_color", Color.GRAY)
