//
//  SSUserFriends.h
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"

@interface SSUserFriends : NSObject

@property (nonatomic, strong) SSUserFriendsblock ssblock;

+(SSUserFriends *)shareInstance;

-(void)getUserFriends:(SSUserFriendsblock)ssblock;

@end
