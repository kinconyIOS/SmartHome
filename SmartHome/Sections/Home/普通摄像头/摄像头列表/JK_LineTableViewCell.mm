//
//  JK_LineTableViewCell.m
//  ZNJD2
//
//  Created by he on 14-7-18.
//
//

#import "JK_LineTableViewCell.h"

@implementation JK_LineTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
