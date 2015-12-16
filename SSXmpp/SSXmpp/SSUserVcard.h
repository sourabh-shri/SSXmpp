//
//  SSSetUserVcard.h
//  SSXmpp
//
//  Created by CANOPUS16 on 02/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"


@interface SSUserVcard : NSObject

@property (nonatomic, strong) SSUserVcardblock ssblock;

+(SSUserVcard *)shareInstance;

-(void)setVcardOfUser:(SSUserVcardblock)ssblock;
-(void)getVcardOfUser:(SSUserVcardblock)ssblock;

@end
