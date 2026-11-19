//
//  MainMenuViewController.m
//  ischoolistaff
//
//  Created by Jasmond Luk on 11/5/2016.
//  Copyright © 2016 Dreamware Limited. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MyClass.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

-(void)viewDidLoad
{
    globalvariables=[GlobalVariables singleObj];
    [super viewDidLoad];
    self.slideMenuDelegate=self;

}

-(NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier=@"notification";
            break;
        case 1:
            identifier=@"studentprofile";
            break;
        case 2:
            identifier=@"classschedule";
            break;
        case 3:
            identifier=@"timetable";
            break;
        case 4:
            identifier=@"renewal";
            break;
        case 5:
            identifier=@"financial";
            break;
        case 6:
            identifier=@"message";
            break;
        case 7:
            identifier=@"classphoto";
            break;
        case 8:
            identifier=@"taskassignment";
            break;
        case 9:
            identifier=@"leadprofile";
            break;
        case 10:
            identifier=@"assessment";
            break;
        case 11:
            identifier=@"centerinformation";
            break;
        case 12:
            identifier=@"settings";
            break;
        case 13:
            identifier=@"changelog";
            break;
        case 14:
            identifier=@"helpcenter";
            break;
        default:
            break;
    }
    globalvariables.leftmenuindex=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return identifier;
}



-(CGFloat) leftMenuWidth
{
    return 220;
}



- (BOOL)deepnessForLeftMenu
{
    return YES;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    //nudge the left button 15 point to the left by making the value negative
    button.frame = CGRectMake(0, 0, 20, 21);
    [button setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
}

-(void) leftMenuWillOpen
{
    [self.view endEditing:YES];
    if (self.leftMenu.datedisplayed) {
        if (![[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"d"] isEqualToString:self.leftMenu.datedisplayed]) {
            globalvariables.reloadleftmenu=YES;
        }
    }
    
    if ([globalvariables.leftmenuindex isEqualToString:@"6"] || [globalvariables.leftmenuindex isEqualToString:@"8"]) {
        globalvariables.reloadleftmenu=YES;
//        [MyClass retrieveunreadmessagecount];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.leftMenu.tableView reloadData];
                });
            }];
        });
    }
    
    globalvariables.reloadleftmenu=YES;
    
    if (globalvariables.reloadleftmenu) {
        globalvariables.reloadleftmenu=NO;
        [self.leftMenu.tableView reloadData];
    }
    
    [self.leftMenu.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[globalvariables.leftmenuindex intValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


-(void) rightMenuDidOpen
{
    [self closeRightMenu];
}
/*
-(CGFloat) rightMenuWidth
{
    return 100;
}
*/



@end
