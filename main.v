module main

import application

fn main() {
	if app := application.new() {
		app.run() or { println(err) }
	} else {
		println(err)
	}
}
