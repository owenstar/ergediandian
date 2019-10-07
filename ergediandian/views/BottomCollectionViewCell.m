//
//  BottomCollectionViewCell.m
//  erge
//
//  Created by peanut on 2019/9/19.
//  Copyright © 2019 peanut. All rights reserved.
//

#import "BottomCollectionViewCell.h"
#import "MainCollectionViewCell.h"
@interface BottomCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation BottomCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;  //行间距
        flowLayout.minimumInteritemSpacing = 0;
        //列间距
        //        flowLayout.estimatedItemSize = CGSizeMake(50, 50);  //预定的itemsize
        //        flowLayout.itemSize = CGSizeMake(150, 100); //固定的itemsize
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.delegate = self; //设置代理
        self.collectionView.dataSource = self;   //设置数据来源
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
        [self.contentView addSubview:self.collectionView];
    }
    return  self;
}

//-(instancetype)initWithFrame:(CGRect)frame
//    if (self = [super i]) {
//}

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
    return CGSizeMake((ScreenWidth - 10) / 2.0, ScreenWidth / 2.0 * 335 / 597 + 40);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - setter
-(void)setDataArray:(NSArray<PlayModel *> *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
@end

