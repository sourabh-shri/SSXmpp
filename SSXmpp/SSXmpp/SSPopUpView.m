//
//  SSPopUpView.m
//  SSXmpp
//
//  Created by CANOPUS16 on 24/11/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSPopUpView.h"
#import "AppDelegate.h"


@implementation SSPopUpView

+(SSPopUpView*)shareInstance
{
    static SSPopUpView* obj;
    if(obj==nil)
        obj=[[SSPopUpView alloc]init];
    return obj;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // [self setup];
    }
    return self;
}

-(void)showSSPopUp:(UIImage *)imageFirst secondimage:(UIImage *)imageSecond complition:(SSPopUpBlock)complition
{
    _blok= complition;
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    // set center label
    {
        UILabel *centerLabel = [[UILabel alloc]init];
        
        [centerLabel setBackgroundColor:[UIColor clearColor]];
        [centerLabel setTextAlignment:NSTextAlignmentCenter];
        [centerLabel setTextColor:[UIColor whiteColor]];
        [centerLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
        [centerLabel setText:@"You have a new match!"];
        [self addSubview:centerLabel];
        [centerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [centerLabel addConstraints:@[
                                      [NSLayoutConstraint constraintWithItem:centerLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
                                      [NSLayoutConstraint constraintWithItem:centerLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:window.frame.size.width],
                                      ]];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:centerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
                               [NSLayoutConstraint constraintWithItem:centerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
                               ]];
        
    }
    
    // set top images
    {
        UIView *topView = [[UIView alloc]init];
        [topView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:topView];
        [topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [topView addConstraints:@[
                                  [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-134],
                                  [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-40],
                                  ]];
        [self addConstraints:
         @[
           [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20],
           [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(((window.frame.size.height)/2)+30)],
           ]];
        
        // left image
        {
            CGFloat width = (window.frame.size.width)-75;

            UIImageView *leftimage = [[UIImageView alloc]init];
            [leftimage setClipsToBounds:YES];
            [leftimage setBackgroundColor:[UIColor clearColor]];
            leftimage.layer.cornerRadius = width/4;
            leftimage.layer.borderColor = [UIColor whiteColor].CGColor;
            leftimage.layer.borderWidth = 2.0;

            [topView addSubview:leftimage];
            [leftimage setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [leftimage addConstraints:@[
                                      [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                      [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                      ]];
            
            [topView addConstraints:
             @[
               [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5],
               [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5],
               ]];
           
            //Set internal View
            {
                CGFloat width = (window.frame.size.width)-95;
                
                UIImageView *leftimage = [[UIImageView alloc]init];
                [leftimage setImage:imageFirst];
                [leftimage setClipsToBounds:YES];
                [leftimage setBackgroundColor:[UIColor blackColor]];
                leftimage.layer.cornerRadius = width/4;
                leftimage.layer.borderColor = [UIColor colorWithRed:203.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor;
                leftimage.layer.borderWidth = 2.0;
                
                [topView addSubview:leftimage];
                [leftimage setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                [leftimage addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                            [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                            ]];
                
                [topView addConstraints:
                 @[
                   [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10],
                   [NSLayoutConstraint constraintWithItem:leftimage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10],
                   ]];
                
                
            }
        }
        
        //Right image
        {
            CGFloat width = (window.frame.size.width)-75;

            UIImageView *rightimage = [[UIImageView alloc]init];
            [rightimage setClipsToBounds:YES];
            [rightimage setBackgroundColor:[UIColor clearColor]];
            rightimage.layer.cornerRadius = width/4;
            rightimage.layer.borderColor = [UIColor whiteColor].CGColor;
            rightimage.layer.borderWidth = 2.0;
            [topView addSubview:rightimage];
            [rightimage setTranslatesAutoresizingMaskIntoConstraints:NO];

            [rightimage addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                        [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                        ]];
            
            [topView addConstraints:
             @[
               [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5],
               [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5],
               ]];
            
            {
                CGFloat width = (window.frame.size.width)-95;
                
                UIImageView *rightimage = [[UIImageView alloc]init];
                [rightimage setImage:imageSecond];
                [rightimage setClipsToBounds:YES];
                [rightimage setBackgroundColor:[UIColor blackColor]];
                rightimage.layer.cornerRadius = width/4;
                rightimage.layer.borderColor = [UIColor colorWithRed:203.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor;
                rightimage.layer.borderWidth = 2.0;
                [topView addSubview:rightimage];
                [rightimage setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                [rightimage addConstraints:@[
                                             [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                             [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width/2],
                                             ]];
                
                [topView addConstraints:
                 @[
                   [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10],
                   [NSLayoutConstraint constraintWithItem:rightimage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10],
                   ]];
            }
        }
    }
    
    // set bottom buttons
    {
        UIView *bottomView = [[UIView alloc]init];
        [bottomView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:bottomView];
        [bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [bottomView addConstraints:@[
                                     [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-134],
                                     [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-40],
                                     ]];
        [self addConstraints:
         @[
           [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20],
           [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:(((window.frame.size.height)/2)+30)],
           ]];
        
        // top button
        {
            UIButton *buttonChat = [[UIButton alloc]init];
            [buttonChat setBackgroundColor:[UIColor whiteColor]];
            [buttonChat setTitle:@"Send message" forState:UIControlStateNormal];
            [buttonChat setImage:[UIImage imageNamed:@"NavChat"] forState:UIControlStateNormal];
            buttonChat.tag=0;
            [buttonChat addTarget:self action:@selector(actionOnbutton:) forControlEvents:UIControlEventTouchUpInside];
            [buttonChat setImageEdgeInsets:UIEdgeInsetsMake(10, -15, 10, 10)];

            [buttonChat setTitleColor:[UIColor colorWithRed:203.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            buttonChat.layer.borderColor = [UIColor whiteColor].CGColor;
            buttonChat.layer.borderWidth = 2.0;
            buttonChat.layer.cornerRadius = 25.0;
            [bottomView addSubview:buttonChat];
            [buttonChat setTranslatesAutoresizingMaskIntoConstraints:NO];
            [buttonChat addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:buttonChat attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
                                         [NSLayoutConstraint constraintWithItem:buttonChat attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-100],
                                         ]];
            
            [bottomView addConstraints:
             @[
               [NSLayoutConstraint constraintWithItem:buttonChat attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-130],
                [NSLayoutConstraint constraintWithItem:buttonChat attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
               ]];

        }
        
        // bottom button
        {
            UIButton *buttonSearch = [[UIButton alloc]init];
            [buttonSearch setBackgroundColor:[UIColor clearColor]];
            [buttonSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buttonSearch.tag=1;
            [buttonSearch addTarget:self action:@selector(actionOnbutton:) forControlEvents:UIControlEventTouchUpInside];
            [buttonSearch setImageEdgeInsets:UIEdgeInsetsMake(10, -15, 10, 10)];
            [buttonSearch setTitle:@"Keep Searching" forState:UIControlStateNormal];
            [buttonSearch setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];

            buttonSearch.layer.borderColor = [UIColor whiteColor].CGColor;
            buttonSearch.layer.borderWidth = 2.0;
            buttonSearch.layer.cornerRadius = 25.0;

            [bottomView addSubview:buttonSearch];
            [buttonSearch setTranslatesAutoresizingMaskIntoConstraints:NO];
            [buttonSearch addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:buttonSearch attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
                                         [NSLayoutConstraint constraintWithItem:buttonSearch attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(window.frame.size.width)-100],
                                         ]];
            
            [bottomView addConstraints:
             @[
               [NSLayoutConstraint constraintWithItem:buttonSearch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-65],
               [NSLayoutConstraint constraintWithItem:buttonSearch attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
               ]];

        }
    }
    
    [self showSSPopUp];
}

-(void)actionOnbutton:(UIButton*)sender
{
    if(_blok)
        _blok((int)sender.tag);
    
    [self hideSSPopUp];
}

-(void)actiononcancel
{
    [self hideSSPopUp];
}

-(void)setup
{
    self.backgroundColor=[UIColor colorWithRed:203.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self hideSSPopUp];
}

-(void)hideSSPopUp
{
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [self removeFromSuperview];
    }];
}

-(void)showSSPopUp
{
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [window addSubview:self];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [window addConstraints:
     @[
       [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
       [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
       [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
       [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
       ]];
}

@end
