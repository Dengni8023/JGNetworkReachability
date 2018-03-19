//
//  ReachabilityStatusViewController.m
//  JGNetworkReachabilityDemo
//
//  Created by Mei Jigao on 2018/3/19.
//  Copyright © 2018年 MeiJigao. All rights reserved.
//

#import "ReachabilityStatusViewController.h"
#import <JGSourceBase/JGSourceBase.h>
#import <JGNetworkReachability/JGNetworkReachability.h>

@interface ReachabilityStatusViewController ()

@end

@implementation ReachabilityStatusViewController


#pragma mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initDatas];
    }
    return self;
}

- (void)initDatas {
    
}

- (void)dealloc {
    
    JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGEnableLogWithMode(JGLogModeFunc);
    self.title = NSStringFromClass([self class]);
    
    self.clearsSelectionOnViewWillAppear = NO;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = 44;
    self.tableView.sectionHeaderHeight = 48;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JGReuseIdentifier(UITableViewCell)];
    
    [[JGNetworkReachability sharedInstance] startMonitor];
    switch (_observerType) {
        case StatusObserverTypeBlock: {
            
            // TODO: 注意block内部循环引用内存问题
            JGWeak(self);
            self.title = @"Observer Block";
            [[JGNetworkReachability sharedInstance] addObserver:self action:^(JGNetworkReachabilityStatus status) {
                
                JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
                
                JGStrong(self);
                [self.tableView reloadData];
            }];
        }
            break;
            
        case StatusObserverTypeSelector: {
            
            self.title = @"Observer Selector";
            [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged)];
        }
            break;
            
        case StatusObserverTypeSelectorValue1: {
            
            self.title = @"Observer Selector Value 1";
            [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:)];
        }
            break;
            
        case StatusObserverTypeSelectorValue2: {
            
            self.title = @"Observer Selector Value 2";
            [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:value2:)];
        }
            break;
            
        case StatusObserverTypeSelectorValue3: {
            
            self.title = @"Observer Selector Value 3";
            [[JGNetworkReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:value2:value3:)];
        }
            break;
            
        case StatusObserverTypeNotification: {
            
            self.title = @"Observer Notification";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChangedNotification:) name:JGNetworkReachabilityStatusChangedNotification object:nil];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGReuseIdentifier(UITableViewCell) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action
- (void)networkStatusChanged {
    
    JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 {
    
    JGLog(@"%@", value1);
    JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 value2:(id)value2 {
    
    JGLog(@"%@, %@", value1, value2);
    JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 value2:(id)value2 value3:(id)value3 {
    
    JGLog(@"%@, %@, %@", value1, value2, value3);
    JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

#pragma mark - Notification
- (void)networkStatusChangedNotification:(NSNotification *)notification {
    
    JGLog(@"%@, %@", notification.object, notification.userInfo);
    JGLog(@"Status : %@", [[JGNetworkReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

#pragma mark - End


@end
