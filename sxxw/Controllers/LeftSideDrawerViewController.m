//
//  XHExampleLeftSideDrawerViewController.m
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "LeftSideDrawerViewController.h"

@interface LeftSideDrawerViewController ()

@end

@implementation LeftSideDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin.y = 20;
    tableViewFrame.origin.x = 0;
    tableViewFrame.size.height = self.view.frame.size.height;
    self.tableView.frame = tableViewFrame;
    [self.view addSubview:self.tableView];
    // test github
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
