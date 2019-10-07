//
//  ViewController.m
//  erge
//
//  Created by peanut on 2019/9/18.
//  Copyright © 2019 peanut. All rights reserved.
//

#import "ViewController.h"
#import "TopCollectionViewCell.h"
#import "BottomCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCollectionHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (strong, nonatomic)  NSArray <TopModel *>* titleArray;
@property (strong, nonatomic)  NSArray * urlArray;
@property (assign, nonatomic)  NSInteger currentIndex;
@property (strong, nonatomic)  NSMutableArray * dataTotalArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topCollectionHeight.constant = isPad ? (49 * 1.5) : 49;
    [self.bottomCollectionView registerClass:[BottomCollectionViewCell class] forCellWithReuseIdentifier:@"BottomCollectionViewCell"];
    [self.topCollectionView registerNib:[UINib nibWithNibName:@"TopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TopCollectionViewCell"];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self fetchData];
    // Do any additional setup after loading the view.
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView == _topCollectionView ? @"TopCollectionViewCell" :@"BottomCollectionViewCell" forIndexPath:indexPath];
    if (collectionView == self.topCollectionView) {
        cell.model = self.titleArray[indexPath.row];
    }
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.titleArray.count;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView == _bottomCollectionView ? collectionView.bounds.size : CGSizeMake(self.titleArray[indexPath.item].width, collectionView.bounds.size.height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return collectionView == _bottomCollectionView ? UIEdgeInsetsMake(5, 0, 5, 0) : UIEdgeInsetsZero;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.bottomCollectionView) {
        BottomCollectionViewCell * cell1 = (BottomCollectionViewCell *)cell;
        if (self.dataTotalArray.count) {
            cell1.dataArray = self.dataTotalArray[indexPath.item];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.topCollectionView) {
        return;
    }
    int page = scrollView.contentOffset.x / ScreenWidth;
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:page inSection:0];
    
    self.titleArray[self.currentIndex].selected = NO;
    self.titleArray[page].selected = YES;
    [self.topCollectionView reloadData];
    [self.topCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.currentIndex = page;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.topCollectionView) {
        self.titleArray[self.currentIndex].selected = NO;
        self.titleArray[indexPath.item].selected = YES;
        [self.topCollectionView reloadData];
        [self.bottomCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        self.currentIndex = indexPath.item;
//        [self setCurrentDataWithIndex:self.currentIndex];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//-(void)setCurrentDataWithIndex:(NSInteger)index
//{
//    BottomCollectionViewCell * cell = (BottomCollectionViewCell *)[self.bottomCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]] ;
//    cell.dataArray = self.dataTotalArray[index];
//}


#pragma mark - fetchdata

-(void)fetchData{
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < self.urlArray.count; i++) {
        dispatch_group_enter(group);
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < self.urlArray.count; i++) {
            NSLog(@"dsdsdsd----1");
            dispatch_semaphore_t sem = dispatch_semaphore_create(0);
            [[LENNetworkRequest sharedManager] GET:self.urlArray[i] parameters:@{@"limit":@(200)} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"dsdsdsd");
                if ([responseObject[@"success"]boolValue]) {
                    NSArray * array = [PlayModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    [self.dataTotalArray addObject:array];
                }
                dispatch_semaphore_signal(sem);
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                dispatch_semaphore_signal(sem);
                dispatch_group_leave(group);
            }];

            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.bottomCollectionView reloadData];
    });
}

#pragma mark - lazy
-(NSArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = @[@"api/v1/albums/646/videos",
                      @"api/v1/albums/148/videos",
                      @"api/v1/albums/2/videos",
                      @"api/v1/albums/33/videos",
                      @"api/v1/albums/663/videos",
                      @"api/v1/albums/677/videos",
                      @"api/v1/albums/28/videos",
                      @"api/v1/albums/659/videos",
                      @"api/v1/albums/233/videos",
                      @"api/v1/albums/601/videos",
                      @"api/v1/albums/562/videos",
                      @"api/v1/albums/514/videos"];
    }
    return  _urlArray;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[[TopModel modelWithTitle:@"萌鸡小队" selected:YES],
                      [TopModel modelWithTitle:@"巴塔木" selected:NO],
                      [TopModel modelWithTitle:@"宝宝巴士" selected:NO],
                      [TopModel modelWithTitle:@"小猪佩奇" selected:NO],
                      [TopModel modelWithTitle:@"嗨，道奇" selected:NO],
                      [TopModel modelWithTitle:@"天线宝宝" selected:NO],
                      [TopModel modelWithTitle:@"哈利讲故事" selected:NO],
                      [TopModel modelWithTitle:@"爱探险的朵拉" selected:NO],
                      [TopModel modelWithTitle:@"小马宝莉" selected:NO],
                      [TopModel modelWithTitle:@"大眼兔玩具" selected:NO],
                      [TopModel modelWithTitle:@"超级飞侠" selected:NO],
                      [TopModel modelWithTitle:@"海底小纵队" selected:NO]];
    }
    return  _titleArray;
}

-(NSMutableArray *)dataTotalArray
{
    if (!_dataTotalArray) {
        _dataTotalArray = [NSMutableArray new];
    }
    return _dataTotalArray;
}
@end
