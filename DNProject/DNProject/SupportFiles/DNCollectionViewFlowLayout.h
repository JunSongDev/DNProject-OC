//
//  DNCollectionViewFlowLayout.h
//  DNProject
//
//  Created by zjs on 2019/3/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat(^WidthBlock)(NSIndexPath * indexPath, CGFloat height);

@interface DNCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemSpace;
@property (assign, nonatomic) CGFloat lineSpace;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;

/**
 配置item的宽度
 */
- (void)configItemWidth:(CGFloat(^)(NSIndexPath * indexPath, CGFloat height))widthBlock;

@end

NS_ASSUME_NONNULL_END
