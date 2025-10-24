const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

test "test string" {

    // 格式化时，可以使用 u 输出对应的字符
    const me_zh = '我';
    print("\n{0u} = {0x}\n", .{me_zh}); // 我 = 6211
    try expect(me_zh == 0x6211);
    // 如果是 ASCII 字符，还可以使用 c 进行格式化
    const me_en = 'I';
    try expect(me_en == 0x49);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const formatted = try std.fmt.allocPrint(allocator, "{0u} = {0c} = {0x}", .{me_en});
    defer allocator.free(formatted);

    try expect(eql(u8, formatted, "I = I = 49")); // ✅ 断言字符串完全匹配
    // 下面的写法会报错，因为这些 emoji 虽然看上去只有一个字，但其实需要由多个码位组合而成
    // const hand = '🖐🏽';
    // const flag = '🇨🇳';

}

test "test string 1" {

    // 存储的是 UTF-8 编码序列
    const bytes = "Hello, 世界！";

    // 类型断言
    try std.testing.expectEqualTypes(@TypeOf(bytes), *const [16:0]u8);
    //try expect(eql([]const u8, "*const [16:0]u8", @TypeOf(bytes)));
    //expect("*const [16:0]u8", @TypeOf(bytes));
    try expect(16 == bytes.len);
    // 通过索引访问到的是 UTF-8 编码序列中的字节
    // 由于 UTF-8 兼容 ASCII，所以可以直接打印 ASCII 字符
    try expect(bytes[1] == 'e');

    // “世”字的 UTF-8 字符编码为 E4 B8 96 一个UTF-8字符占用3个ASCII码
    try expect(bytes[7] == 0xE4);
    try expect(bytes[8] == 0xB8);
    try expect(bytes[9] == 0x96);
    // 以 NUL 结尾
    try expect(bytes[16] == 0);
}
