//
//  SignUpViewController.m
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//


//Lets Objective-C access Swift code.Objective-C → Swift
#import "MovieApp-Swift.h"
#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (nonatomic, strong) SignUpViewModel *viewModel;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[SignUpViewModel alloc] init];
}

- (IBAction)BacktoSignIn:(id)sender {
}

- (IBAction)signUpTapped:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    

    NSString *validationError = [self.viewModel validateInputsWithUsername:username password:password];
    if (validationError) {
        [self showAlert:validationError];
        return;
    }
    
    BOOL success = [self.viewModel registerUserWithUsername:username password:password];
    if (success) {
        [self showAlert:@"Sign Up Successful!" dismissOnOK:YES]; // Dismiss after user taps OK
    } else {
        [self showAlert:@"User already exists or failed to save"]; // Stay for correction
    }
}
// Navigate back to Sign In screen
- (IBAction)BacktoSignInpressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Show simple alert
- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

// Show alert and dismiss view controller on OK if specified
- (void)showAlert:(NSString *)message dismissOnOK:(BOOL)dismissOnOK {
    if (!dismissOnOK) { [self showAlert:message]; return; }
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
