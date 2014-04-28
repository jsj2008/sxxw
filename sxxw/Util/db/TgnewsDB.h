//
//  AlbumDB.h
//  album
//
//  Created bytw
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class News;

@interface TgnewsDB : NSObject
// 释放资源
+ (void) finalizeStatements;

// 打开数据库（单例）
+ (id) singleton;
 

// 增加新闻
+ (void) addNews: (News *) news;
//查询新闻详情
+ (News *) getNewsById: (News *) news;
//+ (void) setNewsContent: (News *) news;
+ (void) setNewsContent: (int) newsid content:(NSString *) content;
// 获取新闻
//+ (NSMutableArray *) fetchNews:(NSString *) _typeurlname limit:(NSInteger)_limit;
+ (NSMutableArray *) fetchNews: (NSString *) _arctypeid page:(int)_page;
// 获取图片新闻
+ (NSMutableArray *) fetchpicNews:(NSString *) _typeurlname;
// 删除新闻
+ (void) deleteNewsBytype:(NSString *) _typeurlname;
//查询新闻是否存在
+ (BOOL) getNewsByNewsId:  (int) newsId;
//查询新闻总数
+ (int) fetchNewsCount: (NSString *) _arctypeid;
@end
