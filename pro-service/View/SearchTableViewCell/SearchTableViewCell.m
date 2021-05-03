//
//  SearchTableViewCell.m
//  pro-service
//
//  Created by Александр Мишаков on 19/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.textColor = COLOR_MAIN;
    self.supLabel.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
