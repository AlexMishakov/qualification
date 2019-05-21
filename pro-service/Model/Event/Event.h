//
//  Event.h
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSObject

@property int idEvent;
@property float price;
@property float rating;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nonnull) NSString *description_text;
@property (nonatomic, nonnull) NSString *organization_title;
@property (nonatomic, nonnull) NSString *age_rating;
@property (nonatomic, nonnull) NSDate *created_date;
@property (nonatomic) NSDate *end_event;
@property (nonatomic, nonnull) NSString *main_photo;
@property (nonatomic, nonnull) NSString *profile_name;
@property (nonatomic, nonnull) NSString *profile_surname;
@property (nonatomic, nonnull) NSArray *category;

- (Event *)dictinaryToEvent:(NSDictionary *)dictinary;

@end

NS_ASSUME_NONNULL_END
