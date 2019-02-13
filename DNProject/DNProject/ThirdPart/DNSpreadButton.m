//
//  DNSpreadButton.m
//  DNProject
//
//  Created by zjs on 2019/1/22.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNSpreadButton.h"

@interface DNSpreadButton ()

@property (nonatomic, assign) CGRect  oldFrame;

@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation DNSpreadButton

- (instancetype)init{
    
    self = [super init];
    if(self){
        [self addTarget:self action:@selector(dismissAllButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dismissAllButton {
    
    self.button.selected = false;
    
    for (UIView *item in self.subviews) {
        
        item.frame = self.button.bounds;
        [item removeFromSuperview];
    }
    [self removeFromSuperview];
    [self.bgView addSubview:self];
    self.frame = self.oldFrame;
    self.button.frame = self.bounds;
    [self.button.layer removeAllAnimations];
}

- (void)spreadAllButton {
    
    [self removeFromSuperview];
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = UIColor.clearColor;
    
    self.button.frame = self.oldFrame;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 11 + i;
        button.backgroundColor = UIColor.orangeColor;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:@"userCenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        button.frame = CGRectMake(self.button.frame.origin.x, self.button.frame.origin.y-(i+1)*(self.button.frame.size.height+10), self.button.frame.size.width, self.button.frame.size.height);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.titleArray[i];
        label.frame = CGRectMake(self.button.frame.origin.x-75, self.button.frame.origin.y-(i+1)*(self.button.frame.size.height+10), 75, self.button.frame.size.height);
        
        [self addSubview:button];
        [self addSubview:label];
    }
}

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.tag >= 11) {
        if (self.buttonAction) {
            self.buttonAction(button.tag);
        }
    } else {
        self.button.selected = !self.button.selected;
        
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_2];
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        
        if (self.button.selected) {
            [self spreadAllButton];
            [self.button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        } else {
            [self dismissAllButton];
        }
    }
}

- (void)layoutSubviews {
    
    //[super layoutSubviews];
    
    [self addSubview:self.button];
    if (self.oldFrame.size.width == 0) {
        self.oldFrame = self.frame;
        self.button.frame = self.bounds;
        self.bgView = self.superview;
    }
}

- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
}

- (void)setImageArray:(NSArray *)imageArray {
    
    _imageArray = imageArray;
}

- (UIButton *)button {
    if (!_button){
        _button = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[[UIImage imageNamed:@"plus_F"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [b setImage:[[UIImage imageNamed:@"plus_F"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            [b setTitle:@"关闭" forState:UIControlStateSelected];
            [b setTitle:@"HH" forState:UIControlStateNormal];
            b.backgroundColor = UIColor.orangeColor;
            b.tag = 10;
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b;
        });
    }
    return _button;
}

@end
