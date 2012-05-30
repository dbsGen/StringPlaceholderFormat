StringPlaceholderFormat
=======================

objective-c中类似java占位符的实现

for example:

NSLog(@"%@", [NSString stringWithFormatEx:@"c{2},{1},c", @"b", @"a"]);