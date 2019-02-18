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
//    self.dataImage.contentMode = UIViewContentModeCenter;
    self.dataImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.chooseBtn = [[UIButton alloc] init];
    [self.chooseBtn setImage:[UIImage imageNamed:@"choosePhoto@2x"] forState:UIControlStateNormal];
    self.chooseBtn.layer.cornerRadius  = UIScreen.mainScreen.bounds.size.width*0.03;
    self.chooseBtn.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.dataImage];
    [self.contentView addSubview:self.chooseBtn];
    
    [self setupSubviewsConstraints];
}

- (void)setupSubviewsConstraints {
    
    self.dataImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataImage.topAnchor    constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.dataImage.leftAnchor   constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.dataImage.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.dataImage.rightAnchor  constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    
    self.chooseBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.chooseBtn.topAnchor    constraintEqualToAnchor:self.dataImage.topAnchor constant:4].active = YES;
    [self.chooseBtn.rightAnchor  constraintEqualToAnchor:self.dataImage.rightAnchor constant:-4].active = YES;
    [self.chooseBtn.widthAnchor  constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width*0.06].active = YES;
    [self.chooseBtn.heightAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width*0.06].active = YES;
}

- (void)setModel:(DNImageModel *)model {
    
    _model = model;
    
    self.dataImage.image = [UIImage imageWithData:model.imageData];
}
@end
