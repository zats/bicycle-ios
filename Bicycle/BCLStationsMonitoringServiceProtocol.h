//
//  BCLStationsMonitoringServiceProtocol.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

@protocol BCLStationsMonitoringServiceProtocol <NSObject>

@property (nonatomic, copy, readonly) NSArray *stations;

- (void)startMonitoring;

- (void)stopMonitoring;


@end