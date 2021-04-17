module xmonitor

import os

pub struct Xmonitor {
	xrandr_path string [required]
}

struct Monitor {
	name string
mut:
	brightness f32
}

pub fn (m Monitor) brightness() f32 {
	return m.brightness
}

pub fn (m Monitor) name() string {
	return m.name
}

pub fn (x Xmonitor) get_monitors() ?[]Monitor {
	mut monitors := []Monitor{}

	cmd := '$x.xrandr_path --verbose --query'
	println(cmd)
	result := os.execute(cmd)
	output := result.output.str().split('\n')
	for n, line in output {
		if line.contains(' connected ') {
			name := line.split(' ')[0]
			brightness := output[n + 5].split(' ')[1].f32()
			monitors << Monitor{name, brightness}
		}
	}

	return monitors
}

pub fn (x Xmonitor) set_brightness(monitors []Monitor, value f32) ? {
	for mon in monitors {
		mut brightness := value
		if brightness < 0 {
			brightness = 0
		} else if brightness > 1 {
			brightness = 1
		}

		println('setting brightness of monitor $mon.name from ${mon.brightness * 100}% to ${brightness * 100}%')
		cmd := '$x.xrandr_path --output $mon.name --brightness $brightness'
		os.execute(cmd)
	}
}

pub fn (x Xmonitor) adjust_brightness(monitors []Monitor, delta f32) ? {
	for mon in monitors {
		mut brightness := mon.brightness + delta
		if brightness < 0 {
			brightness = 0
		} else if brightness > 1 {
			brightness = 1
		}

		println('adjusting brightness of monitor $mon.name from ${mon.brightness * 100}% to ${brightness * 100}%')
		cmd := '$x.xrandr_path --output $mon.name --brightness $brightness'
		os.execute(cmd)
	}
}
