//
//  NewsDetailViewController.m
//  sxxw2
//
//  Created by haidony on 14-4-10.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize activityIndicator = _activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self.navigationItem setHidesBackButton:YES];

        
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0.0, 0.0, 45.0, 44.0);
//        [backButton setImage:[UIImage imageNamed:@"contenttoolbar_hd_back_light"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
//        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
//        [temporaryBarButtonItem release];
        
        
    }
    return self;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _DetailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    }else{
        _DetailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    }
    
    
    
    _DetailWebView.delegate = self;
    _DetailWebView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_DetailWebView];
    
    
    //去掉头尾边框
    for (UIView *subView in [_DetailWebView subviews]){
        if ([subView isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in [subView subviews]){
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:_DetailWebView.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  
    [_activityIndicator stopAnimating];
    //修改服务器页面的meta的值
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", _DetailWebView.frame.size.width];
    [_DetailWebView stringByEvaluatingJavaScriptFromString:meta];
    //给网页增加utf-8编码
    [_DetailWebView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagMeta = document.createElement(\"meta\");"
     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    //给网页增加css样式
    [_DetailWebView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 5pt 12pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    //拦截网页图片  并修改图片大小
    [_DetailWebView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=280;" //缩放系数
     "var maxheight =145;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = maxheight;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    //"myimg.height = myimg.height * (maxwidth/oldwidth)+10;"
    
    [_DetailWebView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    /* NSString *res = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('table')[33].innerHTML; "] ;
     NSLog(@"---%@",res);*/
    //  [webView loadHTMLString:res baseURL:nil];
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [_DetailWebView stringByEvaluatingJavaScriptFromString:str];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
