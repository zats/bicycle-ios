//
//  BCLDataMonitoringServiceProtocol.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BCLDataMonitoringServicePolling)(void);

@protocol BCLDataMonitoringServiceProtocol <NSObject>

- (id)schedulePeriodicPollWithIntervall:(NSTimeInterval)pollingInterval
                             usingBlock:(BCLDataMonitoringServicePolling)block;

@end