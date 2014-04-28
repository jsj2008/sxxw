//
//  HttpService.m
//  sxxw
//
//  Created by haidony on 14-4-21.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService

static HttpService *engine;
//static NSString * const HOST_URL = @"192.168.2.4";
static NSString * const HOST_URL = @"www.weyida.com";

+(HttpService*) shareEngine{
    @synchronized(self){
        if(engine == nil){
            engine = [[self alloc] initWithHostName:HOST_URL];
            //HOST——URL是被发送请求的主机地址
        }
    }
    return engine;
}

@end
