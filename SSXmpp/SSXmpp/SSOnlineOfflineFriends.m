//
//  SSOnlineOfflineFriends.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSOnlineOfflineFriends.h"

@implementation SSOnlineOfflineFriends

+(SSOnlineOfflineFriends *)shareInstance
{
    static SSOnlineOfflineFriends * instance;
    if(!instance)
        instance = [[SSOnlineOfflineFriends alloc] init];
    return instance;
}

-(void)setSSOnlineOfflineFriendsDelegate
{
    [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self fetchedResultsControllerOnlineOfflineFriends];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return YES;
}

#pragma mark FetchResultsController

- (void)fetchedResultsControllerOnlineOfflineFriends
{
    if ([SSOnlineOfflineFriends shareInstance].fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [[SSConnectionClasses shareInstance] managedObjectContext_roster];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = @[sd1, sd2];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        [SSOnlineOfflineFriends shareInstance].fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [[SSOnlineOfflineFriends shareInstance].fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        if (![[SSOnlineOfflineFriends shareInstance].fetchedResultsController performFetch:&error])
        {
            //    DDLogError(@"Error performing fetch: %@", error);
        }
    }
    
    
    NSMutableDictionary *dicOflastmessages = [self getUserslastConversationMessage];
    NSMutableArray *arrayOfData = [[NSMutableArray alloc]init];
    
    for ( XMPPUserCoreDataStorageObject *user in [[SSOnlineOfflineFriends shareInstance].fetchedResultsController fetchedObjects])
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

        [dic setValue:user.jid forKey:@"jid"];
        [dic setValue:user.jidStr forKey:@"jidStr"];
        [dic setValue:user.streamBareJidStr forKey:@"streamBareJidStr"];
        [dic setValue:user.nickname forKey:@"nickname"];
        [dic setValue:user.displayName forKey:@"displayName"];
        [dic setValue:user.subscription forKey:@"subscription"];
        [dic setValue:user.ask forKey:@"ask"];
        [dic setValue:user.unreadMessages forKey:@"unreadMessages"];
     
       // NSLog(@"user : %@ \n Unreadmessage : %@",user.jidStr,user.unreadMessages);
        UIImage *img = [UIImage new];

        if (user.photo != nil)
        {
            img = user.photo;
        }
        else
        {
            NSData *photoData = [[[SSConnectionClasses shareInstance] xmppvCardAvatarModule] photoDataForJID:user.jid];
            
            if (photoData != nil)
                img = [UIImage imageWithData:photoData];
            else
                img = [UIImage imageNamed:@"profileplaceholder"];
        }
        
        [dic setValue:img forKey:@"photo"];
        [dic setValue:[NSString stringWithFormat:@"%d",(int)user.section] forKey:@"section"];
        [dic setValue:user.sectionName forKey:@"sectionName"];
        [dic setValue:user.sectionNum forKey:@"sectionNum"];
        
        NSMutableDictionary *dicLastMessage = [dicOflastmessages valueForKey:[dic valueForKey:@"jidStr"]];
        
        if(dicLastMessage!=nil)
        {
            [dic setValue:[dicLastMessage valueForKey:@"mostRecentMessageTimestamp"] forKey:@"mostRecentMessageTimestamp"];
            [dic setValue:[dicLastMessage valueForKey:@"mostRecentMessageBody"] forKey:@"mostRecentMessageBody"];
            [dic setValue:[dicLastMessage valueForKey:@"mostRecentMessageOutgoing"] forKey:@"mostRecentMessageOutgoing"];
            [dic setValue:[dicLastMessage valueForKey:@"unreadcount"] forKey:@"unreadcount"];
            
        }
        else
        {
            [dic setValue:@"" forKey:@"mostRecentMessageTimestamp"];
            [dic setValue:@"" forKey:@"mostRecentMessageBody"];
            [dic setValue:@"" forKey:@"mostRecentMessageOutgoing"];
            [dic setValue:@"0" forKey:@"unreadcount"];
        }
        
        [arrayOfData addObject:dic];
    }
    
    if(_delegate)
        [_delegate shouldReloadTable:arrayOfData];
    
}

-(NSMutableDictionary *)getUserslastConversationMessage
{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[SSConnectionClasses shareInstance].xmppStream.myJID.bare];
    request.predicate = predicate;
    [SSOnlineOfflineFriends shareInstance].fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    [SSOnlineOfflineFriends shareInstance].fetchedResultsController1.delegate = self;
    NSError *error = nil;
    if (![[SSOnlineOfflineFriends shareInstance].fetchedResultsController1 performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
    
    NSArray* messagesStored = [[SSOnlineOfflineFriends shareInstance].fetchedResultsController1.fetchedObjects copy];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    for (XMPPMessageArchiving_Contact_CoreDataObject *messages in messagesStored)
    {
        if(messages.mostRecentMessageBody!=nil)
        {
            NSString *unreadmessage;
            
            if(messages.unreadcount == [NSNull null])
            {
                unreadmessage =@"0";
            }
            else
            {
                unreadmessage = [NSString stringWithFormat:@"%d",messages.unreadcount];
            }
            
            NSDictionary *dic = @{
                                  @"bareJidStr":messages.bareJidStr,
                                  @"mostRecentMessageTimestamp":messages.mostRecentMessageTimestamp,
                                  @"mostRecentMessageBody":messages.mostRecentMessageBody,
                                  @"mostRecentMessageOutgoing":messages.mostRecentMessageOutgoing,
                                  @"streamBareJidStr":messages.streamBareJidStr,
                                  @"unreadcount":unreadmessage,
                                  };
            
            [dicData setObject:dic forKey:[dic valueForKey:@"bareJidStr"]];
            
            NSLog(@"%@",dicData);
        }
    }
    return dicData;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self fetchedResultsControllerOnlineOfflineFriends];
}

- (void)joinMultiUserChatRoom:(NSString *)newRoomName
{
    XMPPJID *roomJID = [XMPPJID jidWithString:newRoomName];
    XMPPRoom *newXmppRoom = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJID dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    [newXmppRoom addDelegate: self  delegateQueue:dispatch_get_main_queue()];
    [newXmppRoom activate:[SSConnectionClasses shareInstance].xmppStream];
    [newXmppRoom joinRoomUsingNickname:[SSConnectionClasses shareInstance].xmppStream.myJID.user
                               history:nil
                             password:nil];
}

@end
