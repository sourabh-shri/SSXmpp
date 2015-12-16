//
//  Ragistraion.h
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//


#import "SSXmppConstant.h"

@interface SSRagistraion : NSObject

@property (nonatomic, strong) SSRegistrationblock ssblock;

+(SSRagistraion *)shareInstance;

-(void)registration:(NSString*)username complition:(SSRegistrationblock)ssblock;

@end
