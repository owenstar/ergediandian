//
//  NSString+Size.h
//  Danale
//
//  Created by Danale on 2018/3/29.
//  Copyright © 2018年 Danale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)
+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font;
+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font;
@end
