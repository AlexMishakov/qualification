//
//  FooterEventTableViewCell.h
//  pro-service
//
//  Created by Александр Мишаков on 23/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FooterEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *organaztionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)setToMapSubTitle:(NSString *)subTitle letitude:(double)letitude longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
