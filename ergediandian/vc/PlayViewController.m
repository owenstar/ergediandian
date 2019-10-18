//
//  PlayViewController.m
//  ergediandian
//
//  Created by peanut on 2019/10/10.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "PlayViewController.h"
#import "TBPlayer.h"
#import "SUAdvancePlayer.h"
#import <MediaPlayer/MediaPlayer.h>

#import "MainCollectionViewCell.h"
#define KRightListP isIphoneX?50:0
#define KRightListN isIphoneX?-250:-200
#define KUrl(url) [NSURL URLWithString:url]
@interface PlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TBPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *showView;//获取视频尺寸 480 * 853
@property (weak, nonatomic) IBOutlet UICollectionView *rightListView;
@property (nonatomic, assign) BOOL show;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightListRightConst;
@property (nonatomic, strong) SUAdvancePlayer *player;
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
//    [[TBPlayer sharedInstance] playWithUrl:KUrl(self.dataArray[self.index].resource) showView:self.showView];
    self.player = [[SUAdvancePlayer alloc] initPlayerWithURL:[NSURL URLWithString:@"http://vodg3ns8cfm.vod.126.net/vodg3ns8cfm/0S0r2IXc_75031_shd.mp4"]];
    self.player.playerLayer.frame = self.showView.bounds;
    [self.showView.layer addSublayer:self.player.playerLayer];
    [self.player play];
    self.dataArray[self.index].isSelected = YES;
    [self.rightListView reloadData];
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [TBPlayer sharedInstance].delegate = self;
}

#pragma mark - delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"MainCollectionViewCell";
    MainCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    cell.border = YES;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    597/335
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 335.0 / 597+40);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self playItemWithOldIndex:self.index newIndex:indexPath.item];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)playEnd
{
    if((self.index + 1) < self.dataArray.count){
        [self playItemWithOldIndex:self.index newIndex:self.index+1];
    }else{
        [self playItemWithOldIndex:self.index newIndex:0];
    }
}

- (void)playItemWithOldIndex:(NSInteger)index newIndex:(NSInteger)newIndex {
    self.dataArray[index].isSelected = NO;
    self.dataArray[newIndex].isSelected = YES;
    [self.rightListView reloadItemsAtIndexPaths:@[
                                              [NSIndexPath indexPathForItem:index inSection:0],
                                              [NSIndexPath indexPathForItem:newIndex inSection:0]]];
    self.index = newIndex;
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [[TBPlayer sharedInstance]playWithUrl:KUrl(self.dataArray[self.index].resource) showView:self.showView];
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
    [[TBPlayer sharedInstance]showOrHideTabView:self.show];
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
