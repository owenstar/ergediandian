//
//  CommonModels.m
//  ergediandian
//
//  Created by 小白王 on 2019/9/28.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "CommonModels.h"

@implementation CommonModels

@end

@implementation PlayModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end


@implementation TopModel
+(TopModel *)modelWithTitle:(NSString *)title selected:(BOOL)selected
{
    TopModel * model = [[TopModel alloc]init];
    model.title = title;
    model.selected = selected;
    model.width = [title sizeWithFont:[UIFont boldSystemFontOfSize:25]].width + 20;
    return  model;
}
@end
