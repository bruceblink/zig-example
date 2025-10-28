const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

test "test single pointer" {
    var integer: i16 = 666;
    const ptr = &integer; // 获取指针
    ptr.* = ptr.* + 1; // 解引用，进行指针运算
    try expect(667 == integer);
    try expect(667 == ptr.*); //
}

test "test array pointer" {
    // 数组指针
    const array = [_]i32{ 1, 2, 3, 4 };
    const ptr: [*]const i32 = &array;
    try expect(1 == ptr[0]);

    // 字符串指针
    var hello: [5]u8 = "hello".*;
    const array_pointer = &hello;
    try expect(array_pointer.len == 5);
    const slice: []u8 = hello[1..3];
    try expect(slice.len == 2);
}
