//
//  CouponRedeemViewController.m
//  MIAWalk
//
//  Created by cromano on 3/15/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "CouponRedeemViewController.h"

@interface CouponRedeemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *CouponTitle;
@property (weak, nonatomic) IBOutlet UILabel *CouponValue;
@property (weak, nonatomic) IBOutlet UILabel *CouponLocation;

@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",[[_CouponContainer description]UTF8String]);
    self.CouponTitle.text = [_CouponContainer objectAtIndex:0];
    self.CouponValue.text = [[_CouponContainer objectAtIndex:1] stringByAppendingString:@" points"];
    self.CouponLocation.text = [_CouponContainer objectAtIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
