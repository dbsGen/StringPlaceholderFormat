//
//  NSString+MTExtend.m
//  Photocus
//
//  Created by zrz on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+MTExtend.h"

@implementation NSString (MTExtend)

+ (id)stringWithFormatEx:(NSString *)format, ...
{
    const char *st = [format UTF8String];
    const char *ch = st;
    if (strlen(ch) > 2) {
        ch += 2;
        int index[10], count = 0;
        for (int i = 0 ; i < 10; i ++) {
            index[i] = -1;
        }
        while (*ch) {
            if (*(ch - 2) == '{' && *ch == '}' && *(ch - 1) >= '0' && *(ch - 1) <= '9') {
                index[count] = (ch - 1) - st;
                count++;
            }
            ch ++;
        }
        
        if (count > 0) {
            id *mem = malloc(10 * sizeof(id));
            NSMutableString *nFormat = [format mutableCopy];
            memset(mem, 0, 10 * sizeof(id));
            va_list arglist;
            va_start(arglist, format);
            for (int n = 0; n < count; n++) {
                NSString *string = va_arg(arglist, id);
                int i = index[n];
                int value = st[i] - '0';
                if (i < 0) {
                    free(mem);
                    @throw [NSException exceptionWithName:@"String format error"
                                                   reason:@"wrong format"
                                                 userInfo:nil];
                    return nil;
                }
                mem[value] = string;
            }
            va_end(arglist);
            //清除mem中的空隙
            int tCo = 0;
            for (int n = 0; n < 10; n++) {
                while (!*(mem + n)) {
                    for (int m = n; m < 9; m++) {
                        *(mem + m) = *(mem + m + 1);
                    }
                }
                tCo ++;
                if (tCo >= count) 
                    break;
            }
            
            for (int n = count - 1; n >= 0; n--) {
                int i = index[n];
                [nFormat replaceCharactersInRange:(NSRange){i - 1, 3}
                                       withString:mem[n]];
            }
            free(mem);
            NSString *output = [NSString stringWithString:nFormat];
            [nFormat release];
            return output;
        }
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *output = [[[NSString alloc] initWithFormat:format
                                              arguments:arglist] autorelease];
    va_end(arglist);
    return output;
}

@end
