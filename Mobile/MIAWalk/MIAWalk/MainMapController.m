//
//  MainMapController.m
//  MIAWalk
//
//  Created by cromano on 3/7/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "MainMapController.h"
#import <Parse/Parse.h>
#import "PointAnnotation.h"

@interface MainMapController (){
   
}
- (IBAction)startTrip:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property  GMSMapView *GMap;
@end

@implementation MainMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
       // [self.locationManager startUpdatingLocation];
//        self.mapView.showsUserLocation = YES;
        
    }
    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    // User's location
    //25.794032, -80.189041
    CLLocationCoordinate2D newUserLocation = CLLocationCoordinate2DMake(25.794032, -80.189041);
   // [self.mapView.userLocation setCoordinate: newUserLocation];
    [self zoomIn:newUserLocation];
    
    
    
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude ];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Bus_Stops"];
    // Interested in locations near user.
    
    
    
    
    // Limit what could be a lot of points.
    query.limit = 5;
    // Final list of objects
    NSLog(@"Calling GEO Stuff");

    [query whereKey:@"pointLocation" nearGeoPoint:userGeoPoint ];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
              //  NSLog(@"%@", object.objectId);
                PointAnnotation *newAnnotation = [[PointAnnotation alloc] init];
                [newAnnotation setTagId:2];
                PFGeoPoint *current = object[@"pointLocation"];
                [newAnnotation setCoordinate:CLLocationCoordinate2DMake(current.latitude, current.longitude)];
                [self.mapView addAnnotation:newAnnotation];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *metroMoverquery = [PFQuery queryWithClassName:@"Metro_Mover_Stations"];
    // Interested in locations near user.
    
    
    
    
    // Limit what could be a lot of points.
    metroMoverquery.limit = 100;
    [metroMoverquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%s", [[object description]UTF8String]);
                PointAnnotation *newAnnotation = [[PointAnnotation alloc] init];
                [newAnnotation setTagId:2];
               
                NSString *latitude = object[@"LAT"];
                 float latit = [latitude floatValue];
                
                NSString *longitude = object[@"LON"];
                float longit = [longitude floatValue];
                               
                PFGeoPoint *current = [PFGeoPoint geoPointWithLatitude:latit longitude:longit];
                [newAnnotation setCoordinate:CLLocationCoordinate2DMake(current.latitude, current.longitude)];
                
                NSString *name = object[@"NAME"];
                NSLog(@"%s",[name UTF8String]);
                [newAnnotation setTitle:name];
                [self.mapView addAnnotation:newAnnotation];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    
   // NSLog(@"%d",(int)[busStops count]);
   
}
-(void)zoomIn:(CLLocationCoordinate2D) newUserLocation{
   // MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] init];
    PointAnnotation *pointAnnotation = [[PointAnnotation alloc]init];
    [pointAnnotation setCoordinate:newUserLocation];
    [pointAnnotation setTagId:1];

  //  newAnnotation.image = [UIImage imageNamed:<#(NSString *)#>]
   // newAnnotation an
    [self.mapView addAnnotation:pointAnnotation];
    [self.mapView setZoomEnabled:YES];
    MKCoordinateRegion mapRegion;
        mapRegion.center = newUserLocation;
        mapRegion.span.latitudeDelta = 0.02;
        mapRegion.span.longitudeDelta = 0.02;
    
    
        [self.mapView setRegion:mapRegion animated: YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(PointAnnotation *)annotation
{
    MKAnnotationView *pinView;
    if(annotation.tagId == 1){
        MKAnnotationView *pinView = [self returnPointView:annotation.coordinate andTitle:annotation.title andColor:MKPinAnnotationColorGreen];
        return pinView;
    }
    else{
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        annotationView.canShowCallout = YES;
       // annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;

      // pinView = [self returnPointView:annotation.coordinate andTitle:annotation.title andColor:MKPinAnnotationColorRed];
    }
    
      //return pinView;
}
-(MKPinAnnotationView*) returnPointView: (CLLocationCoordinate2D) location andTitle: (NSString*) title andColor: (int) color{
    /*Method that acts as a point-generating machine. Takes the parameters of the location, the title, and the color of the
     pin, and it returns a view that holds the pin with those specified details*/
    
    MKPointAnnotation *resultPin = [[MKPointAnnotation alloc] init];
    MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:resultPin reuseIdentifier:Nil];
    [resultPin setCoordinate:location];
    resultPin.title = title;
    result.pinColor = color;
    result.enabled = YES;
    return result;
}
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
//    annotationView.canShowCallout = YES;
//    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
//    return annotationView;
//}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = mapView.userLocation.coordinate;
//    mapRegion.span.latitudeDelta = 0.2;
//    mapRegion.span.longitudeDelta = 0.2;
//    
//    
//    [mapView setRegion:mapRegion animated: YES];
//    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    //NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startTrip:(id)sender {
}
@end
