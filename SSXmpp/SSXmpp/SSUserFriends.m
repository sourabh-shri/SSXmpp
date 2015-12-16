//
//  SSUserFriends.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSUserFriends.h"

@implementation SSUserFriends

+(SSUserFriends *)shareInstance
{
    static SSUserFriends * instance;
    if(!instance)
        instance = [[SSUserFriends alloc] init];
    return instance;
}

-(void)getUserFriends:(SSUserFriendsblock)ssblock
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
        NSError *error = [[NSError alloc] init];
        NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
        NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
        [iq addAttributeWithName:@"type" stringValue:@"get"];
        [iq addAttributeWithName:@"id" stringValue:kUserFriend];
        //[iq addAttributeWithName:@"from" stringValue:@"abcdefgx@canopus-pc"];
        [iq addChild:query];
        
        [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppStream sendElement:iq];
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:iq.XMLString error:&errors];
    if(data!=nil && [[[data valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:kUserFriend])
    {
        NSArray *array;
        if([[[[data valueForKey:@"iq"]valueForKey:@"query"] valueForKey:@"item"] isKindOfClass:[NSDictionary class]])
        {
            array = [NSArray arrayWithObject:[[[data valueForKey:@"iq"]valueForKey:@"query"] valueForKey:@"item"]];
        }
        else
        {
            array = [[[[data valueForKey:@"iq"]valueForKey:@"query"] valueForKey:@"item"]  copy];
        }
        
        if(array==nil)
        {
            if(_ssblock)
            {
                _ssblock(SSResponce(kUserFriendNotFound,kFailed,@""));
            }
        }
        else
        {
            if(_ssblock)
            {
                _ssblock(SSResponce(@"",kSuccess,array));
            }
        }
        
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kUserFriendFailled,kFailed,@""));
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kUserFriendFailled,kFailed,@""));
    }
}


@end
