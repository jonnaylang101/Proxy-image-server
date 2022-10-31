module images

import vweb
import net.http
import rand
import storage

struct App {
	vweb.Context
}

struct Image {
	image_id string
	user_id  string
	mut: 
	width int
	height int
}


pub fn server(port int) {
	vweb.run_at(new_app(), vweb.RunParams{
		port: port
	}) or { panic(err) }
}

fn new_app() &App {
	return &App{}
}

['/images/:user_uuid'; 'post']
pub fn (mut app App) add(user_uuid string) vweb.Result {
	if user_uuid.len < 36 {
		app.set_status(400, '')
		app.text("nope... invalid user_uuid")
	}

	ct := app.req.header.get(.content_type) or {
		app.set_status(400, '')
		return app.text('missing multipart header and boundary')
	}

	boundary := '--' + ct.split('boundary=')[1]

	f, files := http.parse_multipart_form(app.req.data, boundary)
	file_list := files["file"]
	
	for _, file_data in file_list {
		storage.add_file(file_data.filename, file_data.data) or {
			app.set_status(err.code(), '')
			return app.text(err.msg())
		}
	}
	

	mut image := Image{
		user_id: user_uuid
		image_id: rand.uuid_v4()
	}


	w := f['width']
	if w.len > 0 {
		image.width = w.int()
	}

	h := f['height']
	if h.len > 0 {
		image.height = h.int()
	}

	app.set_status(201, '')
	return app.json(image)
}

['/images/:filename'; 'get']
pub fn (mut app App) get(filename string) vweb.Result {
	filepath := storage.get_filepath(filename) or {
		println(err)
		app.set_status(err.code(), '')
		return app.text(err.msg())
	}

	return app.file(filepath)
}