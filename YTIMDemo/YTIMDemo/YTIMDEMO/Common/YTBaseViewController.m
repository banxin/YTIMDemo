//
//  YTBaseViewController.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTBaseViewController.h"

@interface YTBaseViewController ()

@end

@implementation YTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置顶部导航标题栏为不透明，否则在ios7以上系统会挡住下方的页面内容
    self.navigationController.navigationBar.translucent = NO;
}

@end
