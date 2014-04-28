//
//  XHNeteaseNewsViewController.m
//  XHNewsFrameworkExample
//
//  Created by 曾 宪华 on 14-1-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "NewsViewController.h"
#import <XHNewsFramework/XHMenu.h>
#import <XHNewsFramework/XHScrollBannerView.h>

#import "LefttypeDB.h"
#import "Lefttype.h"
#import "TgnewstypeDB.h"
#import "Newstype.h"
#import "TgnewsDB.h"
#import "TFHpple.h"
#import "TableCell.h"
#import "TableCell3.h"
#import "TableCell4.h"
#import "MoreCell.h"
#import "NewsDetailViewController.h"
#import "Util.h"
#import "HttpService.h"
#import "RESideMenu.h"
#import "UIImageView+WebCache.h"

@interface NewsViewController (){
    TableCell3 *cell3;
}
@end

@implementation NewsViewController
@synthesize news = _news;
@synthesize toppicnews = _toppicnews;
@synthesize picnews = _picnews;
@synthesize activityIndicator = _activityIndicator;
@synthesize newsinfo = _newsinfo;

// 存储在用户缺省存储（NSUserDefaults）中更新时间的标识符
static NSString * const kLastStoreUpdateKey = @"LastStoreUpdate";
// 获取排行榜的 RSS 种子的更新频率，单位：秒
static NSTimeInterval const kRefreshTimeInterval = 60*60*12;


#pragma mark -
- (id)init {
    self = [super init];
	if (self) {
        // custom UI
        /*
         self.topScrollViewToolBarBackgroundColor = [UIColor colorWithRed:0.362 green:0.555 blue:0.902 alpha:1.000];
         self.leftShadowImage = [UIImage imageNamed:@"leftShadow"];
         self.rightShadowImage = [UIImage imageNamed:@"rightShadow"];
         self.indicatorColor = [UIColor colorWithRed:0.219 green:0.752 blue:0.002 alpha:1.000];
         self.managerButtonBackgroundImage = [UIImage imageNamed:@"managerMenuButton"];
         
         self.midContentLogoImage = [UIImage imageNamed:@"logo"];
         self.contentScrollViewBackgroundColor = [UIColor colorWithRed:1.000 green:0.724 blue:0.640 alpha:1.000];
         */
        self.isShowManagerButton = YES;
        //顶部左侧按钮
        UIButton *topLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topLeftButton.frame = CGRectMake(0.0, 0.0, 45.0, 44.0);
        [topLeftButton setImage:[UIImage imageNamed:@"top_navigation_menuicon"] forState:UIControlStateNormal];
        [topLeftButton addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topLeftButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
        
        
        //导航栏颜色
        UIColor *color1 = [UIColor colorWithRed:179.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1];
        
//        color1 = [UIColor blueColor];
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
            [[UINavigationBar appearance]setTintColor:color1];
        }else {
            [[UINavigationBar appearance] setBarTintColor:color1];
            [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
        }
        
        self.title = @"三峡新闻";
        
        [self initLefttype];
        [self initNewstype];
        [self loadDataSource];
        
    }
	return self;
}

-(void)reloadContentView:(int)index{
    currleftindex = index;
    [self initNewstype];
    [self loadDataSource];
    [self reloadDataSource];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)left {
    [self.sideMenuViewController presentMenuViewController];
    
    
}

- (void)receiveScrollViewPanGestureRecognizerHandle:(UIPanGestureRecognizer *)scrollViewPanGestureRecognizer {
    [self.sideMenuViewController panGestureRecognized:scrollViewPanGestureRecognizer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [_activityIndicator setCenter:self.view.center];
    }else{
        [_activityIndicator setCenter:CGPointMake(self.view.center.x, self.view.center.y-40)];
    }
    
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    
    //如果设备无网络
    if (![Util connectedToNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络无连接，离线模式。";
        hud.margin = 10.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - contentView refreshControl delegate

- (void)pullDownRefreshingAction:(XHContentView *)contentView {
    [_activityIndicator startAnimating];
    [self loadNews];
    [contentView performSelector:@selector(endPullDownRefreshing) withObject:nil afterDelay:0];
}

- (void)pullUpRefreshingAction:(XHContentView *)contentView {
    [contentView performSelector:@selector(endPullUpRefreshing) withObject:nil afterDelay:3];
}

//contentViews代理
#pragma mark - contentViews delegate/datasource

- (NSInteger)numberOfContentViews {
	long numberOfPanels = [self.items count];
	return numberOfPanels;
}

- (NSInteger)contentView:(XHContentView *)contentView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section {
    XHMenu *item = [self.items objectAtIndex:page];
    if (contentView.tableView.tag == 1) {
        return [item.dataSources count]+1-2;
    }else{
        if ([item.dataSources count] > 0) {
            return [item.dataSources count]+1;
        }else{
            return 0;
        }
        
    }

}

- (UITableViewCell *)contentView:(XHContentView *)contentView cellForRowAtIndexPath:(XHPageIndexPath *)indexPath {
	//定义灰色
    UIColor *color = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    XHMenu *menu = [self.items objectAtIndex:indexPath.page];
    if (contentView.tableView.tag != 1) {//普通新闻
        if ([menu.dataSources count] != 0 && [menu.dataSources count] == indexPath.row) {
            static NSString *moreCellIdentifier = @"moreCellIdentifier";
            MoreCell *moreCell = [contentView.tableView dequeueReusableCellWithIdentifier:moreCellIdentifier];
            if (moreCell == nil) {
                moreCell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil] lastObject];
            }
            NSNumber *maxpage = [maxpageArray objectAtIndex:indexPath.page];
            NSNumber *page = [pageArray objectAtIndex:indexPath.page];
            if ([page intValue] == [maxpage intValue]) {
                moreCell.lbinfo.text = @"全部加载完毕";
            }else{
                moreCell.lbinfo.text = @"点击加载更多";
            }
            return moreCell;
        }else{
            static NSString *cellIdentifier = @"TableCellIdentifier";
            TableCell *cell = (TableCell *)[contentView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil] lastObject];
            }
            if([menu.dataSources count]>0){
                News *_newEs = [menu.dataSources objectAtIndex:[indexPath row]];
                cell.titlename.text = _newEs.title;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_newEs.datestr longLongValue]];
                NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                NSString * dateStr=[dateformatter stringFromDate:date];
                cell.datestr.text =dateStr;
            }
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = color;
            return cell;
        }
    }else if (contentView.tableView.tag == 1){//图片新闻
        if ([menu.dataSources count] != 0 && [menu.dataSources count]-2 == indexPath.row) {
            static NSString *moreCellIdentifier = @"moreCellIdentifier";
            MoreCell *moreCell = [contentView.tableView dequeueReusableCellWithIdentifier:moreCellIdentifier];
            if (moreCell == nil) {
                moreCell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil] lastObject];
            }
            NSNumber *maxpage = [maxpageArray objectAtIndex:indexPath.page];
            NSNumber *page = [pageArray objectAtIndex:indexPath.page];
            if ([page intValue] == [maxpage intValue]) {
                moreCell.lbinfo.text = @"全部加载完毕";
            }else{
                moreCell.lbinfo.text = @"点击加载更多";
            }
            return moreCell;
        }else if(0==[indexPath row]){//图片新闻第一个单元格，滑动图片，初始化TableCell3
            static NSString *CellIdentifier = @"TableCellIdentifier3";
            cell3 = (TableCell3 *)[contentView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell3 == nil) {
                cell3 = [[[NSBundle mainBundle] loadNibNamed:@"TableCell3" owner:self options:nil] lastObject];
            }
            if([_toppicnews count]>0){
                sv = [cell3 getSv:_toppicnews];
                sv.delegate = self;
                UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectedCell:)];
                tap1.cancelsTouchesInView = NO;
                [cell3 addGestureRecognizer:tap1];
            }
            return cell3;
        }else{//图片新闻非第一个单元格，初始化TableCell4
            static NSString *CellIdentifier = @"TableCellIdentifier4";
            TableCell4 *cell4 = (TableCell4 *)[contentView.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (cell4 == nil) {
                cell4 = [[[NSBundle mainBundle] loadNibNamed:@"TableCell4" owner:self options:nil] lastObject];
            }
            if([menu.dataSources count]>0&&[menu.dataSources count]>(3+[indexPath row]-1)){
                News *_newEs = [menu.dataSources objectAtIndex:(3+[indexPath row]-1)];
                cell4.titlename2.text = _newEs.title;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_newEs.datestr longLongValue]];
                NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                NSString * dateStr=[dateformatter stringFromDate:date];
                cell4.datestr2.text = dateStr;
                
                if (!_newEs.titleimg || [_newEs.titleimg isEqualToString:@""]) {
                    _newEs.titleimg = @"/news/images/defaultpic.gif";
                }
                NSString *temp = [@"http://weyida.com" stringByAppendingString:_newEs.titleimg];
                [cell4.imageview setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"defaultpic.gif"] ];
            }
            cell4.selectedBackgroundView = [[UIView alloc] initWithFrame:cell4.frame];
            cell4.selectedBackgroundView.backgroundColor = color;
            return cell4;
        }
    }else{
        static NSString *CellIdentifier = @"tempTableCellIdentifier";
        UITableViewCell *cell = [contentView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]init];
        }
        return cell;
    }
}

- (void)contentView:(XHContentView *)contentView didSelectRowAtIndexPath:(XHPageIndexPath *)indexPath {
    XHMenu *menu = [self.items objectAtIndex:indexPath.page];
    
    if (contentView.tableView.tag != 1) {
        //点击加载更多
        if ([menu.dataSources count] == indexPath.row) {
            NSIndexPath *nsindexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self performSelectorInBackground:@selector(loadMore) withObject:nil];
            [contentView.tableView deselectRowAtIndexPath:nsindexpath animated:YES];
        }else{
            _newsinfo =  [menu.dataSources objectAtIndex:indexPath.row];
            [self loadNewsDetail:_newsinfo.newsid];
        }
    }else if(contentView.tableView.tag == 1){//图片新闻
        //点击加载更多
        if ([menu.dataSources count]-2 == indexPath.row) {
            NSIndexPath *nsindexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self performSelectorInBackground:@selector(loadMore) withObject:nil];
            [contentView.tableView deselectRowAtIndexPath:nsindexpath animated:YES];
        }else{
            if(contentView.tableView.tag==1){
                _newsinfo =  [menu.dataSources objectAtIndex:(3+[indexPath row]-1)];
            }
            [self loadNewsDetail:_newsinfo.newsid];
        }
    }
}

//图片新闻，第一个单元格，点击打开图片新闻事件
-(void)doSelectedCell:(UITapGestureRecognizer*)sender{
    _newsinfo = [_toppicnews objectAtIndex: sv.contentOffset.x/320];
    [self loadNewsDetail:_newsinfo.newsid];
    
}





- (XHContentView *)contentViewForPage:(NSInteger)page {
    XHContentView *contentView;
    NSString *type = [typetypeArray objectAtIndex:page];
    if ([type isEqualToString:@"text"]) {
        static NSString *identifier = @"XHContentView";
        contentView = (XHContentView *)[self dequeueReusablePageWithIdentifier:identifier];
        if (contentView == nil) {
            contentView = [[XHContentView alloc] initWithIdentifier:identifier];
            [contentView setPullDownRefreshed:NO];
            [contentView setPullUpRefreshed:NO];
            contentView.refreshControlDelegate = self;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
                contentView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
    }else if([type isEqualToString:@"pic"]){
        static NSString *identifier = @"XHContentViewForPic";
        contentView = (XHContentView *)[self dequeueReusablePageWithIdentifier:identifier];
        if (contentView == nil) {
            contentView = [[XHContentView alloc] initWithIdentifier:identifier];
            [contentView setPullDownRefreshed:NO];
            [contentView setPullUpRefreshed:NO];
            contentView.refreshControlDelegate = self;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
                contentView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
    }
    XHMenu *item = [self.items objectAtIndex:page];
    if ([item.dataSources count] > 0) {
        [contentView setPullDownRefreshed:YES];
    }else{
        [contentView setPullDownRefreshed:NO];
    }
	return contentView;
}

- (CGFloat)contentView:(XHContentView *)contentView heightForRowAtIndexPath:(XHPageIndexPath *)indexPath {
    XHMenu *menu = [self.items objectAtIndex:indexPath.page];
    if (contentView.tableView.tag == 1) {//图片新闻
        if ([menu.dataSources count]-2 == indexPath.row) {
            return 50;
        }else if(0==[indexPath row]){
            return 191;
        }else {
            return 75;
        }
    }else{
        if ([menu.dataSources count] == indexPath.row) {
            return 50;
        }else {
            return 55;
        }
    }
}



- (void)goToContentView:(NSInteger)index{
    if (index >= [self.items count]) {
        index = 0;
    }
    [super goToContentView:index];
    XHMenu *menu = [self.items objectAtIndex:self.currentPage];
    if ([menu.dataSources count] == 0) {
        [_activityIndicator startAnimating];
        [self loadNews];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == sv) {
        [cell3 setstatus:sv];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [super scrollViewDidEndDecelerating:scrollView];
    XHMenu *menu = [self.items objectAtIndex:self.currentPage];
    if ([menu.dataSources count] == 0) {
        [_activityIndicator startAnimating];
        [self loadNews];
    }
}



#pragma mark - init
// 从数据库读取所有侧边栏
- (void) initLefttype{
    self.lefttypearray =  [LefttypeDB fetchLefttype];
}
// 从数据库读取所有新闻类型
- (void) initNewstype{
    
    Lefttype *temptype = [self.lefttypearray objectAtIndex:currleftindex];
    [Util getLastNewstype:temptype];
    self.newstypearray =  [TgnewstypeDB fetchNewstype:temptype.code];
    typetypeArray=[[NSMutableArray alloc] init];//类型
    typeArray=[[NSMutableArray alloc] init];//类型标题
    typeidArray = [[NSMutableArray alloc] init];//类型id
    pageArray = [[NSMutableArray alloc] init];//页数
    maxpageArray = [[NSMutableArray alloc] init];//最大页
    
    for (Newstype *newstype in self.newstypearray) {
        NSString *name  = newstype.name;
        NSString *type = newstype.type;
        NSString *typeid = newstype.arctypeid;
        [typetypeArray addObject:type];
        [typeArray addObject:name];
        [typeidArray addObject:typeid];
        [pageArray addObject:[NSNumber numberWithInt:1]];
        [maxpageArray addObject:[NSNumber numberWithInt:1]];
    }
    if ([typeidArray count] > 0) {
        currtypeid = [typeidArray objectAtIndex:0];
    }

}

- (void)loadDataSource {
    NSMutableArray *items = [NSMutableArray new];
    for (int i = 0; i < typeArray.count; i++) {
        XHMenu *item = [[XHMenu alloc] init];
        NSString *title;
        title = [typeArray objectAtIndex:i];
        item.title = title;
        item.titleNormalColor = [UIColor colorWithWhite:0.141 alpha:1.000];
        item.titleFont = [UIFont boldSystemFontOfSize:16];
        [items addObject:item];
    }
    self.items = items;
    
}


// 从数据库读取所有新闻
- (void) loadNews{
    
    currtypeid = [typeidArray objectAtIndex:self.currentPage];
    NSString *type = [typetypeArray objectAtIndex:self.currentPage];
    
    [pageArray replaceObjectAtIndex:self.currentPage withObject:[NSNumber numberWithInt:1]];
    NSString *temp =@"text";
    NSString *temp2 = @"pic";
    XHContentView *contentView = [self contentViewAtPage:self.currentPage];
    XHMenu *item = [self.items objectAtIndex:self.currentPage];
    if([type isEqualToString:temp]){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"archives" forKey:@"domethod"];
        [params setObject:currtypeid forKey:@"typeid"];
        [params setObject:@"1" forKey:@"page"];
        [params setObject:@"10" forKey:@"pagesize"];
        MKNetworkOperation *op  = [[HttpService shareEngine] operationWithPath:@"news/news.php" params:params httpMethod:@"GET"];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSDictionary *result = [completedOperation responseJSON];
            int count = [[result valueForKey:@"num"] intValue];
            int maxpage = count%10 == 0 ? count/10 : count/10+1;
            [maxpageArray replaceObjectAtIndex:self.currentPage withObject:[NSNumber numberWithInt:maxpage]];
            NSArray *list = [result valueForKey:@"list"];
            _news = [[NSMutableArray alloc]init];
            for (int i = 0 ; i< list.count; i++) {
                NSDictionary *temp = [list objectAtIndex:i];
                NSString *newsid = [temp valueForKey:@"id"];
                NSString *title = [temp valueForKey:@"title"];
                NSString *datestr = [temp valueForKey:@"pubdate"];
                NSString *arctypeid = [temp valueForKey:@"typeid"];
                NSString *titleimg = [temp valueForKey:@"litpic"];
                News *_new = [[News alloc] init];
                _new.newsid = newsid;
                _new.title = title;
                _new.datestr = datestr;
                _new.arctypeid = arctypeid;
                _new.titleimg = titleimg;
                [TgnewsDB addNews:_new];
                [_news addObject:_new];
            }
            item.dataSources = _news;
            contentView.tableView.tag = 0;
            [contentView.tableView reloadData];
            [_activityIndicator stopAnimating];
            if (!contentView.pullDownRefreshed && [item.dataSources count] > 0) {
                [contentView setPullDownRefreshed:YES];
            }
        }
        errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            
            NSLog(@"连接超时,本地查询");
            _news = [[NSMutableArray alloc]init];
            _news = [TgnewsDB fetchNews:currtypeid page:1];
            int count = [TgnewsDB fetchNewsCount:currtypeid];
            int maxpage = count%10 == 0 ? count/10 : count/10+1;
            [maxpageArray replaceObjectAtIndex:self.currentPage withObject:[NSNumber numberWithInt:maxpage]];
            item.dataSources = _news;
            contentView.tableView.tag = 0;
            [contentView.tableView reloadData];
            [_activityIndicator stopAnimating];
            if (!contentView.pullDownRefreshed && [item.dataSources count] > 0) {
                [contentView setPullDownRefreshed:YES];
            }
        }];
        [[HttpService shareEngine] enqueueOperation:op];
    }else if([type isEqualToString:temp2]){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"archives" forKey:@"domethod"];
        [params setObject:currtypeid forKey:@"typeid"];
        [params setObject:@"1" forKey:@"page"];
        [params setObject:@"10" forKey:@"pagesize"];
        MKNetworkOperation *op  = [[HttpService shareEngine] operationWithPath:@"news/news.php" params:params httpMethod:@"GET"];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSDictionary *result = [completedOperation responseJSON];
            
            int count = [[result valueForKey:@"num"] intValue];
            int maxpage = count%10 == 0 ? count/10 : count/10+1;
            [maxpageArray replaceObjectAtIndex:self.currentPage withObject:[NSNumber numberWithInt:maxpage]];
            NSArray *list = [result valueForKey:@"list"];
            
            _picnews = [[NSMutableArray alloc]init];
            _toppicnews = [[NSMutableArray alloc]init];
            for (int i = 0 ; i< list.count; i++) {
                
                NSDictionary *temp = [list objectAtIndex:i];
                
                NSString *newsid = [temp valueForKey:@"id"];
                NSString *title = [temp valueForKey:@"title"];
                NSString *datestr = [temp valueForKey:@"pubdate"];
                NSString *arctypeid = [temp valueForKey:@"typeid"];
                NSString *titleimg = [temp valueForKey:@"litpic"];
                
                News *_new = [[News alloc] init];
                _new.newsid = newsid;
                _new.title = title;
                _new.datestr = datestr;
                _new.arctypeid = arctypeid;
                _new.titleimg = titleimg;
                [TgnewsDB addNews:_new];
                if (i<3 && _toppicnews.count <=3) {
                    [_toppicnews addObject:_new];
                }
                [_picnews addObject:_new];
            }
            item.dataSources = _picnews;
            contentView.tableView.tag = 1;
            [contentView.tableView reloadData];
            [_activityIndicator stopAnimating];
            if (!contentView.pullDownRefreshed && [item.dataSources count] > 0) {
                [contentView setPullDownRefreshed:YES];
            }
            
        }
        errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            
            NSLog(@"连接超时,本地查询");
            _picnews = [[NSMutableArray alloc]init];
            _toppicnews = [[NSMutableArray alloc]init];
            _toppicnews = [TgnewsDB fetchpicNews:currtypeid];
            _picnews = [TgnewsDB fetchNews:currtypeid page:1];
            
            int count = [TgnewsDB fetchNewsCount:currtypeid];
            int maxpage = count%10 == 0 ? count/10 : count/10+1;
            [maxpageArray replaceObjectAtIndex:self.currentPage withObject:[NSNumber numberWithInt:maxpage]];
            item.dataSources = _picnews;
            contentView.tableView.tag = 1;
            [contentView.tableView reloadData];
            [_activityIndicator stopAnimating];
            if (!contentView.pullDownRefreshed && [item.dataSources count] > 0) {
                [contentView setPullDownRefreshed:YES];
            }
            
            
        }];
        [[HttpService shareEngine] enqueueOperation:op];
    }
}

//点击加载更多
-(void)loadMore{
    
    currtypeid = [typeidArray objectAtIndex:self.currentPage];
    NSString *type = [typetypeArray objectAtIndex:self.currentPage];
    NSNumber *page = [pageArray objectAtIndex:self.currentPage];
    page = [NSNumber numberWithInt:[page intValue]+1];
    NSNumber *maxpage = [maxpageArray objectAtIndex:self.currentPage];
    NSString *temp =@"text";
    NSString *temp2 = @"pic";
    XHContentView *contentView = [self contentViewAtPage:self.currentPage];
    XHMenu *item = [self.items objectAtIndex:self.currentPage];
    
    if ([page intValue] <= [maxpage intValue]) {
        [_activityIndicator startAnimating];
        [pageArray replaceObjectAtIndex:self.currentPage withObject:page];
        if([type isEqualToString:temp]){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"archives" forKey:@"domethod"];
            [params setObject:currtypeid forKey:@"typeid"];
            [params setObject:page forKey:@"page"];
            [params setObject:@"10" forKey:@"pagesize"];
            MKNetworkOperation *op  = [[HttpService shareEngine] operationWithPath:@"news/news.php" params:params httpMethod:@"GET"];
            
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                NSDictionary *result = [completedOperation responseJSON];
                NSArray *list = [result valueForKey:@"list"];
                _news = [[NSMutableArray alloc]init];
                for (int i = 0 ; i< list.count; i++) {
                    NSDictionary *temp = [list objectAtIndex:i];
                    NSString *newsid = [temp valueForKey:@"id"];
                    NSString *title = [temp valueForKey:@"title"];
                    NSString *datestr = [temp valueForKey:@"pubdate"];
                    NSString *arctypeid = [temp valueForKey:@"typeid"];
                    NSString *titleimg = [temp valueForKey:@"litpic"];
                    News *_new = [[News alloc] init];
                    _new.newsid = newsid;
                    _new.title = title;
                    _new.datestr = datestr;
                    _new.arctypeid = arctypeid;
                    _new.titleimg = titleimg;
                    [TgnewsDB addNews:_new];
                    [_news addObject:_new];
                }
                [item.dataSources addObjectsFromArray:_news];
                contentView.tableView.tag = 0;
                [contentView.tableView reloadData];
                [_activityIndicator stopAnimating];
            }
            errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                _news = [[NSMutableArray alloc]init];
                _news = [TgnewsDB fetchNews:currtypeid page:[page intValue]];
                [item.dataSources addObjectsFromArray: _news];
                contentView.tableView.tag = 0;
                [contentView.tableView reloadData];
                [_activityIndicator stopAnimating];
            }];
            [[HttpService shareEngine] enqueueOperation:op];
        }else if([type isEqualToString:temp2]){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"archives" forKey:@"domethod"];
            [params setObject:currtypeid forKey:@"typeid"];
            [params setObject:page forKey:@"page"];
            [params setObject:@"10" forKey:@"pagesize"];
            MKNetworkOperation *op  = [[HttpService shareEngine] operationWithPath:@"news/news.php" params:params httpMethod:@"GET"];
            
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                NSDictionary *result = [completedOperation responseJSON];
                NSArray *list = [result valueForKey:@"list"];
                
                _picnews = [[NSMutableArray alloc]init];
                
                for (int i = 0 ; i< list.count; i++) {
                    
                    NSDictionary *temp = [list objectAtIndex:i];
                    NSString *newsid = [temp valueForKey:@"id"];
                    NSString *title = [temp valueForKey:@"title"];
                    NSString *datestr = [temp valueForKey:@"pubdate"];
                    NSString *arctypeid = [temp valueForKey:@"typeid"];
                    NSString *titleimg = [temp valueForKey:@"litpic"];
                    
                    News *_new = [[News alloc] init];
                    _new.newsid = newsid;
                    _new.title = title;
                    _new.datestr = datestr;
                    _new.arctypeid = arctypeid;
                    _new.titleimg = titleimg;
                    [TgnewsDB addNews:_new];
                    [_picnews addObject:_new];
                }
                [item.dataSources addObjectsFromArray:_picnews];
                contentView.tableView.tag = 1;
                [contentView.tableView reloadData];
                [_activityIndicator stopAnimating];
            }
            errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                _picnews = [[NSMutableArray alloc]init];
                _picnews = [TgnewsDB fetchNews:currtypeid page:[page intValue]];
                [item.dataSources addObjectsFromArray:_picnews];
                contentView.tableView.tag = 1;
                [contentView.tableView reloadData];
                [_activityIndicator stopAnimating];
            }];
            [[HttpService shareEngine] enqueueOperation:op];
            
        }
    }else{
        NSLog(@"没有更多数据了");
    }
}

//新闻详情
-(void)loadNewsDetail:(NSString *)newsid{
    NewsDetailViewController *detailvc = [[NewsDetailViewController alloc] init];
    XHMenu *menu = [self.items objectAtIndex:self.currentPage];
    detailvc.title = menu.title;
    [self.navigationController pushViewController:detailvc animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:newsid forKey:@"aid"];
    [params setObject:@"article" forKey:@"domethod"];
    MKNetworkOperation *op  = [[HttpService shareEngine] operationWithPath:@"news/news.php" params:params httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSArray *result = [completedOperation responseJSON];
        NSString *content = [[result objectAtIndex:0] valueForKey:@"body"];
        [detailvc.DetailWebView loadHTMLString:content baseURL:[NSURL URLWithString:@"http://www.weyida.com"]];
        [TgnewsDB setNewsContent:[newsid intValue] content:content];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        _newsinfo.newsid = newsid;
        _newsinfo = [TgnewsDB getNewsById:_newsinfo];
        [detailvc.DetailWebView loadHTMLString:_newsinfo.content baseURL:[NSURL URLWithString:@"http://www.weyida.com"]];
                    
    }];
    [[HttpService shareEngine] enqueueOperation:op];
}

- (void)didOpenManagerItems{
    NSLog(@"didOpenManagerItems");
}


@end
