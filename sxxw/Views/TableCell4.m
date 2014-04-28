//
//  TableCell4.m
//  sxxw
//
//  Created by haidony on 14-4-22.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "TableCell4.h"

@implementation TableCell4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected){
        self.titlename2.textColor = [UIColor grayColor];
    }
    self.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    UIColor *color = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(7, -2, rect.size.width - 14, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(7, rect.size.height, rect.size.width - 14, 1));
}

@end
