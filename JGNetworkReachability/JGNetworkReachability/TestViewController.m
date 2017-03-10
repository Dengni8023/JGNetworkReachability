//
//  TestViewController.m
//  JGNetworkReachability
//
//  Created by 梅继高 on 2017/3/9.
//  Copyright © 2017年 Jigao Mei. All rights reserved.
//

#import "TestViewController.h"
#import "JGNetworkReachability.h"

#define CLog(format, ...) NSLog((@"%s Line:%zd " format), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)

@interface TestViewController () <JGNetworkReachabilityDelegate> {
    
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityStatusChange:) name:JGNetworkReachabilityDidChangeNotification object:nil];
    if (self.navigationController.viewControllers.count % 2) {
        
        __weak typeof(self) weakSelf = self;
        [[JGNetworkReachability sharedInstance] addObserver:self reachabilityStatusChange:^(JGNetworkReachabilityStatus status) {
            
            NSLog(@"Observer=>%@ : %@", weakSelf.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
        }];
    }
    else {
        
        [[JGNetworkReachability sharedInstance] addDelegate:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setTitle:[NSString stringWithFormat:@"Ctr_%zd", self.navigationController.viewControllers.count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[JGNetworkReachability sharedInstance] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Touch=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    
    TestViewController *ctr = [[TestViewController alloc] init];
    if (self.navigationController) {
        
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else {
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctr];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Notification
- (void)networkReachabilityStatusChange:(NSNotification *)notification {
    
    NSLog(@"Notification=> %@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

#pragma mark - JGNetworkReachabilityDelegate
- (void)networkReachability:(JGNetworkReachability *)networkReachability didChangeStatus:(JGNetworkReachabilityStatus)status {
    
    NSLog(@"Delegate=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

@end
