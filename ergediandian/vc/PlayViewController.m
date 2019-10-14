//
//  PlayViewController.m
//  ergediandian
//
//  Created by peanut on 2019/10/10.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "PlayViewController.h"
#import "TBPlayer.h"
@interface PlayViewController ()
@property (weak, nonatomic) IBOutlet UIView *showView;//获取视频尺寸 480 * 853
@property (weak, nonatomic) IBOutlet UICollectionView *rightListView;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fullScreenButtonClick:UIInterfaceOrientationLandscapeRight];
    [self addTapGestureRecognizer];
    NSURL *url2 = [NSURL URLWithString:self.model.resource];
    [[TBPlayer sharedInstance] playWithUrl:url2 showView:self.showView];
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView)];
    [self.showView addGestureRecognizer:tap];
}

- (void)tapPlayView
{
    __weak typeof(self) weakSelf = self;
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持横屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)fullScreenButtonClick:(UIInterfaceOrientation)orientation{
    //屏幕横屏的方法
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    [invocation setArgument:&orientation atIndex:2];
    [invocation invoke];
}

#pragma mark - xib action
- (IBAction)backAction:(UIButton *)sender {
//    [self fullScreenButtonClick:UIInterfaceOrientationPortrait];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playAction:(UIButton *)sender {
    
}

- (IBAction)sigleCirclePlay:(UIButton *)sender {
    
}

@end
