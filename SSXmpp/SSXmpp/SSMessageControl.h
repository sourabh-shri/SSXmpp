//
//  SSMessageControl.h
//  SSXmpp
//
//  Created by CANOPUS16 on 02/11/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"

@protocol SSMessageDelegate <NSObject>
@optional
- (void)shouldReloadTable:(NSMutableArray*)data;
- (void)chatStatus:(NSString*)status;
@end

@interface SSMessageControl : NSObject<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSFetchedResultsController*fetchedResultsController;
@property(nonatomic, assign) id <SSMessageDelegate> delegate;
@property (nonatomic,strong) NSString * otherjid;

+(SSMessageControl *)shareInstance;

- (void)setSSMessageDelegate;
- (void)sendMessage:(NSString *)messageString to:(NSString *)name;
- (void)fetchedObjectsController;

- (void)sendActiveChatToUser;
- (void)sendInactiveChatToUser;

- (void)sendComposingChatToUser;
- (void)sendPausedChatToUser;
- (void)sendExitChatToUser;


@end
