//
//  NSString+Size.m
//  Danale
//
//  Created by Danale on 2018/3/29.
//  Copyright © 2018年 Danale. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
/**
 
 计算单行文字的size
 
 @parms  文本
 
 @parms  字体
 
 @return  字体的CGSize
 
 */
+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size;
    
}

/**
 
 计算多行文字的CGRect
 
 @parms  文本
 
 @parms  字体
 
 @return  字体的CGRect
 
 */

+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font{
    
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect;
    
}
@end
