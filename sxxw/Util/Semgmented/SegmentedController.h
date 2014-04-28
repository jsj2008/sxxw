//
//  SegmentedController.h
//  SegmentedSwitch
//
//  Created by yang on 13-6-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentedController;
@protocol SegmentedControllerDelegate <NSObject>
@optional
- (void)segmentedViewController:(SegmentedController *)segmentedControl touchedAtIndex:(NSUInteger)index;

@end



@interface SegmentedController : UIView

{
     
     UIImageView *ButtonbackgroundImage;    //选中时背景视图
     NSInteger    SelectedTagChang;              //选择tag

}
@property (assign, nonatomic) id<SegmentedControllerDelegate>Delegate;

@property (strong, nonatomic) NSMutableArray  * TitleArray;     //按钮title
@property (strong, nonatomic) UIButton * SegmentedButton;       //button
@property (strong, nonatomic) UIScrollView * ScrollView;     //滚动视图
@property (assign, nonatomic) NSUInteger  Textleng;
@property (strong, nonatomic) NSMutableArray * TEXTLENGARRAY;
/*
 初始化方法
 title 传入button的title（NSArray）
 Frame 设置view的框架
 */
-(id)initContentTitle:(NSArray*)Title CGRect:(CGRect)Frame;

//初始化选择indx （0）
/*由于技术原因在初始选择时请调用次方法
 此方法初始值为0*/
-(NSInteger)initselectedSegmentIndex;
-(void)SelectButton:(UIButton*)sender;
//设置背景颜色
-(void)setBackgroundColor;
-(void)SelectButton2:(NSInteger)selectedIndex  type:(NSInteger)type;
@end
