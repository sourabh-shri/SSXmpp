//
//  SSAddFriend.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSAddFriend.h"

@implementation SSAddFriend

+(SSAddFriend *)shareInstance
{
    static SSAddFriend * instance;
    if(!instance)
        instance = [[SSAddFriend alloc] init];
    return instance;
}

-(void)addFriendWithJid:(NSString *)friendname complition:(SSAddFriendsblock)ssblock
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
        
//        NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
//        
//        NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
//       
//        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
//        
//        [item addAttributeWithName:@"jid" stringValue:[friendname stringByAppendingString:Userpostfix]];
//        [item addAttributeWithName:@"name" stringValue:friendname];
//        
//        [query addChild:item];
//
//        [iq addAttributeWithName:@"type" stringValue:@"set"];
//        [iq addChild:query];
//
        
        [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
       // [[SSConnectionClasses shareInstance].xmppStream sendElement:iq];
  
        
        if(![friendname rangeOfString:Userpostfix].length>0)
        {
            friendname = [friendname stringByAppendingString:Userpostfix];
        }
  [[[SSConnectionClasses shareInstance] xmppRoster] addUser:[XMPPJID jidWithString:friendname] withNickname:friendname];
        
    }

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:iq.XMLString error:&errors];
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendSuccess,kSuccess,data));
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendFailled,kFailed,@""));
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendFailled,kFailed,@""));
    }
}
@end
