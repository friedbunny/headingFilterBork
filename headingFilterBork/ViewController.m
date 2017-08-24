//
//  ViewController.m
//  headingFilterBork
//
//  Created by Jason Wray on 8/23/17.
//  Copyright © 2017 Kulturny. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocationDirection oldHeading;
@property UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.headingFilter = 10;
    [_locationManager startUpdatingHeading];

    _label = [[UILabel alloc] initWithFrame:self.view.frame];
    _label.font = [UIFont monospacedDigitSystemFontOfSize:32 weight:UIFontWeightMedium];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];

    [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(meaninglessChangeToHeadingOrientation)
                                   userInfo:nil
                                    repeats:YES
     ];
}

- (void)meaninglessChangeToHeadingOrientation {
    _locationManager.headingOrientation = CLDeviceOrientationPortrait;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CLLocationDirection heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading;
    CLLocationDirection diff = heading - _oldHeading;

    _label.text = [NSString stringWithFormat:@"%.3f", heading];
    NSLog(@"Changed from %f to %f (a difference of %f, despite a heading filter of %.1f)", _oldHeading, heading, diff, manager.headingFilter);

    _oldHeading = heading;
}

@end
