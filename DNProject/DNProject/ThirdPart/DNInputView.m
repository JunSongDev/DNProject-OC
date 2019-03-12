//
//  DNInputView.m
//  DNProject
//
//  Created by zjs on 2019/3/12.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNInputView.h"

@interface DNInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *leftIconImg;

// ** < 超出最大字数限制提示 > **//
@property (nonatomic, strong) UILabel     *tipsLabel;

// ** <      输入框标题    > **//
@property (nonatomic, strong) UILabel     *headPlaceholder;

// ** < 当前字数及最大可输入字数显示 > **//
@property (nonatomic, strong) UILabel     *maxLengthLb;

// ** <          分割线         > **//
@property (nonatomic, strong) UIView      *bottomLine;
@end

@implementation DNInputView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textColor    = UIColor.darkGrayColor;
        self.tipTextColor = UIColor.redColor;
        self.maxTextColor = UIColor.lightGrayColor;
        self.lineColor    = UIColor.lightGrayColor;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self addSubview:self.headPlaceholder];
    [self.headPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).inset(AUTO_MARGIN(12));
        make.left.right.mas_equalTo(self).inset(AUTO_MARGIN(5));
    }];
    
    [self addSubview:self.leftIconImg];
    [self.leftIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headPlaceholder.mas_bottom).mas_offset(AUTO_MARGIN(8));
        make.left.mas_equalTo(self.headPlaceholder.mas_left);
        make.size.mas_equalTo(CGSizeMake(AUTO_MARGIN(20), AUTO_MARGIN(30)));
    }];
    
    [self addSubview:self.maxLengthLb];
    [self.maxLengthLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.leftIconImg.mas_bottom);
        make.right.mas_equalTo(self.headPlaceholder.mas_right);
        make.width.mas_offset(AUTO_MARGIN(40));
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.leftIconImg);
        make.left.mas_equalTo(self.leftIconImg.mas_right).mas_offset(AUTO_MARGIN(8));
        make.right.mas_equalTo(self.maxLengthLb.mas_left).mas_offset(-AUTO_MARGIN(8));
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(AUTO_MARGIN(8));
        make.left.right.mas_equalTo(self.headPlaceholder);
        make.height.mas_offset(1);
    }];
    
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.bottomLine.mas_bottom).mas_offset(AUTO_MARGIN(8));
        make.left.right.mas_equalTo(self.headPlaceholder);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(12));
    }];
}

#pragma mark -- UITextFieldDelegate && Action
- (void)textFieldEditingChanged:(UITextField *)sender {
    
    if (sender.text.length > self.maxLength) {
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.tipsLabel.alpha = 1.0;
            self.tipsLabel.textColor   = self.tipTextColor;
            self.maxLengthLb.textColor = self.tipTextColor;
            self.textField.textColor   = self.tipTextColor;
            self.bottomLine.backgroundColor = self.tipTextColor;
            
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.tipsLabel.alpha = 0.0;
            self.textField.textColor   = self.textColor;
            self.maxLengthLb.textColor = self.maxTextColor;
            self.bottomLine.backgroundColor = self.lineColor;
            
        } completion:nil];
    }
    self.maxLengthLb.text = [NSString stringWithFormat:@"%ld/%ld", sender.text.length, self.maxLength];
}

- (void)setPlaceholderLabelHidden:(BOOL)hide {
    
    if (hide) {
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.headPlaceholder.alpha = 0.0f;
            self.textField.placeholder = self.placeholder;
            self.bottomLine.backgroundColor = self.lineColor;
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.headPlaceholder.alpha = 1.0f;
            self.textField.placeholder = @"";
            self.bottomLine.backgroundColor = self.lineColor;
        } completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setPlaceholderLabelHidden:NO];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self setPlaceholderLabelHidden:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self setPlaceholderLabelHidden:YES];
    return YES;
}



- (UIImageView *)leftIconImg {
    
    if (!_leftIconImg) {
        _leftIconImg = [[UIImageView alloc] init];
        _leftIconImg.contentMode     = UIViewContentModeScaleAspectFit;
        _leftIconImg.backgroundColor = [UIColor clearColor];
    }
    return _leftIconImg;
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = UIColor.clearColor;
        _textField.placeholder     = self.placeholder;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate        = self;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = self.tipTextColor;
        _tipsLabel.font = [UIFont systemFontOfSize:AUTO_MARGIN(12)];
        _tipsLabel.text = @"字数超出最大限制";
        _tipsLabel.alpha = 0.0;
    }
    return _tipsLabel;
}

- (UILabel *)maxLengthLb {
    
    if (!_maxLengthLb) {
        _maxLengthLb = [[UILabel alloc] init];
        _maxLengthLb.textColor     = self.maxTextColor;
        _maxLengthLb.textAlignment = NSTextAlignmentRight;
        _maxLengthLb.font = [UIFont systemFontOfSize:AUTO_MARGIN(12)];
        _maxLengthLb.text = [NSString stringWithFormat:@"0/%ld", self.maxLength];
    }
    return _maxLengthLb;
}

- (UILabel *)headPlaceholder {
    
    if (!_headPlaceholder) {
        _headPlaceholder = [[UILabel alloc] init];
        _headPlaceholder.font = [UIFont systemFontOfSize:AUTO_MARGIN(13)];
        _headPlaceholder.text = self.placeholder;
        _headPlaceholder.alpha = 0.0;
    }
    return _headPlaceholder;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.lineColor;
    }
    return _bottomLine;
}

@end
