//
//  Defines.h
//  pro-service
//
//  Created by Александр Мишаков on 16/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

// MARK: Custom log
#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

// MARK: Urls
#if DEBUG
    #define DOMEN  @""
#else
    #define DOMEN  @""
#endif

// MARK: Colors
#define COLOR_MAIN [UIColor colorWithRed:1.000 green:0.388 blue:0.388 alpha:1.00]
