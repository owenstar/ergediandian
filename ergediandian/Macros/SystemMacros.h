//
//  SystemMacros.h
//  ergediandian
//
//  Created by 小白王 on 2019/9/28.
//  Copyright © 2019 小白王. All rights reserved.
//

#ifndef SystemMacros_h
#define SystemMacros_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define isPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
isPhoneX = YES;\
}\
}\
isPhoneX;\
})

#define kTabOffset isIphoneX?44:0
#endif /* SystemMacros_h */
