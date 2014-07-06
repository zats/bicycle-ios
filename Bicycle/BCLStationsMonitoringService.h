//
//  BCLStationsMonitoringService.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCLStationsMonitoringService : NSObject

@property (nonatomic, copy, readonly) NSArray *stations;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
