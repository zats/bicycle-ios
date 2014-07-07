//
//  BCLStation.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLStation.h"

#import "Mantle+Reusability.h"
#import <Mantle/Mantle.h>

NSArray *BCLLocationCoordinateToArray(CLLocationCoordinate2D coordinate) {
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        return @[ @(coordinate.latitude), @(coordinate.longitude) ];
    }
    return nil;
}

CLLocationCoordinate2D BCLArrayToLocationCoordinate(NSArray *coordinates) {
    if ([coordinates count] != 2) {
        return kCLLocationCoordinate2DInvalid;
    }
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([coordinates[0] doubleValue],
                                                                 [coordinates[1] doubleValue]);
    if (!CLLocationCoordinate2DIsValid(location)) {
        return kCLLocationCoordinate2DInvalid;
    }
    return location;
}


@interface BCLStation () <MTLJSONSerializing, MTLUniquing>

@property (nonatomic, copy, readwrite) NSString *stationId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *address;
@property (nonatomic, readwrite) NSUInteger capacity;
@property (nonatomic, readwrite) NSUInteger availableBicycles;
@property (nonatomic, readwrite) NSUInteger availableDocks;
@property (nonatomic, readwrite) CLLocationCoordinate2D location;

@end

@implementation BCLStation

+ (NSString *)uniquiePropertyName {
    return SQTypedKeyPath(BCLStation, stationId);
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         SQTypedKeyPath(BCLStation, stationId): @"id",
         SQTypedKeyPath(BCLStation, name): @"name",
         SQTypedKeyPath(BCLStation, address): @"address",
         SQTypedKeyPath(BCLStation, capacity): @"capacity",
         SQTypedKeyPath(BCLStation, availableBicycles): @"availableBicycles",
         SQTypedKeyPath(BCLStation, availableDocks): @"availableDocks",
         SQTypedKeyPath(BCLStation, location): @"location"
    };
}

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *coordinates) {
        CLLocationCoordinate2D coordinate = BCLArrayToLocationCoordinate(coordinates);
        if (CLLocationCoordinate2DIsValid(coordinate)) {
            return [NSValue value:&coordinate
                     withObjCType:@encode(CLLocationCoordinate2D)];
        }
        return nil;
    } reverseBlock:^id(NSValue *locationValue) {
        CLLocationCoordinate2D coordinate = kCLLocationCoordinate2DInvalid;
        [locationValue getValue:&coordinate];
        return BCLLocationCoordinateToArray(coordinate);
    }];
}

@end
