//
//  UserFriendsViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "UserFriendsViewController.h"
#import "SSUserFriends.h"
#import "SSXmppConstant.h"

@interface UserFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelJid;
@end
@implementation UserFriendsCell
@end


@interface UserFriendsViewController ()
{
    NSArray *tableArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewUserFriends;

@end

@implementation UserFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SSUserFriends shareInstance]getUserFriends:^(NSDictionary *result) {
        if([[result valueForKey:kStatus]isEqualToString:kSuccess])
        {
            tableArray = [[result valueForKey:kData] copy];
            [_tableViewUserFriends reloadData];
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
    UserFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserFriendsCell"];
    cell.labelUsername.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.labelJid.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"jid"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)didReceiveMemoryWarning {
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
