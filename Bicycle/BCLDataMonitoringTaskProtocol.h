//
//  BCLDataMonitoringTask.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <AppleGuice/AppleGuice.h>

typedef void(^BCLDataMonitoringTaskBlock)(void);

@protocol BCLDataMonitoringTaskProtocol <AppleGuiceInjectable>

@property (nonatomic, readonly) NSDate *startDate;

@property (nonatomic, readonly) NSDate *lastExecutionDate;

@property (nonatomic, copy) BCLDataMonitoringTaskBlock *block;

@end