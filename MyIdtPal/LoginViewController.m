//
//  LoginViewController.m
//  MyIdtPal
//
//  Created by Jo Pu  on 11/5/15.
//  Copyright © 2015 Jos Factory. All rights reserved.
//

#import "LoginViewController.h"
#import <AWSCognito/AWSCognito.h>
#import <DigitsKit/DigitsKit.h>
#import "MainViewController.h"

@interface LoginViewController ()
@property DGTAuthenticateButton *authButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: remove for production
//    [[Digits sharedInstance] logOut];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showMainView"]) {
////        MainViewController *mainViewController = [segue destinationViewController];
//        
//        NSLog(@"segue to main view");        
//    }
//}

- (void)viewDidAppear:(BOOL)animated {    
    if (!self.userID) {
        [self makeAuthButton];
    } else {
        NSLog(@"user already logged in: %@", self.userID);
        [self toggleVisible];
    }
}

- (void)makeAuthButton {
    self.authButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        if (session.userID) {
            self.userID = session.userID;
            NSLog(@"DGT login userID: %@", session.userID);
            [self toggleVisible];
        } else if (error) {
            NSLog(@"Authentication error: %@", error.localizedDescription);
        }
    }];
    
    self.authButton.center = self.view.center;
    
    self.authButton.digitsAppearance = [self makeTheme];
    [self.view addSubview:self.authButton];
}

- (DGTAppearance *)makeTheme {
    DGTAppearance *theme = [[DGTAppearance alloc] init];
    
    theme.accentColor = [UIColor colorWithRed:(85/255.0) green:(172/255.0) blue:(238/255.0) alpha:1];
    
    return theme;
}

- (void)toggleVisible {
    self.confirmLabel.hidden = NO;
    self.tokenTextField.hidden = NO;
    self.nextButton.hidden = NO;
    self.authButton.hidden = YES;
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
