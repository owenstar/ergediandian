//
//  PlayViewController.m
//  ergediandian
//
//  Created by peanut on 2019/10/10.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "PlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MainCollectionViewCell.h"
#define KRightListWidth (isPad ? 1.5 : 1) *200
#define KUrl(url) [NSURL URLWithString:url]

@implementation JYVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@end

@interface PlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightListWidth;//适配ipad 右侧列表
@property (weak, nonatomic) IBOutlet JYVideoPlayer *videoLayer;//获取视频尺寸 480 * 853
@property (weak, nonatomic) IBOutlet UICollectionView *rightListView;
@property (nonatomic, assign) BOOL show;//是否显示右侧的列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightListRightConst;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) id timeObserver;                      //视频播放时间观察者
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
}

#pragma mark - init
- (void)setupSubview
{
    self.rightListWidth.constant = KRightListWidth;
    self.backBtnWidth.constant = 80 * ((isPad ? 1.5 : 1));
    [self.rightListView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
    self.rightListRightConst.constant = -KRightListWidth;
    [self fullScreenButtonClick:UIInterfaceOrientationLandscapeRight];
    [self addTapGestureRecognizer];
    [self playVideoWithUrl:KUrl(self.dataArray[self.index].resource)];
    self.dataArray[self.index].isSelected = YES;
    [self.rightListView reloadData];
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

- (void)playVideoWithUrl:(NSURL *)url{
    [self releaseVideoPlayer];
    self.videoLayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    AVAsset * asset = [AVAsset assetWithURL:url];
    self.playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    if(!self.player){
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }else{
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    // 将player输出到显示动画层playerLayer
    AVPlayerLayer * playerLayer = (AVPlayerLayer *)self.videoLayer.layer;
    [playerLayer setPlayer:self.player];
    [self addPlayerNotification];
    [self.indicator startAnimating];
    self.controlView.hidden = YES;
    [self setTime:0 withTotal:0];
}

- (void)releaseVideoPlayer
{
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    [self removeNotification];
    self.playerItem = nil;
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

- (void)playItemWithOldIndex:(NSInteger)index newIndex:(NSInteger)newIndex {
    self.dataArray[index].isSelected = NO;
    self.dataArray[newIndex].isSelected = YES;
    [self.rightListView reloadItemsAtIndexPaths:@[
                                              [NSIndexPath indexPathForItem:index inSection:0],
                                              [NSIndexPath indexPathForItem:newIndex inSection:0]]];
    self.index = newIndex;
    [self.rightListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self playVideoWithUrl:KUrl(self.dataArray[self.index].resource)];
}

#pragma mark - 点击手势
- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView)];
    [self.videoLayer addGestureRecognizer:tap];
}

- (void)tapPlayView
{
    self.show = !self.show;
    self.rightListView.alpha = self.show?0:1;
    [UIView animateWithDuration:1 animations:^{
        self.rightListView.alpha = self.show?1:0;
        self.rightListRightConst.constant = self.show?(isIphoneX?44:0):-KRightListWidth;
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
    [self releaseVideoPlayer];
//    [self fullScreenButtonClick:UIInterfaceOrientationPortrait];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playAction:(UIButton *)sender {
    
}

- (IBAction)sigleCirclePlay:(UIButton *)sender {
    
}


#pragma mark - player
- (void)removeNotification
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addPlayerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    //    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    //    //播放失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailedToPlayToEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    //    //异常中断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
//    监听AVPlayerItem状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    loadedTimeRanges状态
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//    playbackLikelyToKeepUp状态
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
   //时间监听
    [self addProgressObserver];
//    //声音被打断的通知（电话打来）
//    AVAudioSessionInterruptionNotification
//    //耳机插入和拔出的通知
//    AVAudioSessionRouteChangeNotification
}

#pragma mark - action
- (void)appDidEnterBackground
{
    [self.player pause];
}
- (void)appDidEnterPlayGround
{
    [self.player play];
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification
{
    if((self.index + 1) < self.dataArray.count){
        [self playItemWithOldIndex:self.index newIndex:self.index+1];
    }else{
        [self playItemWithOldIndex:self.index newIndex:0];
    }
}

- (void)playerItemFailedToPlayToEnd:(NSNotification *)notification
{
    
}

- (void)playerItemPlaybackStalled:(NSNotification *)notification
{
    // 这里网络不好的时候，就会进入，不做处理，会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"buffing-----buffing");
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem * item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
             [self.player play];
             self.controlView.hidden = NO;
            [self.indicator stopAnimating];
        }else if (item.status == AVPlayerItemStatusFailed){
             NSLog(@"failed");
        }
   }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
    //            [self updateLoadedTimeRanges:timeRanges];
     }
    
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //缓冲区空了，所需做的处理操作
        [self.indicator startAnimating];
    }
    
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //缓冲就绪，所需做的处理操作
        [self.indicator stopAnimating];
    }
}

//通常情况下,在加载网络视频时,我们需要获取视频的缓冲进度,这时候,我们可以通过监听AVPlayerItem的loadedTimeRanges状态,获取缓冲进度
- (void)updateLoadedTimeRanges:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        CMTimeRange timerange = [[timeRanges firstObject] CMTimeRangeValue];
        CMTime bufferDuration = CMTimeAdd(timerange.start, timerange.duration);
        // 获取到缓冲的时间,然后除以总时间,得到缓冲的进度
        NSLog(@"%f",CMTimeGetSeconds(bufferDuration));
    }
}

//- (void)seekToTime:(CMTime)time;
//- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler NS_AVAILABLE(10_7, 5_0);
//- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter;
////此方法包含回调事件
//- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^)(BOOL finished))completionHandler NS_AVAILABLE(10_7, 5_0);
- (void)addProgressObserver{
    //这里设置每秒执行一次
    __weak __typeof(self) weakself = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([weakself.playerItem duration]);
        NSLog(@"当前已经播放%f",current);
        if (current) {
            [weakself setTime:current withTotal:total];
        }
    }];
}


#pragma mark - 私有方法
//设置播放时长
- (void)setTime:(float)current withTotal:(float)total{
    self.slider.value = current/total;
    self.currentTimeLabel.text = [self displayTime:(int)current];
    self.totalTimeLabel.text = [self displayTime:(int)total];
}

- (NSString*)displayTime:(int)timeInterval{
    NSString * time = @"";
    int seconds = timeInterval % 60;
    int minutes = (timeInterval / 60) % 60;
    int hours = timeInterval / 3600;
    NSString * secondsStr=seconds<10?[NSString stringWithFormat:@"%@%d",@"0",seconds]:[NSString stringWithFormat:@"%d",seconds];
    NSString * minutesStr=minutes<10?[NSString stringWithFormat:@"%@%d",@"0",minutes]:[NSString stringWithFormat:@"%d",minutes];
    NSString * hoursStr=hours<10?[NSString stringWithFormat:@"%@%d",@"0",hours]:[NSString stringWithFormat:@"%d",hours];
    time = [NSString stringWithFormat:@"%@%@%@%@%@",hoursStr,@":",minutesStr,@":",secondsStr];
    return time;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
