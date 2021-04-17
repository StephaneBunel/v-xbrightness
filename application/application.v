module application

import os
import xmonitor

const (
	env_xrandr_path = 'XBR_XRANDR'
)

pub struct App {
	xmon xmonitor.Xmonitor [required]
}

pub fn new() ?App {
	if os.args.len != 2 {
		app_usage()
		return error('')
	}

	// find xrandr
	path := find_exe('xrandr', application.env_xrandr_path) ?

	return App{
		xmon: xmonitor.Xmonitor{
			xrandr_path: path
		}
	}
}

pub fn (a App) run() ? {
	monitors := a.xmon.get_monitors() ?
	arg := os.args[1].str().to_lower()

	if arg == 'status' {
		for mon in monitors {
			println('$mon.name(): brightness=${mon.brightness() * 100}')
		}

		return
	}

	mut valid := false
	for c in '=+-' {
		if arg[0] == c {
			valid = true
			break
		}
	}
	if !valid {
		app_usage()
		return
	}
	
	mut number := arg
	if arg[0].ascii_str() == '=' {
		number = arg[1..]
	}
	
	if !number[1].is_digit() {
		println('invalid number: $number')
		app_usage()
		return
	}

	value := number.f32() / 100
	match arg[0].ascii_str() {
		'=' {
			a.xmon.set_brightness(monitors, value) ?
		}
		'+', '-' {
			a.xmon.adjust_brightness(monitors, value) ?
		}
		else {
			app_usage()
		}
	}
}
