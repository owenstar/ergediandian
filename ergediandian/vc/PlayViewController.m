//
//  PlayViewController.m
//  ergediandian
//
//  Created by peanut on 2019/10/10.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "PlayViewController.h"
#import "TBPlayer.h"
#import "MainCollectionViewCell.h"
#define KRightListP isIphoneX?50:0
#define KRightListN isIphoneX?-250:-200
@interface PlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *showView;//获取视频尺寸 480 * 853
@property (weak, nonatomic) IBOutlet UICollectionView *rightListView;
@property (nonatomic, assign) BOOL show;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightListRightConst;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
}

#pragma mark - init
- (void)setupSubview
{
    [self.rightListView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
    self.rightListRightConst.constant = KRightListN;
    [self fullScreenButtonClick:UIInterfaceOrientationLandscapeRight];
    [self addTapGestureRecognizer];
    [[TBPlayer sharedInstance] playWithUrl:[NSURL URLWithString:self.dataArray[self.index].resource] showView:self.showView];
    self.dataArray[self.index].isSelected = YES;
    [self.rightListView reloadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark - delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"MainCollectionViewCell";
    MainCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    597/335
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 335 / 597);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataArray[self.index].isSelected = NO;
    self.index = indexPath.item;
    self.dataArray[self.index].isSelected = YES;
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [[TBPlayer sharedInstance] playWithUrl:[NSURL URLWithString:self.dataArray[indexPath.item].resource] showView:self.showView];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 点击手势
- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView)];
    [self.showView addGestureRecognizer:tap];
}

- (void)tapPlayView
{
    self.show = !self.show;
    self.rightListView.alpha = self.show?0:1;
    [UIView animateWithDuration:1 animations:^{
        self.rightListView.alpha = self.show?1:0;
        self.rightListRightConst.constant = self.show?KRightListP:KRightListN;
    }];
}

#pragma mark - 全屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
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
    [[TBPlayer sharedInstance]stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playAction:(UIButton *)sender {
    
}

- (IBAction)sigleCirclePlay:(UIButton *)sender {
    
}

@end
