//
//  BCLStationsMonitoringService.m
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCLStationsMonitoringService.h"
#import "Objection+BetterObjectiveC.h"
#import "BCLAPIClientProtocol.h"
#import <AFNetworking/AFNetworking.h>

static const NSTimeInterval BCLStationMoitoringInterval = 1.5 * 60;

static inline BOOL BCLReachabiltyStatusToBoolean(AFNetworkReachabilityStatus status) {
    return status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi;
}

@interface BCLStationsMonitoringService ()
@property (nonatomic) NSDate *lastExecutionTime;
@property (nonatomic) NSTimer *nextExecutionTimer;
@property (nonatomic) id<BCLAPIClientProtocol> apiClient;
@property (nonatomic, copy, readwrite) NSArray *stations;
@property (nonatomic) BOOL previouslyReachable;
@end

@implementation BCLStationsMonitoringService

objection_requires_sel(@selector(apiClient))

- (void)startMonitoring {
    [self _registerForBackgroundNotification];
    [self _registerForForegroundNotification];
    [self _registerForNetworkRestoredNotification];
    
    self.nextExecutionTimer = [NSTimer scheduledTimerWithTimeInterval:BCLStationMoitoringInterval
                                                               target:self
                                                             selector:@selector(_timerHandler)
                                                             userInfo:nil
                                                              repeats:YES];
    [self _performTaskIfNeeded];
}

- (void)stopMonitoring {
    [self _unregisterForForegroundNotification];
    [self _unregisterForBackgroundNotification];
    [self _unregisterForNetworkRestoredNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)_backgroundNotificationHandler {
    [self stopMonitoring];
}

- (void)_foregroundNotificationHandler {
    [self startMonitoring];
}

- (void)_rachabilityNotificationHandler:(NSNotification *)notification {
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    BOOL isReachable = BCLReachabiltyStatusToBoolean(status);
    if (isReachable && !self.previouslyReachable) {
        [self _performTaskIfNeeded];
    }
    self.previouslyReachable = isReachable;
}

- (void)_timerHandler {
    [self _performTaskIfNeeded];
}

#pragma mark - Private

- (void)_performTaskIfNeeded {
    NSTimeInterval lastInterval = [[NSDate date] timeIntervalSinceDate:self.lastExecutionTime];
    if (lastInterval >= BCLStationMoitoringInterval) {
        [self _performTask];
    }
}

- (void)_performTask {
    self.lastExecutionTime = [NSDate date];
    [self.apiClient allStations];
}

- (void)_registerForBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_backgroundNotificationHandler)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)_unregisterForBackgroundNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)_registerForForegroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_foregroundNotificationHandler)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)_unregisterForForegroundNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

- (void)_registerForNetworkRestoredNotification {
    self.previouslyReachable = ((AFHTTPSessionManager *)self.apiClient).reachabilityManager.reachable;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_rachabilityNotificationHandler:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

- (void)_unregisterForNetworkRestoredNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
}

@end
