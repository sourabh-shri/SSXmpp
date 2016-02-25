//
//  OnOfflineViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "OnOfflineViewController.h"

#import "SSUserFriends.h"
#import "SSXmppConstant.h"
#import "SSOnlineOfflineFriends.h"

#import "SSXmppConstant.h"

#import "ChatViewController.h"
#import "SSOnlineOfflineFriends.h"

@interface OnOfflineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userOnline;
@property (weak, nonatomic) IBOutlet UILabel *unReadCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOFA;
@property (weak, nonatomic) IBOutlet UILabel *lableDate;

@end
@implementation OnOfflineCell
@end


@interface OnOfflineViewController ()<SSOnlineOfflineFriendsDelegate>
{
    NSArray *tableArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewOnOffline;

@end

@implementation OnOfflineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SSOnlineOfflineFriends shareInstance].delegate=self;
    [[SSOnlineOfflineFriends shareInstance] setSSOnlineOfflineFriendsDelegate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SSOnlineOfflineFriends shareInstance].delegate=nil;
}

#pragma mark - tableview deleget/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnOfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnOfflineCell"];
    cell.userName.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"displayName"];
    cell.userImage.image = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"photo"];
    cell.userOnline.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"mostRecentMessageBody"];
    
    cell.unReadCount.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"unreadcount"];
     cell.lableDate.text = [NSString stringWithFormat:@"%@",[[tableArray objectAtIndex:indexPath.row] valueForKey:@"mostRecentMessageTimestamp"]];
    switch ([[[tableArray objectAtIndex:indexPath.row] valueForKey:@"sectionNum"] integerValue]) {
        case 0:
            cell.imageViewOFA.image = [UIImage imageNamed:@"Online.jpeg"];
            break;
        case 1:
            cell.imageViewOFA.image = [UIImage imageNamed:@"Away.jpeg"];
            break;
        case 2:
            cell.imageViewOFA.image = [UIImage imageNamed:@"Offline.jpeg"];
            break;
        default:
            break;
    }
    return cell;
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
//{
//    
//    NSArray *sections = [[self fetchedResultsController] sections];
//    
//    if (sectionIndex < [sections count])
//    {
//        id <NSFetchedResultsSectionInfo> sectionInfo = sections[sectionIndex];
//        return sectionInfo.numberOfObjects;
//    }
//    
//    return 0;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:CellIdentifier];
//    }
//    
//    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = user.displayName;
//    [self configurePhotoForCell:cell user:user];
//    
//    return cell;
//}
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [[[tableArray objectAtIndex:<#(NSUInteger)#>] sections] count];
//}
//
//
//
//- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
//{
//    NSArray *sections = [[self fetchedResultsController] sections];
//    
//    if (sectionIndex < [sections count])
//    {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
//        
//        int section = [sectionInfo.name intValue];
//        switch (section)
//        {
//            case 0  : return @"Available";
//            case 1  : return @"Away";
//            default : return @"Offline";
//        }
//    }
//    
//    return @"";
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    [self performSegueWithIdentifier:@"ChatViewController" sender:indexPath];
}


- (void)shouldReloadTable:(NSMutableArray*)data
{
    tableArray = [data mutableCopy];
    [_tableViewOnOffline reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)indexPath
{
    if([segue.identifier isEqualToString:@"ChatViewController"])
    {
        
        ChatViewController *vc = (ChatViewController *)[segue destinationViewController];
        vc.otherJid = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"jidStr"];
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
