//
//  Ragistraion.m
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSRagistraion.h"

@implementation SSRagistraion

+(SSRagistraion *)shareInstance
{
    static SSRagistraion * instance;
    if(!instance)
        instance = [[SSRagistraion alloc] init];
    return instance;
}

-(void)registration:(NSString*)username complition:(SSRegistrationblock)ssblock
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
        [[SSConnectionClasses shareInstance] setupStream];

        if([[SSConnectionClasses shareInstance].xmppStream isConnected])
        {
            [[SSConnectionClasses shareInstance].xmppStream disconnect];
        }
        
        [[SSConnectionClasses shareInstance] connectWithJid:[SSXmppCommonClass removeSpacialCharecter:username]];
        
        NSError *error = nil;
        
        if (![[SSConnectionClasses shareInstance].xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
        {
            
        }
        
        [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

#pragma mark XMPPStream Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    [SSConnectionClasses shareInstance].isXmppConnected = YES;

    NSError *errorr = nil;
    if([[SSConnectionClasses shareInstance].xmppStream registerWithPassword:UserPassword error:&errorr])
    {
        // register 
    }
    else
    {
        // error
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (![SSConnectionClasses shareInstance].isXmppConnected)
    {
        // DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (_ssblock)
    {
        [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        _ssblock(SSResponce(kUserRagistered,kSuccess,@""));
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:error.XMLString error:&errors];
    
    if([[[[data valueForKey:@"iq"]valueForKey:@"error"]valueForKey:@"code"] isEqualToString:@"409"])
    {
        if (_ssblock)
        {
            [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            _ssblock(SSResponce(kUserExist,kFailed,@""));
        }
    }
    else if([[[[data valueForKey:@"iq"]valueForKey:@"error"]valueForKey:@"code"] isEqualToString:@"500"])
    {
        if (_ssblock)
        {
            [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            _ssblock(SSResponce(kServiceError,kFailed,@""));
        }
    }
    else
    {
        if (_ssblock)
        {
            [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            _ssblock(SSResponce(@"didNotRegister",kFailed,@""));
        }
    }
}

@end
