//
//  RewardsViewController.m
//  MIAWalk
//
//  Created by cromano on 3/7/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "RewardsViewController.h"
#import "CouponTableViewCell.h"

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
    NSArray *results = [query findObjects];
    for (PFObject *object in results) {
        NSLog(@"%@", object[@"StepsCompleted"]);
        count += (int)[object[@"StepsCompleted"] integerValue];
    }
    
    
    self.stepsNumber.text = [NSString stringWithFormat:@"%d",count];
    float dollarsAccount = (count/2000)*2.50;
    self.dollarsSaved.text = [NSString stringWithFormat:@"%.2f",dollarsAccount];
    float co2Reduction = count*(16/1250);
    self.co2Emissions.text = [NSString stringWithFormat:@"%.2f",co2Reduction];
    //Every 10 steps is a point
    self.points.text = [NSString stringWithFormat:@"%d",(int)(count*0.15)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    coupons = [[NSMutableArray alloc]initWithArray:@[@"10% OFF on Espresso",@"Buy one get 50% OFF",@"Free Pastry",@"One FREE Ticket",@"20% on your order"]];
    establishments = [[NSMutableArray alloc]initWithArray:@[@"Local Coffee Shop", @"Indie Bookstore",@"Downtown Cafe",@"PAMM",@"Fabio Calzone's"]];
    
    values= [[NSMutableArray alloc]initWithArray:@[@"2,000",@"1,200",@"1,000",@"2,750",@"500"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return coupons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    [cell setCouponUp:[coupons objectAtIndex:indexPath.row] withSubTitle:[establishments objectAtIndex:indexPath.row] withValue:[values objectAtIndex:indexPath.row]];
    cell.tag = (int)indexPath.row;
    [cell.redeem addTarget:nil action:@selector(redeem:) forControlEvents:UIControlEventTouchUpInside];
    cell.redeem.tag = indexPath.row;
    return cell;
}
-(void)redeem:(UIButton *)sender{
//    NSLog(@"Over here");
    NSString *couponTitle = [coupons objectAtIndex:sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem" message:couponTitle delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
@end
