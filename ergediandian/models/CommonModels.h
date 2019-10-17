//
//  CommonModels.h
//  ergediandian
//
//  Created by 小白王 on 2019/9/28.
//  Copyright © 2019 小白王. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CommonModels : NSObject

@end



@interface PlayModel : NSObject
@property (nonatomic, strong) NSString * resource;//链接
@property (nonatomic, strong) NSString * name;//名称
@property (nonatomic, strong) NSString * image;//缩略图
@property (nonatomic, strong) NSString * play_count;//播放次数
@property (nonatomic, strong) NSString * duration;//时长
@property (nonatomic, assign) BOOL isSelected;//是否选中状态
@end


@interface TopModel : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) float width;
+ (TopModel *)modelWithTitle:(NSString *)title selected:(BOOL)selected;
@end
