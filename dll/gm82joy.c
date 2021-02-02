#define GMREAL __declspec(dllexport) double __cdecl
#define GMSTRING __declspec(dllexport) const char* __cdecl
#include "include/SDL.h"

#pragma comment(lib, "SDL2.lib")


#define bool int
#define false 0
#define true !false

SDL_Joystick** sticks = NULL;
int stick_capacity = 16;
int stick_count = 0;

GMREAL joy_init() {
	SDL_InitSubSystem(SDL_INIT_JOYSTICK);
	sticks = malloc(stick_capacity*sizeof(SDL_Joystick*));
	return 0;
}

GMSTRING sdl_get_error() {
	return SDL_GetError();
}

GMREAL joy_update() {
	bool change = false;
	SDL_JoystickUpdate();
	// count currently active joysticks and free any that are detached
	int current_count = 0;
	{
		int shift_amount = 0;
		for (int i = 0; i < stick_count; i++) {
			if (!SDL_JoystickGetAttached(sticks[i])) {
				SDL_JoystickClose(sticks[i]);
				shift_amount++;
				change = true;
			} else {
				sticks[i-shift_amount] = sticks[i];
				current_count++;
			}
		}
	}
	stick_count = current_count;
	if (current_count < SDL_NumJoysticks()) {
		// a new stick was attached, find it and give it a slot
		for (int i = 0; i < SDL_NumJoysticks(); i++) {
			bool found = false;
			SDL_Joystick *new_joy = SDL_JoystickOpen(i);
			if (new_joy == NULL) continue;
			// do we already have this one?
			SDL_JoystickID id = SDL_JoystickInstanceID(new_joy);
			for (int j = 0; j < stick_count; j++) {
				if (id == SDL_JoystickInstanceID(sticks[j])) {
					// yes
					found = true;
					break;
				}
			}
			if (found) {
				// decrement refcount and continue
				SDL_JoystickClose(new_joy);
				continue;
			} else {
				// we got a new stick add it to the set
				if (stick_count >= stick_capacity) {
					// holy shit more than we were ready for, add more capacity
					sticks = realloc(sticks, (stick_count+1)*sizeof(SDL_Joystick*));
					stick_capacity = stick_count+1;
				}
				sticks[stick_count++] = new_joy;
				change = true;
			}
		}
	}
	return change;
}

GMREAL joy_count() {
	return stick_count;
}

GMSTRING joy_name(double id) {
	if (id < stick_count) {
		return SDL_JoystickName(sticks[(int)id]);
	}
	return "";
}

#define JOY_FUN(gmf, sdlf) GMREAL gmf(double id) { \
		if (id < stick_count) \
			return sdlf(sticks[(int)id]); \
		return -1; \
	}

JOY_FUN(joy_axes, SDL_JoystickNumAxes)
JOY_FUN(joy_buttons, SDL_JoystickNumButtons)
JOY_FUN(joy_hats, SDL_JoystickNumHats)
JOY_FUN(joy_balls, SDL_JoystickNumBalls)

#undef JOY_FUN

GMREAL joy_axis(double id, double axis) {
	if (id < stick_count) {
		return (float)SDL_JoystickGetAxis(sticks[(int)id], axis) / 32768.0f;
	}
	return 0;
}

GMREAL joy_button(double id, double button) {
	if (id < stick_count) {
		return SDL_JoystickGetButton(sticks[(int)id], button);
	}
	return 0;
}

GMREAL joy_hat(double id, double hat) {
	if (id < stick_count) {
		switch (SDL_JoystickGetHat(sticks[(int)id], hat)) {
		case SDL_HAT_UP:
			return 0.0f;
		case SDL_HAT_RIGHT:
			return 90.0f;
		case SDL_HAT_DOWN:
			return 180.0f;
		case SDL_HAT_LEFT:
			return 270.0f;
		case SDL_HAT_RIGHTUP:
			return 45.0f;
		case SDL_HAT_RIGHTDOWN:
			return 135.0f;
		case SDL_HAT_LEFTUP:
			return 315.0f;
		case SDL_HAT_LEFTDOWN:
			return 225.0f;
		case SDL_HAT_CENTERED:
		default:
			return -1.0f;
		}
	}
	return -1;
}

GMREAL joy_hat_x(double id, double hat) {
	if (id < stick_count) {
		Uint8 pos = SDL_JoystickGetHat(sticks[(int)id], hat);
		if (pos & SDL_HAT_LEFT) return -1.0;
		if (pos & SDL_HAT_RIGHT) return 1.0;
		return 0.0;
	}
	return 0;
}

GMREAL joy_hat_y(double id, double hat) {
	if (id < stick_count) {
		Uint8 pos = SDL_JoystickGetHat(sticks[(int)id], hat);
		if (pos & SDL_HAT_UP) return -1.0;
		if (pos & SDL_HAT_DOWN) return 1.0;
		return 0.0;
	}
	return 0;
}

GMREAL joy_ball_x(double id, double ball) {
	if (id < stick_count) {
		int dx, dy;
		SDL_JoystickGetBall(sticks[(int)id], ball, &dx, &dy);
		return dx;
	}
	return 0;
}

GMREAL joy_ball_y(double id, double ball) {
	if (id < stick_count) {
		int dx, dy;
		SDL_JoystickGetBall(sticks[(int)id], ball, &dx, &dy);
		return dy;
	}
	return 0;
}
