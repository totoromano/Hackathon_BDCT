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


@end
@implementation CouponTableViewCell
- (IBAction)redeemCoupon:(id)sender {
    
}

- (void)awakeFromNib {
    // Initialization code
//    self.couponTitle.text = @"Coupon Title";
//    self.couponEstablishment.text = @"Local Coffee Shop";
//    self.value.text = @"10% Off Any Order";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCouponUp:(NSString *)str withSubTitle:(NSString *)est withValue:(NSString *)value{
    self.couponTitle.text = str;
    self.couponEstablishment.text = est;
    self.value.text = [value stringByAppendingString:@" pts."];
}
@end
