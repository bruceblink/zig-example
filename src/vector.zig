const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

test "test init vector" {
    const ele_4 = @Vector(4, i32);

    // 向量必须拥有编译期已知的长度和类型
    const a = ele_4{ 1, 2, 3, 4 };
    const b = ele_4{ 5, 6, 7, 8 };

    // 执行相加的操作
    const c = a + b;

    print("\nVector c is {any}\n", .{c});
    // 以数组索引的语法来访问向量的元素
    print("the third element of Vector c[2] is {}\n", .{c[2]});

    // 定义一个数组，注意我们这里使用的是浮点类型
    var arr1: [4]f32 = [_]f32{ 1.1, 3.2, 4.5, 5.6 };
    // 直接转换成为一个向量
    const vec: @Vector(4, f32) = arr1;

    print("Vector vec is {any}\n", .{vec});

    // 将一个切片转换为向量
    const vec2: @Vector(2, f32) = arr1[1..3].*;
    print("Vector vec2 is {any}\n", .{vec2});
}
