//
//  MainCollectionViewCell.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.wrapImage.layer.masksToBounds = YES;
    self.wrapImage.layer.cornerRadius = 10;
}

@end
