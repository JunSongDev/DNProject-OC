//
//  DNDropBoxControl.m
//  DNProject
//
//  Created by zjs on 2019/1/29.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNDropBoxControl.h"

@interface DNDropBoxControl ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView      *sourceView;
@property (nonatomic, strong) UIButton    *backButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,   copy) NSArray     *dataSourceArr;

@property (nonatomic, assign) DNDropBoxControlDirection direction;
@end

@implementation DNDropBoxControl

#pragma mark -- 初始化
- (instancetype)initFormView:(UIView *)fromView direction:(DNDropBoxControlDirection)direction {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _sourceView = fromView;
        _direction  = direction;
        
        [self addSubviewsForSuper];
        [self addConstraintsForSuper];
    }
    return self;
}

#pragma mark -- 添加控件
- (void)addSubviewsForSuper {
    
    self.backButton = [[UIButton alloc] init];
    self.backButton.backgroundColor = UIColor.clearColor;
    [self.backButton addTarget:self
                        action:@selector(dismissBoxControl)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 45;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    [self.tableView registerClass:[DNDropBoxControlCell class] forCellReuseIdentifier:@"boxControlCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addSubview:self.tableView];
}

#pragma mark -- 添加布局
- (void)addConstraintsForSuper {
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self);
    }];
    
    if (self.direction == DNDropBoxControlDirectionTop) {

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.mas_offset(CGRectGetMidX(self.sourceView.frame));
            make.bottom.mas_equalTo(self.mas_top).mas_offset(- CGRectGetMaxY(self.sourceView.frame) - 5);
            make.width.mas_offset(SCREEN_W*0.5);
            make.height.mas_offset(SCREEN_W*0.75);
        }];

    } else {

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.mas_offset(CGRectGetMidX(self.sourceView.frame));
            make.top.mas_equalTo(self.mas_top).mas_offset(CGRectGetMaxY(self.sourceView.frame) + 5 + 88);
            make.width.mas_offset(SCREEN_W*0.5);
            make.height.mas_offset(SCREEN_W*0.75);
        }];
    }
}

#pragma mark -- Event
- (void)showBoxControl {
    
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.4];
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (void)dismissBoxControl {
    
    [self removeFromSuperview];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNDropBoxControlModel *model;
    if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
        
        model = self.dataSourceArr[indexPath.section][indexPath.row];
    }
    else {
        model = self.dataSourceArr[indexPath.row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathModel:)]) {
        
        [self.delegate didSelectRowAtIndexPathModel:model];
        
        [self dismissBoxControl];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
        
        return self.dataSourceArr.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
        
        return [self.dataSourceArr[section] count];
    }
    else {
        return self.dataSourceArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNDropBoxControlModel *model;
    if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
        
        model = self.dataSourceArr[indexPath.section][indexPath.row];
    }
    else {
        model = self.dataSourceArr[indexPath.row];
    }
    DNDropBoxControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boxControlCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[DNDropBoxControlCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"boxControlCell"];
    }
    cell.model = model;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
        
        return [self.dataSource titleForHeaderInSection:section];
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

#pragma mark -- Setter
// TOOD:  数据刷新，tableView 高度设置
- (void)setDataSource:(id<DNDropBoxControlDataSource>)dataSource {
    
    _dataSource = dataSource;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(boxControlTitle:)]) {
        
        self.dataSourceArr = [self.dataSource boxControlTitle:self];
        
        CGFloat tableViewH = 0.0;
        
        if ([self.dataSourceArr[0] isKindOfClass:[NSArray class]]) {
            
            tableViewH = 250;
        } else {
            tableViewH = self.dataSourceArr.count < 5 ? 50 * self.dataSourceArr.count:250;
        }
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_offset(tableViewH);
        }];
        // 更新布局
        [self updateConstraints];
        // 刷新数据源
        [self.tableView reloadData];
    } else {
        NSAssert(self.dataSource, @"数据源为空");
    }
}

#pragma mark -- Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}

@end

@implementation DNDropBoxControlCell

- (void)setModel:(DNDropBoxControlModel *)model {
    
    _model = model;
    
    self.textLabel.text  = model.titleStr;
    self.imageView.image = [UIImage imageNamed:model.imageName];
}

@end


@implementation DNDropBoxControlModel


@end
