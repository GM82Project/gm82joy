#define __gm82joy_call
//(func,args,...)
    var call;

    call=__gm82joy_map("__dll_"+argument0)

    if (argument_count=1) return external_call(call)
    if (argument_count=2) return external_call(call,argument[1])
    if (argument_count=3) return external_call(call,argument[1],argument[2])
    if (argument_count=4) return external_call(call,argument[1],argument[2],argument[3])
    if (argument_count=5) return external_call(call,argument[1],argument[2],argument[3],argument[4])
    if (argument_count=6) return external_call(call,argument[1],argument[2],argument[3],argument[4],argument[5])


#define __gm82joy_define
//(func,args,...)
    var dll,call;

    dll=temp_directory+"\gm82\gm82joy.dll"
    if (argument_count=1) call=external_define(dll,argument0,1,0,0)
    if (argument_count=2) call=external_define(dll,argument0,1,0,1,argument[1])
    if (argument_count=3) call=external_define(dll,argument0,1,0,2,argument[1],argument[2])
    if (argument_count=4) call=external_define(dll,argument0,1,0,3,argument[1],argument[2],argument[3])
    if (argument_count=5) call=external_define(dll,argument0,1,0,4,argument[1],argument[2],argument[3],argument[4])
    if (argument_count=6) call=external_define(dll,argument0,1,0,5,argument[1],argument[2],argument[3],argument[4],argument[5])

    __gm82joy_map("__dll_"+argument0,call)


#define __gm82joy_define_str
//(func,args,...)
    var dll,call;

    dll=temp_directory+"\gm82\gm82joy.dll"
    if (argument_count=1) call=external_define(dll,argument0,1,1,0)
    if (argument_count=2) call=external_define(dll,argument0,1,1,1,argument[1])
    if (argument_count=3) call=external_define(dll,argument0,1,1,2,argument[1],argument[2])
    if (argument_count=4) call=external_define(dll,argument0,1,1,3,argument[1],argument[2],argument[3])
    if (argument_count=5) call=external_define(dll,argument0,1,1,4,argument[1],argument[2],argument[3],argument[4])
    if (argument_count=6) call=external_define(dll,argument0,1,1,5,argument[1],argument[2],argument[3],argument[4],argument[5])

    __gm82joy_map("__dll_"+argument0,call)


#define __gm82joy_map
//(key):value
//(key,value)
    if (argument_count=1) {
        return ds_map_find_value(__gm82joy_mapid,argument[0])
    } else {
        ds_map_set(__gm82joy_mapid,argument[0],argument[1])
    }


#define __gm82joy_init
    object_event_add(gm82core_object,ev_step,ev_step_begin,"__gm82joy_update()")
        
    //move sdl2 to a common location so that it doesn't leave a copy behind every time you run the game
    p=string_pos("\appdata\local\temp\gm_ttt_",string_lower(temp_directory))    
    dir=string_copy(temp_directory,1,p+19)+"gm82 dll cache"    
    directory_create(dir)    
    file_delete(dir+"\SDL2.dll")
    file_rename(temp_directory+"\gm82\SDL2.dll",dir+"\SDL2.dll")
    //poke it so that joydll can find it
    //this is a valid function and will put sdl2 in the link list
    //this means it can be anywhere and it'll be found for further function defs
    external_define(dir+"\SDL2.dll","SDL_GetError",dll_cdecl,ty_string,0)
    
    __gm82joy_define("joy_init"                     )    
    __gm82joy_define("joy_count"                    )
    __gm82joy_define("joy_update"                   )
    __gm82joy_define("joy_buttons"  ,ty_real        )
    __gm82joy_define("joy_axes"     ,ty_real        )
    __gm82joy_define("joy_hats"     ,ty_real        )
    __gm82joy_define("joy_balls"    ,ty_real        )
    __gm82joy_define_str("joy_name" ,ty_real        )
    __gm82joy_define("joy_axis"     ,ty_real,ty_real)
    __gm82joy_define("joy_button"   ,ty_real,ty_real)
    __gm82joy_define("joy_button_pressed"   ,ty_real,ty_real)
    __gm82joy_define("joy_button_released"   ,ty_real,ty_real)
    __gm82joy_define("joy_hat"      ,ty_real,ty_real)
    __gm82joy_define("joy_hat_x"    ,ty_real,ty_real)
    __gm82joy_define("joy_hat_y"    ,ty_real,ty_real)
    __gm82joy_define("joy_ball_x"   ,ty_real,ty_real)
    __gm82joy_define("joy_ball_y"   ,ty_real,ty_real)
    
    __gm82joy_call("joy_init")
    
    __gm82joy_map("updated",0)
    __gm82joy_map("deadzone",0.05)


#define __gm82joy_update
    if (__gm82joy_call("joy_update")) {
        __gm82joy_map("updated",1)
        __gm82joy_map("count",__gm82joy_call("joy_count"))
    }


#define __gm82joy_deadzone
    if (abs(argument0)<__gm82joy_map("deadzone"))
        return 0
    return argument0


#define joystick_set_deadzone
    __gm82joy_map("deadzone",median(0,argument0,1))


#define joystick_found
    if (__gm82joy_map("updated")) {
        __gm82joy_map("updated",0)
        return 1
    }
    return 0


#define joystick_count
    return __gm82joy_map("count")


#define joystick_axes
    return __gm82joy_call("joy_axes",argument0)

    
#define joystick_buttons
    return __gm82joy_call("joy_buttons",argument0)


#define joystick_check_button
    return __gm82joy_call("joy_button",argument0,argument1)


#define joystick_check_button_pressed
    return __gm82joy_call("joy_button_pressed",argument0,argument1)


#define joystick_check_button_released
    return __gm82joy_call("joy_button_released",argument0,argument1)


#define joystick_direction
    var xa,ya;
    
    xa=sign(__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,0)))+1
    ya=sign(__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,1)))+1
    
    return pick(ya,
        pick(xa,vk_numpad7,vk_numpad8,vk_numpad9),
        pick(xa,vk_numpad4,vk_numpad5,vk_numpad6),
        pick(xa,vk_numpad1,vk_numpad2,vk_numpad3)
    )


#define joystick_direction_leftstick
    var xa,ya;
    
    xa=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,0))
    ya=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,1))
    
    if (xa==0 && ya==0) return -1
    
    return point_direction(0,0,xa,ya)


#define joystick_direction_rightstick
    var xa,ya;
    
    xa=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,2))
    ya=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,3))
    
    if (xa==0 && ya==0) return -1
    
    return point_direction(0,0,xa,ya)


#define joystick_distance_leftstick
    var xa,ya;
    
    xa=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,0))
    ya=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,1))
    
    return min(point_distance(0,0,xa,ya),1)


#define joystick_distance_rightstick
    var xa,ya;
    
    xa=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,3))
    ya=__gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,2))
    
    return min(point_distance(0,0,xa,ya),1)


#define joystick_exists
    return (argument0<__gm82joy_call("joy_count"))

 
#define joystick_has_pov
    return !!__gm82joy_call("joy_hats",argument0)

 
#define joystick_name
    return __gm82joy_call("joy_name",argument0)


#define joystick_pov
    var xa,ya;
    
    xa=sign(__gm82joy_call("joy_hat_x",argument0,0))
    ya=sign(__gm82joy_call("joy_hat_y",argument0,0))
    
    if (xa==0 && ya==0) return -1
    
    return (90-point_direction(0,0,xa,ya)+360) mod 360


#define joystick_pov_direction
    var xa,ya;
    
    xa=sign(__gm82joy_call("joy_hat_x",argument0,0))
    ya=sign(__gm82joy_call("joy_hat_y",argument0,0))
    
    if (xa==0 && ya==0) return -1
    
    return point_direction(0,0,xa,ya)


#define joystick_pov_x
    return __gm82joy_call("joy_hat_x",argument0,0)


#define joystick_pov_y
    return __gm82joy_call("joy_hat_y",argument0,0)


#define joystick_axis
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,argument1))

 
#define joystick_xpos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,0))

 
#define joystick_ypos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,1))

 
#define joystick_zpos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,2))


#define joystick_rpos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,3))

 
#define joystick_upos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,4))

 
#define joystick_vpos
    return __gm82joy_deadzone(__gm82joy_call("joy_axis",argument0,5))

 