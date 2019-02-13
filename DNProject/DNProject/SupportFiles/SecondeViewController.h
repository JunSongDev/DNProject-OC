//
//  SecondeViewController.h
//  DNProject
//
//  Created by zjs on 2019/2/12.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SecondVcDelegate <NSObject>

@required;
- (void)operationSelector:(NSInteger)tag;

@end

@interface SecondeViewController : UIViewController

@property (nonatomic, weak) id<SecondVcDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
