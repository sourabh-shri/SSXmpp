//
//  HomeViewController.m
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "AllUserViewController.h"
#import "SSAllUser.h"
#import "SSXmppConstant.h"

@interface AllUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelJid;
@end
@implementation AllUserCell
@end


@interface AllUserViewController ()
{
    NSArray *tableArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewHome;
@end

@implementation AllUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[SSAllUser shareInstance]getalluser:^(NSDictionary *result)
    {
        if([[result valueForKey:kStatus]isEqualToString:kSuccess])
        {
            tableArray = [[result valueForKey:kData] copy];
            [_tableViewHome reloadData];
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
    AllUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllUserCell"];
    cell.labelUsername.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"Username"];
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
