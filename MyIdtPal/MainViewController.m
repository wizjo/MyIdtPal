//
//  MainViewController.m
//  MyIdtPal
//
//  Created by Jo Pu  on 11/5/15.
//  Copyright © 2015 Jos Factory. All rights reserved.
//

#import "MainViewController.h"
#import <AWSCognito/AWSCognito.h>
#import "AFNetworking.h"
#import "DoneCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.teamsUrl = @"https://idonethis.com/api/v0.1/teams/crashlytics/";
    [self.addButton addTarget:self action:@selector(createADone:) forControlEvents:UIControlEventTouchUpInside];

    [self fetchDones];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"donesTableEmbed"]) {
        self.donesTableViewController = segue.destinationViewController;
    }
}

- (void)fetchDones {
    NSString *donesUrl = @"https://idonethis.com/api/v0.1/dones/?team=crashlytics";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.apiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:donesUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.donesTableViewController.dones = responseObject[@"results"];
        [self.donesTableViewController.tableView reloadData];
        self.descriptionLabel.text = @"Fabric's Dones today";
        NSLog(@"fetched dones!");
        [self.donesTableViewController viewWillAppear:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.descriptionLabel.text = @"iDoneThis ran into a problem :( Try post a done?";
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchTeams {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.apiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:self.teamsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *firstOrg = [responseObject[@"results"] objectAtIndex:0];
        NSLog(@"org name: %@, url: %@", firstOrg[@"name"], firstOrg[@"url"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (IBAction)createADone:(id)sender {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    [self postADone:self.doneTextField.text forDate:dateString];
    
    self.doneTextField.text = @"";
    [self.doneTextField resignFirstResponder];
}

- (void)postADone:(NSString *)body forDate:(NSString *)forDate {
    NSLog(@"body: %@, forDate: %@", body, forDate);
    
    NSString *postUrl = @"https://idonethis.com/api/v0.1/dones/";
    NSDictionary *params = @{@"raw_text":body, @"team":self.teamsUrl, @"done_date":forDate};
    NSLog(@"params: %@", params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.apiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:postUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.descriptionLabel.text = @"Fabric's Dones today";
        // append new done
        NSArray *newDones = [self.donesTableViewController.dones arrayByAddingObject:@{@"owner":@"me", @"raw_text":body}];
        self.donesTableViewController.dones = newDones;
        [self.donesTableViewController.tableView reloadData];
        NSLog(@"post success!");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

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

@end
