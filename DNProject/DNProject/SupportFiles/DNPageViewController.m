//
//  DNPageViewController.m
//  DNProject
//
//  Created by zjs on 2019/3/7.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNPageViewController.h"
#import "PageTestViewController.h"
#import "UIViewController+Extra.h"
#import "UIView+Extra.h"


#define kTopBarHeight           UIApplication.sharedApplication.statusBarFrame.size.height
#define StopHeight              (264 - kTopBarHeight - 44 - 45)


@interface DNPageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIViewController *cuurentVc;

@property (nonatomic, strong) UISegmentedControl *segmentView;

@property (nonatomic, assign) CGFloat headerView_H;

@property (nonatomic,   copy) NSArray *vcArray;

@end

@implementation DNPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.title = @"个人中心";
    
    [self initializationSubviews];
    // Do any additional setup after loading the view.
}

- (void)initializationSubviews {
    
    [self configBottomScrollView];
    
    self.headerView_H = 264;
    
    PageTestViewController *first = [[PageTestViewController alloc] init];
    first.view.backgroundColor = UIColor.redColor;
    
    PageTestViewController *second = [[PageTestViewController alloc] init];
    second.view.backgroundColor = UIColor.cyanColor;
    
    NSArray *vcArray = @[first, second];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_W * vcArray.count, 0);
    
    for (int i = 0; i < vcArray.count; i++) {
        
        UIViewController *vc = vcArray[i];
        vc.view.frame = CGRectMake(SCREEN_W * i, 0, SCREEN_W, SCREEN_H);
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [self.mainScrollView addSubview:vc.view];
        
        for (UIView *view in vc.view.subviews) {
            
            if ([view isKindOfClass:[UITableView class]] ||
                [view isKindOfClass:[UIScrollView class]] ||
                [view isKindOfClass:[UICollectionView class]] ) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                vc.rootScrollView = scrollView;
                
                if ([view isKindOfClass:[UITableView class]]) {
                    
                    UITableView *tableView = (UITableView *)view;
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.headerView_H - kTopBarHeight + 45)];
                    tableView.tableHeaderView = view;
                    
                } else if ([view isKindOfClass:[UIScrollView class]]) {
                    
                }
                [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            }
        }
    }
    
    self.headerView = [self getHeaderViewWithImageName:@"name"
                                            titleArray:@[@"我的帖子", @"设置"]
                                                height:self.headerView_H];
    [self.view addSubview:self.headerView];
}

#pragma mark  观察者模式
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        UITableView *tableView = object;
        
        if (offset <= (StopHeight) && offset >= 0) {
            self.headerView.dn_y = -offset;
            self.headerView.dn_height = self.headerView_H;
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y != tableView.contentOffset.y) {
                    vc.rootScrollView.contentOffset = tableView.contentOffset;
                }
            }
        } else if(offset > StopHeight) { // 悬停
            self.headerView.dn_y = - StopHeight;
            self.headerView.dn_height =  self.headerView_H;
            
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y < StopHeight) {
                    vc.rootScrollView.contentOffset = CGPointMake(vc.rootScrollView.contentOffset.x, StopHeight);
                }
            }
        } else if (offset < 0) {
            self.headerView.dn_y = 0;
            self.headerView.dn_height = self.headerView_H - offset;
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y != tableView.contentOffset.y) {
                    vc.rootScrollView.contentOffset = tableView.contentOffset;
                }
            }
        }
    }
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width);
    self.cuurentVc = self.vcArray[index];
    self.segmentView.selectedSegmentIndex = index;
}

#pragma mark  绘制headerView
- (UIView *)getHeaderViewWithImageName:(NSString *)imageName titleArray:(NSArray<NSString *> *)aTitleArray height:(CGFloat)aHeight{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, aHeight)];
    view.backgroundColor = UIColor.orangeColor;
    
    UIImageView *imageView   = [[UIImageView alloc] init];
    imageView.clipsToBounds          = false;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = true;
    [view addSubview:imageView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updataHeaderImage:)];
//    [imageView addGestureRecognizer:tap];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
        make.width.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    
    imageView.layer.cornerRadius  = AUTO_MARGIN(50);
    imageView.layer.masksToBounds = true;
    imageView.layer.borderWidth   = 1;
    imageView.layer.borderColor   = UIColor.orangeColor.CGColor;
    
    
    UISegmentedControl *segmentView = [[UISegmentedControl alloc] initWithItems:aTitleArray];
    segmentView.backgroundColor = UIColor.whiteColor;
    segmentView.tintColor       = UIColor.clearColor;
    segmentView.selectedSegmentIndex = 0;
    NSDictionary *normalAttribute = @{NSForegroundColorAttributeName:UIColor.lightGrayColor,
                                      NSFontAttributeName:[UIFont systemFontOfSize:15]
                                      };
    
    NSDictionary *selectAttribute = @{NSForegroundColorAttributeName:UIColor.orangeColor,
                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                      };
    [segmentView setTitleTextAttributes:normalAttribute forState:UIControlStateNormal];
    [segmentView setTitleTextAttributes:selectAttribute forState:UIControlStateSelected];
    
    [segmentView addTarget:self action:@selector(segmentIndexChange:) forControlEvents:UIControlEventValueChanged];
    
    [view addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(view);
        make.height.mas_equalTo(45);
    }];
    self.segmentView = segmentView;
    
    return view;
}

- (void)segmentIndexChange:(UISegmentedControl *)sender {

    self.mainScrollView.contentOffset = CGPointMake(SCREEN_W * sender.selectedSegmentIndex, 0);
    self.cuurentVc = self.vcArray[sender.selectedSegmentIndex];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

#pragma mark  配置最底层ScrollView
- (void)configBottomScrollView {
    self.mainScrollView                                = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.mainScrollView.delegate                       = self;
    self.mainScrollView.pagingEnabled                  = YES;
    self.mainScrollView.bounces                        = NO;
    self.mainScrollView.backgroundColor                = UIColor.whiteColor;
    self.mainScrollView.showsVerticalScrollIndicator   = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    if (@available(iOS 11.0, *)) {
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end
