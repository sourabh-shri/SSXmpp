//
//  AddUserViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "AddUserViewController.h"
#import "SSAllUser.h"
#import "SSAddFriend.h"
#import "SSXmppConstant.h"

@interface AddUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelJid;
@end
@implementation AddUserCell
@end


@interface AddUserViewController ()
{
    NSArray *tableArray;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldSelectedUser;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAddUser;

@end

@implementation AddUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[SSAllUser shareInstance]getalluser:^(NSDictionary *result)
     {
         if([[result valueForKey:kStatus]isEqualToString:kSuccess])
         {
             tableArray = [[result valueForKey:kData] copy];
             NSMutableArray *arry  = [[NSMutableArray alloc]init];
             for (NSDictionary*dic in tableArray)
             {
                 if([[dic valueForKey:@"jid"] rangeOfString:Userpostfix].length>0)
                 {
                     [arry addObject:dic];
                 }
             }
             tableArray= [arry copy];
             [_tableViewAddUser reloadData];
         }
         else
         {
             NSString* str =  [NSString stringWithFormat:@"%@",result];
             ShowAlert(@"Message", str, nil);
         }
     }];

}

- (IBAction)actionOnAdd:(id)sender
{
    if(_textFieldSelectedUser.text.length>0)
    [[SSAddFriend shareInstance]addFriendWithJid:_textFieldSelectedUser.text complition:^(NSDictionary *result)
    {
        if([[result valueForKey:kStatus]isEqualToString:kSuccess])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString* str =  [NSString stringWithFormat:@"%@",result];
            ShowAlert(@"Message", str, nil);
        }
    }];
}

#pragma mark - tableview deleget/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddUserCell"];
    cell.labelUsername.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"Username"];
    cell.labelJid.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"jid"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textFieldSelectedUser.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"jid"];
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
