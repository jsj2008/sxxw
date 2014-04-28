//
//  NewsDetailViewController.h
//  sxxw2
//
//  Created by haidony on 14-4-10.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *DetailWebView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
