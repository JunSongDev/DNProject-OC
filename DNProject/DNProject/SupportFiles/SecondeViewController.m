//
//  SecondeViewController.m
//  DNProject
//
//  Created by zjs on 2019/2/12.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "SecondeViewController.h"

@interface SecondeViewController ()

@end

@implementation SecondeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"哈哈哈哈";
    self.view.backgroundColor = UIColor.cyanColor;
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"gyjq";
    lb.font = [UIFont systemFontOfSize:30];
    lb.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lb];
    lb.frame = CGRectMake(10, 100, 200, 30);
    
    //方法一
//    CGSize suggestedSize = [lb sizeThatFits:CGSizeMake(200, 30)];
//    lb.frame = CGRectMake(10, 100, suggestedSize.width, suggestedSize.height);
    //方法二
//    [lb sizeToFit];

    //方法三
//    CGSize labelSize = [lb.text sizeWithFont:lb.font
//                           constrainedToSize:CGSizeMake(200.f, MAXFLOAT)
//                               lineBreakMode:NSLineBreakByWordWrapping];
//    lb.frame = CGRectMake(10, 100, labelSize.width, labelSize.height);
//
    //方法四
    CGSize size = [lb.text sizeWithAttributes:@{ NSFontAttributeName: lb.font }];
    lb.frame = CGRectMake(10, 100, size.width, size.height);
    // Do any additional setup after loading the view.
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self previewActionItemsAction:1];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self previewActionItemsAction:2];
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self previewActionItemsAction:3];
    }];
    
    return @[action1,action2,action3];
}

- (void)previewActionItemsAction:(NSInteger)tag {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(operationSelector:)]) {
        
        [self.delegate operationSelector:tag];
    }
}
@end
