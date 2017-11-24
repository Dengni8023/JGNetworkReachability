//
//  JGNetworkReachabilityDemo.m
//  JGNetworkReachabilityDemo
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGNetworkReachabilityDemo.h"
#import "JGNetworkReachability.h"
#import "JGSourceBase.h"

@interface JGNetworkReachabilityDemo () {
    
    NSString *titleString;
}

@end

@implementation JGNetworkReachabilityDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGEnableLogWithMode(JGLogModeFile);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *tips = [[UILabel alloc] init];
    tips.textColor = [UIColor blackColor];
    tips.text = @"点击跳转新页面，测试网络监听";
    [self.view addSubview:tips];
    
    tips.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:tips attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:tips attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0].active = YES;
    
    if (self.navigationController.viewControllers.count % 3 == 0) {
        
        JGWeak(self);
        [[JGNetworkReachability sharedInstance] addObserver:self action:^(JGNetworkReachabilityStatus status) {
            
            JGStrong(self);
            titleString = [self.title stringByAppendingString:[[JGNetworkReachability sharedInstance] reachabilityStatusString]];
            JGLog(@"%@", titleString);
            JGLog(@"Observer=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
        }];
    }
    else if (self.navigationController.viewControllers.count % 3 == 1) {
        
        [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged)];
    }
    else {
        
        [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:object:)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setTitle:[NSString stringWithFormat:@"Ctr_%zd", self.navigationController.viewControllers.count]];
    titleString = [[NSString alloc] initWithString:self.title];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#warning Block memory test !
    [[JGNetworkReachability sharedInstance] removeActionWithObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    JGLog();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    JGLog(@"Touch=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    
    JGNetworkReachabilityDemo *vcT = [[JGNetworkReachabilityDemo alloc] init];
    [self.navigationController pushViewController:vcT animated:YES];
}

- (void)networkStatusChanged {
    
    JGLog(@"Selector=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

- (void)networkStatusChanged:(id)sender object:(id)obj {
    
    JGLog(@"%@, %@", sender, obj);
    JGLog(@"Selector=>%@ : %@", self.title, [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
}

@end
