//
//  CreateGroupViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 21/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "SSCreateRoom.h"

@interface CreateGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCheck;

@end

@implementation CreateGroupCell
@end

@interface CreateGroupViewController ()
{
    NSArray *tableArray;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldSubject;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCreateGroup;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[SSCreateRoom shareInstance] fetchedFriends:^(NSDictionary *result)
    {
        if([[result valueForKey:kStatus]isEqualToString:kSuccess])
        {
            tableArray = [[result valueForKey:kData] copy];
            for (NSMutableDictionary *dic in tableArray)
            {
                [dic setValue:@"0" forKey:@"isSelected"];
            }
            [_tableViewCreateGroup reloadData];
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
    CreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateGroupCell"];
    cell.userName.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"displayName"];
    if([[[tableArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]isEqualToString:@"1"])
    {
        cell.imageViewCheck.image = [UIImage imageNamed:@"received_tik"];
    }
    else
    {
        cell.imageViewCheck.image = [UIImage imageNamed:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[tableArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]isEqualToString:@"1"])
        [[tableArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"isSelected"];
    else
        [[tableArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"];

    [_tableViewCreateGroup reloadData];
}

- (IBAction)actionOnDonee:(id)sender
{
    NSMutableArray *otherUserArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in tableArray)
    {
        if([[dic valueForKey:@"isSelected"]isEqualToString:@"1"])
        {
            [otherUserArray addObject:dic];
        }
    }
    
    [[SSCreateRoom shareInstance] createARoom:_textFieldSubject.text users:otherUserArray complition:^(NSDictionary *result) {
        
    }];
    
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
