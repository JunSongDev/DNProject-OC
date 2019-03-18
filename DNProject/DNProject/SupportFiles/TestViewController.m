//
//  TestViewController.m
//  DNProject
//
//  Created by zjs on 2019/3/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "TestViewController.h"
#import "DNCollectionViewFlowLayout.h"
#import "DNTestCollectionViewCell.h"
#import "NSString+Extra.h"

@interface TestViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *array;
@end

@implementation TestViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//
//        NSLog(@"%s", __func__);
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//
//        NSLog(@"%s", __func__);
//    }
//    return self;
//}
//
//- (void)loadView {
//
//    NSLog(@"%s", __func__);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    
    self.array = @[@"你是谁", @"哈哈哈哈哈啊哈哈", @"那就这样吧", @"开始了", @"22岁5月8天", @"TestViewController", @"viewDidLoad"];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DNTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DNTestCollectionViewCell" forIndexPath:indexPath];
    cell.titleLb.text = self.array[indexPath.row];
    return cell;
}

//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)viewWillLayoutSubviews {
//
//    [super viewWillLayoutSubviews];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)viewDidLayoutSubviews {
//
//    [super viewDidLayoutSubviews];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//
//    [super viewDidAppear:animated];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//
//    [super viewDidDisappear:animated];
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)didReceiveMemoryWarning {
//
//    NSLog(@"%s", __func__);
//}
//
//- (void)dealloc {
//
//    NSLog(@"%s", __func__);
//}

//- (void)

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        DNCollectionViewFlowLayout *flowlayout = [[DNCollectionViewFlowLayout alloc] init];
        flowlayout.itemHeight = 30;
        flowlayout.itemSpace  = 8;
        flowlayout.lineSpace  = 8;
        flowlayout.sectionInsets = UIEdgeInsetsMake(8, 8, 0, 8);
        [flowlayout configItemWidth:^CGFloat(NSIndexPath * _Nonnull indexPath, CGFloat height) {
            
            @autoreleasepool {
              
                NSString *string = self.array[indexPath.row];
                return [string dn_getTextWidth:[UIFont systemFontOfSize:15]
                                        height:30] + 20;
            };
        }];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowlayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        [_collectionView registerClass:[DNTestCollectionViewCell class] forCellWithReuseIdentifier:@"DNTestCollectionViewCell"];
    }
    return _collectionView;
}

@end
