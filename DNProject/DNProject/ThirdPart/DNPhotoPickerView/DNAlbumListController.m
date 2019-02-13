//
//  DNAlbumListController.m
//  DNProject
//
//  Created by zjs on 2019/2/13.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNAlbumListController.h"
#import "DNPhotoPickerController.h"
#import "DNAlbumLisetCell.h"
#import "DNPhotoManager.h"

@interface DNAlbumListController ()<UITableViewDelegate, UITableViewDataSource, DNPhotoManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *allAlbumArr;
@end

@implementation DNAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [[DNPhotoManager defaultManager] getCompressImages];
    [DNPhotoManager defaultManager].delegate = self;
    
    [self initializationSubviews];
    [self setupnavigationItem];
    // Do any additional setup after loading the view.
}

- (void)initializationSubviews {
    
    [self.view addSubview:self.tableView];
    
    [self setupSubviewsConstraints];
}

- (void)setupSubviewsConstraints {
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.topAnchor    constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leftAnchor   constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.rightAnchor  constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (void)setupnavigationItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissVc)];
}

- (void)dismissVc {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UIScreen.mainScreen.bounds.size.width*0.15 + 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allAlbumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNPhotoPickerViewModel *model = self.allAlbumArr[indexPath.row];
    DNAlbumLisetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNAlbumLisetCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[DNAlbumLisetCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"DNAlbumLisetCell"];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNPhotoPickerViewModel *model = self.allAlbumArr[indexPath.row];
    DNPhotoPickerController *pickerVc = [[DNPhotoPickerController alloc] init];
    pickerVc.model = model;
    [self.navigationController pushViewController:pickerVc animated:YES];
}

#pragma mark -- Other Delegate
- (void)getAllPhotsData:(NSArray *)dataArr {
    
    self.allAlbumArr = dataArr;
    
    [self.tableView reloadData];
    
    DNPhotoPickerViewModel *model = self.allAlbumArr[0];
    DNPhotoPickerController *pickerVc = [[DNPhotoPickerController alloc] init];
    pickerVc.model = model;
    [self.navigationController pushViewController:pickerVc animated:NO];
    
    NSLog(@"%ld", dataArr.count);
}

#pragma mark -- Setter

#pragma mark -- Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 45;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        [_tableView registerClass:[DNAlbumLisetCell class] forCellReuseIdentifier:@"DNAlbumLisetCell"];
        
    }
    return _tableView;
}

- (void)dealloc {
    
    NSLog(@"%@ ---- dealloc", NSStringFromClass([self class]));
}

@end
