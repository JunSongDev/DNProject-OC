//
//  DNNavTitleView.m
//  DNProject
//
//  Created by zjs on 2019/1/18.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNNavTitleView.h"

@interface DNNavTitleView ()

@property (nonatomic, strong) UILabel     *title_label;
@property (nonatomic, strong) UIImageView *title_image;
@end

@implementation DNNavTitleView

- (instancetype)init {

    self = [super init];
    if (self) {
        
        [self addSubviewsForSuper];
        [self addConstraintsForSuper];
        
        [self addTarget:self action:@selector(touchTitleView) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addSubviewsForSuper {
    
    self.title_label = [[UILabel alloc] init];
    
    self.title_image = [[UIImageView alloc] init];
    self.title_image.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.title_label];
    [self addSubview:self.title_image];
}

- (void)addConstraintsForSuper {
    
    self.title_image.translatesAutoresizingMaskIntoConstraints = NO;
    [self.title_image.widthAnchor constraintEqualToConstant:11].active = YES;
    [self.title_image.heightAnchor constraintEqualToConstant:10].active = YES;
    [self.title_image.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.title_image.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-5].active = YES;
    
    self.title_label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.title_label.topAnchor constraintEqualToAnchor:self.topAnchor constant:5].active = YES;
    [self.title_label.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:5].active = YES;
    [self.title_label.rightAnchor constraintEqualToAnchor:self.title_image.leftAnchor constant:-5].active = YES;
    [self.title_label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5].active = YES;
}

- (void)touchTitleView {
    
    self.touchUp = !self.touchUp;
    
    if (self.isTouchUp) {
        
        self.title_image.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.title_image.transform = CGAffineTransformIdentity;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navTitleViewTouchInside)]) {
        
        [self.delegate navTitleViewTouchInside];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat fontSize = self.titleFont ? :14;
    self.title_label.font = [UIFont systemFontOfSize:fontSize];
    self.title_label.textColor = self.titleColor ? :UIColor.blackColor;
    
    NSString *imageName = self.imageName ? :@"downBlackImage";
    self.title_image.image = [UIImage imageNamed:imageName];
}

#pragma mark -- 获取文本字体大小
- (CGSize)dn_getTextSize:(NSString *)contentStr {
    
    NSMutableDictionary * attributeDict = [[NSMutableDictionary alloc]init];
    
    attributeDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    attributeDict[NSParagraphStyleAttributeName] = paragraphStyle;
    
    // 计算文本的 rect
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 34)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributeDict
                                           context:nil];
    return rect.size;
}

- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    
    self.title_label.text = titleStr;
    
    double version = UIDevice.currentDevice.systemVersion.doubleValue;
    if (version < 11.0) {
        
        CGFloat titleViewW = [self dn_getTextSize:titleStr].width + 26;
        self.frame = CGRectMake(SCREEN_W/2.0 - titleViewW/2.0, 5, titleViewW, 34);
    }
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    
    [self layoutSubviews];
}

- (void)setTitleFont:(CGFloat)titleFont {
    
    _titleFont = titleFont;
    
    [self layoutSubviews];
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    
    [self layoutSubviews];
}

@end
