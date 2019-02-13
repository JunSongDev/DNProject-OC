//
//  DNSpreadButton.h
//  DNProject
//
//  Created by zjs on 2019/1/22.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNSpreadButton : UIButton

@property (nonatomic, copy) void (^buttonAction)(NSInteger buttonTag);

@property (nonatomic, copy) NSArray * titleArray;
@property (nonatomic, copy) NSArray * imageArray;
@end

NS_ASSUME_NONNULL_END
