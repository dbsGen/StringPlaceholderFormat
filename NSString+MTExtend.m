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
        int count = 0;
        char index[10][4];
        memset(index, 0, 30*sizeof(char));
        while (*ch) {
            if (*(ch - 2) == '{' && *ch == '}' && *(ch - 1) >= '0' && *(ch - 1) <= '9') {
                index[count][0] = '{';
                index[count][1] = *(ch - 1);
                index[count][2] = '}';
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
                int value = index[n][1] - '0';
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
                [nFormat replaceOccurrencesOfString:[NSString stringWithUTF8String:index[n]] 
                                         withString:mem[n] 
                                            options:NSLiteralSearch 
                                              range:(NSRange){0, [nFormat length]}];
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
