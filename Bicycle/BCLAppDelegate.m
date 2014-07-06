//
//  AppDelegate.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLAppDelegate.h"

#import "BCLAPIClientProtocol.h"
#import "BCLStationsMonitoringService.h"
#import "BCLModule.h"

#import "Objection+BetterObjectiveC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Crashlytics/Crashlytics.h>

@interface BCLAppDelegate ()
@property (nonatomic) BCLStationsMonitoringService *monitoringService;
@property (nonatomic) id<BCLAPIClientProtocol> apiClient;
@end

@implementation BCLAppDelegate

objection_requires_sel(@selector(monitoringService),
                       @selector(apiClient));

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self _initializeAPIKeys];
    [self _initializeDependencyInjection];
    [self _initializeServices];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private

- (void)_initializeServices {
    [self.monitoringService startMonitoring];
}

- (void)_initializeDependencyInjection {
    JSObjectionModule *module = [[BCLModule alloc] init];
    JSObjectionInjector *defaultInjection = [JSObjection createInjectorWithModule:module];
    [JSObjection setDefaultInjector:defaultInjection];
    [[JSObjection defaultInjector] injectDependencies:self];
}

- (void)_initializeAPIKeys {
    [GMSServices provideAPIKey:@"AIzaSyDO0fejaIgM6opnYL-i7w3InJxnG87v0LQ"];
    [Crashlytics startWithAPIKey:@"1806f0e415eca8782897d8254a1363122c77c03a"];
}

@end
