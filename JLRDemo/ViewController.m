//
//  ViewController.m
//  JLRDemo
//
//  Created by 余豪 on 16/7/6.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 200, 50);
    btn.center = self.view.center;
    [btn setTitle:@"Common Push" forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame)+30, 200, 50);
    [btn1 setTitle:@"StoryBoard Push" forState:UIControlStateNormal];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn1];
}

-(void)btnClick:(UIButton *) sender{
    if (sender.tag == 0) {
        NSString *customURL = @"TESTDEMO://NaviPush/SecondViewController?userId=99999&age=18";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }else{
        NSString *customURL = @"TESTDEMO://StoryBoardPush?sbname=Main&bundleid=SBVC";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
