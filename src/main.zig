const std = @import("std");
const rl = @import("raylib");
const fb = @import("framebuffer.zig");

const Clock = std.Io.Clock.real;

pub fn main(init: std.process.Init) !void {
    const width = 800;
    const height = 600;
    var framebuffer = fb.Framebuffer.init(width, height, rl.Color.black);

    rl.initWindow(width, height, "Software Renderer");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    const start = Clock.now(init.io);
    var frame_start = start;
    var dt: f32 = 1;

    while (!rl.windowShouldClose()) {
        frame_start = Clock.now(init.io);
        defer {
            dt = @floatFromInt(frame_start.durationTo(Clock.now(init.io)).toNanoseconds());
            dt /= 1_000_000_000;
        }
        // const time = start.durationTo(Clock.now(init.io)).toMicroseconds();
        // std.debug.print("{}\n", .{dt});
        framebuffer.clear(); // Qué pasa si no incluimos esta linea?

        // framebuffer.image.drawCircle(@intFromFloat(x), height / 2 - 7, 15, .red);
        const elapsed: f32 = @floatFromInt(start.durationTo(Clock.now(init.io)).toNanoseconds());
        const elapsed_micro: f32 = elapsed / 1_000;
        const elapsed_mili: f32 = elapsed / 1_000_000;
        const elapsed_seconds: f32 = elapsed / 1_000_000_000;
        _ = elapsed_seconds;
        _ = elapsed_micro;

        const speed = 0.25;
        const periods = 10;

        var x_last: f32 = 0;
        var y_last: f32 = @sin((elapsed_mili * speed) * std.math.tau * periods / width) * height / 3 + height / 2;
        for (0..width) |i| {
            const x: f32 = @floatFromInt(i);
            const y = @sin((x + elapsed_mili * speed) * std.math.tau * periods / width) * height / 3 + height / 2;

            framebuffer.draw_line(
                .{ .x = x_last, .y = y_last },
                .{ .x = x, .y = y },
                .{ .r = 0xff, .g = 0, .b = 0, .a = 0xf0 },
            );

            defer x_last = x;
            defer y_last = y;
            // std.debug.print("elapsed: {} x:{} y:{} x_last:{} y_last:{}\n", .{ elapsed, x, y, x_last, y_last });
        }

        try framebuffer.swap();
    }
}
