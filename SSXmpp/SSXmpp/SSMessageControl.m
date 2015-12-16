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
    [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self fetchedObjectsController];
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
    [message addAttributeWithName:@"to" stringValue:name];
    [message addAttributeWithName:@"id" stringValue:messageId];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"messageType" stringValue:@"TextMessage"];
    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:UserJid]];
    
    [message addChild:body];
    
//    NSXMLElement *request = [NSXMLElement elementWithName:@"request"];
//    [request addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:receipts"];
//    [message addChild:request];
    
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];
    [self fetchedObjectsController];
}


#pragma mark - ReceiveMessage

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([message isChatMessageWithBody])
    {
      //  [self performSelector:@selector(fetchedObjectsController) withObject:nil afterDelay:.3];
        
//        NSError *parseError = nil;
//        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:[message XMLString] error:&parseError];
//        NSDictionary *MessageDict=[xmlDictionary valueForKey:@"message"];
//        if ([MessageDict[@"date"] isEqualToString:@""]) {
//            NSDate *date = [NSDate date];  //  gets current date
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString* todayDate = [formatter stringFromDate:date];
//            [MessageDict setValue:todayDate forKey:@"date"];
//            
//        }
//     //   [_messageDelegate newMessageReceived:MessageDict];
//        
//        NSString *body = [[message elementForName:@"body"] stringValue];
//        NSString *displayName = [[message from]bare];
//        if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//        {
//            // We are not active, so use a local notification instead
//            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//            localNotification.alertAction = @"Ok";
//            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//            localNotification.soundName = UILocalNotificationDefaultSoundName;
//            
//            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//        }
    }
}

- (void)fetchedObjectsController
{
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
            
            NSDictionary *dic = @{@"from":from,@"messageText":messageText,@"messageId":messageId,@"type":type,@"image":img,@"timestamp":messages.timestamp,@"outgoing":messages.outgoing};
            [dataArray addObject:dic];
        }
        else
        {
            XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:messages.message];
            
            if([[xmppMessage generateReceiptResponse] hasReceiptRequest])
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

    if(_delegate)
        [_delegate shouldReloadTable:dataArray];

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
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

- (void)sendActiveChatToUser {
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addActiveChatState];
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];}

- (void)sendInactiveChatToUser {
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[SSMessageControl shareInstance].otherjid];
    XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:message];
    [xmppMessage addInactiveChatState];
    XMPPElementReceipt *receipt;
    [[[SSConnectionClasses shareInstance] xmppStream] sendElement:message andGetReceipt:&receipt];}

- (void)sendExitChatToUser {
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
