//
//  CreateTableDB.m
//  sxxw
//
//  Created by tw on 14-1-8.
//  Copyright (c) 2014年 com.tght. All rights reserved.
//

#import "CreateTableDB.h"
#import "SQLiteHelper.h"
@implementation CreateTableDB

// 数据库连接
static sqlite3 *kNewsDatabase;
// SQLite帮助类
static SQLiteHelper *kSqlite;

// 获取
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
            [self createLastTables:kNewsDatabase];
		}
	}
	
	return self;
}
//创建表
- (BOOL) createLastTables:(sqlite3*)db {
     //这句是大家熟悉的SQL语句
    char *sql = "DROP  TABLE  IF  EXISTS  lefttype;";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
    sqlite3_stmt *statement;
     NSInteger sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create  table");
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  test");
        return NO;
    }
    sql = " DROP  TABLE  IF  EXISTS  newstype;";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
     sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create  table");
        return NO;
    }
     success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  test");
        return NO;
    }
    sql = "DROP  TABLE  IF  EXISTS  news;";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
    sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create  table");
        return NO;
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  test");
        return NO;
    }
    sql = "create table if not exists news(newid INTEGER PRIMARY KEY AUTOINCREMENT,titleimg text,content text,typeurlname text,url text,title text,datestr text);";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
    sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create news table");
        return NO;
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  news");
        return NO;
    }
    sql = "create table if not exists lefttype(tid INTEGER PRIMARY KEY AUTOINCREMENT,type text,name text,code text,url text);";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
    sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create lefttype table");
        return NO;
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  lefttype");
        return NO;
    }
    sql = "create table if not exists newstype(tid INTEGER PRIMARY KEY AUTOINCREMENT,pcode text,type text,name text,code text,url text);";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
    
    sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create  newstype table");
        return NO;
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create  newstype");
        return NO;
    }
     

    NSLog(@"Create table successed.");
    return YES;
}
@end
