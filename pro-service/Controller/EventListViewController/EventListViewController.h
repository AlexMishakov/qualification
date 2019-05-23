//
//  EventListViewController.h
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventListViewController : UIViewController

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSArray *arrayEvent;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property BOOL navPrefersLargeTitles;

@end

NS_ASSUME_NONNULL_END
