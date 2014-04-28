//
//  YGPSegmentedController.m
//  YGPSegmentedSwitch
//
//  Created by yang on 13-6-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SegmentedController.h"
#import "Globle.h"
#import "ConstKEY.h"
//按钮空隙
#define BUTTONGAP 5
//按钮长度
#define BUTTONWIDTH 59
//按钮宽度
#define BUTTONHEIGHT 30
//滑条CONTENTSIZEX
#define CONTENTSIZEX 320

//偏移量
#define Off 200
//选择显示区域（view）
#define SelectVisible (sender.tag-100)
#define initselectedIndex 0

@implementation SegmentedController
{

     int ButtonWidthBackg;
     
     NSMutableArray * _Buutonimage;
     NSMutableArray * _Buutons;
}
@synthesize TitleArray;
@synthesize SegmentedButton;
@synthesize Delegate=_delegate;
@synthesize Textleng;
@synthesize ScrollView;
@synthesize TEXTLENGARRAY;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
         self.frame =CGRectZero;
         ScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        // SelectedTagChang = 1;
       
         [self SetScrollview];     //setup
         [self setSelectedIndex:0];
         
    }
    return self;
}

//初始化框架数据
-(id)initContentTitle:(NSMutableArray*)Title CGRect:(CGRect)Frame
{
    [ScrollView removeFromSuperview];//删除已经有的tab
     if (self = [super init])
     {
          [self addSubview:ScrollView];
          TitleArray = Title ;
          [self setFrame:Frame];
          [ScrollView setFrame:Frame];
          [self setBackgroundColor];
          ScrollView.contentSize = CGSizeMake((BUTTONWIDTH+BUTTONGAP)*[self.TitleArray count]+BUTTONGAP, 40);
          TEXTLENGARRAY = [[NSMutableArray alloc]init];
     }
     //初始化button
     [self initWithButton];
     return self;
}

//设置滚动视图
-(void)SetScrollview
{

     ScrollView.backgroundColor = [UIColor whiteColor];
     ScrollView.pagingEnabled = NO;
     ScrollView.scrollEnabled=YES;
     ScrollView.showsHorizontalScrollIndicator = NO;
     ScrollView.showsVerticalScrollIndicator = NO;
}

//初始化button
-(void)initWithButton
{
    int buttonPadding = 18;
     int xPos =10;
     SegmentedButton.titleLabel.text=nil;
//     NSArray * array = [[NSArray alloc]init];
     NSMutableArray * array2 = [[NSMutableArray alloc]init];
    _Buutons = [[NSMutableArray alloc] init];
     for (int i = 0; i<[self.TitleArray count]; i++)
     {
          
          NSString *title = [TitleArray objectAtIndex:i];
          SegmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
          [SegmentedButton setTitle:[NSString stringWithFormat:@"%@",[self.TitleArray objectAtIndex:i]] forState:UIControlStateNormal];

          int buttonWidth = [title sizeWithFont:SegmentedButton.titleLabel.font
                             constrainedToSize:CGSizeMake(150, 28)
                                  lineBreakMode:NSLineBreakByClipping].width;
         
          [SegmentedButton setFrame:CGRectMake(xPos, 2, buttonWidth+buttonPadding, BUTTONHEIGHT)];
          SegmentedButton.tag=i+100;
          if (i==0)
          {
               SegmentedButton.selected=NO;
          }
          
          [SegmentedButton setTitleColor:[Globle colorFromHexRGB:@"868686"] forState:
           UIControlStateNormal];
          // [SegmentedButton setTitleColor:[Globle colorFromHexRGB:@"bb0b15"] forState:UIControlStateSelected];
         //[SegmentedButton setTitleColor:[Globle colorFromHexRGB:@"3366CC"] forState:UIControlStateSelected];
         
          [SegmentedButton addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
       
         //设置大小 by tw 20131113
         SegmentedButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
           
          xPos += buttonWidth+buttonPadding;
          
          _Buutonimage = [[NSMutableArray alloc]init];
          ButtonWidthBackg=buttonWidth+buttonPadding;
         
          NSString * strings;
          strings = nil;
          strings = [NSString stringWithFormat:@"%f",SegmentedButton.frame.size.width];
          
          [_Buutonimage removeAllObjects];
          [array2 addObject:strings];
          for (NSMutableArray * array3 in array2) {
               [_Buutonimage addObject:array3];
          }
          [_Buutons addObject:SegmentedButton];
          [ScrollView addSubview:SegmentedButton];
     }
     
     //设置选中背景
     ButtonbackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, [[_Buutonimage objectAtIndex:0]floatValue], 33)];
     [ButtonbackgroundImage setImage:[UIImage imageNamed:@"red_background2.png"]];
     [ScrollView addSubview:ButtonbackgroundImage];
}

//点击button调用方法
-(void)SelectButton:(UIButton*)sender
{
      //取消当前选择
     if (sender.tag!=SelectedTagChang)
     {
          UIButton * ALLButton = (UIButton*)[self viewWithTag:SelectedTagChang];
         if ([ALLButton isKindOfClass:[UIButton class]]) {
             ALLButton.selected=NO;
         }
          SelectedTagChang = sender.tag;
     }
    if ([sender isKindOfClass:[UIButton class]]) {
        sender.selected=YES;
    }
    
   
     //button 背景图片
     [UIView animateWithDuration:0.25 animations:^{
          [ButtonbackgroundImage setFrame:CGRectMake(sender.frame.origin.x, 0,[[_Buutonimage objectAtIndex:SelectVisible]floatValue] , 33)];
     } completion:^(BOOL finished){
           [self setSelectedIndex:SelectVisible];
      
       }];

//     NSLog(@"%f",sender.frame.origin.x);
//      [YGPScrollView setContentOffset:CGPointMake(sender.frame.origin.x, 0)];
     float x = ScrollView.contentOffset.x;
     [ScrollView setContentOffset:CGPointMake(x, 0)];
     
     
     //设置居中
     if (sender.frame.origin.x>Off)
     {
          [ScrollView setContentOffset:CGPointMake(sender.frame.origin.x-130, 0) animated:YES]; 
     }

}
//点击button调用方法
-(void)SelectButton2:(NSInteger)selectedIndex  type:(NSInteger)type

{
    UIButton *sender= [_Buutons objectAtIndex:selectedIndex];
    sender.selected = YES;
    
    //button 背景图片
    [UIView animateWithDuration:0.25 animations:^{
        [ButtonbackgroundImage setFrame:CGRectMake(sender.frame.origin.x, 0,[[_Buutonimage objectAtIndex:SelectVisible]floatValue] , 33)];
    } completion:^(BOOL finished){
       // [self setSelectedIndex:SelectVisible];
        
    }];
    
    //     NSLog(@"%f",sender.frame.origin.x);
    //      [YGPScrollView setContentOffset:CGPointMake(sender.frame.origin.x, 0)];
    float x = ScrollView.contentOffset.x;
    [ScrollView setContentOffset:CGPointMake(x, 0)];
    
    
    //设置居中
    if (sender.frame.origin.x>Off)
    {
        [ScrollView setContentOffset:CGPointMake(sender.frame.origin.x-130, 0) animated:YES];
    }else{
          [ScrollView setContentOffset:CGPointMake(sender.frame.origin.x-10, 0) animated:YES];
    }
}
//选择index
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    
     if ([_delegate respondsToSelector:@selector(segmentedViewController:touchedAtIndex:)])
          [_delegate segmentedViewController:self touchedAtIndex:selectedIndex];
}

-(NSInteger)initselectedSegmentIndex
{
     //初始化为（0）
     return initselectedIndex;
}

-(void)setBackgroundColor
{
     //为了区别Tab和View的颜色 
     self.backgroundColor = [UIColor grayColor];
     ScrollView.alpha = 0.9;

}
@end
