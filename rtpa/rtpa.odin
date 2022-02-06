package rtpa

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import rl "vendor:raylib"
import "core:c"

Atlas_Info :: struct {
	image_path: string,
	width: uint,
	height: uint,
	sprite_count: uint,
	is_font: bool,
	font_size: uint,
}

Sprite_Info :: struct {
	name_id: string,
	origin_x: uint,
	origin_y: uint,
	position_x: uint,
	position_y: uint,
	source_width: uint,
	source_height: uint,
	padding: uint,
	trimmed: bool,
	trim_rec_x: uint,
	trim_rec_y: uint,
	trim_rec_width: uint,
	trim_rec_height: uint,
}

load :: proc(path: string) -> (Atlas_Info, [dynamic]Sprite_Info) {
	data, ok := os.read_entire_file(path)
	if !ok do fmt.println("Failed to open rtpa file")

	atlas: Atlas_Info
	sprites: [dynamic]Sprite_Info

	lines := strings.split(string(data), "\n", context.temp_allocator)
	loop: for line in lines {
		if len(line) > 0 {
			switch line[0] {
				case '#':
					continue
				case 'a':
					line_without_a := line[1:]
					words := strings.split(line_without_a, " ", context.temp_allocator)
					ok: bool
					atlas.image_path = words[1]
					atlas.width, ok = strconv.parse_uint(words[2])
					if !ok do fmt.println("Failed to parse uint")
					atlas.height, ok = strconv.parse_uint(words[3])
					if !ok do fmt.println("Failed to parse uint")
					atlas.sprite_count, ok = strconv.parse_uint(words[4])
					if !ok do fmt.println("Failed to parse uint")
					atlas.is_font, ok = strconv.parse_bool(words[5])
					if !ok do fmt.println("Failed to parse uint")
					atlas.font_size, ok = strconv.parse_uint(words[6])
					if !ok do fmt.println("Failed to parse uint")
				case 's':
					s: Sprite_Info
					line_without_s := line[1:]
					words := strings.split(line_without_s, " ", context.temp_allocator)
					ok: bool
					s.name_id = words[1]
					s.origin_x, ok = strconv.parse_uint(words[2])
					if !ok do fmt.println("Failed to parse uint")
					s.origin_y, ok = strconv.parse_uint(words[3])
					if !ok do fmt.println("Failed to parse uint")
					s.position_x, ok = strconv.parse_uint(words[4])
					if !ok do fmt.println("Failed to parse uint")
					s.position_y, ok = strconv.parse_uint(words[5])
					if !ok do fmt.println("Failed to parse uint")
					s.source_width, ok = strconv.parse_uint(words[6])
					if !ok do fmt.println("Failed to parse uint")
					s.source_height, ok = strconv.parse_uint(words[7])
					if !ok do fmt.println("Failed to parse uint")
					s.padding, ok = strconv.parse_uint(words[8])
					if !ok do fmt.println("Failed to parse uint")
					s.trimmed, ok = strconv.parse_bool(words[9])
					if !ok do fmt.println("Failed to parse uint")
					s.trim_rec_x, ok = strconv.parse_uint(words[10])
					if !ok do fmt.println("Failed to parse uint")
					s.trim_rec_y, ok = strconv.parse_uint(words[11])
					if !ok do fmt.println("Failed to parse uint")
					s.trim_rec_width, ok = strconv.parse_uint(words[12])
					if !ok do fmt.println("Failed to parse uint")
					s.trim_rec_height, ok = strconv.parse_uint(words[13])
					if !ok do fmt.println("Failed to parse uint")
					append(&sprites, s)
			}
		}
	}

	return atlas, sprites
}

draw :: proc(texture: rl.Texture2D, sprites: ^[dynamic]Sprite_Info, sprite_name: string, position: rl.Vector2, scale: c.float, rotation: c.float) {
	using rl
	s: Sprite_Info
	for sprite in sprites {
		if sprite.name_id == sprite_name {
			s = sprite
			break
		}
	}
	//DrawTextureRec(texture, Rectangle{c.float(s.position_x), c.float(s.position_y), c.float(s.source_width) * scale.x, c.float(s.source_height) * scale.y}, position, WHITE)
	DrawTexturePro(texture, Rectangle{c.float(s.position_x), c.float(s.position_y), c.float(s.source_width), c.float(s.source_height)}, Rectangle{position.x, position.y, c.float(s.source_width) * scale, c.float(s.source_height) * scale}, Vector2{c.float(s.origin_x), c.float(s.origin_y)}, rotation, WHITE)
}

get_sprite_info :: proc(sprites: ^[dynamic]Sprite_Info, sprite_name: string) -> Sprite_Info {
	for sprite in sprites {
		if sprite.name_id == sprite_name do return sprite
	}
	fmt.println("Failed to get sprite info")
	return Sprite_Info{}
}