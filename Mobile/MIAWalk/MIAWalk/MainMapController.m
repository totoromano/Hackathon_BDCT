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

@interface MainMapController ()<UIActionSheetDelegate>{
    NSArray *layers;
}
- (IBAction)startTrip:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property  GMSMapView *GMap;
- (IBAction)showOptions:(id)sender;
@end

@implementation MainMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    layers = @[@"Entertainment",@"Food",@"Bikes",@"Bus",@"Report"];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
//        [self.locationManager startUpdatingLocation];
//        self.mapView.showsUserLocation = YES;
//        
    }
    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    CLLocationCoordinate2D newUserLocation = CLLocationCoordinate2DMake(25.78054, -80.19057);
    [self zoomIn:newUserLocation];
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude ];
    PFQuery *query = [PFQuery queryWithClassName:@"Bus_Stops"];
    query.limit = 5;
    [query whereKey:@"pointLocation" nearGeoPoint:userGeoPoint ];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                PointAnnotation *newAnnotation = [[PointAnnotation alloc] init];
                [newAnnotation setTagId:2];
                PFGeoPoint *current = object[@"pointLocation"];
                [newAnnotation setCoordinate:CLLocationCoordinate2DMake(current.latitude, current.longitude)];
                [self.mapView addAnnotation:newAnnotation];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
//    PFQuery *metroMoverquery = [PFQuery queryWithClassName:@"Metro_Mover_Stations"];
//    // Interested in locations near user.
//    
//    
//    
//    
//    // Limit what could be a lot of points.
//    metroMoverquery.limit = 100;
//    [metroMoverquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%s", [[object description]UTF8String]);
//                PointAnnotation *newAnnotation = [[PointAnnotation alloc] init];
//                [newAnnotation setTagId:2];
//               
//                NSString *latitude = object[@"LAT"];
//                 float latit = [latitude floatValue];
//                
//                NSString *longitude = object[@"LON"];
//                float longit = [longitude floatValue];
//                               
//                PFGeoPoint *current = [PFGeoPoint geoPointWithLatitude:latit longitude:longit];
//                [newAnnotation setCoordinate:CLLocationCoordinate2DMake(current.latitude, current.longitude)];
//                
//                NSString *name = object[@"NAME"];
//                NSLog(@"%s",[name UTF8String]);
//                [newAnnotation setTitle:name];
//                [self.mapView addAnnotation:newAnnotation];
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    
    
   // NSLog(@"%d",(int)[busStops count]);
   
}
-(void)zoomIn:(CLLocationCoordinate2D) newUserLocation{
    PointAnnotation *pointAnnotation = [[PointAnnotation alloc]init];
    [pointAnnotation setCoordinate:newUserLocation];
    [pointAnnotation setTagId:1];
    
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
        return annotationView;
    }
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

- (IBAction)startTrip:(id)sender {
}
- (IBAction)showOptions:(id)sender {
    UIActionSheet *options = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Entertainment", @"Food", @"Bikes", @"Bus", @"Report", nil];
    
    [options showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex < 4){
        [self showLayer:buttonIndex];
    }else if( buttonIndex == 4){
        NSLog(@"Reports Here");
    }
}
-(void)showLayer:(NSInteger)index{
    
    NSString *layer = [layers objectAtIndex:index];
    
    PFQuery *metroMoverquery = [PFQuery queryWithClassName:@"Metro_Mover_Stations"];
    metroMoverquery.limit = 100;
    [metroMoverquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
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
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

}
@end
