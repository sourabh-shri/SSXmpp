//
//  MyProfile.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/11/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "MyProfileViewController.h"
#import "SSXmppConstant.h"
#import "SSUserVcard.h"

@implementation MyProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SSUserVcard shareInstance]getVcardOfUser:^(NSDictionary *result)
    {
        NSData *d = [result valueForKey:kData];
        _imageViewPic.image = [UIImage imageWithData:d];
    }];
}

@end
