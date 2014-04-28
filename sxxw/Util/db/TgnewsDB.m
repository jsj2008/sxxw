//
//  AlbumDB.m
//  album
//
//  Created bytw
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgnewsDB.h"
#import "SQLiteHelper.h"
#import "News.h" 

@implementation TgnewsDB

// 数据库连接
static sqlite3 *kNewsDatabase;
// SQLite帮助类
static SQLiteHelper *kSqlite;

// 获取相册
static sqlite3_stmt *fetchNewsStatement = nil;
static sqlite3_stmt *fetchNewsStatement2 = nil;
// 释放资源
+ (void) finalizeStatements
{
	if (fetchNewsStatement)
	{
		sqlite3_finalize(fetchNewsStatement);
	} 
    if (fetchNewsStatement2)
	{
		sqlite3_finalize(fetchNewsStatement2);
	} 
    [kSqlite closeDatabase];
}

// 打开数据库（单例）
+ (id) singleton
{
	return [[self alloc] init];
}

-(id) init
{
	if ((self=[super init]) ) {
		if (kNewsDatabase == nil)
		{
			if (kSqlite == nil) 
            {
				kSqlite = [[SQLiteHelper alloc] init];
			}
            
            [kSqlite createEditableCopyOfDatabaseIfNeeded];
			[kSqlite initDatabaseConnection];
			
			kNewsDatabase = [kSqlite database];
		}
	}
	
	return self;
}
 
// 增加新闻
+ (void) addNews: (News *) _news{
    
    if (![self getNewsByNewsId:[_news.newsid intValue]]) {
        sqlite3_stmt *statement;
        static char *sql = "INSERT INTO news(title,datestr,newsid,arctypeid,content,titleimg) VALUES (?,?,?,?,'',?)";
        if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
        }
        sqlite3_bind_text(statement, 1, [_news.title UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [_news.datestr UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [_news.newsid UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [_news.arctypeid UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 5, [_news.titleimg UTF8String], -1, NULL);
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR)
        {
            NSAssert1(0, @"Error: failed to add news with message '%s'.", sqlite3_errmsg(kNewsDatabase));
        } 
        sqlite3_finalize(statement);
    }
}
//// 编辑新闻
//+ (void) setNewsContent: (News *) news
//{
//    sqlite3_stmt *statement;
//    
//    static char *sql = "UPDATE news SET content = ? WHERE newid = ?";
//    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
//    {
//        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
//    }
//    sqlite3_bind_text(statement, 1, [news.content UTF8String], -1, NULL);
//    sqlite3_bind_int(statement, 2, news.newid);
//    
//    int success = sqlite3_step(statement);
//    
//    if (success == SQLITE_ERROR)
//    {
//        NSAssert1(0, @"Error: failed to edit album with message '%s'.", sqlite3_errmsg(kNewsDatabase));
//    }
//    
//    sqlite3_finalize(statement);
//}

// 编辑新闻
+ (void) setNewsContent: (int) newsid content:(NSString *) content{
    sqlite3_stmt *statement;
    
    static char *sql = "UPDATE news SET content = ? WHERE newsid = ?";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_bind_text(statement, 1, [content UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 2, newsid);
    
    int success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to edit album with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    NSLog(@"设置新闻内容成功");
    sqlite3_finalize(statement);
}

//  // 获取所有新闻
//+ (NSMutableArray *) fetchNews: (NSString *) _typeurlname  limit:(NSInteger)_limit
//{
//    NSMutableArray *newsarray = [NSMutableArray array]; 
// 	if (fetchNewsStatement == nil) {
//		const char *sql = "SELECT newid, title,datestr,url,typeurlname,content,titleimg FROM news where typeurlname=?  order by newid  ";
//		if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &fetchNewsStatement, NULL) != SQLITE_OK) { 
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
//		}
//	}
// 	sqlite3_bind_text(fetchNewsStatement, 1, [_typeurlname UTF8String], -1, nil);//给问号
//    //sqlite3_bind_int(fetchNewsStatement, 2, (_limit-1)*10);//给问号
//   // 占位符赋值
//	while (sqlite3_step(fetchNewsStatement) == SQLITE_ROW)
//	{
//		News *_new = [[News alloc] init];
//        
//        _new.newid = sqlite3_column_int(fetchNewsStatement, 0);
//        _new.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 1)];
//		_new.datestr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 2)]; 
//        _new.datestr= [_new.datestr substringToIndex:10];         
//        _new.url = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement, 3)];
//        _new.typeurlname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 4)]; 
//        _new.titleimg = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement, 6)];
// 		[newsarray addObject:_new];
//        
//	}
//	 	sqlite3_reset(fetchNewsStatement); 
//    return newsarray;
//}

// 获取所有新闻
+ (NSMutableArray *) fetchNews: (NSString *) _arctypeid page:(int)_page
{
    NSMutableArray *newsarray = [NSMutableArray array];
 	if (fetchNewsStatement == nil) {
		const char *sql = "SELECT newid, title,datestr,url,typeurlname,content,titleimg,newsid FROM news where arctypeid=?  order by newid  limit ?,10";
		if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &fetchNewsStatement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
		}
	}
 	sqlite3_bind_text(fetchNewsStatement, 1, [_arctypeid UTF8String], -1, nil);//给问号
    sqlite3_bind_int(fetchNewsStatement, 2, (_page-1)*10);//给问号
    // 占位符赋值
	while (sqlite3_step(fetchNewsStatement) == SQLITE_ROW)
	{
		News *_new = [[News alloc] init];
        
        _new.newid = sqlite3_column_int(fetchNewsStatement, 0);
        _new.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 1)];
		_new.datestr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 2)];
        _new.datestr= [_new.datestr substringToIndex:10];
//        _new.url = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement, 3)];
//        _new.typeurlname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 4)];
        _new.titleimg = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement, 6)];
        _new.newsid = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement, 7)];
 		[newsarray addObject:_new];
        
	}
    sqlite3_reset(fetchNewsStatement);
    return newsarray;
}

// 获取新闻总数
+ (int) fetchNewsCount: (NSString *) _arctypeid{
    sqlite3_stmt *statement;
    const char *sql = "SELECT count(*) FROM news where arctypeid=?";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
 	sqlite3_bind_text(statement, 1, [_arctypeid UTF8String], -1, nil);//给问号
    sqlite3_step(statement);
    int count = sqlite3_column_int(statement, 0);
    sqlite3_reset(statement);
    return count;
}

// 获取图片新闻
+ (NSMutableArray *) fetchpicNews: (NSString *) _arctypeid
{
    NSMutableArray *newsarray = [NSMutableArray array]; 
	if (fetchNewsStatement2 == nil) {
		const char *sql = "SELECT newid, title,datestr,url,typeurlname,content,titleimg,newsid FROM news where arctypeid=?  order by newid  limit 3";
		if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &fetchNewsStatement2, NULL) != SQLITE_OK) {
            
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
		}
	}
 	sqlite3_bind_text(fetchNewsStatement2, 1, [_arctypeid UTF8String], -1, nil);//给问号占位符赋值
	while (sqlite3_step(fetchNewsStatement2) == SQLITE_ROW)
	{
		News *_new = [[News alloc] init];
        _new.newid = sqlite3_column_int(fetchNewsStatement2, 0);
        _new.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement2, 1)];
		_new.datestr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement2, 2)];
        _new.datestr= [_new.datestr substringToIndex:10]; 
//        _new.url = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement2, 3)];
//        _new.typeurlname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement2, 4)];
        _new.titleimg = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement2, 6)];
        _new.newsid = [NSString stringWithFormat:@"%s", sqlite3_column_text(fetchNewsStatement2, 7)];
 		[newsarray addObject:_new];
        
	}
	
	// Reset the statement for future reuse.
	sqlite3_reset(fetchNewsStatement2);
    return newsarray;
}

// 获取新闻内容
+ (News *) getNewsById:  (News *) news{
 	 sqlite3_stmt *statement;
    const char *sql = "SELECT newid, title,datestr,url,typeurlname,content FROM news where newsid=?    ";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_bind_text(statement, 1, [news.newsid UTF8String], -1, nil);
	while (sqlite3_step(statement) == SQLITE_ROW){
        news.newid = sqlite3_column_int(statement, 0);
        news.content=[NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding]; 
   	}
 	sqlite3_reset(statement);
    return news;
}

// 查询新闻是否存在
+ (BOOL) getNewsByNewsId:  (int) newsId{
    sqlite3_stmt *statement;
    const char *sql = "SELECT count(*) FROM news where newsid=? ";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK) {
        
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_bind_int(statement, 1, newsId);
    sqlite3_step(statement);
    int count = sqlite3_column_int(statement, 0);
    sqlite3_reset(statement);
	if (count > 0) {
        return YES;
    }else{
        return NO;
    }
}
// 删除新闻
+ (void) deleteNewsBytype: (NSString *) _typeurlname
{
    sqlite3_stmt *statement; 
    static char *sql = "DELETE FROM news WHERE typeurlname = ?";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    
    sqlite3_bind_text(statement, 1, [_typeurlname UTF8String], -1, nil);
    
    int success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to delete album with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_finalize(statement);
} 
@end
