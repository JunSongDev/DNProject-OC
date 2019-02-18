//
//  DNPhotoPickerCollectionCell.h
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DNImageModel;

@protocol DNPhotoPickerDelegate <NSObject>

- (void)selectPhoto:(DNImageModel *)model ;

@end

@interface DNPhotoPickerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) DNImageModel *model;

@property (nonatomic, weak) id<DNPhotoPickerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
