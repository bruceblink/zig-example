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
