//
//  MKCoordinateRegion+String.m
//  Bicycle
//
//  Created by Sasha Zats on 7/7/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "MKCoordinateRegion+String.h"

const MKCoordinateRegion kBCLCoordinateRegionInvalid = (MKCoordinateRegion){{-180,-180}, {-1,-1}};

MKCoordinateRegion BCLCoordinateRegionFromString(NSString *string) {
    // {{0,0},{0,0}} - minimum 13 characters
    if ([string length] < 13) {
        return kBCLCoordinateRegionInvalid;
    }
    MKCoordinateRegion region;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *openingBraketChar = [NSCharacterSet characterSetWithCharactersInString:@"{"];
    NSCharacterSet *closingBraketChar = [NSCharacterSet characterSetWithCharactersInString:@"}"];
    NSCharacterSet *commaBraketChar = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSString *buffer = nil;
    if (![scanner scanCharactersFromSet:openingBraketChar intoString:&buffer] ||
        [buffer length] != 2) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanDouble:&region.center.latitude]) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:commaBraketChar intoString:&buffer] ||
        [buffer length] != 1) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanDouble:&region.center.longitude]) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:closingBraketChar intoString:&buffer] ||
        [buffer length] != 1) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:commaBraketChar intoString:&buffer] ||
        [buffer length] != 1) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:openingBraketChar intoString:&buffer] ||
        [buffer length] != 1) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanDouble:&region.span.latitudeDelta]) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:commaBraketChar intoString:&buffer] ||
        [buffer length] != 1) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanDouble:&region.span.longitudeDelta]) {
        return kBCLCoordinateRegionInvalid;
    }
    if (![scanner scanCharactersFromSet:closingBraketChar intoString:&buffer] ||
        [buffer length] != 2) {
        return kBCLCoordinateRegionInvalid;
    }
    return region;
}

NSString *BCLStringFromMKCoordinateRegion(MKCoordinateRegion region) {
    return [NSString stringWithFormat:@"{{%f,%f},{%f,%f}}",
                region.center.latitude,
                region.center.longitude,
                region.span.latitudeDelta,
                region.span.longitudeDelta];
}