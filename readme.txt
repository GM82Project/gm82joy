-Game Maker 8.2 Joystick-

This is a replacement joystick system for Game Maker 8.1. Adding the extension
completely replaces the builtin joystick functions with SDL2, which supports a
lot more types of controllers. We also provide some new convenience functions
that help you use joysticks in your games.


[vanilla function list]

joystick_axes
joystick_buttons
joystick_check_button
joystick_direction
joystick_exists
joystick_has_pov
joystick_name
joystick_pov
joystick_rpos
joystick_upos
joystick_vpos
joystick_xpos
joystick_ypos
joystick_zpos


[extended functions]

joystick_axis(id,axis)
    Returns the raw value (-1.0 to 1.0) of <axis> of controller <id>.

joystick_check_button_pressed(id,button)
    Returns whether the <button> on joystick <id> was pressed since last step.

joystick_check_button_released(id,button)
    Returns whether the <button> on joystick <id> was released since last step.

joystick_count()
    Returns the number of joysticks connected.

joystick_direction_leftstick(id)
    Returns a standard game maker angle for the left stick (x+y axes).

joystick_direction_rightstick(id)
    Returns a standard game maker angle for the right stick (r+z axes).

joystick_found()
    Returns true if the known joysticks have changed since last step (either
    when new ones are found or old ones lost).

joystick_pov_direction(id)
    Returns a standard game maker angle for the pov hat (dpad).

joystick_pov_x(id)
    Returns an axis value (-1, 0 or 1) for the pov hat (dpad) horizontal.

joystick_pov_y(id)
    Returns an axis value (-1, 0 or 1) for the pov hat (dpad) vertical.

joystick_set_deadzone(value)
    Changes the internal deadzone value used for axis values (default is 5%).

[notes]

-> The default axis deadzone is set to 5% (0.05).
-> Vanilla function return values are unchanged for compatibility. New functions
   are provided with more convenient return values.


- Created by renex & floogle-