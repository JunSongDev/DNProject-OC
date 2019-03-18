//
//  DNTestCollectionViewCell.m
//  DNProject
//
//  Created by zjs on 2019/3/18.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNTestCollectionViewCell.h"

@implementation DNTestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLb = [[UILabel alloc] init];
        self.titleLb.font                = [UIFont systemFontOfSize:15];
        self.titleLb.textAlignment       = NSTextAlignmentCenter;
        self.titleLb.layer.cornerRadius  = 15.f;
        self.titleLb.layer.masksToBounds = YES;
        self.titleLb.layer.borderWidth   = 0.8;
        self.titleLb.layer.borderColor   = UIColor.orangeColor.CGColor;
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
