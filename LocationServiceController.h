//
//  LocationServiceController.h
//  MyiHR
//
//  Created by Dhivya Narayanan on 12/16/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

//Google places - Server Key
#define kGOOGLE_API_KEY @"AIzaSyCom7w2tNFWEeNAAhBy-orizy3_bBK8vvU"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface LocationServiceController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate> {
    CLLocationCoordinate2D currentCentre;  //current location coordinate
    int currenDist;     //Distance from current location
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hospitalBt;
- (IBAction)btPress:(id)sender;

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(assign) double currentLatitude;
@property(assign) double currentLongitude;



@end


