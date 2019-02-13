//
//  ViewController.m
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "ViewController.h"
#import "SecondeViewController.h"
#import "DNAlbumListController.h"
#import "DNPhotoPickerController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, UISearchControllerDelegate, SecondVcDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;
//数据源
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Project";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addSubviewsForSuper];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)addSubviewsForSuper {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 45;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width,
                                                       44.0);
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        DNLog(@"3D Touch 可用");
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    } else {
        
        DNLog(@"3D Touch 不可用");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DNAlbumListController *second = [[DNAlbumListController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:second];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:second animated:YES];
}

#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程
- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"didDismissSearchController");
    
    NSLog(@"-----%@", NSStringFromCGRect(searchController.searchBar.frame));
}

- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"presentSearchController");
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList = [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark -- SecondVcDelegate
- (void)operationSelector:(NSInteger)tag {
    
    if (tag == 1) {
        
        NSLog(@"------------- 关注");
    } else if (tag == 2) {
        
        NSLog(@"------------- 收藏");
    } else {
        
        NSLog(@"------------- 分享");
        [self showSharePreview];
    }
}

#pragma mark -- UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    SecondeViewController *second = [[SecondeViewController alloc] init];
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    second.preferredContentSize = CGSizeMake(0.0f,500.0f);
    second.delegate = self;
    
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,40);
    previewingContext.sourceRect = rect;
    
    return second;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}
#pragma mark -- 调用系统分享面板
- (void)showSharePreview {
    
    NSArray *array = @[@"哈哈哈",
                       [UIImage imageNamed:@"test"],
                       [NSURL URLWithString:@"https://www.baidu.com"]];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:array
                                                                           applicationActivities:nil];
    //UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
    if (@available(iOS 11.0, *)) {
        activity.excludedActivityTypes = @[UIActivityTypeMessage,
                                           UIActivityTypeMail,
                                           UIActivityTypeOpenInIBooks,
                                           UIActivityTypeMarkupAsPDF];
    }
    // UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
    else if (@available(iOS 9.0, *)) {
        activity.excludedActivityTypes = @[UIActivityTypeMessage,
                                           UIActivityTypeMail,
                                           UIActivityTypeOpenInIBooks];
    } else {
        activity.excludedActivityTypes = @[UIActivityTypeMessage,
                                           UIActivityTypeMail];
    }
    activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,
                                            BOOL completed,
                                            NSArray * _Nullable returnedItems,
                                            NSError * _Nullable activityError) {
        
                                                if (completed) {
                                                    DNLog(@">>>>>success");
                                                } else {
                                                    DNLog(@">>>>>faild");
                                                }
                                            };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        activity.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activity animated:YES completion:nil];
        
    } else {
        [self presentViewController:activity animated:YES completion:nil];
    }
}

#pragma mark -- Getter
- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)searchList {
    
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

@end
