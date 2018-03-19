//
//  JGNetworkReachability.h
//  JGNetworkReachability
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JGNetworkReachability.
FOUNDATION_EXPORT double JGNetworkReachabilityVersionNumber;

//! Project version string for JGNetworkReachability.
FOUNDATION_EXPORT const unsigned char JGNetworkReachabilityVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JGNetworkReachability/PublicHeader.h>

// JGSC 缩写说明
// JG: 作者
// NR: Network Reachability

#if __has_include(<JGNetworkReachability/JGNetworkReachability.h>)

#import <JGNetworkReachability/JGNRReachability.h>

#else

#import "JGNRReachability.h"

#endif
