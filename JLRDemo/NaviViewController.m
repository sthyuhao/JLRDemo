//
//  NaviViewController.m
//  JLRDemo
//
//  Created by 余豪 on 16/7/12.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "NaviViewController.h"

@interface NaviViewController ()

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 初始化一个返回按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        // 为返回按钮设置图片样式
//        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [button setTitle:@"bilegou" forState:UIControlStateNormal];
        // 设置返回按钮触发的事件
        [button addTarget:self action:@selector(naviClickBack) forControlEvents:UIControlEventTouchUpInside];
        // 初始化一个BarButtonItem，并将其设置为返回的按钮的样式
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        negativeSpacer.width = -15;
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButton, nil];
    }
    [super pushViewController:viewController animated:animated];
    viewController.hidesBottomBarWhenPushed = NO;
}

-(void) naviClickBack{
    [self popViewControllerAnimated:YES];
}

@end
