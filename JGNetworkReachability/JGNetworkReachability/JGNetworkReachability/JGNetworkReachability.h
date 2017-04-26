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

/**
 移除状态监听block，非必需
 addStatusObserver:action: 调用时block内部不存在内存问题时observer内存释放时会自动移除；
 addStatusObserver:action: 调用时block内部存在内存问题时observer内存释放时必须手动调用本接口移除监听

 @param observer 监听接收者
 */
- (void)removeStatusObserver:(id)observer;

/**
 状态变化监听处理，可添加多个监听者
 selector定义带单个可选参数，执行时参数类型 JGNetworkReachability
 selector定义多个参数执行时只第一参数有效，其他参数无效
 
 @param observer 监听接收者
 @param selector 监听处理selector
 */
- (void)addStatusTarget:(id)observer selector:(SEL)selector;

/**
 移除状态监听selector，非必需，observer内存释放时会自动移除
 
 @param observer 监听接收者
 */
- (void)removeStatusTarget:(id)observer;

@end

NS_ASSUME_NONNULL_END
