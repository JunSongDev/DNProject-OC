//
//  DNAlbumLisetCell.m
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNAlbumLisetCell.h"
#import "DNPhotoPickerViewModel.h"
#import "DNImageModel.h"

@interface DNAlbumLisetCell ()

@property (nonatomic, strong) UIImageView *albumImage;
@property (nonatomic, strong) UILabel     *albumDesc;
@end

@implementation DNAlbumLisetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializationSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

- (void)initializationSubviews {
    
    self.albumImage = [[UIImageView alloc] init];
    self.albumImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.albumDesc  = [[UILabel alloc] init];
    self.albumDesc.textColor = UIColor.darkGrayColor;
    self.albumDesc.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:self.albumImage];
    [self.contentView addSubview:self.albumDesc];
}

- (void)setupSubviewsConstraints {
    
    self.albumImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.albumImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5].active = YES;
    [self.albumImage.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:5].active = YES;
    [self.albumImage.widthAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width*0.15].active = YES;
    [self.albumImage.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-5].active = YES;
    
    self.albumDesc.translatesAutoresizingMaskIntoConstraints = NO;
    [self.albumDesc.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.albumDesc.leftAnchor constraintEqualToAnchor:self.albumImage.rightAnchor constant:5].active = YES;
    [self.albumDesc.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-5].active = YES;
}

- (void)setModel:(DNPhotoPickerViewModel *)model {
    
    _model = model;
    if (model.albumData.count != 0) {
        
        DNImageModel *imageModel = model.albumData[0];
        self.albumImage.image = [UIImage imageWithData:imageModel.imageData];
    } else {
        
    }
    self.albumDesc.text   = [NSString stringWithFormat:@"%@ (%ld)", model.albumName, model.albumData.count];
}

@end
