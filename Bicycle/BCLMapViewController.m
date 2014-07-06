//
//  BCLMapViewController.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import <Masonry/Masonry.h>

@interface BCLMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@end

@implementation BCLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    [self _setDefaultLocation];
}

- (void)_setDefaultLocation {
    NSURL *serviceRegionsFileURL = [[NSBundle mainBundle] URLForResource:@"ServiceRegions" withExtension:@"plist"];
    NSDictionary *serviceRegions = [NSDictionary dictionaryWithContentsOfURL:serviceRegionsFileURL];
    NSDictionary *telAviv = [serviceRegions[@"Cities"] firstObject];
    CGFloat zoomLevel = [telAviv[@"Zoom"] floatValue];
    NSArray *locationCoordinates = telAviv[@"Location"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([locationCoordinates[0] doubleValue], [locationCoordinates[1] doubleValue]);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location zoom:zoomLevel];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
