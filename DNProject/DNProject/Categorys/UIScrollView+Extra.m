//
//  UIScrollView+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIScrollView+Extra.h"
#import <objc/runtime.h>

@interface DNEmptyView ()

@property (nonatomic, strong) UILabel     * tipsLabel;
@property (nonatomic, strong) UIButton    * reloadButton;
@property (nonatomic, strong) UIImageView * emptyImage;
@property (nonatomic, strong) UIView      * containerView;
@end

@implementation DNEmptyView

- (instancetype)initImageName:(NSString *)imageName tipStr:(NSString *)tipStr {
    
    self = [super init];
    if (self) {
        
        _logoImageName = imageName;
        
    }
    return self;
}

- (void)addSubviewsForSuper {
    
    self.containerView = [[UIView alloc] init];
    
    self.emptyImage = [[UIImageView alloc] init];
    
    self.tipsLabel = [[UILabel alloc] init];
    
    self.reloadButton  = [[UIButton alloc] init];
    [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.emptyImage];
    [self.containerView addSubview:self.reloadButton];
    [self.containerView addSubview:self.tipsLabel];
}

- (void)addConstraintsForSuper {
    
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.mas_equalTo(self);
    }];
    
    [self.emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.containerView.mas_top).inset(AUTO_MARGIN(12));
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.emptyImage.mas_bottom).inset(AUTO_MARGIN(8));
        make.left.right.mas_equalTo(self.containerView).inset(AUTO_MARGIN(12));
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).inset(AUTO_MARGIN(8));
        make.left.right.bottom.mas_equalTo(self.containerView).inset(AUTO_MARGIN(12));
    }];
}

@end

@implementation UIScrollView (Extra)

static NSString *headerRefresHandlerKey = @"refresHandlerKey";
static NSString *footerRefresHandlerKey = @"refresHandlerKey";

- (void)dn_refreshHeader:(RefresHandler)handler {
    
    objc_setAssociatedObject(self, &headerRefresHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader:)];
    header.stateLabel.textColor = UIColor.cyanColor;
    header.lastUpdatedTimeLabel.textColor = UIColor.cyanColor;
    [header setValue:UIColor.cyanColor forKeyPath:@"_loadingView.color"];
    header.automaticallyChangeAlpha = YES;
    self.mj_header = header;
}

- (void)refreshHeader:(MJRefreshNormalHeader *)header {
    
    RefresHandler refreshHandler = (RefresHandler)objc_getAssociatedObject(self, &headerRefresHandlerKey);
    if (refreshHandler) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [header endRefreshing];
            refreshHandler();
        });
    }
}

- (void)dn_refreshFooter:(RefresHandler)handler {
    
    objc_setAssociatedObject(self, &footerRefresHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter:)];
    footer.stateLabel.textColor = UIColor.cyanColor;
    [footer setValue:UIColor.cyanColor forKeyPath:@"_loadingView.color"];
    footer.automaticallyChangeAlpha = YES;
    self.mj_footer = footer;
}

- (void)refreshFooter:(MJRefreshBackNormalFooter *)footer {
    
    RefresHandler refreshHandler = (RefresHandler)objc_getAssociatedObject(self, &footerRefresHandlerKey);
    if (refreshHandler) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [footer endRefreshing];
            refreshHandler();
        });
    }
}

@end
