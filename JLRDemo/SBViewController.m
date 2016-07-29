//
//  SBViewController.m
//  JLRDemo
//
//  Created by 余豪 on 16/7/8.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "SBViewController.h"
#import "MHCB2BWebView.h"

@interface SBViewController ()<MHCB2BWebViewDelegate>{
    MHCB2BWebView *my;
}

@end

@implementation SBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 123;
    
    my = [[MHCB2BWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [my loadURLString:@"http://www.baidu.com"];
    my.delegate = self;
    [self.view addSubview:my];
    
    // 初始化一个返回按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    // 为返回按钮设置图片样式
    [button setTitle:@"hahaha" forState:UIControlStateNormal];
    // 设置返回按钮触发的事件
    [button addTarget:self action:@selector(naviClickBack) forControlEvents:UIControlEventTouchUpInside];
    // 初始化一个BarButtonItem，并将其设置为返回的按钮的样式
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButton, nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

-(void) naviClickBack{
    if(my.wkWebView.canGoBack){
        [my.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)wkwebView:(MHCB2BWebView *)webview title:(NSString *)title{
    self.title = title;
}

- (void)wkwebViewDidStartLoad:(MHCB2BWebView *)webview{
    NSLog(@"页面开始加载");
}
- (void)wkwebView:(MHCB2BWebView *)webview shouldStartLoadWithURL:(NSURL *)URL{
    NSLog(@"截取到URL：%@",URL);
}
- (void)wkwebView:(MHCB2BWebView *)webview didFinishLoadingURL:(NSURL *)URL{
    NSLog(@"页面加载完成");
}
- (void)wkwebView:(MHCB2BWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error{
    NSLog(@"加载出现错误");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
