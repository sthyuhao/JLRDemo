//
//  AppDelegate.m
//  JLRDemo
//
//  Created by 余豪 on 16/7/6.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "AppDelegate.h"
#import "JLRoutes.h"
#import <objc/runtime.h>
#import "NaviViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define IMG(name) [UIImage imageNamed:name]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self jumpRoutes];
    return YES;
}

-(void) jumpRoutes{
    UITabBarController *customTabbarVC = [[UITabBarController alloc] init];
    customTabbarVC.tabBar.tintColor = [UIColor orangeColor];
    [self.window setRootViewController:customTabbarVC];
    
    customTabbarVC.viewControllers = @[
                                       [self viewControllerWithTitle:@"首页" image:IMG(@"icon_home.png") selectImage:IMG(@"icon_home_select.png")  VC:[[UIViewController alloc] init]],
                                       [self viewControllerWithTitle:@"车源" image:IMG(@"icon_cheyuan.png") selectImage:IMG(@"icon_cheyuan_select.png")  VC:[[UIViewController alloc] init]],
                                       [self viewControllerWithTitle:@"客服" image:IMG(@"icon_search.png") selectImage:IMG(@"icon_search_select.png")  VC:[[UIViewController alloc] init]],
                                       [self viewControllerWithTitle:@"我的" image:IMG(@"icon_my.png") selectImage:IMG(@"icon_my_select.png")  VC:[[UIViewController alloc] init]]
                                       ];

//    app启动时资源占用率大，如果不异步执行，openUrl会延迟大约10s才被执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        NSString *customURL = @"TESTDEMO://Tabbar/ViewController/SecondViewController/ThirdViewController/FourViewController";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    });
    
    //Tabbar规则
    [JLRoutes addRoute:@"/Tabbar/:tabVC1/:tabVC2/:tabVC3/:tabVC4" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {

        customTabbarVC.viewControllers = @[
                                           [self viewControllerWithTitle:@"首页" image:IMG(@"icon_home.png") selectImage:IMG(@"icon_home_select.png")  VC:[[NSClassFromString(parameters[@"tabVC1"]) alloc] init]],
                                           [self viewControllerWithTitle:@"车源" image:IMG(@"icon_cheyuan.png") selectImage:IMG(@"icon_cheyuan_select.png")  VC:[[NSClassFromString(parameters[@"tabVC2"]) alloc] init]],
                                           [self viewControllerWithTitle:@"客服" image:IMG(@"icon_search.png") selectImage:IMG(@"icon_search_select.png")  VC:[[NSClassFromString(parameters[@"tabVC3"]) alloc] init]],
                                           [self viewControllerWithTitle:@"我的" image:IMG(@"icon_my.png") selectImage:IMG(@"icon_my_select.png")  VC:[[NSClassFromString(parameters[@"tabVC4"]) alloc] init]]
                                           ];
        return YES;
    }];
    
    //    navigation Push规则
    [JLRoutes addRoute:@"/NaviPush/:controller" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
        UIViewController *currentVc = [self currentViewController];
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        [currentVc.navigationController pushViewController:v animated:YES];
        return YES;
    }];
    
    //    StoryBoard Push规则
    [JLRoutes addRoute:@"/StoryBoardPush" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
        UIViewController *currentVc = [self currentViewController];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:parameters[@"sbname"] bundle:nil];
        UIViewController *v  = [storyboard instantiateViewControllerWithIdentifier:parameters[@"bundleid"]];
        [self paramToVc:v param:parameters];
        [currentVc.navigationController pushViewController:v animated:YES];
        return YES;
    }];
}

-(void)paramToVc:(UIViewController *) v param:(NSDictionary<NSString *,NSString *> *)parameters{
    //        runtime将参数传递至需要跳转的控制器
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList(v.class , &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *param = parameters[key];
        if (param != nil) {
            [v setValue:param forKey:key];
        }
    }
}

-(NaviViewController *) viewControllerWithTitle:(NSString *) title image:(UIImage *)image selectImage:(UIImage *)selectImage VC:(UIViewController *)VC{
    VC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.title = [NSString stringWithFormat:@"%@首页",title];
    VC.tabBarItem.title = title;
    NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:VC];
    return nav;
}

/**
 *          获取当前控制器
 */
-(UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}

//customURL = [NSString stringWithFormat:@"mhc://StoryBoardPush?sbname=Search&bundleid=detail&skuId=%@",newUrlString];

- (NSString *) jlroutesUrlwithSbname:(NSString *) sbname bundleid:(NSString *) bundleid param:(NSString *) param {
    NSString *customURL ;

    customURL = [NSString stringWithFormat:@"mhc://StoryBoardPush?sbname=%@&bundleid=%@",sbname,bundleid];
    if (param !=nil || ![param isEqualToString:@""]) {
        customURL = [NSString stringWithFormat:customURL,param];
    }
    return customURL;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [JLRoutes routeURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
