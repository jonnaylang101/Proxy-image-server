import vweb
import os

struct App {
	vweb.Context
}

struct Animal {
	breed string
	noise string
}

fn server(port int) {
	vweb.run_at(new_app(), vweb.RunParams{
		port: port
	}) or { panic(err) }
}

fn new_app() &App {
	mut app := &App{}

	app.mount_static_folder_at(os.resource_abs_path('.'), '/')
	return app
}

['/']
pub fn (mut app App) page_home() vweb.Result {
	// all this constants can be accessed by src/templates/page/home.html file.
	page_title := 'Some animals that you can hear'

	list_of_animals := [
		Animal{
			breed: 'Cow'
			noise: 'Moooooooooo!'
		},
		Animal{
			breed: 'Sheep'
			noise: 'Baaaaaaaaaa!'
		}
		Animal{
			breed: 'Sloth'
			noise: ''
		}
	]

	// println(list_of_animals)
	// $vweb.html() in `<folder>_<name> vweb.Result ()` like this
	// render the `<name>.html` in folder `./templates/<folder>`
	return $vweb.html()
}