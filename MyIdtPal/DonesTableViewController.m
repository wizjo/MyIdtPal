//
//  DonesTableViewController.m
//  MyIdtPal
//
//  Created by Jo Pu  on 11/6/15.
//  Copyright © 2015 Jos Factory. All rights reserved.
//

#import "DonesTableViewController.h"
#import "AFNetworking.h"
#import "DoneCell.h"

@interface DonesTableViewController ()

@end

@implementation DonesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    // Configure the cell...
    
    DoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneCell"];
    NSDictionary *done = self.dones[indexPath.row];

    NSString *item = [NSString stringWithFormat:@"%@: %@", done[@"owner"], done[@"raw_text"]];
//    NSAttributedString *markedup_done = [[NSAttributedString alloc] initWithData:[item dataUsingEncoding:NSUnicodeStringEncoding]
//                                                                    options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                                         documentAttributes:nil error:nil];
    
    cell.bodyLabel.text = item;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
