//
//  DateViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 20/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@property (weak, nonatomic) IBOutlet UIView *wrapContent;

@end

@implementation DateViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = true;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.wrapContent.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.wrapContent.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.wrapContent.layer.mask = maskLayer;
}

@end
