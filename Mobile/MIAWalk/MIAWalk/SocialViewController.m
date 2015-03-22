//
//  SocialViewController.m
//  MIAWalk
//
//  Created by cromano on 3/7/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "SocialViewController.h"
#import "ReportsTableViewCell.h"
#import "ReportDetailsViewController.h"

@interface SocialViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *feedSelector;
@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property NSArray *coupons;
@property NSArray *reports;
@end

@implementation SocialViewController

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *couponsQuery = [PFQuery queryWithClassName:@"Coupon"];
    [couponsQuery whereKey:@"available" equalTo:[NSNumber numberWithBool:NO]];
    [couponsQuery orderByDescending:@"createdAt"];
    _coupons = [couponsQuery findObjects];
    
    PFQuery *reportsQuery = [PFQuery queryWithClassName:@"Report"];
    //[couponsQuery whereKey:@"available" equalTo:[NSNumber numberWithBool:NO]];
    [couponsQuery orderByDescending:@"createdAt"];
    _reports = [reportsQuery findObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_feedSelector addTarget:self
                         action:@selector(reloadContent)
               forControlEvents:UIControlEventValueChanged];
   
}
-(void)reloadContent{
    [_feedTable reloadData];
    _feedTable.allowsSelection = !_feedTable.allowsSelection;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_feedSelector selectedSegmentIndex] == 0){
        return _coupons.count;
    }else{
        return _reports.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *leftHandSide;
    
    if([_feedSelector selectedSegmentIndex] == 0){
        ReportsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        PFObject *coupon = [_coupons objectAtIndex:indexPath.row];
        NSString *user = coupon[@"user"];
        NSString *couponTitle = coupon[@"title"];
        leftHandSide = [[user stringByAppendingString:@" has redeemed coupon: "] stringByAppendingString:couponTitle];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
          [cell.title setNumberOfLines:2];
        cell.title.text = leftHandSide;
        cell.imageThumbnail.image = [UIImage imageNamed:@"rewardgreen.png"];
        return cell;
    }else{
        ReportsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        PFObject *report = [_reports objectAtIndex:indexPath.row];
        NSString *reportTitle = report[@"title"];
        leftHandSide = reportTitle;
        PFFile *theImage = [report objectForKey:@"image"];
        NSData *imageData = [theImage getData];
        cell.imageThumbnail.image = [UIImage imageWithData:imageData];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.title.text = leftHandSide;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_feedSelector selectedSegmentIndex] == 1){
        [self performSegueWithIdentifier:@"showReport" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showReport"]){
        ReportDetailsViewController *destination = (ReportDetailsViewController *)[segue destinationViewController];
        NSLog(@"%s", [[[_reports objectAtIndex:[_feedTable indexPathForSelectedRow].row ] description]UTF8String]);
        destination.report = [_reports objectAtIndex:[_feedTable indexPathForSelectedRow].row ];
        
    }
}

@end
