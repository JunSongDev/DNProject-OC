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
#import "DNPageViewController.h"
#import "DNInputView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, UISearchControllerDelegate, SecondVcDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) DNPageViewController *pageVc;
//数据源
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchList;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSMutableArray *array;
@end

@implementation ViewController

// 通知编译器不要自动生成实例变量,setter和getter
//@dynamic name;

// 关联实例变量_name到属性name上，即属性name生成的实例变量名为_name
@synthesize name = __name;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Project";
    self.view.backgroundColor = UIColor.whiteColor;
    
    DNInputView *userName = [[DNInputView alloc] init];
    userName.placeholder = @"请输入用户名";
    userName.maxLength = 20;
    
    [self.view addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.mas_top).inset(100);
        make.left.right.mas_equalTo(self.view).inset(50);
    }];
    
//    // 创建队列组
//    dispatch_group_t group = dispatch_group_create();
//    // 创建信号量，并且设置值为10
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    for (int i = 0; i < 20; i++) {
//        // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_group_async(group, queue, ^{
//            NSLog(@"%i",i);
//            sleep(2);
//            // 每次发送信号则semaphore会+1，
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
//    [self addSubviewsForSuper];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(jump)];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)jump {
    
    [self.navigationController pushViewController:self.pageVc animated:YES];
}

- (DNPageViewController *)pageVc {
    
    if (!_pageVc) {
        _pageVc = [[DNPageViewController alloc] init];
    }
    return _pageVc;
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
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.delegate = self;
//    self.searchController.searchResultsUpdater = self;
//    //设置UISearchController的显示属性，以下3个属性默认为YES
//    //搜索时，背景变暗色
//    self.searchController.dimsBackgroundDuringPresentation = YES;
//    //搜索时，背景变模糊
//    self.searchController.obscuresBackgroundDuringPresentation = YES;
//    //隐藏导航栏
//    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view);
    }];
    
    /*
     
     delegate:
        代理，首先是一种协议，想要响应代理的方法必须遵守且实现这个协议
     NSNotication:
        通知，一对多，由通知中心发出一个通知，多个对象可以接收并作出对应的响应
     KVO
        观察者模式，对某个值或某个对象的变化进行监听，当改变时作出对应的处理
        当第一次观察某个对象时，runtime 会创建一个继承与被观察类的子类，在这个子类中，会重写被观察的 key，然后将对象的 isa 指针指向子类，所以对象就成了新建对象的实例，在被重写的方法中添加了调用通知观察者的方法，然后当一个属性变化时，就会触发 setter 方法，但是这个方法被重写了，内部添加了发送通知的机制，从而激活键值通知机制，此外新的子类还重写了 dealloc 方法释放资源
     */
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
                       [NSURL URLWithString:@"https://www.baidu.com"],
                       [UIImage imageNamed:@"test"]];
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
