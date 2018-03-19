//
//  JGNRReachability.h
//  JGNetworkReachability
//
//  Created by 梅继高 on 2018/6/12.
//  Copyright © 2018年 MeiJigao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 网络连接类型
 */
typedef NS_ENUM(NSInteger, JGNRReachabilityStatus) {
    JGNRReachabilityStatusNotReachable = 1, // 不可连接
    JGNRReachabilityStatusViaWiFi, // WiFi
    JGNRReachabilityStatusViaWWAN, // 蜂窝移动网络
};

/**
 * 蜂窝移动网络类型
 */
typedef NS_ENUM(NSInteger, JGNRWWANType) {
    JGNRWWANTypeUnknown = 201,
    JGNRWWANTypeGPRS, // GPRS
    JGNRWWANType2G, // 2G
    JGNRWWANType3G, // 3G
    JGNRWWANType4G, // 4G
};

typedef void (^JGNRReachabilityStatusChangeBlock)(JGNRReachabilityStatus status);

FOUNDATION_EXTERN NSNotificationName const JGNRReachabilityStatusChangedNotification;

typedef NSString *JGNRReachabilityNotificationKey NS_EXTENSIBLE_STRING_ENUM;
FOUNDATION_EXTERN JGNRReachabilityNotificationKey const JGNRReachabilityNotificationStatusKey;

#pragma mark - Deprecated
DEPRECATED_MSG_ATTRIBUTE("Use JGNRReachabilityStatus instead")
typedef NS_ENUM(NSInteger, JGNetworkReachabilityStatus) {
    JGNetworkReachabilityStatusNotReachable = JGNRReachabilityStatusNotReachable,
    JGNetworkReachabilityStatusReachableViaWiFi = JGNRReachabilityStatusViaWiFi,
    JGNetworkReachabilityStatusReachableViaWWAN = JGNRReachabilityStatusViaWWAN,
};

DEPRECATED_MSG_ATTRIBUTE("Use JGNRWWANType instead")
typedef NS_ENUM(NSInteger, JGNetworkReachabilityWWAN) {
    JGNetworkReachabilityWWANUnknown = JGNRWWANTypeUnknown,
    JGNetworkReachabilityWWANGPRS = JGNRWWANTypeGPRS,
    JGNetworkReachabilityWWAN2G = JGNRWWANType2G,
    JGNetworkReachabilityWWAN3G = JGNRWWANType3G,
    JGNetworkReachabilityWWAN4G = JGNRWWANType4G,
};

typedef void (^JGNetworkReachabilityStatusChangeAction)(JGNetworkReachabilityStatus status)
DEPRECATED_MSG_ATTRIBUTE("Use JGNRReachabilityStatusChangeBlock instead");

FOUNDATION_EXTERN NSNotificationName const JGNetworkReachabilityStatusChangedNotification
DEPRECATED_MSG_ATTRIBUTE("Use JGNRReachabilityStatusChangedNotification instead");

typedef JGNRReachabilityNotificationKey JGNetworkReachabilityNotificationKey
DEPRECATED_MSG_ATTRIBUTE("Use JGNRReachabilityNotificationKey instead");
FOUNDATION_EXTERN JGNRReachabilityNotificationKey const JGNetworkReachabilityNotificationstatusKey;

@interface JGNRReachability : NSObject

/** 网络连接类型 */
@property (nonatomic, assign, readonly) JGNRReachabilityStatus reachabilityStatus;

/** 网络是否可连接 */
@property (nonatomic, assign, readonly) BOOL reachable;

/** 是否WiFi网络 */
@property (nonatomic, assign, readonly) BOOL reachableViaWiFi;

/** 是否为蜂窝移动网络 */
@property (nonatomic, assign, readonly) BOOL reachableViaWWAN;

/** 蜂窝移动网络状态 */
@property (nonatomic, assign, readonly) JGNRWWANType WWANType;

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
 @param block 监听处理block
 */
- (void)addObserver:(id)observer statusChangeBlock:(nullable JGNRReachabilityStatusChangeBlock)block;

/**
 移除状态监听block，非必需
 addStatusObserver:statusChangeBlock: 调用时block内部不存在内存问题时observer内存释放时会自动移除；
 addStatusObserver:statusChangeBlock: 调用时block内部存在内存问题时observer内存释放时必须手动调用本接口移除监听
 
 @param observer 监听接收者
 */
- (void)removeStatusChangeBlockWithObserver:(id)observer;

/**
 状态变化监听处理，可添加多个监听者
 selector定义带单个可选参数，执行时参数类型 JGNRReachability
 selector定义多个参数执行时只第一参数有效，其他参数无效
 
 @param observer 监听接收者
 @param selector 监听处理selector
 */
- (void)addObserver:(id)observer selector:(SEL)selector;

/**
 移除状态监听selector，非必需，observer内存释放时会自动移除
 
 @param observer 监听接收者
 */
- (void)removeSelectorWithObserver:(id)observer;

#pragma mark - Deprecated
- (void)addObserver:(id)observer action:(nullable JGNetworkReachabilityStatusChangeAction)notification
DEPRECATED_MSG_ATTRIBUTE("Replaced by -addObserver:statusChangeBlock:");

- (void)removeActionWithObserver:(id)observer
DEPRECATED_MSG_ATTRIBUTE("Replaced by -removeStatusChangeBlockWithObserver:");

@property (nonatomic, assign, readonly) JGNRWWANType WWANStatus
DEPRECATED_MSG_ATTRIBUTE("Use WWANType instead");

@end

DEPRECATED_MSG_ATTRIBUTE("Use JGNRReachability instead")
@interface JGNetworkReachability : JGNRReachability

@end

NS_ASSUME_NONNULL_END
