//
//  MainViewController.m
//  MyIdtPal
//
//  Created by Jo Pu  on 11/5/15.
//  Copyright © 2015 Jos Factory. All rights reserved.
//

#import "MainViewController.h"
#import <AWSCognito/AWSCognito.h>

@interface MainViewController ()
@property (nonatomic) AWSCognitoCredentialsProvider *credentialsProvider;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"main view controller did load");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Re-initialize Cognito client. Need this b/c default Fabric.with doesn't initialize correctly.
- (void)configureAuthProvider {
    self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                initWithRegionType:AWSRegionUSEast1
                                identityPoolId:@"us-east-1:60a5010c-a3de-4f6f-a8ff-f52ec07f951d"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:self.credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
