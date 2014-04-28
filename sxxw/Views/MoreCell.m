//
//  MoreCell.m
//  sxxw2
//
//  Created by haidony on 14-4-10.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
    self.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];

    self.lbinfo.textColor = [UIColor grayColor];
    // Configure the view for the selected state
    
    UIColor *color = [UIColor colorWithRed:219.0/255.0 green:234.0/255.0 blue:244.0/255.0 alpha:1];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = color;
    
    
}


@end
