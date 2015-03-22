//
//  RewardsViewController.m
//  MIAWalk
//
//  Created by cromano on 3/7/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "RewardsViewController.h"
#import "CouponTableViewCell.h"
#import "CouponRedeemViewController.h"

@interface RewardsViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepsNumber;
@property (weak, nonatomic) IBOutlet UILabel *dollarsSaved;
@property (weak, nonatomic) IBOutlet UILabel *co2Emissions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *points;


@end

@implementation RewardsViewController{
    NSMutableArray *coupons;
    NSMutableArray *establishments;
    NSMutableArray *values;
}

-(void)viewDidAppear:(BOOL)animated{
    int count = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"user" equalTo:@"tester"];
    [query whereKey:@"StepsCompleted" greaterThan:[NSNumber numberWithInt:0]];
    NSArray *results = [query findObjects];
    for (PFObject *object in results) {
       // NSLog(@"%@", object[@"StepsCompleted"]);
        count += (int)[object[@"StepsCompleted"] integerValue];
    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.stepsNumber.text = [formatter stringFromNumber: [NSNumber numberWithInt:count]];
    float dollarsAccount = (count/2000)*2.50;
    self.dollarsSaved.text = [NSString stringWithFormat:@"%.2f",dollarsAccount];
    float co2Reduction = (count*0.0128);
    self.co2Emissions.text = [NSString stringWithFormat:@"%.2f",co2Reduction];
    NSLog(@"%.20f",co2Reduction);
    //Every 10 steps is a point
    self.points.text = [formatter stringFromNumber:[NSNumber numberWithInt:(int)(count*0.15)]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    coupons = [[NSMutableArray alloc]initWithArray:@[@"10% OFF Espresso",@"Buy one get 50% OFF",@"Free Pastry",@"One FREE Ticket",@"20% on your order"]];
    establishments = [[NSMutableArray alloc]initWithArray:@[@"Local Coffee Shop", @"Indie Bookstore",@"Downtown Cafe",@"PAMM",@"Fabio Calzone's"]];
    values= [[NSMutableArray alloc]initWithArray:@[@"1,000",@"800",@"600",@"600",@"500"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"redeem"]){
        CouponRedeemViewController *destVC = (CouponRedeemViewController *)[segue destinationViewController];
        destVC.CouponContainer = @[[coupons objectAtIndex:[self.tableView indexPathForSelectedRow].row],[values objectAtIndex:[self.tableView indexPathForSelectedRow].row],[establishments objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return coupons.count;
}
-(CouponTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    [cell setCouponUp:[coupons objectAtIndex:indexPath.row] withSubTitle:[establishments objectAtIndex:indexPath.row] withValue:[values objectAtIndex:indexPath.row] withIndex:indexPath.row];
    cell.identifier = (int)indexPath.row;
    NSLog(@"%d here",cell.identifier);
    [cell.redeem addTarget:nil action:@selector(redeem:) forControlEvents:UIControlEventTouchUpInside];
    cell.redeem.tag = indexPath.row;
    
    return cell;
}
-(void)redeem:(UIButton *)sender{
    NSString *couponTitle = [coupons objectAtIndex:sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem" message:couponTitle delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *couponTitle = [coupons objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem" message:couponTitle delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self performSegueWithIdentifier:@"redeem" sender:self];
    }
}
@end
