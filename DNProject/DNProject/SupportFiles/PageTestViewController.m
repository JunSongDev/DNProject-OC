//
//  PageTestViewController.m
//  DNProject
//
//  Created by zjs on 2019/3/7.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "PageTestViewController.h"
#import "DNPageViewController.h"

@interface PageTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializationSubviews];
    // Do any additional setup after loading the view.
}

- (void)initializationSubviews {
    
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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是第 %ld 行", indexPath.row + 1];
    
    return cell;
}

- (void)dealloc {
    
    NSLog(@"%s",__func__);
}

@end
