//
//  BCLMapViewController.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLMapViewController.h"

#import "BCLStation.h"
#import "BCLStationsMonitoringService.h"

#import <GoogleMaps/GoogleMaps.h>
#import <Masonry/Masonry.h>

@interface BCLMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@property (nonatomic, strong) BCLStationsMonitoringService *stationsMonitoringService;
@property (nonatomic, copy) NSArray *markers;
@end

@implementation BCLMapViewController

objection_requires_sel(@selector(stationsMonitoringService));

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[JSObjection defaultInjector] injectDependencies:self];
    
    [self _setupVisualEffects];
    [self _setMapDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Private

- (void)_setupVisualEffects {
    UIBlurEffect *blurVisualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurVisualEffect];
    [self.view insertSubview:effectView belowSubview:self.searchTextField];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchTextField).with.insets(UIEdgeInsetsMake(0, -10, 0, -10));
    }];
}

- (void)_setMapDefaults {
//    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    [self _setDefaultMapView];
    [self _subscribeForStationChanges];
}

- (void)_setDefaultMapView {
    NSURL *serviceRegionsFileURL = [[NSBundle mainBundle] URLForResource:@"ServiceRegions" withExtension:@"plist"];
    NSDictionary *serviceRegions = [NSDictionary dictionaryWithContentsOfURL:serviceRegionsFileURL];
    NSDictionary *telAviv = [serviceRegions[@"Cities"] firstObject];
    CGFloat zoomLevel = [telAviv[@"Zoom"] floatValue];
    NSArray *locationCoordinates = telAviv[@"Location"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([locationCoordinates[0] doubleValue], [locationCoordinates[1] doubleValue]);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location zoom:zoomLevel];
}

- (void)_subscribeForStationChanges {

    // Convert station data into markers
    RAC(self, markers) = [[RACObserve(self.stationsMonitoringService, stations) skip:1] map:^id(NSArray *stations) {
        NSMutableArray *results = [NSMutableArray array];
        for (BCLStation *station in stations) {
            GMSMarker *stationMarker = [GMSMarker markerWithPosition:station.location];
            stationMarker.title = [NSString stringWithFormat:@"b %tu d %tu %@",station.availableBicycles, station.availableDocks, station.name];
            stationMarker.snippet = station.address;
            stationMarker.icon = [GMSMarker markerImageWithColor:[self _colorForStation:station]];
            [results addObject:stationMarker];
        }
        return results;
    }];
    
    @weakify(self);
    [[RACObserve(self, markers) skip:1] subscribeNext:^(NSArray *markers) {
        @strongify(self);
        [self.mapView clear];
        
        for (GMSMarker *marker in markers) {
            marker.map = self.mapView;
        }
    }];
}

- (UIColor *)_colorForStation:(BCLStation *)station {
    CGFloat ratio = (float)station.availableBicycles / (float)station.capacity;
    if (ratio > 0.5) {
        return [UIColor colorWithRed:0.477 green:0.745 blue:0.327 alpha:1.000];
    } else if (ratio > 0.2) {
        return [UIColor colorWithRed:0.925 green:0.716 blue:0.072 alpha:1.000];
    }
    return [UIColor colorWithRed:0.768 green:0.000 blue:0.031 alpha:1.000];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {

}

@end
