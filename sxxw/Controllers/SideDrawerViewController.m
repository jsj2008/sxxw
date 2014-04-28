//
//  XHExampleSideDrawerViewController.m
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//
#import "UIViewController+RESideMenu.h"
#import "SideDrawerViewController.h"
#import "RESideMenu.h"
#import "LefttypeDB.h"
#import "Lefttype.h"
#import "NewsViewController.h"
#import <XHNewsFramework/XHParallaxNavigationController.h>
#import "LeftTeableCell.h"
#import "Util.h"

@interface SideDrawerViewController (){
    UIButton *closeButton;
}
@end

@implementation SideDrawerViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataSource =[LefttypeDB fetchLefttype];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"lefttablecellIdentifier";
    
    LeftTeableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LeftTableCell" owner:self options:nil] lastObject];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell title] setTextColor:[UIColor whiteColor]];
    Lefttype *_lefttype = [self dataSource][[indexPath row]];
    [[cell title] setText:_lefttype.name];
    
    if ([_lefttype.name isEqualToString:@"集团新闻"]) {
        [[cell titleimg] setImage:[UIImage imageNamed:@"sidebar_nav_news"]];
    }else if([_lefttype.name isEqualToString:@"三峡水情"]){
        [[cell titleimg] setImage:[UIImage imageNamed:@"sidebar_nav_photo"]];
    }else if([_lefttype.name isEqualToString:@"专题报道"]){
        [[cell titleimg] setImage:[UIImage imageNamed:@"sidebar_nav_comment"]];
    }else if([_lefttype.name isEqualToString:@"党建工作"]){
        [[cell titleimg] setImage:[UIImage imageNamed:@"sidebar_nav_reading"]];
    }
    UIColor *color = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.8];
    [cell setSelectedBackgroundView:[UIView new]];
    cell.selectedBackgroundView.backgroundColor = color;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Lefttype *_lefttype = [self dataSource][[indexPath row]];
    if ([indexPath row] == 1) {
        if (_lefttype.url) {
            [self ShowPopupWindow:_lefttype.url];
        }
    }else{
        XHParallaxNavigationController *vc = (XHParallaxNavigationController *)self.sideMenuViewController.contentViewController;
        NewsViewController *newsViewController = [vc.childViewControllers objectAtIndex:0];
        [self.sideMenuViewController setContentViewController:vc];
        [self.sideMenuViewController hideMenuViewController];
        [newsViewController reloadContentView:[indexPath row]];
    }
}

-(void)ShowPopupWindow:(NSString *)url{
    
    
    
    //[MTPopupWindow showWindowWithHTMLFile:@"more.html"];
    //创建UIWebView
    closeButton= [[UIButton alloc] initWithFrame:CGRectMake(285, 5, 30, 30)];
    [closeButton addTarget:self action:@selector(ClosePopupW:) forControlEvents:UIControlEventTouchUpInside];
    
    // [button setBackgroundColor:[UIColor redColor]];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];;
    
    UIWebView *WebView = [[UIWebView alloc] initWithFrame:CGRectMake(1, 15, self.view.frame.size.width-31, self.view.frame.size.height-50)];
    //[WebView setUserInteractionEnabled:NO];
    [WebView setBackgroundColor:[UIColor clearColor]];
    //[WebView setDelegate:self];
    //[WebView setOpaque:NO];//使网页透明
    
    //去掉头尾边框
    for (UIView *subView in [WebView subviews]){
        if ([subView isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in [subView subviews]){
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    //WebView.scalesPageToFit = YES;
    [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: url]]];
    //NSURL *theurl = [NSURL URLWithString:@"http://weyida.com/tgnews/news/china/2012-12-10/69.html"];
    // [_webView loadRequest:[NSURLRequest requestWithURL:theurl]];
    // [WebView loadHTMLString:@"<html><body><h1 style='color:red;'>水电费水电费水电费</h1></body></html>" baseURL:nil];
    
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, self.view.frame.size.height-30)];
    [view setTag:2014];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:1];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [view addSubview:WebView];
    [self.sideMenuViewController.view addSubview:view];
    [self.sideMenuViewController.view addSubview:closeButton];
    
    if (![Util connectedToNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:WebView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络无连接，请稍后再试。";
        hud.margin = 10.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }
}

-(void)ClosePopupW:(UIButton*)sender{
    //关闭
    UIView *view = (UIView*)[self.sideMenuViewController.view viewWithTag:2014];
    [view removeFromSuperview];
    [closeButton removeFromSuperview];
}

@end
