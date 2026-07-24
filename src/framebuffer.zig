const rl = @import("raylib");

pub const Framebuffer = struct {
    width: i32,
    height: i32,
    image: rl.Image,
    texture: ?rl.Texture,
    background_color: rl.Color,

    pub fn init(width: i32, height: i32, color: rl.Color) Framebuffer {
        return Framebuffer{
            .width = width,
            .height = height,
            .image = rl.genImageColor(width, height, color),
            .background_color = color,
            .texture = null,
        };
    }

pub fn draw_line(self: Framebuffer, x0: i32, y0: i32, x1: i32, y1: i32, color: rl.Color) void {
        var x = x0;
        var y = y0;
        const dx: i32 = @intCast(@abs(x0 - x1));
        const dy: i32 = -@as(i32, @intCast(@abs(y0 - y1)));
        const step_x: i32 = if (x0 < x1) 1 else -1;
        const step_y: i32 = if (y0 < y1) 1 else -1;

        var err: isize = dx + dy;
        while (true) {
            if (x >= 0 and y >= 0 and x < self.width and y < self.height) {
                self.draw_pixel(x, y, color) catch unreachable;
            }

            if (x == x1 and y == y1) break;

            if (x != x1 and 2 * err >= dy) {
                err += dy;
                x += step_x;
            }

            if (y != y1 and 2 * err <= dx) {
                err += dx;
                y += step_y;
            }
        }
    }

    pub fn draw_pixel(self: *Framebuffer, x: f32, y: f32, color: rl.Color) !void {
        const i32_x: i32 = @intFromFloat(x);
        const i32_y: i32 = @intFromFloat(y);

        if (i32_x > self.width) return error.BadCoordinates;
        if (i32_y > self.height) return error.BadCoordinates;

        if (i32_x < 0) return error.BadCoordinates;
        if (i32_y < 0) return error.BadCoordinates;

        self.image.drawPixel(i32_x, i32_y, color);
    }

    pub fn clear(self: *Framebuffer) void {
        self.image.clearBackground(self.background_color);
        // Si no ponemos esto, se muere la compu. Pruebenlo, pero ahí le dan ctrl+c
        if (self.texture) |texture| {
            rl.unloadTexture(texture);
        }
    }

    pub fn swap(self: *Framebuffer) !void {
        rl.beginDrawing();
        defer rl.endDrawing();

        self.texture = try rl.loadTextureFromImage(self.image);
        rl.drawTexture(self.texture.?, 0, 0, .white);
        //equivalente a
        // if (self.texture) |texture| {
        //     rl.drawTexture(texture, 0, 0, .white);
        // } else unreachable;
    }
};
