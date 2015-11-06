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

@property DGTSession *session;
@property DGTAuthenticateButton *authButton;
@property (nonatomic) AWSCognitoDataset* dataset;
@property (nonatomic) AWSCognitoCredentialsProvider *credentialsProvider;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCognito];
    [self.nextButton addTarget:self action:@selector(syncToAws:) forControlEvents:UIControlEventTouchUpInside];
    
    // TODO: delete. ONLY for development!!!
//    [[Digits sharedInstance] logOut];
}

- (void)viewDidAppear:(BOOL)animated {    
    if (!self.session) {
        [self makeAuthButton];
    } else {
        NSLog(@"user already logged in: %@", self.session.userID);
        [self configureAuthProvider:self.session.authToken secret:self.session.authTokenSecret];
        [self toggleVisible];
        [self synchronizeDataset];
    }
}

// Re-initialize Cognito client. Need this b/c default Fabric.with doesn't initialize correctly.
- (void)configureCognito {
    self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:@"us-east-1:60a5010c-a3de-4f6f-a8ff-f52ec07f951d"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:self.credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

- (void)configureAuthProvider:(NSString *)token secret:(NSString *)secret {
    NSString *value = [NSString stringWithFormat:@"%@;%@", token, secret];
    // Note: This overrides any existing logins
    self.credentialsProvider.logins = @{@"www.digits.com": value};
    self.dataset = [[AWSCognito defaultCognito] openOrCreateDataset:@"apiToken"];
}

- (void)makeAuthButton {
    self.authButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        if (session.userID) {
            self.session = session;
            [self configureAuthProvider:session.authToken secret:session.authTokenSecret];
            [self toggleVisible];
            [self synchronizeDataset];
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

- (IBAction)syncToAws:(id)sender {
    [self.dataset setString:self.tokenTextField.text forKey:@"apiToken"];
    [self synchronizeDataset];
    [self.tokenTextField resignFirstResponder];
}

- (void)synchronizeDataset {
    // Avoid keeping a reference if the ViewController is popped
    // before a sync completes.
    LoginViewController* __weak weakSelf = self;
    [[self.dataset synchronize] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error in sync: %@", task.error.localizedDescription);
            return nil;
        }
        
        if (task.completed) {
            NSLog(@"Sync successful");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf) {
                    weakSelf.tokenTextField.text = [self.dataset stringForKey:@"apiToken"];
                }
            });
        }
        
        return nil;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMainView"]) {
        MainViewController *mainViewController = segue.destinationViewController;
        
        mainViewController.apiToken = [self.dataset stringForKey:@"apiToken"];
    }
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
