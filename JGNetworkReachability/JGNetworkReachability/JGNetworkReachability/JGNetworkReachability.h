//
//  JGNetworkReachability.h
//  JGNetworkReachability
//
//  Created by 梅继高 on 2017/3/9.
//  Copyright © 2017年 Jigao Mei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const JGNetworkReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString *const JGNetworkReachabilityNotificationStatusKey;

/**
 * 网络连接类型
 */
typedef NS_ENUM(NSInteger, JGNetworkReachabilityStatus) {
    JGNetworkReachabilityStatusNotReachable = 1, // 不可连接
    JGNetworkReachabilityStatusReachableViaWiFi, // WiFi
    JGNetworkReachabilityStatusReachableViaWWAN, // 蜂窝移动网络
};

/**
 * 蜂窝移动网络类型
 */
typedef NS_ENUM(NSInteger, JGNetworkReachabilityWWAN) {
    JGNetworkReachabilityWWANUnknown = 201,
    JGNetworkReachabilityWWANGPRS, // GPRS
    JGNetworkReachabilityWWAN2G, // 2G
    JGNetworkReachabilityWWAN3G, // 3G
    JGNetworkReachabilityWWAN4G, // 4G
};

typedef void (^JGNetworkReachabilityStatusChangeAction)(JGNetworkReachabilityStatus status);

@protocol JGNetworkReachabilityDelegate;
@interface JGNetworkReachability : NSObject

/** 网络连接类型 */
@property (nonatomic, assign, readonly) JGNetworkReachabilityStatus reachabilityStatus;

/** 网络是否可连接 */
@property (nonatomic, assign, readonly) BOOL reachable;

/** 是否WiFi网络 */
@property (nonatomic, assign, readonly) BOOL reachableViaWiFi;

/** 是否为蜂窝移动网络 */
@property (nonatomic, assign, readonly) BOOL reachableViaWWAN;

/** 蜂窝移动网络状态 */
@property (nonatomic, assign, readonly) JGNetworkReachabilityWWAN WWANStatus;

/** 网络连接类型描述，eg: NoNetwork, WiFi, Mobile, GPRS, 2G, 3G, 4G */
@property (nonatomic, copy, readonly) NSString *reachabilityStatusString;

+ (instancetype)sharedInstance;

/**
 * 全局调用，可重复调用，已启动时重复调用无效
 */
- (void)startMonitor;

/**
 * 状态变化监听处理
 * block需注意内存问题
 * dealloc 调用 removeObserver:移除监听
 */
- (void)addObserver:(id)observer reachabilityStatusChange:(nullable JGNetworkReachabilityStatusChangeAction)notification;

/**
 * 状态变化监听移除
 * 存在监听则移除，不存在则不做处理
 */
- (void)removeObserver:(id)observer;

/**
 * 状态变化监听回调代理，内部处理内存问题，不需外部处理
 */
- (void)addDelegate:(id<JGNetworkReachabilityDelegate>)delegate;

@end

@protocol JGNetworkReachabilityDelegate <NSObject>

@optional
- (void)networkReachability:(JGNetworkReachability *)networkReachability didChangeStatus:(JGNetworkReachabilityStatus)status;

@end

NS_ASSUME_NONNULL_END
