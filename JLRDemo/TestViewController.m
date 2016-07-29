//
//  TestViewController.m
//  JLRDemo
//
//  Created by 余豪 on 16/7/7.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "TestViewController.h"
#import "NaviViewController.h"

@interface TestViewController ()

@end

#define IMG(name) [UIImage imageNamed:name]

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *customURL = @"TESTDEMO://Tabbar/ViewController/SecondViewController/ThirdViewController/FourViewController";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
}


@end
