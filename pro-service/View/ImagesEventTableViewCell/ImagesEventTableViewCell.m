//
//  ImagesEventTableViewCell.m
//  pro-service
//
//  Created by Александр Мишаков on 23/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "ImagesEventTableViewCell.h"
#import "ImageEventCollectionViewCell.h"

@implementation ImagesEventTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionImage.pagingEnabled = NO;
    self.collectionImage.showsVerticalScrollIndicator = false;
    self.collectionImage.showsHorizontalScrollIndicator = false;
    self.collectionImage.delaysContentTouches = false;
    [self.collectionImage registerNib:[UINib nibWithNibName:@"ImageEventCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageEventCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageEventCollectionViewCell" forIndexPath:indexPath];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 140);
}

@end
