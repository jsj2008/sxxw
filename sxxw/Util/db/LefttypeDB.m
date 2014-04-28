//
//  LeftTypeDB.m
//  sxxw
//
//  Created bytw
//  Copyright (c) 2014年 com.tght. All rights reserved.
//
#import "LefttypeDB.h"
#import "SQLiteHelper.h"
#import "Lefttype.h"

@implementation LefttypeDB

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

// 增加新闻类型
+ (void) addLefttype: (Lefttype *) _lefttype
{
    
    sqlite3_stmt *statement;
    static char *sql = "INSERT INTO lefttype(name,code,url,type) VALUES (?,?,?,?)";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_bind_text(statement, 1, [_lefttype.name UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 2, [_lefttype.code UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 3, [_lefttype.url UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 4, [_lefttype.type UTF8String], -1, NULL);
    int success = sqlite3_step(statement);
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to add news with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_finalize(statement);
}
// 获取所有新闻
+ (NSMutableArray *) fetchLefttype
{
    NSMutableArray *lefttypearray = [NSMutableArray array];
 	if (fetchNewsStatement == nil) {
		const char *sql = "SELECT tid, name,code,url,type FROM lefttype order by tid ";
		if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &fetchNewsStatement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
		}
	}
    // 占位符赋值
	while (sqlite3_step(fetchNewsStatement) == SQLITE_ROW)
	{
 		Lefttype *_lefttype = [[Lefttype alloc] init];
        _lefttype.tid = sqlite3_column_int(fetchNewsStatement, 0);
        _lefttype.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 1)];
        _lefttype.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 2)];
        _lefttype.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 3)];
        _lefttype.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 4)];
        [lefttypearray addObject:_lefttype];
	}
    sqlite3_reset(fetchNewsStatement);
    return lefttypearray;
}
// 删除新闻类型
+ (void) deleteLefttype
{
    sqlite3_stmt *statement;
    static char *sql = "DELETE FROM lefttype ";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    int success = sqlite3_step(statement);
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to delete lefttype with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_finalize(statement);
}

@end
