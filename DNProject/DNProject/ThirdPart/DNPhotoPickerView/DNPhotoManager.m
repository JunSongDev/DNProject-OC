//
//  DNPhotoManager.m
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNPhotoManager.h"
#import "DNPhotoPickerViewModel.h"
#import "DNImageModel.h"
#import <UIKit/UIKit.h>

@interface DNPhotoManager ()

@property (nonatomic, strong) NSMutableArray * albumData;
@end

static DNPhotoManager *_manager = nil;

@implementation DNPhotoManager

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc] init];
        }
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

- (void)getCompressImages {
    
    __weak typeof(self) weakself = self;
    
    [self getAlbumAuth:^{
        
        [weakself.albumData removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 获得所有的自定义相簿
            PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            // 遍历所有的自定义相簿
            for (PHAssetCollection *assetCollection in assetCollections) {
                [weakself enumerateAssetsInAssetCollection:assetCollection albumName:assetCollection.localizedTitle original:NO];
            }
            
            // 获得相机胶卷
            PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
            // 遍历相机胶卷,获取大图
            [weakself enumerateAssetsInAssetCollection:cameraRoll albumName:@"相机胶卷" original:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(getAllPhotsData:)]) {
                    
                    [weakself.delegate getAllPhotsData:weakself.albumData];
                }
            });
        });
        
    }];
    
}

- (void)getAlbumAuth:(void(^)(void))completeHandler {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted:
            DNLog(@"因为系统原因, 无法访问相册");
            break;
            
        case PHAuthorizationStatusDenied: {
            
            DNLog(@"用户拒绝");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告"
                                                                message:@"请去-> [设置 - 隐私 - 相机 - 项目名称] 打开访问开关"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"去设置", nil];
            
            [alertView show];
        } break;
            
        case PHAuthorizationStatusAuthorized: {
            
            DNLog(@"用户允许");
            completeHandler();
        } break;
            
        case PHAuthorizationStatusNotDetermined: {
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
               
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    completeHandler();
                    
                } else {
                    
                    DNLog(@"用户拒绝");
                }
            }];
        } break;
    }
}

/**
 @brief 遍历相簿中的全部图片

 @param assetCollection 相簿
 @param original 是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection albumName:(NSString *)albumName original:(BOOL)original {
    
    DNPhotoPickerViewModel *model = [[DNPhotoPickerViewModel alloc] init];
    model.albumName = albumName;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 存储某个相册中的所有图片
    NSMutableArray *array = [NSMutableArray array];
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                     options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeDefault
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result,
                                                                NSDictionary * _Nullable info) {
                                                    
                                                    DNImageModel *imageModel = [[DNImageModel alloc] init];
                                                    imageModel.imageData = UIImagePNGRepresentation(result);
                                                    imageModel.selected = NO;
                                                    [array addObject:imageModel];
                                                }];
    }
    model.albumData = array;
    [self.albumData addObject:model];
}

#pragma mark -- Getter
- (NSMutableArray *)albumData {
    
    if (!_albumData) {
        _albumData = [NSMutableArray array];
    }
    return _albumData;
}
@end
