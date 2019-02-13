//
//  DNPhotoManager.h
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DNPhotoManagerDelegate <NSObject>

- (void)getAllPhotsData:(NSArray *)dataArr;

@end

@interface DNPhotoManager : NSObject

@property (nonatomic, weak) id<DNPhotoManagerDelegate> delegate;

+ (instancetype)defaultManager;

- (void)getCompressImages;
@end

NS_ASSUME_NONNULL_END
