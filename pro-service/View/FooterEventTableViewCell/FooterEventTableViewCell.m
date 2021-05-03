//
//  FooterEventTableViewCell.m
//  pro-service
//
//  Created by Александр Мишаков on 23/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "FooterEventTableViewCell.h"

@implementation FooterEventTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setToMapSubTitle:(NSString *)subTitle letitude:(double)letitude longitude:(double)longitude
{
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = letitude;
    centerCoordinate.longitude = longitude;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = centerCoordinate;
//    annotation.title = title;
    annotation.subtitle = subTitle;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:NO];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    region.span = span;
    centerCoordinate.latitude += 0.00025;
    region.center = centerCoordinate;
    [self.mapView setRegion:region animated:NO];
}

@end
