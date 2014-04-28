//
//  HttpService.h
//  sxxw
//
//  Created by haidony on 14-4-21.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "News.h"

@interface HttpService : MKNetworkEngine

+(HttpService*) shareEngine;


@end
