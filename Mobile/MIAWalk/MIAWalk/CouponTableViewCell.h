//
//  CouponTableViewCell.h
//  MIAWalk
//
//  Created by cromano on 3/8/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *redeem;
@property int indexOnArray;
@property int identifier;
-(void)setCouponUp:(NSString *)str withSubTitle:(NSString *)est withValue:(NSString *)value withIndex:(NSInteger *)identifier;
@end
