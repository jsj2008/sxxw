//
//  XHNeteaseNewsViewController.h
//  XHNewsFrameworkExample
//
//  Created by 曾 宪华 on 14-1-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

// 当编译的时候，如果出现报错，提示头文件找不到的时候，把XHNewsFramework.framework拖出工程，然后再拖进来，这样就不会报错了，因为github上传后所引起的，具体操作可以看fixTheHeadError.gif文件，会教你怎么做。
#import <XHNewsFramework/XHNewsContainerViewController.h>
#import "News.h"
#import "MBProgressHUD.h"
#import<SystemConfiguration/SCNetworkReachability.h>


@interface NewsViewController : XHNewsContainerViewController<XHContentViewRefreshingDelegate>{
    
    NSMutableArray *lefttypeArray;//左侧菜单
    NSMutableArray *typetypeArray;//新闻类型
    NSMutableArray *typeArray;//新闻类型标题
    NSMutableArray *typeidArray;//新闻类别id
    NSMutableArray *pageArray;//页数
    NSMutableArray *maxpageArray;//最大页数
    
    NSString *currtypeid;//当前类别id
    int currleftindex;//当前左侧菜单
    UIScrollView *sv;

}


@property (strong, nonatomic) NSMutableArray *lefttypearray;
@property (strong, nonatomic) NSMutableArray *newstypearray;
@property (strong, nonatomic) NSMutableArray *news;
@property (strong, nonatomic) NSMutableArray *toppicnews;
@property (strong, nonatomic) NSMutableArray *picnews;
@property (nonatomic, retain) News *newsinfo;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;


-(void)reloadContentView:(int)index;

@end
