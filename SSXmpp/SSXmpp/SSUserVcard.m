//
//  SSSetUserVcard.m
//  SSXmpp
//
//  Created by CANOPUS16 on 02/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSUserVcard.h"

@implementation SSUserVcard

+(SSUserVcard *)shareInstance
{
    static SSUserVcard * instance;
    if(!instance)
        instance = [[SSUserVcard alloc] init];
    return instance;
}

-(void)getVcardOfUser:(SSUserVcardblock)ssblock
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
        XMPPvCardTemp *myvCardTempw = [[[SSConnectionClasses shareInstance] xmppvCardTempModule] myvCardTemp];
    }
}

-(void)setVcardOfUser:(SSUserVcardblock)ssblock
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
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppRoster] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPvCardTemp *myvCardTemp = [[[SSConnectionClasses shareInstance] xmppvCardTempModule] myvCardTemp];
        
        NSData *imageData1 = UIImageJPEGRepresentation([UIImage imageNamed:@"Picachu.jpg"],0.5);

        if (myvCardTemp)
        {
            [myvCardTemp setPhoto:imageData1];

            [[[SSConnectionClasses shareInstance] xmppvCardTempModule] updateMyvCardTemp:myvCardTemp];
        }
    }
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{

}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    
}
@end
