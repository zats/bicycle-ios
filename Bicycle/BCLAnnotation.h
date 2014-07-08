//
//  BCLAnnotation.h
//  Bicycle
//
//  Created by Sasha Zats on 7/7/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

@class BCLStation;

@interface BCLAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, readwrite, copy) NSString *title;

@property (nonatomic, readwrite, copy) NSString *subtitle;

@property (nonatomic, weak) BCLStation *station;

@end
