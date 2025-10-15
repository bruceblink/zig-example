const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    try root.bufferedPrint();
    // 测试标准输入
    try test_stdio();
}

fn test_stdio() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdin_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;
    const stdout = &stdout_writer.interface;
    try stdout.writeAll("Type your name\n");
    try stdout.flush();
    const name = try stdin.takeDelimiterExclusive('\n');
    try stdout.print("Your name is: {s}\n", .{name});
    try stdout.flush();
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}

test "test stdout" {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.writeAll("This message was written into stdout.\n");
}
