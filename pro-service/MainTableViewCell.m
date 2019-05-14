//
//  MainTableViewCell.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentShadow.layer.masksToBounds = NO;
    self.contentShadow.layer.cornerRadius = 10;
    self.contentShadow.layer.shadowOffset = CGSizeMake(0, 5);
    self.contentShadow.layer.shadowRadius = 8;
    self.contentShadow.layer.shadowOpacity = 0.15;
    
    self.content.layer.masksToBounds = YES;
    self.content.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
