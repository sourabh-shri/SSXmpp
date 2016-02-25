//
//  SSMessageControl.m
//  SSXmpp
//
//  Created by CANOPUS16 on 02/11/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSMessageControl.h"
#import "SSXmppConstant.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessage+XEP_0085.h"
#import "XMPPMessage+XEP_0184.h"
#import "XMPPRoomCoreDataStorage.h"

@implementation SSMessageControl

+(SSMessageControl *)shareInstance
{
    static SSMessageControl * instance;
    if(!instance)
        instance = [[SSMessageControl alloc] init];
    return instance;
}

-(void)setSSMessageDelegate
{
    _isInChat =YES;
    [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self fetchedObjectsController];
}

-(void)removeSSMessageDelegate
{
    _isInChat =NO;
    [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - SentMessage

-(void)sendMessage:(NSString *)messageString to:(NSString *)name
{
    NSData *data = [messageString dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:goodValue];
    
    NSString *messageId=[[[SSConnectionClasses shareInstance] xmppStream] generateUUID];
    
    if(![name rangeOfString:Userpostfix].length>0)
    {
        name= [name stringByAppendingString:Userpostfix];
    }
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"id" stringValue:messageId];
    [message addAttributeWithName:@"to" stringValue:name];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"messageType" stringValue:@"TextMessage"];
    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:UserJid]];
    [message addChild:body];

    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
    
    [self fetchedObjectsController];
}

-(void)sentMessageInagroup:(NSString *)messageString to:(NSString *)name
{
    NSData *data = [messageString dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:goodValue];
    
    NSString *messageId=[[[SSConnectionClasses shareInstance] xmppStream] generateUUID];
    
    if(![name rangeOfString:Grouppostfix].length>0)
    {
        name= [name stringByAppendingString:Grouppostfix];
    }
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"id" stringValue:messageId];
    [message addAttributeWithName:@"to" stringValue:name];
    [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    [message addAttributeWithName:@"messageType" stringValue:@"TextMessage"];
    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:UserJid]];
    
    [message addChild:body];
    
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
    
    //[self fetchedObjectsController];
}


#pragma mark - ReceiveMessage

- (void)fetchedGroupObjectsController
{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"roomJIDStr=%@",[SSMessageControl shareInstance].otherjid];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    
//    [fetchRequest setFetchBatchSize:20];
//  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPRoomMessageCoreDataStorageObject"];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"localTimestamp" ascending:YES];
//    request.sortDescriptors = @[sort];
    
//   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomJIDStr = %@",[SSMessageControl shareInstance].otherjid];
    
    
    [SSMessageControl shareInstance].fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    
    [SSMessageControl shareInstance].fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![[SSMessageControl shareInstance].fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
    
    NSArray* messagesStored = [[SSMessageControl shareInstance].fetchedResultsController.fetchedObjects copy];
}

- (void)fetchedObjectsController
{
//    XMPPRoomMessageCoreDataStorageObject
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ and streamBareJidStr = %@",[SSMessageControl shareInstance].otherjid,[SSConnectionClasses shareInstance].xmppStream.myJID.bare];
    request.predicate = predicate;
    [SSMessageControl shareInstance].fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    [SSMessageControl shareInstance].fetchedResultsController.delegate = self;
    NSError *error = nil;
    if (![[SSMessageControl shareInstance].fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
    
    NSArray* messagesStored = [[SSMessageControl shareInstance].fetchedResultsController.fetchedObjects copy];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    XMPPMessageArchiving_Message_CoreDataObject *lastMessage;
    for (XMPPMessageArchiving_Message_CoreDataObject *messages in messagesStored)
    {
        if(messages.body!=nil)
        {
            NSError *parseError = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:[[messages message] XMLString] error:&parseError];
           // NSLog(@"%@",xmlDictionary);
            NSDictionary *MessageDict=[xmlDictionary valueForKey:@"message"];
            NSString *from=[MessageDict valueForKey:@"from"];
            NSString *type=[MessageDict valueForKey:@"type"];
            NSString *messageText=[[MessageDict valueForKey:@"body"] valueForKey:@"text"];
            NSString *messageId=[MessageDict valueForKey:@"id"];
            NSString *recieptStatus=messages.recieptStatus;

            UIImage *img = [UIImage new];
            NSData *photoData;
            if([messages.outgoing integerValue]==1)
            {
             photoData = [[[SSConnectionClasses shareInstance] xmppvCardAvatarModule] photoDataForJID:[XMPPJID jidWithString:messages.streamBareJidStr]];
            }
            else
            {
             photoData = [[[SSConnectionClasses shareInstance] xmppvCardAvatarModule] photoDataForJID:[XMPPJID jidWithString:messages.bareJidStr]];
            }
            
            if (photoData != nil)
                   img = [UIImage imageWithData:photoData];
            else
                img = [UIImage imageNamed:@"profileplaceholder"];
            
            NSDictionary *dic = @{@"from":from,@"messageText":messageText,@"messageId":messageId,@"type":type,@"image":img,@"timestamp":messages.timestamp,@"outgoing":messages.outgoing,@"recieptStatus":recieptStatus};
            
            [dataArray addObject:dic];
           
            lastMessage = messages;
        }
        else
        {
            XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:messages.message];
            
            if([messages.message hasReceiptRequest])
            {
                NSLog(@"%@",@"hasReceiptResponse");
            }
            if([messages.message hasReceiptResponse])
            {
                NSLog(@"%@",@"hasReceiptResponse");
            }
            
            if([xmppMessage hasComposingChatState])
            {
                if(_delegate)
                    [_delegate chatStatus:@"Typing..."];
            }
            else if ([xmppMessage hasPausedChatState])
            {
                if(_delegate)
                    [_delegate chatStatus:@"Paused..."];
            }
            else if ([xmppMessage hasGoneChatState] || [xmppMessage hasInactiveChatState] )
            {
                if(_delegate)
                    [_delegate chatStatus:@"Gone/inactive..."];
            }
        }
    }
    
    if(lastMessage)
    {
        XMPPMessageArchiving_Contact_CoreDataObject *contact = [storage contactWithBareJidStr:lastMessage.bareJidStr streamBareJidStr:lastMessage.streamBareJidStr managedObjectContext:[storage managedObjectContext2]];
        
        contact.unreadcount=0;
    }
    
    if(_delegate)
        [_delegate shouldReloadTable:dataArray];

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(_isInChat)
        [self fetchedObjectsController];
}

- (void)sendComposingChatToUser
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addComposingChatState];
    
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
}

- (void)sendActiveChatToUser
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addActiveChatState];
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
}

- (void)sendInactiveChatToUser
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addInactiveChatState];
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];}

- (void)sendExitChatToUser
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addGoneChatState];
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
}

- (void)sendPausedChatToUser
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addPausedChatState];
    [[SSConnectionClasses shareInstance].xmppStream sendElement:message];
}

@end
