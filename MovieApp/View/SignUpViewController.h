//
//  SignUpViewController.h
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signUpTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

NS_ASSUME_NONNULL_END
