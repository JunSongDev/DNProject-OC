//
//  DNDropBoxControl.h
//  DNProject
//
//  Created by zjs on 2019/1/29.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DNDropBoxControlDirection) {
    
    DNDropBoxControlDirectionTop = 0,
//    DNDropBoxControlDirectionLeading,
    DNDropBoxControlDirectionBottom,
//    DNDropBoxControlDirectionTraining
};

@class DNDropBoxControl;
@class DNDropBoxControlCell;
@class DNDropBoxControlModel;

@protocol DNDropBoxControlDelegate <NSObject>

@required;
- (void)didSelectRowAtIndexPathModel:(DNDropBoxControlModel *)model;

@end

@protocol DNDropBoxControlDataSource <NSObject>

@optional;
- (NSString *)titleForHeaderInSection:(NSInteger)section;

@required;
- (NSArray<DNDropBoxControlModel *> *)boxControlTitle:(DNDropBoxControl *)boxControl;

@end

@interface DNDropBoxControl : UIView

@property (nonatomic, weak) id<DNDropBoxControlDelegate>   delegate;
@property (nonatomic, weak) id<DNDropBoxControlDataSource> dataSource;

- (void)showBoxControl;

- (instancetype)initFormView:(UIView *)fromView direction:(DNDropBoxControlDirection)direction NS_DESIGNATED_INITIALIZER;

@end

@interface DNDropBoxControlCell : UITableViewCell

@property (nonatomic, strong) DNDropBoxControlModel *model;

@end

@interface DNDropBoxControlModel : NSObject

@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, copy) NSString * titleStr;
@end

NS_ASSUME_NONNULL_END
