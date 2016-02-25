//
//  UserTabController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "UserTabController.h"

@interface UserTabCell : UITableViewCell
@end
@implementation UserTabCell
@end

@interface UserTabController ()
{
    NSArray *arrayTable;
}
@end

@implementation UserTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self tabBarController] setTitle:@"SS Xmpp"];
    [[[self tabBarController] navigationItem] setHidesBackButton:YES];
    arrayTable = [[NSArray alloc]initWithObjects:@"All xmpp user",@"Add user",@"User friends",@"User online/offline friends",@"My profile", @"User Groups ",@"Create Group",nil];
}

#pragma mark - tableview deleget/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTabCell"];
    cell.textLabel.text = [arrayTable objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"AllUserViewController" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"AddUserViewController" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"UserFriendsViewController" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"OnOfflineViewController" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"MyProfileViewController" sender:nil];
            break;
        case 5:
            [self performSegueWithIdentifier:@"UserGroupsViewController" sender:nil];
            break;
        case 6:
            [self performSegueWithIdentifier:@"CreateGroupViewController" sender:nil];
            break;
        default:
            break;
    }
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
