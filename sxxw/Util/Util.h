//
//  Util.h
//  sxxw
//
//  Created by tw on 14-1-3.
//  Copyright (c) 2014年 com.tght. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lefttype.h"
@interface Util : NSObject
// 获取侧边栏列表数据
+ (Lefttype *) getLastLefttype;
// 获取大项下栏目数据
+ (void) getLastNewstype: (Lefttype *) lefttype;
//判断网络连接
+ (BOOL)connectedToNetwork;
@end
