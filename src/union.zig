const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

const Payload = union {
    int: i64,
    float: f64,
    boolean: bool,
};

test "init union" {
    var payload = Payload{ .int = 123 };
    try expect(123 == payload.int);
    payload = Payload{ .int = 9 };
    try expect(9 == payload.int);
}

// 初始化一个编译器已知的union
test "init union2" {
    // 通过 @unionInit 初始化一个联合类型
    const payload = @unionInit(Payload, "int", 666);
    try expect(666 == payload.int);
}
