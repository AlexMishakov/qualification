//
//  ImagesEventTableViewCell.h
//  pro-service
//
//  Created by Александр Мишаков on 23/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagesEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (strong) NSArray *images;

@end

NS_ASSUME_NONNULL_END
