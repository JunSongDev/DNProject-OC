//
//  DNPhotoPickerController.m
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNPhotoPickerController.h"
#import "DNAlbumListController.h"
#import "DNPhotoPickerCollectionCell.h"
#import "DNPhotoPickerViewModel.h"

@interface DNPhotoPickerController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *photoArr;
@end

@implementation DNPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    [self initializationSubviews];
    // Do any additional setup after loading the view.
}

- (void)initializationSubviews {
    
    [self.view addSubview:self.collectionView];
    
    [self setupSubviewsConstraints];
    
    [self setupnavigationItem];
}

- (void)setupnavigationItem {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(leftClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissVc)];
}

- (void)setupSubviewsConstraints {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView.topAnchor    constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.collectionView.leftAnchor   constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.collectionView.rightAnchor  constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (void)leftClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissVc {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UICollectionViewDelegate

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DNImageModel *model = self.photoArr[indexPath.row];
    DNPhotoPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoPickerViewCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark -- Setter
- (void)setModel:(DNPhotoPickerViewModel *)model {
    
    _model = model;
    
    self.title    = model.albumName;
    self.photoArr = model.albumData;
    
    [self.collectionView reloadData];
}

#pragma mark -- Getter
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((UIScreen.mainScreen.bounds.size.width - 10) / 3,
                                         (UIScreen.mainScreen.bounds.size.width - 10) / 3);
        flowLayout.minimumLineSpacing = 5.f;
        flowLayout.minimumInteritemSpacing = 5.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        [_collectionView registerClass:[DNPhotoPickerCollectionCell class] forCellWithReuseIdentifier:@"photoPickerViewCell"];
    }
    return _collectionView;
}

- (void)dealloc {
    
    NSLog(@"%@ ---- dealloc", NSStringFromClass([self class]));
}
@end
