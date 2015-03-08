//
//  PedometerViewController.h
//  MIAWalk
//
//  Created by cromano on 3/7/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface PedometerViewController : UIViewController
-(void)countSteps;
-(void)stopCounting;
-(void)getData;
@end
