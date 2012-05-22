//
//  NSString+MTExtend.h
//  Photocus
//
//  Created by zrz on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MTExtend)

//最多10个占位符,参数智能是obj-c类型
+ (id)stringWithFormatEx:(NSString *)format, ...  NS_FORMAT_FUNCTION(1,2);

@end
