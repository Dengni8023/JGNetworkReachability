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

@interface TestViewController () {
    
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    __weak typeof(self) weakSelf = self;
    [[JGNetworkReachability sharedInstance] addStatusObserver:self action:^(JGNetworkReachabilityStatus status) {
        
        CLog(@"Observer=>%@ : %@", weakSelf.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    }];
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
    
    CLog();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CLog(@"Touch=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    
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

@end
