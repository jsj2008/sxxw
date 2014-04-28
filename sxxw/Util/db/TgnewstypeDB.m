//
//  AlbumDB.m
//  album
//
//  Created bytw  
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgnewstypeDB.h"
#import "SQLiteHelper.h"
#import "Newstype.h" 

@implementation TgnewstypeDB

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
+ (void) addNewstype: (Newstype *) _newstype
{
    
    sqlite3_stmt *statement;
     static char *sql = "INSERT INTO newstype(name,code,url,type,pcode,arctypeid) VALUES (?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK) 
    {
         NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
     } 
    sqlite3_bind_text(statement, 1, [_newstype.name UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 2, [_newstype.code UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 3, [_newstype.url UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 4, [_newstype.type UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 5, [_newstype.pcode UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 6, [_newstype.arctypeid UTF8String], -1, NULL);
    int success = sqlite3_step(statement);
     if (success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to add news with message '%s'.", sqlite3_errmsg(kNewsDatabase)); 
    } 
    sqlite3_finalize(statement);
}
   // 获取所有新闻
+ (NSMutableArray *) fetchNewstype:(NSString *) pcode;
{
    NSMutableArray *newstypearray = [NSMutableArray array];
 	if (fetchNewsStatement == nil) {
		const char *sql = "SELECT tid, name,code,url,type,pcode,arctypeid FROM newstype WHERE pcode = ? order by tid ";
		if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &fetchNewsStatement, NULL) != SQLITE_OK) { 
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
		}
	}
    sqlite3_bind_text(fetchNewsStatement, 1, [pcode UTF8String], -1, nil);//给问号
   // 占位符赋值
	while (sqlite3_step(fetchNewsStatement) == SQLITE_ROW)
	{
		Newstype *_newstype = [[Newstype alloc] init];
        
        _newstype.tid = sqlite3_column_int(fetchNewsStatement, 0);
        _newstype.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 1)];
        _newstype.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 2)];
        _newstype.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 3)];
        _newstype.type= [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 4)];
        _newstype.arctypeid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(fetchNewsStatement, 6)];
        [newstypearray addObject:_newstype];
	}
	 	sqlite3_reset(fetchNewsStatement); 
    return newstypearray;
}
// 删除新闻类型
+ (void) deleteNewstype:(NSString *) pcode
{
    sqlite3_stmt *statement;
    static char *sql = "DELETE FROM newstype WHERE pcode = ? ";
    if (sqlite3_prepare_v2(kNewsDatabase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_bind_text(statement, 1, [pcode UTF8String], -1, nil);//给问号
    int success = sqlite3_step(statement); 
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to delete album with message '%s'.", sqlite3_errmsg(kNewsDatabase));
    }
    sqlite3_finalize(statement);
}

 @end
