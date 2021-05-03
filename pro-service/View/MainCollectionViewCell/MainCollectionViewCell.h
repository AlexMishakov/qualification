//
//  MainCollectionViewCell.h
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *wrapImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;

@end

NS_ASSUME_NONNULL_END
