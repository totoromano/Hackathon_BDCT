//
//  ReportDetailsViewController.m
//  MIAWalk
//
//  Created by cromano on 3/15/15.
//  Copyright (c) 2015 MIAWalk. All rights reserved.
//

#import "ReportDetailsViewController.h"

@interface ReportDetailsViewController ()
@property NSArray *reportsContainer;
@property (weak, nonatomic) IBOutlet UILabel *reporTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageReport;
@property (weak, nonatomic) IBOutlet UILabel *ReportDescription;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end

@implementation ReportDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.author.text = _report[@"user"];
    self.reporTitle.text = _report[@"title"];
    self.ReportDescription.text = _report[@"description"];
    
    PFFile *theImage = _report[@"image"];
    NSData *imageData = [theImage getData];
    self.imageReport.image = [UIImage imageWithData:imageData];

//    NSLog(@"%s",[[_report description]UTF8String]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
