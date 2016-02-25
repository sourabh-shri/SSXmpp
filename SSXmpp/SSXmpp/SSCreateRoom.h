//
//  SSCreateRoom.h
//  SSXmpp
//
//  Created by CANOPUS16 on 21/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"


@interface SSCreateRoom : NSObject<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) SSRoomFriendblock ssblock;
@property (nonatomic, strong) SSCreateRoomblock ssblock1;
@property (nonatomic, strong) NSMutableArray *usersToAdd;


@property (nonatomic,strong) NSFetchedResultsController*fetchedResultsController;


+ (SSCreateRoom *)shareInstance;
-(void)createARoom:(NSString *)subject users:(NSMutableArray*)users complition:(SSCreateRoomblock)ssblock;
- (void)fetchedFriends:(SSRoomFriendblock)ssblock;

@end