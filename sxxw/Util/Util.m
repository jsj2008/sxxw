//
//  Util.m
//  sxxw
//
//  Created by tw on 14-1-3.
//  Copyright (c) 2014年 com.tght. All rights reserved.
//

#import "Util.h"
#import "TFHpple.h"
#import "TgnewstypeDB.h"
#import "LefttypeDB.h"
#import "Newstype.h"
#import "Lefttype.h"

@implementation Util


// 存储在用户缺省存储（NSUserDefaults）中更新时间的标识符
static NSString * const kLastNewsTypeUpdate = @"LastNewsTypeUpdate";
static NSString * const LastLeftTypeUpdate = @"LastLeftTypeUpdate";
// 获取排行榜的 RSS 种子的更新频率，单位：秒
static NSTimeInterval const kRefreshTimeInterval = 60;
// 获取侧边栏列表数据
+(Lefttype *) getLastLefttype{
    Lefttype *temp = nil;
    NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:LastLeftTypeUpdate];
    if (lastUpdate == nil || -[lastUpdate timeIntervalSinceNow] > kRefreshTimeInterval) {
        NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.weyida.com/news/leftmu.html"]];
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements  = [xpathParser search:@"//a"];
        NSArray *elements2  = [xpathParser search:@"//span"];
        if([elements count]>0&&[elements count]==[elements2 count]){
             [LefttypeDB deleteLefttype];
            for(int i = 0; i < [elements count]; i++)
            {
                TFHppleElement *element = [elements objectAtIndex:i];
                TFHppleElement *element2= [elements2 objectAtIndex:i];
                NSDictionary *aAttributeDict = [element attributes];
                NSString *temptitle =   [element2 content];
                NSString *temphref =  [aAttributeDict objectForKey:@"href"];
                NSString *tempcode =  [aAttributeDict objectForKey:@"code"];
                NSString *temptype =  [aAttributeDict objectForKey:@"type"];
                if(temptitle.length>0&&temphref.length>0){
                    //NSString *tempcode = [temphref substringFromIndex:29];
                    Lefttype *_lefttype = [[Lefttype alloc] init];
                    _lefttype.name = temptitle;
                    _lefttype.code = tempcode;
                    _lefttype.type = temptype;
                    _lefttype.url = temphref;
                    [LefttypeDB addLefttype:_lefttype];
                    if(i==0){
                         temp =_lefttype;
                    }
                    _lefttype = nil;
                }
            }
        }
        
        // 记录排行榜的最后一次保存到Core Data的时间。程序每次运行时，用来判断是否要更新排行榜。
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LastLeftTypeUpdate];
    }
    return temp;
}
// 获取大项下栏目数据
+(void) getLastNewstype: (Lefttype *) _lefttype{
       NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastNewsTypeUpdate];
    if (lastUpdate == nil || -[lastUpdate timeIntervalSinceNow] > kRefreshTimeInterval) {
         NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_lefttype.url]];
         TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements  = [xpathParser search:@"//a"];
        NSArray *elements2  = [xpathParser search:@"//span"];
          if([elements count]>0&&[elements count]==[elements2 count]){
             [TgnewstypeDB deleteNewstype:_lefttype.code];
            for(int i = 0; i < [elements count]; i++)
            {
                TFHppleElement *element = [elements objectAtIndex:i];
                TFHppleElement *element2= [elements2 objectAtIndex:i];
                NSDictionary *aAttributeDict = [element attributes];
                NSString *temptitle =   [element2 content];
                NSString *temphref =  [aAttributeDict objectForKey:@"href"];
                NSString *tempcode =  [aAttributeDict objectForKey:@"code"];
                NSString *temptype =  [aAttributeDict objectForKey:@"type"];
                NSString *temparctypeid =  [aAttributeDict objectForKey:@"id"];
                
                if(temptitle.length>0&&temphref.length>0){
                  //  NSString *tempcode = [temphref substringFromIndex:29];
                    Newstype *_newstype = [[Newstype alloc] init];
                    _newstype.name = temptitle;
                    _newstype.code = tempcode;
                    _newstype.pcode = _lefttype.code;
                    _newstype.url = temphref;
                    _newstype.type = temptype;
                    _newstype.arctypeid = temparctypeid;
                    [TgnewstypeDB addNewstype:_newstype];
                    _newstype = nil;
                    
                }
            }
        }
        
        // 记录排行榜的最后一次保存到Core Data的时间。程序每次运行时，用来判断是否要更新排行榜。
        // [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastNewsTypeUpdate];
    }

}

+ (BOOL)connectedToNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}
@end
