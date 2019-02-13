//
//  UIScrollView+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefresHandler)(void);

@interface DNEmptyView : UIView

/** 图片名称 */
@property (nonatomic, copy) NSString *logoImageName;
/** 标题名称 */
@property (nonatomic, copy) NSString *titleLabelText;
/** 小标题名称 */
//@property (nonatomic, copy) NSString *subTitleLabelText;
/** 按钮名称 */
@property (nonatomic, copy) NSString *reloadButtonTitle;
/** 文本颜色 */
@property (nonatomic, assign) UIColor *titleColor;
/** 按钮背景颜色 */
@property (nonatomic, strong) UIColor *reloadBGColor;
/** 按钮文本颜色 */
@property (nonatomic, strong) UIColor *reloadTitleColor;

- (instancetype)initImageName:(NSString *)imageName tipStr:(NSString *)tipStr;
@end

@interface UIScrollView (Extra)

- (void)dn_refreshHeader:(RefresHandler)handler;
- (void)dn_refreshFooter:(RefresHandler)handler;

@end

NS_ASSUME_NONNULL_END
