//
//  JGNetworkReachabilityImpl.m
//  JGNetworkReachability
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGNetworkReachabilityImpl.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import "JGSourceBase.h"

typedef void (^JGNetworkReachabilityStatusBlock)(void);

static void JGReachabilityStatusChange(SCNetworkReachabilityFlags flags, JGNetworkReachabilityStatusBlock block) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (block) {
            block();
        }
    });
}

static void JGNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    
    JGReachabilityStatusChange(flags, (__bridge JGNetworkReachabilityStatusBlock)info);
}

static const void *JGNetworkReachabilityRetainCallback(const void *info) {
    
    return Block_copy(info);
}

static void JGNetworkReachabilityReleaseCallback(const void *info) {
    
    if (info) {
        Block_release(info);
    }
}

@interface JGNetworkReachability ()

@property (nonatomic, assign, readonly) SCNetworkReachabilityRef reachabilityRef;
@property (nonatomic, assign, readonly) BOOL runningSchedule;

@property (nonatomic, strong, readonly) NSMapTable *statusBlocks;
@property (nonatomic, strong, readonly) NSMapTable *statusSelectors;

@end

@implementation JGNetworkReachability

#pragma mark - ClassMethod
+ (instancetype)sharedInstance {
    
    static JGNetworkReachability *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[JGNetworkReachability alloc] init];
    });
    
    return instance;
}

#pragma mark - init & dealloc
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _statusBlocks = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
        _statusSelectors = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
        
        //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        struct sockaddr_in6 address;
        bzero(&address, sizeof(address));
        address.sin6_len = sizeof(address);
        address.sin6_family = AF_INET6;
#else
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
#endif
        
        // 创建测试连接
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
        _reachabilityRef = CFRetain(defaultRouteReachability);
        CFRelease(defaultRouteReachability);
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_reachabilityRef != NULL) {
        
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
    }
}

#pragma mark - Monitor
- (void)startMonitor {
    
    if (!self.reachabilityRef) {
        return;
    }
    
    if (self.runningSchedule) {
        return;
    }
    
    JGWeak(self);
    JGNetworkReachabilityStatusBlock callback = ^(void) {
        
        JGStrong(self);
        [self notifyReachabilityStatusChange];
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, JGNetworkReachabilityRetainCallback, JGNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.reachabilityRef, JGNetworkReachabilityCallback, &context);
    _runningSchedule = SCNetworkReachabilityScheduleWithRunLoop(self.reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

- (void)stopMonitor {
    
    if (!self.reachabilityRef) {
        return;
    }
    
    if (!self.runningSchedule) {
        return;
    }
    
    _runningSchedule = !SCNetworkReachabilityUnscheduleFromRunLoop(self.reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

- (void)addObserver:(id)observer action:(JGNetworkReachabilityStatusChangeAction)notification {
    
    if (observer && notification) {
        
        [self.statusBlocks setObject:notification forKey:observer];
    }
}

- (void)removeActionWithObserver:(id)observer {
    
    if (observer) {
        
        [self.statusBlocks removeObjectForKey:observer];
    }
}

- (void)addObserver:(id)observer selector:(SEL)selector {
    
    if (observer && selector) {
        
        [self.statusSelectors setObject:NSStringFromSelector(selector) forKey:observer];
    }
}

- (void)removeSelectorWithObserver:(id)observer {
    
    if (observer) {
        
        [self.statusSelectors removeObjectForKey:observer];
    }
}

- (void)notifyReachabilityStatusChange {
    
    // Block
    for (id obj in self.statusBlocks.objectEnumerator.allObjects) {
        
        JGNetworkReachabilityStatusChangeAction action = obj;
        if (action) {
            
            action(self.reachabilityStatus);
        }
    }
    
    // Selector
    for (id obj in self.statusSelectors.keyEnumerator.allObjects) {
        
        SEL selector = NSSelectorFromString([self.statusSelectors objectForKey:obj]);
        if (selector) {
            
            [obj performSelector:selector withObject:self afterDelay:0];
        }
    }
}

#pragma mark - Getter
- (JGNetworkReachabilityStatus)reachabilityStatus {
    
    // 标识(Flags)代表对一个域名(网络结点)或者地址(IP)的可连接性
    // 其包括是否需要一个网络连接以及在建立网络连接的过程中是否需要用户干预
    // 获得连接的状态，如果能获得状态则返回TRUE，否则返回FALSE
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags);
    
    JGNetworkReachabilityStatus status = JGNetworkReachabilityStatusNotReachable;
    if (didRetrieveFlags) {
        
        // 通过一个短暂的(网络)连接可以到达指定的域名或地址，比如PPP(Point to Point Protocol)协议
        //kSCNetworkReachabilityFlagsTransientConnection    = 1<<0,
        
        // 通过当前的网络配置可连接到指定的域名和地址
        //kSCNetworkReachabilityFlagsReachable        = 1<<1,
        
        // 通过当前的网络配置可连接到指定的域名和地址，但是首先得建立连接过程
        // 如果此标识被设定，那么标识
        // kSCNetworkReachabilityFlagsConnectionOnTraffic
        // kSCNetworkReachabilityFlagsConnectionOnDemand
        // kSCNetworkabilityFlagsIsWWAN
        // 通常应被设定为指定的网络连接要求类型
        // 如果用户必须手动生成此连接， 那么kSCNetworkReachabilityFlagsInterventionRequired标识也应要设定
        //kSCNetworkReachabilityFlagsConnectionRequired    = 1<<2,
        
        // 通过当前的网络配置可连接到指定的域名和地址，但是首先得建立连接过程，任何到达指定域名或地址的连接都将始于此连接
        //kSCNetworkReachabilityFlagsConnectionOnTraffic    = 1<<3,
        //kSCNetworkReachabilityFlagsConnectionAutomatic    = kSCNetworkReachabilityFlagsConnectionOnTraffic
        
        // 可通过当前网络配置连接到指定的域名或地址，但首先必须建立一个网络连接
        //kSCNetworkReachabilityFlagsInterventionRequired    = 1<<4,
        
        // 可通过当前网络配置连接到指定的域名或地址，但首先必须建立一个网络连接
        // 连接必须通过CFSocketSteam编程接口建立，其它函数将无法建立此连接
        //kSCNetworkReachabilityFlagsConnectionOnDemand    = 1<<5,
        
        // 指定的域名或地址与当前系统的网络接口相关(即本地的网络地址)
        //kSCNetworkReachabilityFlagsIsLocalAddress    = 1<<16,
        
        // 网络流量将不通过网关，而会直接的导向系统中的接口
        //kSCNetworkReachabilityFlagsIsDirect        = 1<<17,
        
        // 可通过蜂窝移动网络连接到指定域名或地址，GPRS（2G），EDGE（2G到3G的过渡技术方案，这里可以理解为3G），3G，4G
        //kSCNetworkReachabilityFlagsIsWWAN        = 1<<18,
        
        // 网络是否可连接
        BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
        
        // 是否需要建立连接过程
        BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
        
        // 需要建立连接过程的连接，是否需要用户配置连接
        BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
        BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
        
        // 设备网络连接状态
        BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
        if (isNetworkReachable) {
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
                
                status = JGNetworkReachabilityStatusReachableViaWWAN;
            }
            else {
                
                status = JGNetworkReachabilityStatusReachableViaWiFi;
            }
        }
    }
    
    return status;
}

- (BOOL)reachable {
    
    switch (self.reachabilityStatus) {
        case JGNetworkReachabilityStatusNotReachable:
            return NO;
            break;
            
        default:
            return YES;
            break;
    }
}

- (BOOL)reachableViaWiFi {
    
    switch (self.reachabilityStatus) {
        case JGNetworkReachabilityStatusReachableViaWiFi:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

- (BOOL)reachableViaWWAN {
    
    switch (self.reachabilityStatus) {
        case JGNetworkReachabilityStatusReachableViaWWAN:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

- (JGNetworkReachabilityWWAN)WWANStatus {
    
    JGNetworkReachabilityWWAN status = JGNetworkReachabilityWWANUnknown;
    if (self.reachableViaWWAN) {
        
        // 获取手机网络类型
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = info.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
            
            //GPRS网络
            status = JGNetworkReachabilityWWANGPRS;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
            
            //EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
            status = JGNetworkReachabilityWWAN2G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
            
            //3G WCDMA网络
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
            
            //3.5G网络，3G到4G的过度技术
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
            
            //3.5G网络，3G到4G的过度技术
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
            
            // CDMA 1X，CDMA2000的第一阶段
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
            
            //CDMA的EVDORev0(CDMA2000的演进版本)
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
            
            //CDMA的EVDORevA(CDMA2000的演进版本)
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
            
            //CDMA的EVDORevB(CDMA2000的演进版本)
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
            
            //HRPD网络，电信使用的一种3G到4G的演进技术， 3.75G
            status = JGNetworkReachabilityWWAN3G;
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
            
            //LTE4G网络
            status = JGNetworkReachabilityWWAN4G;
        }
    }
    
    return status;
}

- (NSString *)reachabilityStatusString {
    
    NSString *statusStr = @"NoNetwork";
    switch (self.reachabilityStatus) {
        case JGNetworkReachabilityStatusNotReachable:
            statusStr = @"NoNetwork";
            break;
            
        case JGNetworkReachabilityStatusReachableViaWiFi:
            statusStr = @"WiFi";
            break;
            
        case JGNetworkReachabilityStatusReachableViaWWAN: {
            
            switch (self.WWANStatus) {
                case JGNetworkReachabilityWWANUnknown:
                    statusStr = @"Mobile";
                    break;
                    
                case JGNetworkReachabilityWWANGPRS:
                    statusStr = @"GPRS";
                    break;
                    
                case JGNetworkReachabilityWWAN2G:
                    statusStr = @"2G";
                    break;
                    
                case JGNetworkReachabilityWWAN3G:
                    statusStr = @"3G";
                    break;
                    
                case JGNetworkReachabilityWWAN4G:
                    statusStr = @"4G";
                    break;
            }
        }
            break;
    }
    
    return statusStr;
}

#pragma mark - End

@end
