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
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@", DOMEN, self.images[indexPath.row]];
    DLog(@"%@", stringUrl);
    NSURL *urlImage = [NSURL URLWithString:stringUrl];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell) cell.imageImageView.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 120);
}

@end
