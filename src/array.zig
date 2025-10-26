const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

test "test init array" {
    const message = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
    // const message = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    try expect(eql(u8, "hello"[0..5], message[0..]));
    try expect('h' == message[0]);
}

test "test destruction array" {
    const orange: [4]u8 = .{ 255, 165, 0, 255 };
    // 解构
    const r, const g, const b, const a = orange;
    try expect(255 == r);
    try expect(165 == g);
    try expect(0 == b);
    try expect(255 == a);
}

test "test connect array" {
    const part_one = [_]i32{ 1, 2, 3, 4 };
    const part_two = [_]i32{ 5, 6, 7, 8 };
    const all_of_it = part_one ++ part_two;
    try expect(eql(
        i32,
        ([8]i32{ 1, 2, 3, 4, 5, 6, 7, 8 })[0..], // 这里的数组必须加()
        all_of_it[0..],
    ));
    // &.{...} 语法是一个匿名数组切片，比 [8]i32{...}[0..] 简洁。
    try expect(eql(i32, &.{ 1, 2, 3, 4, 5, 6, 7, 8 }, all_of_it[0..]));
}

test "test multiply array" {
    const small = [3]i8{ 1, 2, 3 };
    const big: [9]i8 = small ** 3;
    try expect(eql(i8, &.{ 1, 2, 3, 1, 2, 3, 1, 2, 3 }, big[0..]));
}

fn make(x: i32) i32 {
    return x + 1;
}

test "test fn init array" {
    // 使用函数初始化数组
    const array = [_]i32{make(3)} ** 10;
    try expect(eql(i32, &.{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 }, array[0..]));
}

test "comptime init array" {
    // 编译器初始化数组
    const fancy_array = init: {
        var initial_value: [10]usize = undefined;
        for (&initial_value, 0..) |*pt, i| {
            pt.* = i;
        }
        break :init initial_value;
    };
    try expect(eql(usize, &.{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, fancy_array[0..]));
}
