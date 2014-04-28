//
//  CreateTableDB.h
//  sxxw
//
//  Created by tw on 14-1-8.
//  Copyright (c) 2014年 com.tght. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateTableDB : NSObject
// 释放资源
+ (void) finalizeStatements; 
// 打开数据库（单例）
+ (id) singleton;
@end
