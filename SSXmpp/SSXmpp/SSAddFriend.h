//
//  SSAddFriend.h
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"

@interface SSAddFriend : NSObject

@property (nonatomic, strong) SSAddFriendsblock ssblock;

+(SSAddFriend *)shareInstance;

-(void)addFriendWithJid:(NSString *)friendname complition:(SSAddFriendsblock)ssblock;

@end
