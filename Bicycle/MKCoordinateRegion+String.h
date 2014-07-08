//
//  MKCoordinateRegion+String.h
//  Bicycle
//
//  Created by Sasha Zats on 7/7/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <MapKit/MKGeometry.h>

extern const MKCoordinateRegion kBCLCoordinateRegionInvalid;

extern MKCoordinateRegion BCLCoordinateRegionFromString(NSString *string);
extern NSString *BCLStringFromMKCoordinateRegion(MKCoordinateRegion region);