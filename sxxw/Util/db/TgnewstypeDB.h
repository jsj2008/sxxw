//
//  AlbumDB.h
//  album
//
//  Created bytw 
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Newstype;

@interface TgnewstypeDB : NSObject
// 释放资源
+ (void) finalizeStatements;

// 打开数据库（单例）
+ (id) singleton;
 

// 增加新闻类型
+ (void) addNewstype: (Newstype *) newstype;
  
// 获取新闻类型
+ (NSMutableArray *) fetchNewstype:(NSString *) pcode;
+ (void) deleteNewstype:(NSString *) pcode;
@end
