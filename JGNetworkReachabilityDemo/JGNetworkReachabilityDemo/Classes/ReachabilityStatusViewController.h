//
//  ReachabilityStatusViewController.h
//  JGNetworkReachabilityDemo
//
//  Created by Mei Jigao on 2018/3/19.
//  Copyright © 2018年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, StatusObserverType) {
    StatusObserverTypeBlock = 0,
    StatusObserverTypeSelector,
    StatusObserverTypeSelectorValue1,
    StatusObserverTypeSelectorValue2,
    StatusObserverTypeSelectorValue3,
    StatusObserverTypeNotification,
};

@interface ReachabilityStatusViewController : UITableViewController

@property (nonatomic, assign) StatusObserverType observerType;

@end

NS_ASSUME_NONNULL_END
