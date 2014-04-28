//
//  TableCell.h
//  sxxw
//
//  Created by tw on 13-11-6.
//  Copyright (c) 2013年 com.tght. All rights reserved.
//
 
@interface TableCell : UITableViewCell{
     UILabel *titlename; // 标题
    UILabel *datestr; 
}

@property (nonatomic ,retain) IBOutlet UILabel *titlename; 
@property (nonatomic ,retain) IBOutlet UILabel *datestr;
@end
