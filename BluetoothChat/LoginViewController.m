//
//  LoginViewController.m
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "LoginViewController.h"
#import "ContactListController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) ContactListController *contactListController;

@end

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(id)sender
{
    if ([self.nameTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Name could not be nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        self.contactListController = [[ContactListController alloc] initWithNibName:@"ContactListController" bundle:nil];
        [self.navigationController pushViewController:self.contactListController animated:YES];
    }
}
@end
