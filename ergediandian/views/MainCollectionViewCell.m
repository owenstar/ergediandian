//
//  MainCollectionViewCell.m
//  ergediandian
//
//  Created by 小白王 on 2019/9/28.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "MainCollectionViewCell.h"
@interface MainCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation MainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(PlayModel *)model
{
    _model = model;
    self.imageview.image = nil;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
    self.label.text = model.name;
}

-(void)setBorder:(BOOL)border
{
    _border = border;
    if(border){
        self.bgView.layer.borderColor = self.model.isSelected?[UIColor redColor].CGColor:[UIColor lightGrayColor].CGColor;
        self.bgView.layer.borderWidth = isPad?10:5;
        self.bgView.layer.cornerRadius = isPad?10:5;
        self.bgView.layer.masksToBounds = YES;
    }
}
@end
