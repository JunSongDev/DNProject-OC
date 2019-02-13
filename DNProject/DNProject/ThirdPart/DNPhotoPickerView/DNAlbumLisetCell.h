//
//  DNAlbumLisetCell.h
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DNPhotoPickerViewModel;
@interface DNAlbumLisetCell : UITableViewCell

@property (nonatomic, strong) DNPhotoPickerViewModel *model;
@end

NS_ASSUME_NONNULL_END
