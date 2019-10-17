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
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
        [self.contentView addSubview:self.collectionView];
    }
    return  self;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    597/335
    return CGSizeMake((ScreenWidth - 10) / 2.0, ScreenWidth / 2.0 * 335 / 597 + 40);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController * vc = [[PlayViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
    vc.index = indexPath.item;
    [[NSObject getCurrentViewController] presentViewController:vc animated:YES completion:nil];
}

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

