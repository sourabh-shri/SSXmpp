//
//  SSAllUser.h
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"

@interface SSAllUser : NSObject

@property (nonatomic, strong) SSAllUserblock ssblock;

+(SSAllUser *)shareInstance;

-(void)getalluser:(SSAllUserblock)ssblock;

@end
