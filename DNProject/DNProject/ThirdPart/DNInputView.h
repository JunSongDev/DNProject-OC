//
//  DNInputView.h
//  DNProject
//
//  Created by zjs on 2019/3/12.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNInputView : UIView

// ** <       输入框      > **//
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic,   copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIColor *maxTextColor;

@property (nonatomic, strong) UIColor *tipTextColor;

@property (nonatomic, assign) NSInteger maxLength;

@end

NS_ASSUME_NONNULL_END
