//
//  SSAllUser.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSAllUser.h"

@implementation SSAllUser

+(SSAllUser *)shareInstance
{
    static SSAllUser * instance;
    if(!instance)
        instance = [[SSAllUser alloc] init];
    return instance;
}

-(void)getalluser:(SSAllUserblock)ssblock
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
        
        NSXMLElement *field1 = [NSXMLElement elementWithName:@"field"];
        [field1 addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
        [field1 addAttributeWithName:@"type" stringValue:@"hidden"];
        NSXMLElement *value1 = [NSXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search"];
        [field1 addChild:value1];
        
        NSXMLElement *field2 = [NSXMLElement elementWithName:@"field"];
        [field2 addAttributeWithName:@"var" stringValue:@"search"];
        [field2 addAttributeWithName:@"type" stringValue:@"text-single"];
        [field2 addAttributeWithName:@"label" stringValue:@"Search"];
        NSXMLElement *value2 = [NSXMLElement elementWithName:@"value" stringValue:@"*"];
        [field2 elementForName:@"required"];
        [field2 addChild:value2];
        
        NSXMLElement *field3 = [NSXMLElement elementWithName:@"field"];
        [field3 addAttributeWithName:@"var" stringValue:@"Username"];
        [field3 addAttributeWithName:@"type" stringValue:@"boolean"];
        [field3 addAttributeWithName:@"label" stringValue:@"Username"];
        NSXMLElement *value3 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
        [field3 addChild:value3];
        
        NSXMLElement *field4 = [NSXMLElement elementWithName:@"field"];
        [field4 addAttributeWithName:@"var" stringValue:@"Name"];
        [field4 addAttributeWithName:@"type" stringValue:@"boolean"];
        [field4 addAttributeWithName:@"label" stringValue:@"Name"];
        NSXMLElement *value4 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
        [field4 addChild:value4];
        
//        NSXMLElement *field5 = [NSXMLElement elementWithName:@"field"];
//        [field5 addAttributeWithName:@"var" stringValue:@"Email"];
//        [field5 addAttributeWithName:@"type" stringValue:@"boolean"];
//        [field5 addAttributeWithName:@"label" stringValue:@"Email"];
//        NSXMLElement *value5 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
//        [field5 addChild:value5];
        
        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:search"];
        NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
        [x addAttributeWithName:@"type" stringValue:@"submit"];
        
        [x addChild:field1];
        [x addChild:field2];
        [x addChild:field3];
        [x addChild:field4];
       // [x addChild:field5];
        
        [query addChild:x];
        //	XMPPIQ *iq = [XMPPIQ iq];
        NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
        [iq addAttributeWithName:@"type" stringValue:@"set"];
        [iq addAttributeWithName:@"id" stringValue:kAllUser];
        [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"search.%@",[[Userpostfix componentsSeparatedByString:@"@"] lastObject]]]];
        [iq addAttributeWithName:@"xml:lang" stringValue:@"en"];
        NSString *userBare1  = [[[[SSConnectionClasses shareInstance] xmppStream] myJID] bare];
        
        [iq addAttributeWithName:@"from" stringValue:userBare1];
        
        [iq addChild:query];
        
        [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppStream ] sendElement:iq];
    }
}

#pragma mark XMPPStream Delegate

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:iq.XMLString error:&errors];
  
    if(data!=nil && [[[data valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:kAllUser])
    {
        NSArray *array = [[[[[data valueForKey:@"iq"]valueForKey:@"query"] valueForKey:@"x"] valueForKey:@"item"] copy];
        
        NSMutableArray *arrayMutable = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array)
        {
            NSArray *array = [dic valueForKey:@"field"];
            
            NSDictionary *dicc = @{
                                   [[array objectAtIndex:0]valueForKey:@"var"]:[[[[array  objectAtIndex:0]valueForKey:@"value"] allKeys] count]>0?[[[array objectAtIndex:0]valueForKey:@"value"] valueForKey:@"text"]:@"",
                                   [[array objectAtIndex:1]valueForKey:@"var"]:[[[[array objectAtIndex:1]valueForKey:@"value"] allKeys] count]>0?[[[array objectAtIndex:1]valueForKey:@"value"] valueForKey:@"text"]:@"",
                                   [[array objectAtIndex:2]valueForKey:@"var"]:[[[[array objectAtIndex:2]valueForKey:@"value"] allKeys] count]>0?[[[array objectAtIndex:2]valueForKey:@"value"] valueForKey:@"text"]:@"",
                                   [[array objectAtIndex:3]valueForKey:@"var"]:[[[[array objectAtIndex:3]valueForKey:@"value"] allKeys] count]>0?[[[array objectAtIndex:3]valueForKey:@"value"]  valueForKey:@"text"]:@""
                                   };
            
            [arrayMutable addObject:[dicc mutableCopy]];
        }
        
        if(_ssblock)
        {
            _ssblock(SSResponce(@"",kSuccess,arrayMutable));
        }
    }
    
//    else if(dic!=nil &&  [[[dic valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:@"server all groups"])
//    {
//        NSMutableArray *groupArray = [[NSMutableArray alloc]init];
//        
//        for(NSXMLElement *element in [[iq childElement]children])
//        {
//            NSDictionary *dic =@{@"Username":[element attributeStringValueForName:@"name"],
//                                 @"jid":[element attributeStringValueForName:@"jid"]
//                                 };
//            
//            NSMutableDictionary *dc= [NSMutableDictionary dictionaryWithDictionary:dic];
//            
//            [groupArray addObject:dc];
//        }
//        if(xmppresponcegroupblock)
//        {
//            xmppresponcegroupblock(@{@"message":@"",
//                                     @"status":@"success",
//                                     @"data":groupArray
//                                     });
//            xmppresponcegroupblock=nil;
//        }
//    }
//    else if(dic!=nil &&  [[[dic valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:@"vcardget"])
//    {
//        NSString *userdata = [[[[dic valueForKey:@"iq"] valueForKey:@"vCard"] valueForKey:@"userdata"] valueForKey:@"text"];
//        
//        NSDictionary *dic = [self makeStringToJson:userdata];
//        
//        
//        if(_xmppvcardblock)
//        {
//            if(userdata==nil)
//            {
//                _xmppvcardblock(@{@"message":@"",
//                                  @"status":@"failed",
//                                  @"data":@"",
//                                  });
//                //_xmppvcardblock=nil;
//                
//            }
//            else
//            {
//                _xmppvcardblock(@{@"message":@"",
//                                  @"status":@"success",
//                                  @"data":dic
//                                  });
//                //_xmppvcardblock=nil;
//                
//            }
//        }
//    }
//    else if(dic!=nil &&  [[[dic valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:@"vcardset"])
//    {
//        
//        
//        if(_xmppvcardblock)
//            _xmppvcardblock(@{@"message":@"",
//                              @"status":@"success",
//                              @"data":@""
//                              });
//        _xmppvcardblock=nil;
//        
//    }
    
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{

}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:iq.XMLString error:&errors];
    if(data!=nil && [[[data valueForKey:@"iq"]valueForKey:@"id"] isEqualToString:kAllUser])
    {
        if (_ssblock)
        {
            _ssblock(SSResponce(kAllUserFailled,kFailed,@""));
        }
    }
}
@end
