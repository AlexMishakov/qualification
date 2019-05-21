//
//  Calendar.h
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calendar : NSObject

@property (nonatomic) NSArray *today;
@property (nonatomic) NSArray *allDay;

- (void)loadToday;
- (void)loadFromDate:(NSDate *)date;
- (void)loadAllDay;
- (void)loadTag:(NSArray *)tags;

@end

NS_ASSUME_NONNULL_END
