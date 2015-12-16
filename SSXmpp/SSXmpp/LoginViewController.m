//
//  LoginViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "LoginViewController.h"
#import "SSXmppConstant.h"
#import "SSLogin.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldJid;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionOnLogin:(id)sender
{
//        [[SSPopUpView shareInstance] showSSPopUp:[UIImage imageNamed:@"profileplaceholder"] secondimage:[UIImage imageNamed:@"profileplaceholder"] complition:^(int index)
//         {
//            NSLog(@"%d",index);
//            
//         }];
//    
    [[SSLogin shareInstance]login:_textFieldJid.text complition:^(NSDictionary *result)
     {
         if([[result valueForKey:kStatus]isEqualToString:kSuccess])
         {
             [self performSegueWithIdentifier:@"HomeViewController" sender:nil];
         }
         else
         {
             NSString* str =  [NSString stringWithFormat:@"%@",result];
             ShowAlert(@"Message", str, nil);
         }
     }];
}

- (IBAction)actionOnSignUp:(id)sender
{
    [self performSegueWithIdentifier:@"RagistrationViewController" sender:nil];
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
