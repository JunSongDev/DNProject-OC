//
//  DNPhotoPickerCollectionCell.m
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNPhotoPickerCollectionCell.h"
#import "DNImageModel.h"

@interface DNPhotoPickerCollectionCell ()

@property (nonatomic, strong) UIButton    *chooseBtn;
@property (nonatomic, strong) UIImageView *dataImage;

@end

@implementation DNPhotoPickerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializationSubviews];
    }
    return self;
}

- (void)initializationSubviews {
    
    self.dataImage = [[UIImageView alloc] init];
    //self.dataImage.contentMode = UIViewContentModeScaleToFill;
    self.dataImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.dataImage];
    
    [self setupSubviewsConstraints];
}

- (void)setupSubviewsConstraints {
    
    self.dataImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataImage.topAnchor    constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.dataImage.leftAnchor   constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.dataImage.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.dataImage.rightAnchor  constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
}

- (void)setModel:(DNImageModel *)model {
    
    _model = model;
    
    self.dataImage.image = [UIImage imageWithData:model.imageData];
}
@end
