//
//  Name of the file: LocationServiceController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File uses locations services to track the current location and ge the nearby
//  hospitals using google places api ad it will be shown in MapKitView

//
//  Created by Dhivya Narayanan on 12/10/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "LocationServiceController.h"

@interface LocationServiceController ()

@end

@implementation LocationServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;      //sets delegate to mapview
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;   //sets delegate to location manager
    //Authorization request if ios < 8
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];    //starts updating location
    //setting mapview
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.currentLatitude;
    region.center.longitude = self.currentLongitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //updates userlocation
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
- (NSString *)deviceLocation {
    //Gets the current device location - latitude and longitude
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    //Gets the current device location - only latitude
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    //Gets the current device location - only longitude
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    //Gets the current device location - altitude
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Updates current location
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations
{
    static int updates = 0;
    NSLog(@"Update : %d",++updates);
    //getting current latitude and longitude value
    self.currentLatitude = [[locations lastObject] coordinate].latitude;
    self.currentLongitude = [[locations lastObject]coordinate].longitude;
    NSLog(@"currentLatitude: %g",self.currentLatitude);
    NSLog(@"currentLongitude: %g",self.currentLongitude);
    
}

//Event handler for bar button(Hospital) click
- (IBAction)btPress:(id)sender {
    
    //send query to google places api to get nearby hospitals
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSString *buttonTitle = [button.title lowercaseString];
    [self.locationManager stopUpdatingLocation];
    [self queryGooglePlaces:buttonTitle];
    
}
//send query to google places api to get nearby hospitals
-(void) queryGooglePlaces: (NSString *) googleType {
    
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", self.currentLatitude, self.currentLongitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

//Gets the fetched data by google places - list of nearby hospitals
-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

@end
