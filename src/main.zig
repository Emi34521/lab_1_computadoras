const std = @import("std");
const rl = @import("raylib");
const fb = @import("framebuffer.zig");

const Point = fb.Point;

pub fn main(init: std.process.Init) !void {
    _ = init;
    const width = 1920;
    const height = 1080;
    var framebuffer = fb.Framebuffer.init(width, height, rl.Color.black);

    rl.initWindow(width, height, "Software Renderer");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    const polygon1 = [_]Point{
        .{ .x = 165, .y = 380 }, .{ .x = 185, .y = 360 }, .{ .x = 180, .y = 330 },
        .{ .x = 207, .y = 345 }, .{ .x = 233, .y = 330 }, .{ .x = 230, .y = 360 },
        .{ .x = 250, .y = 380 }, .{ .x = 220, .y = 385 }, .{ .x = 205, .y = 410 },
        .{ .x = 193, .y = 383 },
    };

    const polygon2 = [_]Point{
        .{ .x = 321, .y = 335 }, .{ .x = 288, .y = 286 }, .{ .x = 339, .y = 251 }, .{ .x = 374, .y = 302 },
    };

    const polygon3 = [_]Point{
        .{ .x = 377, .y = 249 }, .{ .x = 411, .y = 197 }, .{ .x = 436, .y = 249 },
    };

    const polygon4 = [_]Point{
        .{ .x = 413, .y = 177 }, .{ .x = 448, .y = 159 }, .{ .x = 502, .y = 88 },  .{ .x = 553, .y = 53 },
        .{ .x = 535, .y = 36 },  .{ .x = 676, .y = 37 },  .{ .x = 660, .y = 52 },  .{ .x = 750, .y = 145 },
        .{ .x = 761, .y = 179 }, .{ .x = 672, .y = 192 }, .{ .x = 659, .y = 214 }, .{ .x = 615, .y = 214 },
        .{ .x = 632, .y = 230 }, .{ .x = 580, .y = 230 }, .{ .x = 597, .y = 215 }, .{ .x = 552, .y = 214 },
        .{ .x = 517, .y = 144 }, .{ .x = 466, .y = 180 },
    };

    const polygon5 = [_]Point{
        .{ .x = 682, .y = 175 }, .{ .x = 708, .y = 120 }, .{ .x = 735, .y = 148 }, .{ .x = 739, .y = 170 },
    };

    while (!rl.windowShouldClose()) {
        framebuffer.clear();

        framebuffer.draw_polygon(&polygon1, .white);
        framebuffer.draw_polygon(&polygon2, .white);
        framebuffer.draw_polygon(&polygon3, .white);
        framebuffer.draw_polygon(&polygon4, .white);
        framebuffer.draw_polygon(&polygon5, .white);

        try framebuffer.swap();
    }
}