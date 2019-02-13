//
//  DNNavTitleView.h
//  DNProject
//
//  Created by zjs on 2019/1/18.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DNNavTitleViewDelegate <NSObject>

- (void)navTitleViewTouchInside;

@end

@interface DNNavTitleView : UIControl

@property (nonatomic, weak) id<DNNavTitleViewDelegate> delegate;

@property (nonatomic,   copy) NSString *imageName;
@property (nonatomic,   copy) NSString *titleStr;

@property (nonatomic, assign) CGFloat  titleFont;

@property (nonatomic, assign, getter=isTouchUp) BOOL touchUp;

@property (nonatomic, strong) UIColor *titleColor;
@end

NS_ASSUME_NONNULL_END
