//
//  SSPopUpView.h
//  SSXmpp
//
//  Created by CANOPUS16 on 24/11/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SSPopUpBlock) (int index);

@interface SSPopUpView : UIView 

@property (nonatomic,strong) SSPopUpBlock blok;

+(SSPopUpView*)shareInstance;

-(void)showSSPopUp:(UIImage *)imageFirst secondimage:(UIImage *)imageSecond complition:(SSPopUpBlock)complition;

@end