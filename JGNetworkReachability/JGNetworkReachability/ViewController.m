//
//  ViewController.m
//  JGNetworkReachability
//
//  Created by 梅继高 on 2017/3/3.
//  Copyright © 2017年 Jigao Mei. All rights reserved.
//

#import "ViewController.h"
#import "JGNetworkReachability.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Init : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    
    // 开启监听
    [[JGNetworkReachability sharedInstance] startMonitor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    TestViewController *ctr = [[TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctr];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
