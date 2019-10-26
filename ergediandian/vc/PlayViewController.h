//
//  PlayViewController.h
//  ergediandian
//
//  Created by peanut on 2019/10/10.
//  Copyright © 2019 小白王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  JYVideoPlayer:UIView

@end

@interface PlayViewController : UIViewController
@property (nonatomic, strong) NSArray <PlayModel *>* dataArray;
@property (nonatomic, assign) NSInteger index;
@end


