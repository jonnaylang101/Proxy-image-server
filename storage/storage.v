module storage

import os

pub fn add_file(name string, data string) ! {
	sp := store_path() !
	os.write_file("$sp/$name", data) !
}

pub fn get_filepath(name string) !string {
	sp := store_path() !

	fullpath := "$sp/$name"
	if !os.exists(fullpath) {
		return error_with_code('$fullpath not found', 404)
	}

	return fullpath
}

fn store_path() !string {
	mut p := "./storage/store"
	p = os.existing_path(p) or {
		"./storage/"
	}
	if p == "./storage/" {
		p = p+"store"
		os.mkdir(p, os.MkdirParams{}) !
	}
	return p
}
