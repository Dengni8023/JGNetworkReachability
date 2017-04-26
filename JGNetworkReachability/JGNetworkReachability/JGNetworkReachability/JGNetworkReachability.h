//
//  JGNetworkReachability.h
//  JGNetworkReachability
//
//  Created by 梅继高 on 2017/3/9.
//  Copyright © 2017年 Jigao Mei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
 状态变化监听处理，可添加多个监听者，注意block内存问题

 @param observer 监听接收者
 @param notification 监听处理block
 */
- (void)addStatusObserver:(id)observer action:(nullable JGNetworkReachabilityStatusChangeAction)notification;

@end

NS_ASSUME_NONNULL_END
