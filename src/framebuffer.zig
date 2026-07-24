const rl = @import("raylib");

pub const Point = struct {
    x: f32,
    y: f32,
};

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
    pub fn draw_polygon(self: *Framebuffer, points: []const Point, color: rl.Color) void {
        if (points.len < 2) return;
        for (points, 0..) |p, i| {
            const next = points[(i + 1) % points.len]; // conecta el último punto con el primero
            self.draw_line(p, next, color);
        }
    }

    pub fn draw_line(self: *Framebuffer, p0: Point, p1: Point, color: rl.Color) void {
        var x: i32 = @intFromFloat(p0.x);
        var y: i32 = @intFromFloat(p0.y);
        const x1: i32 = @intFromFloat(p1.x);
        const y1: i32 = @intFromFloat(p1.y);

        const dx: i32 = @intCast(@abs(x - x1));
        const dy: i32 = -@as(i32, @intCast(@abs(y - y1)));
        const step_x: i32 = if (x < x1) 1 else -1;
        const step_y: i32 = if (y < y1) 1 else -1;

        var err: isize = dx + dy;
        while (true) {
            if (x >= 0 and y >= 0 and x < self.width and y < self.height) {
                self.draw_pixel(@floatFromInt(x), @floatFromInt(y), color) catch unreachable;
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
        if (self.texture) |texture| {
            rl.unloadTexture(texture);
        }
    }

    pub fn swap(self: *Framebuffer) !void {
        rl.beginDrawing();
        defer rl.endDrawing();

        self.texture = try rl.loadTextureFromImage(self.image);
        rl.drawTexture(self.texture.?, 0, 0, .white);
    }
};
