//
//  RagistrationViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "RagistrationViewController.h"
#import "SSRagistraion.h"
#import "SSXmppConstant.h"

@interface RagistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfieldJid;

@end

@implementation RagistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)actionOnSignUp:(id)sender
{
    [[SSRagistraion shareInstance]registration:_textfieldJid.text complition:^(NSDictionary *result)
     {
         NSString* str =  [NSString stringWithFormat:@"%@",result];
         ShowAlert(@"Message", str, nil);
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
