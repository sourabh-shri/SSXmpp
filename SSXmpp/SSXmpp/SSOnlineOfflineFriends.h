//
//  SSOnlineOfflineFriends.h
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"
@protocol SSOnlineOfflineFriendsDelegate <NSObject>
@optional
- (void)shouldReloadTable:(NSMutableArray*)data;
@end

@interface SSOnlineOfflineFriends : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) SSOnOfflineblock ssblock;
@property(nonatomic, assign) id <SSOnlineOfflineFriendsDelegate> delegate;
@property (nonatomic,strong) NSFetchedResultsController*fetchedResultsController;
@property (nonatomic,strong) NSFetchedResultsController*fetchedResultsController1;

+ (SSOnlineOfflineFriends *)shareInstance;
- (void)setSSOnlineOfflineFriendsDelegate;
- (void)fetchedResultsControllerOnlineOfflineFriends;

@end
