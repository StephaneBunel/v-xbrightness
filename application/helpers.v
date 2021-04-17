module application

import os

fn find_exe(exe string, envvar string) ?string {
	mut path := os.getenv(envvar)

	if path.len == 0 {
		// println('$envvar not set. Trying to find $exe in PATH')
		path = os.find_abs_path_of_executable(exe) ?
	}

	if !os.is_executable(path) {
		return error('$path is not executable')
	}

	// println('found: $path')
	return path
}

fn app_usage() {
	exe := os.file_name(os.executable())
	println('$exe: adjust or set the brightness of all connected monitors.')
	println('  xrandr must be installed.')
	println('  if xrandr is not in the PATH you can set it in environment variable ${env_xrandr_path}.')
	println('')
	println('Usage: $exe =<value>|+<delta>|-<delta>|status')
	println('ex:')
	println('  $exe +10 -> adjust monitors brightness 10% up.')
	println('  $exe -20 -> adjust monitors brightness 20% down.')
	println('  $exe =80 -> set monitors brightness to 80%.')
}
