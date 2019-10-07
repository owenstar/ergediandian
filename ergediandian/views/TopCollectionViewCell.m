//
//  TopCollectionViewCell.m
//  erge
//
//  Created by peanut on 2019/9/19.
//  Copyright © 2019 peanut. All rights reserved.
//

#import "TopCollectionViewCell.h"
@interface TopCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation TopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(TopModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = model.selected?[UIColor redColor]:[UIColor blackColor];
    self.titleLabel.font = model.selected?[UIFont boldSystemFontOfSize:25]:[UIFont systemFontOfSize:15];
}

@end


