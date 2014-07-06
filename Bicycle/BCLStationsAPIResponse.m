//
//  BCLStationsAPIResponse.m
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLStationsAPIResponse.h"

#import "BCLStation.h"

@implementation BCLStationsAPIResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        SQTypedKeyPath(BCLStationsAPIResponse, lastUpdate): @"meta.lastFetchDate",
        SQTypedKeyPath(BCLStationsAPIResponse, stations): @"response"
    };
}

+ (NSValueTransformer *)stationsJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[BCLStation class]];
}

@end
