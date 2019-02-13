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
    
    [self.albumData removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        // 遍历相机胶卷,获取大图
        [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getAllPhotsData:)]) {
                
                [self.delegate getAllPhotsData:self.albumData];
            }
        });
    });
}

/**
 @brief 遍历相簿中的全部图片

 @param assetCollection 相簿
 @param original 是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original {
    
    DNPhotoPickerViewModel *model = [[DNPhotoPickerViewModel alloc] init];
    model.albumName = assetCollection.localizedTitle;
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
