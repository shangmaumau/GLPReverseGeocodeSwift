//
//  SwiftHeader.swift
//
//  Created by 尚雷勋 on 2020/3/4.
//  Copyright © 2020 GiANTLEAP Inc. All rights reserved.
//

import Foundation

/*
 
 #define kWidthScale         ([UIScreen mainScreen].bounds.size.width/375.0f)
 #define kHeightScale        ([UIScreen mainScreen].bounds.size.height/667.0f)
 // 屏幕宽度
 #define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
 // 屏幕高度
 #define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)
 // 状态栏高度
 #define kStatusBarHeight    ([UIApplication sharedApplication].statusBarFrame.size.height)
 // 横屏：导航栏高度
 #define kNavigationBarHeight 44.0
 // 横屏：Tab Bar 高度
 #define kTabBarHeight       49.0
 // 横屏：导航栏高度 + 状态栏高度
 #define kViewTopHeight      (kStatusBarHeight + kNavigationBarHeight)
 // iPhone X 适配差值
 #define kBottomSafeAreaHeight ([UIApplication sharedApplication].statusBarFrame.size.height>20.0?34.0:0.0)
 #define kHeight_SegMentBackground 60
 */

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.width
/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.height
/// 宽度比
///
/// 和 iPhone 6 相比
let kWidthScale = kScreenWidth/375.0
/// 高度比
let kHeightScale = kScreenHeight/667.0
/// 状态栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
/// 导航栏高度
let kNavigationBarHeight = CGFloat( 44.0 )
/// Tab 高度
let kTabBarHeight = CGFloat( 49.0 )
/// 导航栏和状态栏一起的高度
let kViewTopHeight = kStatusBarHeight + kNavigationBarHeight
/// 底部高度
let kBottomSafeAreaHeight: CGFloat = UIApplication.shared.statusBarFrame.height > 20.0 ? 34.0 : 0.0


