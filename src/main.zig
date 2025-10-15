const std = @import("std");
const root = @import("root.zig");
const expect = std.testing.expect;
const eql = std.mem.eql;
const builtin = @import("builtin");

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

test "test create file" {
    const cwd = std.fs.cwd();
    const file = try cwd.createFile("foo.txt", .{});
    defer file.close();
    var stdout_buffer: [1024]u8 = undefined;
    var fw = file.writer(&stdout_buffer);
    // 写入数据到缓冲区
    try fw.interface.writeAll("Writing this line to the file\n");
    // 显式地刷新缓冲区，将数据写入文件
    try fw.interface.flush();
}

test "test read file" {
    const cwd = std.fs.cwd();
    const allocator = std.testing.allocator;

    const file = try cwd.createFile("foo.txt", .{});
    defer file.close();

    const write_message = "We are going to read this line\n";

    var fw_buffer: [1024]u8 = undefined;
    var fw = file.writer(&fw_buffer);

    // 通过 .interface 访问 std.io.Writer 接口的 writeAll 方法
    try fw.interface.writeAll(write_message);

    try fw.interface.flush();

    // 重新打开文件进行读取
    const read_file = try cwd.openFile("foo.txt", .{});
    defer read_file.close();

    // 使用 readFileAlloc 读取整个文件
    const read_buffer = try cwd.readFileAlloc(allocator, "foo.txt", 1024);
    defer allocator.free(read_buffer);

    // 断言读取的内容是否与写入的内容一致
    try expect(eql(u8, write_message, read_buffer));

    // 使用 stdout 打印到标准输出到控制台
    std.debug.print("{s}\n", .{read_buffer});
}

test "test append data file" {
    const cwd = std.fs.cwd();
    _ = try cwd.createFile("foo.txt", .{});

    const file = try cwd.openFile("foo.txt", .{ .mode = .write_only });
    defer file.close();
    try file.seekFromEnd(0);
    var fw_buffer: [1024]u8 = undefined;
    var fw = file.writer(&fw_buffer);
    try fw.interface.writeAll("Some random text to write\n");
    try fw.interface.flush();
}

test "test delete file" {
    const cwd = std.fs.cwd();
    const file = try cwd.createFile("foo.txt", .{});
    defer file.close();
    try cwd.deleteFile("foo.txt");
}

test "test copy file" {
    const cwd = std.fs.cwd();
    const file = try cwd.createFile("foo.txt", .{});
    defer file.close();
    try cwd.copyFile("foo.txt", cwd, "foo.txt.bak", .{});
}

test "iterate open dir" {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir("./", .{ .iterate = true });
    var it = dir.iterate();
    while (try it.next()) |entry| {
        std.debug.print("\nFile name: {s}\n", .{entry.name});
    }
}

// 递归遍历文件夹
test "iterate open dir recursion" {
    const allocator = std.heap.page_allocator; // 或其他分配器

    const cwd = std.fs.cwd();
    const dir = try cwd.openDir(".zig-cache", .{ .iterate = true });
    // dir.walk() 返回一个迭代器，用于递归遍历目录
    var walker = try dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        // `entry` 包含文件或目录的信息
        switch (entry.kind) {
            .file => {
                std.debug.print("文件: {s}\n", .{entry.path});
            },
            .directory => {
                std.debug.print("目录: {s}\n", .{entry.path});
            },
            else => {
                // 处理其他文件类型
            },
        }
    }
}
