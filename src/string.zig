const std = @import("std");
const debug = @import("std").debug;
const print = debug.print;

test "test string" {

    // 格式化时，可以使用 u 输出对应的字符
    const me_zh = '我';
    print("{0u} = {0x}\n", .{me_zh}); // 我 = 6211

    // 如果是 ASCII 字符，还可以使用 c 进行格式化
    const me_en = 'I';
    print("{0u} = {0c} = {0x}\n", .{me_en}); // I = I = 49

    // 下面的写法会报错，因为这些 emoji 虽然看上去只有一个字，但其实需要由多个码位组合而成
    // const hand = '🖐🏽';
    // const flag = '🇨🇳';

}
