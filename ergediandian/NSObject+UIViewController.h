//
//  NSObject+UIViewController.h
//  ergediandian
//
//  Created by peanut on 2019/10/14.
//  Copyright © 2019 小白王. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UIViewController)
+ (UIViewController *)getRootViewController;
+ (UIViewController *)getCurrentViewController;
@end

NS_ASSUME_NONNULL_END
