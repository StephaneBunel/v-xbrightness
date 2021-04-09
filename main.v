import os

fn main() {
	delta := parse_args()
	if delta == 0 {
		return
	}

	mbs := get_monitor_brightness()
	set_monitor_brightness(delta, mbs)
}

fn parse_args() f32 {
	if os.args.len == 1 {
		usage()
		return 0
	}

	return os.args[1].f32() / 100
}

fn usage() {
	exe := os.args[0] or { 'xbrightness' }
	println('$exe: adjust the brightness (using xrandr) of all connected monitors.')
	println('Usage: $exe <delta%>')
	println('ex:')
	println('    $exe +10 -> adjust monitors brightness 10% up')
	println('    $exe -20 -> adjust monitors brightness 20% down')
}

fn set_monitor_brightness(delta f32, mbs []MonitorBrightness) {
	for mb in mbs {
		mut brightness := mb.brightness + delta
		if brightness < 0 {
			brightness = 0
		} else if brightness > 1 {
			brightness = 1
		}

		println('adjusting brightness of monitor $mb.monitor from ${mb.brightness * 100}% to ${brightness * 100}%')
		cmd := '/usr/bin/xrandr --output $mb.monitor --brightness $brightness'
		os.execute(cmd)
	}
}

fn get_monitor_brightness() []MonitorBrightness {
	mut monitors := []MonitorBrightness{}

	cmd := '/usr/bin/xrandr --verbose --current'
	result := execute_or_panic(cmd)
	output := result.output.str().split('\n')
	for n, line in output {
		if line.contains(' connected ') {
			monitor := line.split(' ')[0]
			brightness := output[n + 5].split(' ')[1].f32()
			monitors << MonitorBrightness{monitor, brightness}
		}
	}

	return monitors
}

struct MonitorBrightness {
mut:
	monitor    string
	brightness f32
}
