//
//  LayoutHeadFile.h
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#ifndef LayoutHeadFile_h
#define LayoutHeadFile_h

// 屏幕宽
#define SCREEN_W UIScreen.mainScreen.bounds.size.width
// 屏幕高
#define SCREEN_H UIScreen.mainScreen.bounds.size.height
// 根据屏幕宽高适应边距
#define AUTO_MARGIN(size) (SCREEN_W / 375.0)*size
// 是否为刘海屏
#define IS_iPhoneX          UIApplication.sharedApplication.statusBarFrame.size.height > 20 ? YES:NO
// 状态栏高度
#define StatusBarH          UIApplication.sharedApplication.statusBarFrame.size.height
// 导航栏 + 状态栏
#define NavigationBarH      UIApplication.sharedApplication.statusBarFrame.size.height + 44
// 底部安全距离
#define SafeBottomH         (IS_iPhoneX ? 34.f : 0.f)
// TabBar 高度
#define TabBarH             49.f

#endif /* LayoutHeadFile_h */
