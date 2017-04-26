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
    
    // 内存测试使用
    NSString *testString;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    if (self.navigationController.viewControllers.count % 3 == 0) {
    
        __weak typeof(self) weakSelf = self;
        [[JGNetworkReachability sharedInstance] addStatusObserver:self action:^(JGNetworkReachabilityStatus status) {
            
            testString = [weakSelf.title stringByAppendingString:[[JGNetworkReachability sharedInstance] reachabilityStatusString]];
            CLog(@"%@", testString);
            CLog(@"Observer=>%@ : %@", weakSelf.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
        }];
    }
    else if (self.navigationController.viewControllers.count % 3 == 1) {
        
        [[JGNetworkReachability sharedInstance] addStatusTarget:self selector:@selector(networkStatusChanged)];
    }
    else {
        
        [[JGNetworkReachability sharedInstance] addStatusTarget:self selector:@selector(networkStatusChanged:object:)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setTitle:[NSString stringWithFormat:@"Ctr_%zd", self.navigationController.viewControllers.count]];
    testString = [[NSString alloc] initWithString:self.title];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#warning Block memory test !
    [[JGNetworkReachability sharedInstance] removeStatusObserver:self];
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

- (void)networkStatusChanged {
    
    CLog(@"Selector=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

- (void)networkStatusChanged:(id)sender object:(id)obj {
    
    CLog(@"%@, %@", sender, obj);
    CLog(@"Selector=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

@end
