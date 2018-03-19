//
//  ViewController.m
//  JGNetworkReachabilityDemo
//
//  Created by Mei Jigao on 2018/3/19.
//  Copyright © 2018年 MeiJigao. All rights reserved.
//

#import "ViewController.h"
#import <JGSourceBase/JGSourceBase.h>
#import "JGDemoTableData.h"
#import "ReachabilityStatusViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray<JGDemoTableSectionData *> *demoData;

@end

@implementation ViewController

#pragma mark - init & dealloc
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
    
    JGSCWeak(self);
    _demoData = @[
                  JGDemoTableSectionMake(@"",
                                         @[
                                           JGDemoTableRowMakeBlock(@"Block", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeBlock;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           JGDemoTableRowMakeBlock(@"Selector", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeSelector;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           JGDemoTableRowMakeBlock(@"Selector Value 1", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeSelectorValue1;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           JGDemoTableRowMakeBlock(@"Selector Value 2", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeSelectorValue2;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           JGDemoTableRowMakeBlock(@"Selector Value 3", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeSelectorValue3;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           JGDemoTableRowMakeBlock(@"Notification", ^(JGDemoTableRowData * _Nonnull rowData) {
                      
                      JGSCStrong(self);
                      ReachabilityStatusViewController *vcT = [[ReachabilityStatusViewController alloc] init];
                      vcT.observerType = StatusObserverTypeNotification;
                      [self.navigationController pushViewController:vcT animated:YES];
                  }),
                                           ]),
                  ];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.demoData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoData[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGSCReuseIdentifier(UITableViewCell) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.demoData[indexPath.section].rows[indexPath.row].title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.demoData[section].title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    JGDemoTableRowData *rowData = self.demoData[indexPath.section].rows[indexPath.row];
    if (rowData.selectBlock) {
        rowData.selectBlock(rowData);
    }
}

#pragma mark - End

@end
