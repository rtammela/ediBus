//
//  ViewController.m
//  apitestv2
//
//  Created by TAMMELA Roosa on 2/18/15.
//  Copyright (c) 2015 TAMMELA Roosa. All rights reserved.
//

#import "ViewController.h"
#import "SBJson4.h"
#import "busInfo.h"

@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    printf("testing");
    
    // Call busInfo methods
    busInfo* getInfo = [[busInfo alloc] init];
    //[getInfo getServices];
    //[getInfo getStops];
    NSArray *busStopMap = [getInfo makeBusStopMap];

    [getInfo makeServiceMap:busStopMap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

