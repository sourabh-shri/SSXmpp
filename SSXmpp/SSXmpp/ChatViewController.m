//
//  ChatViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 02/11/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "ChatViewController.h"
#import "SSMessageControl.h"

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMessageStatus;
@end
@implementation ChatCell
@end

@interface ChatViewController ()<SSMessageDelegate>
{
    NSMutableArray *tableArray;
}
@property (weak, nonatomic) IBOutlet UILabel *labelChatStatus;
@property (weak, nonatomic) IBOutlet UITableView *tableViewChat;
@property (weak, nonatomic) IBOutlet UITextField *textFieldChat;
@property (weak, nonatomic) IBOutlet UIButton *ButtonGroupMember;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SSMessageControl shareInstance].otherjid = _otherJid;
    [SSMessageControl shareInstance].delegate=self;
    [[SSMessageControl shareInstance] setSSMessageDelegate];
    
    [[SSMessageControl shareInstance] sendActiveChatToUser];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SSMessageControl shareInstance].delegate=nil;
    [[SSMessageControl shareInstance] sendInactiveChatToUser];
    [[SSMessageControl shareInstance] removeSSMessageDelegate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    cell.labelMessage.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"messageText"];
    cell.imageViewUser.image = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    if([[[tableArray objectAtIndex:indexPath.row] valueForKey:@"outgoing"] integerValue]==1)
    {
        [cell.contentView setBackgroundColor:[UIColor darkGrayColor]];
    }
    else
    {
        [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];

    }

    NSString *receaptStatus = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"recieptStatus"];
    
    if([receaptStatus isEqualToString:@"request"])
    {
        cell.imageViewMessageStatus.image = [UIImage imageNamed:@"request_tik"];
    }
    else if ([receaptStatus isEqualToString:@"received"])
    {
        cell.imageViewMessageStatus.image = [UIImage imageNamed:@"received_tik"];
    }
    else
    {
        cell.imageViewMessageStatus.image = [UIImage imageNamed:@"wait_tik"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (IBAction)actionOnSent:(id)sender
{
    [[SSMessageControl shareInstance]sendMessage:_textFieldChat.text to:_otherJid];
    _textFieldChat.text =@"";
}

- (void)shouldReloadTable:(NSMutableArray*)data
{
    tableArray = [data mutableCopy];
    [_tableViewChat reloadData];
    [self scrollTableViewToBottom];
}

- (void)chatStatus:(NSString*)status;
{
    _labelChatStatus.text = status;
}

-(void)scrollTableViewToBottom
{
    if([tableArray count]>0)
    {
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:[tableArray count]-1 inSection:0];
        [_tableViewChat scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (IBAction)actionOnGroupMember:(id)sender
{
    [self performSegueWithIdentifier:@"GroupMembersViewController" sender:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [[SSMessageControl shareInstance] sendComposingChatToUser];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  //  [[SSMessageControl shareInstance] sendPausedChatToUser];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
