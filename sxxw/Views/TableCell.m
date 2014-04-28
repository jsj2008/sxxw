//
//  TableCell.m
//  sxxw
//
//  Created by tw on 13-11-6.
//  Copyright (c) 2013年 com.tght. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
 
@synthesize titlename  ;
@synthesize datestr  ;

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
        titlename.textColor = [UIColor grayColor];
    }
    UIColor *color = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    self.backgroundColor = color;
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
