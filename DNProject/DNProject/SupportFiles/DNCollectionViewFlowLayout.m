//
//  DNCollectionViewFlowLayout.m
//  DNProject
//
//  Created by zjs on 2019/3/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNCollectionViewFlowLayout.h"

@interface DNCollectionViewFlowLayout ()

@property (nonatomic, assign) CGFloat currentY;   //当前Y值
@property (nonatomic, assign) CGFloat currentX;   //当前X值
@property (nonatomic,   copy) WidthBlock widthComputeBlock;   //外包的宽度Block

@property (nonatomic, strong) NSMutableArray * attrubutesArray;   //所有元素的布局信息
@end

@implementation DNCollectionViewFlowLayout

- (void)configItemWidth:(CGFloat (^)(NSIndexPath * _Nonnull, CGFloat))widthBlock {
    
    _widthComputeBlock = widthBlock;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //初始化首个item位置
    _currentY = _sectionInsets.top;
    _currentX = _sectionInsets.left;
    _attrubutesArray = [NSMutableArray array];
    //得到每个item属性并存储
    for (NSInteger i = 0; i < count; i ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrubutesArray addObject:attributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取宽度
    CGFloat contentWidth = self.collectionView.frame.size.width - _sectionInsets.left - _sectionInsets.right;
    
    //通过indexpath创建一个item属性
    UICollectionViewLayoutAttributes *temp = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemW = 0;
    if (_widthComputeBlock) {
        itemW = self.widthComputeBlock(indexPath, _itemHeight);
        //约束宽度最大值
        if (itemW > contentWidth) {
            itemW = contentWidth;
        }
    } else {
        NSAssert(YES, @"请实现计算宽度的block方法");
    }
    
    //计算item的frame
    CGRect frame;
    frame.size = CGSizeMake(itemW, _itemHeight);
    
    //检查坐标
    if (_currentX + frame.size.width > contentWidth) {
        _currentX = _sectionInsets.left;
        _currentY += (_itemHeight + _lineSpace);
    }
    //设置坐标
    frame.origin = CGPointMake(_currentX, _currentY);
    temp.frame = frame;
    
    //偏移当前坐标
    _currentX += frame.size.width + _itemSpace;
    return temp;
}

- (NSInteger)num:(NSInteger)num numt:(NSInteger)numt {
    
    return num < numt ? num : numt;
}


- (CGSize)collectionViewContentSize {
    return CGSizeMake(1,
                      _currentY + _itemHeight + _sectionInsets.bottom);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attrubutesArray;
}

@end
