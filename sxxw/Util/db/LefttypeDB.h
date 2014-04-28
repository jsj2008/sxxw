//
//  LeftTypeDB.h
//  sxxw
//
//  Created bytw
//  Copyright (c) 2014年 com.tght. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lefttype;

@interface LefttypeDB : NSObject
// 释放资源
+ (void) finalizeStatements;

// 打开数据库（单例）
+ (id) singleton;


// 增加新闻类型
+ (void) addLefttype: (Lefttype *) lefttype;

// 获取新闻类型
+ (NSMutableArray *) fetchLefttype;
+ (void) deleteLefttype;
@end
