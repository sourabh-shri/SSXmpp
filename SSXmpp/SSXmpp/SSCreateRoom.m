//
//  SSCreateRoom.m
//  SSXmpp
//
//  Created by CANOPUS16 on 21/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSCreateRoom.h"

@implementation SSCreateRoom

+(SSCreateRoom *)shareInstance
{
    static SSCreateRoom * instance;
    if(!instance)
        instance = [[SSCreateRoom alloc] init];
    return instance;
}

-(void)createARoom:(NSString *)subject users:(NSMutableArray*)users complition:(SSCreateRoomblock)ssblock
{
    _ssblock1 = ssblock;
    _usersToAdd = users;
    
    //subject = [[subject componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

    
    XMPPRoomMemoryStorage * _roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    NSString* roomID = [subject stringByAppendingString:Grouppostfix];
    XMPPJID * roomJID = [XMPPJID jidWithString:roomID];
    XMPPRoom* xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_roomMemory
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom activate:[SSConnectionClasses shareInstance].xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:[SSConnectionClasses shareInstance].xmppStream.myJID.user
                            history:nil
                           password:nil];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
//    DDLogVerbose(@"%@: %@ -> %@", THIS_FILE, THIS_METHOD, sender.roomJID.user);
    
    NSError *parseError = nil;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:configForm.XMLString error:&parseError];
    
    NSXMLElement *newConfig = [configForm copy];
    NSArray* fields = [newConfig elementsForName:@"field"];
    for (NSXMLElement *field in fields)
    {
        NSString *var = [field attributeStringValueForName:@"var"];
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"])
        {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
    }
    [sender configureRoomUsingOptions:newConfig];
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
   [sender fetchConfigurationForm];
   for (NSMutableDictionary *dic in _usersToAdd)
   {
        XMPPJID *friendjid  = [XMPPJID jidWithString:[dic valueForKey:@"jidStr"]]
        ;
       
        
        [sender editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"owner" jid:friendjid]]];
        [sender inviteUser:friendjid withMessage:@"Join it."];
        // [[SSConnectionClasses shareInstance].xmppRoster addUser:friendjid withNickname:subject groups:@[roomID] subscribeToPresence:YES];
    }
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{

}

#pragma mark - get user for add in a group

- (void)fetchedFriends:(SSRoomFriendblock)ssblock;
{
    _ssblock = ssblock;
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (ssblock)
        {
            ssblock(SSResponce(kInternetAlertMessage,kFailed,@""));
        }
    }
    else
    {
        if ([SSCreateRoom shareInstance].fetchedResultsController == nil)
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
            
            [SSCreateRoom shareInstance].fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                        managedObjectContext:moc
                                                                                                          sectionNameKeyPath:@"sectionNum"
                                                                                                                   cacheName:nil];
            [[SSCreateRoom shareInstance].fetchedResultsController setDelegate:self];
            
            NSError *error = nil;
            if (![[SSCreateRoom shareInstance].fetchedResultsController performFetch:&error])
            {
                //    DDLogError(@"Error performing fetch: %@", error);
            }
        }
        
        NSMutableArray *arrayOfData = [[NSMutableArray alloc]init];
        
        for ( XMPPUserCoreDataStorageObject *user in [[SSCreateRoom shareInstance].fetchedResultsController fetchedObjects])
        {
            if([user.jidStr rangeOfString:Grouppostfix].length>0)
                continue;
            
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
            [arrayOfData addObject:dic];
        }
        
        if(_ssblock)
        {
            _ssblock(SSResponce(kUserFriend,kSuccess,arrayOfData));
        }
    }
}

@end
