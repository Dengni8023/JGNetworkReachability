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
    
    JGSCLog(@"<%@: %p>", NSStringFromClass([self class]), self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGSCEnableLogWithMode(JGSCLogModeFunc);
    self.title = NSStringFromClass([self class]);
    
    self.clearsSelectionOnViewWillAppear = YES;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = 44;
    self.tableView.sectionHeaderHeight = 48;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JGSCReuseIdentifier(UITableViewCell)];
    
    [[JGNRReachability sharedInstance] startMonitor];
    switch (_observerType) {
        case StatusObserverTypeBlock: {
            
            // TODO: 注意block内部循环引用内存问题
            JGSCWeak(self);
            self.title = @"Observer Block";
            [[JGNRReachability sharedInstance] addObserver:self statusChangeBlock:^(JGNRReachabilityStatus status) {
                
                JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
                
                JGSCStrong(self);
                [self.tableView reloadData];
            }];
        }
            break;
            
        case StatusObserverTypeSelector: {
            
            self.title = @"Observer Selector";
            [[JGNRReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged)];
        }
            break;
            
        case StatusObserverTypeSelectorValue1: {
            
            self.title = @"Observer Selector Value 1";
            [[JGNRReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:)];
        }
            break;
            
        case StatusObserverTypeSelectorValue2: {
            
            self.title = @"Observer Selector Value 2";
            [[JGNRReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:value2:)];
        }
            break;
            
        case StatusObserverTypeSelectorValue3: {
            
            self.title = @"Observer Selector Value 3";
            [[JGNRReachability sharedInstance] addObserver:self selector:@selector(networkStatusChanged:value2:value3:)];
        }
            break;
            
        case StatusObserverTypeNotification: {
            
            self.title = @"Observer Notification";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChangedNotification:) name:JGNRReachabilityStatusChangedNotification object:nil];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGSCReuseIdentifier(UITableViewCell) forIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action
- (void)networkStatusChanged {
    
    JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 {
    
    JGSCLog(@"%@", value1);
    JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 value2:(id)value2 {
    
    JGSCLog(@"%@, %@", value1, value2);
    JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

- (void)networkStatusChanged:(id)value1 value2:(id)value2 value3:(id)value3 {
    
    JGSCLog(@"%@, %@, %@", value1, value2, value3);
    JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

#pragma mark - Notification
- (void)networkStatusChangedNotification:(NSNotification *)notification {
    
    JGSCLog(@"%@, %@", notification.object, notification.userInfo);
    JGSCLog(@"Status : %@", [[JGNRReachability sharedInstance] reachabilityStatusString]);
    [self.tableView reloadData];
}

#pragma mark - End


@end
