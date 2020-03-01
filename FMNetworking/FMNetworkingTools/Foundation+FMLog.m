//
//  NSDictionary+Log.m
//
//
//  Created by hqc on 15/11/28.
//  Copyright © 2015年 hqc. All rights reserved.
//  用于控制打印输出格式为中文

#import <Foundation/Foundation.h>

@implementation NSDictionary (FMLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    //控制字典的输出内容
    

    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"\t%@:",key];
        [string appendFormat:@"%@,\n",obj];
    }];
    [string appendString:@"}"];
    
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location !=NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    return string;
}
@end


@implementation NSArray (FMLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    //控制字典的输出内容
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"["];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,",obj];
    }];
    [string appendString:@"]\n"];
    
    
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location !=NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    return string;
}


@end

