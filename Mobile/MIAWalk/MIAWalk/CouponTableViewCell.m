//
//  CouponTableViewCell.m
//  MIAWalk
//
//  Created by cromano on 3/8/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "CouponTableViewCell.h"
@interface CouponTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponEstablishment;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *milesAway;


@end
@implementation CouponTableViewCell
- (IBAction)redeemCoupon:(id)sender {
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCouponUp:(NSString *)str withSubTitle:(NSString *)est withValue:(NSString *)value withIndex:(NSInteger *)index{
    
    NSLog(@"Tag of Cell: %d",(int)index);
    self.couponTitle.text = str;
    self.couponEstablishment.text = est;
    self.value.text = [value stringByAppendingString:@" pts."];
    float miles = 0.2 * ((int)index+1);
    self.milesAway.text =[ NSString stringWithFormat:@"%.1f mi.",miles];
}
@end
