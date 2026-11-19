
//
//  LeftMenuViewController.m
//  ischoolistaff
//
//  Created by Jasmond Luk on 11/5/2016.
//  Copyright © 2016 Dreamware Limited. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "StudentInformationViewController.h"
#import "TaskAssignmentViewController.h"
#import "DTViewController.h"
#import "LeadInformationViewController.h"
#import "ClassScheduleViewController.h"
#import "PendingRenewalViewController.h"
#import "CenterInformationViewController.h"

@implementation LeftMenuViewController
@synthesize menuArray;
@dynamic studentprofile_classkeys,studentprofile_submenu,studentprofile_studentkey,prepareforsegue,taskassignment_selectedtaskkey,taskassignment_selectedtaskview,assessment_selecteddtkey,leadprofile_submenu,leadprofile_leadkey,sourceview,studentinformationaction,studentinformationatobject,studentinformationleadobject,studentinformationdtobject,datedisplayed,taskassignment_selectedview,renewal_selectedview,studentprofile_saleskey,centersetup_submenu,centersetup_submenukey,studentinformationclassscheduleobject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    //globalvariables.menuimage=(NSString *)menuimage;
    
    self.menuArray=[NSArray arrayWithObjects:@"Highlights",@"Student Profile",@"Daily Class Schedule",@"Center Time Table",@"Course Renewal",@"Financial Information",@"Message Center",@"Photo Corner",@"Task and Request",@"Lead Profile",@"Assessment and Trial",@"Center Information",@"Settings",@"Change Log",@"Help Center",nil];
    menuimageArray=[NSArray arrayWithObjects:@"notifications_icon.png",@"studentprofile_icon.png",@"dailyclassschedule_icon.png",@"classtimetable_icon.png",@"classrenewal_icon.png",@"paymentinformation_icon.png",@"messagecenter_icon",@"classphoto_icon.png",@"taskassignment_icon.png",@"leadprofile_icon.png",@"assessmenttrialclass_icon.png",@"centerinformation_icon.png",@"settings_icon.png",@"activitylog_icon.png",@"help_icon.png", nil];
    
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"d"];
    
    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (self.tableView.contentSize.height+10>self.view.bounds.size.height) {
        self.tableView.scrollEnabled=YES;
    }
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return menuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *newmessageindicator;
    NSString *cellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        menuitemlabel=[[UILabel alloc]initWithFrame:CGRectMake(42, 0, 205, 44)];
        [menuitemlabel setFont:[UIFont systemFontOfSize:14]];
        menuitemlabel.textColor=[UIColor whiteColor];
        menuitemlabel.highlightedTextColor = [UIColor darkGrayColor];
        menuitemlabel.tag=101;
        [cell.contentView addSubview:menuitemlabel];
        
        menuitemimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 26, 26)];
        menuitemimage.layer.cornerRadius=5;
        menuitemimage.tag=103;
        menuitemimage.layer.masksToBounds=YES;
        [cell.contentView addSubview:menuitemimage];
        
        datelabel=[[UILabel alloc]initWithFrame:CGRectMake(9, 12, 26, 26)];
        [datelabel setFont:[UIFont systemFontOfSize:16]];
        datelabel.textColor=[UIColor blackColor];
        datelabel.highlightedTextColor = [UIColor blackColor];
        datelabel.textAlignment=NSTextAlignmentCenter;
        datelabel.tag=104;
        [cell.contentView addSubview:datelabel];
        
        newmessageindicator=[[UIImageView alloc]initWithFrame:CGRectMake(30, 9-5, 10, 10)];
        newmessageindicator.layer.cornerRadius=5;
        newmessageindicator.tag=105;
        newmessageindicator.layer.masksToBounds=YES;
        [newmessageindicator setImage:[UIImage imageNamed:@"red_background.png"]];
        [cell.contentView addSubview:newmessageindicator];
    }else{
        menuitemlabel=(UILabel *)[cell.contentView viewWithTag:101];
        menuitemimage=(UIImageView *)[cell.contentView viewWithTag:103];
        datelabel=(UILabel *)[cell.contentView viewWithTag:104];
        newmessageindicator=(UIImageView *)[cell.contentView viewWithTag:105];
    }
    
    // Configure the cell...
    menuitemlabel.text=[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:[self.menuArray objectAtIndex:indexPath.row]]];
    [menuitemimage setImage:[UIImage imageNamed:[menuimageArray objectAtIndex:indexPath.row]]];
    
    if (indexPath.row==2) {
        datelabel.text=[df stringFromDate:[NSDate date]];
        datelabel.hidden=NO;
        self.datedisplayed=datelabel.text;
    }else{
        datelabel.hidden=YES;
    }
    
    //change cell selected color
    UIView *selectedview=[[UIView alloc]init];
    selectedview.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    cell.selectedBackgroundView=selectedview;
    
    
    if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:globalvariables.leftmenuindex]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if (indexPath.row==6) {
        newmessageindicator.hidden=globalvariables.unreadmessagecount==0;
    }else if (indexPath.row==8){
        newmessageindicator.hidden=globalvariables.pendingrequestcount==0;
    }else{
        newmessageindicator.hidden=YES;
    }
    
    if ([MyClass showMenuItemwithObject:[menuArray objectAtIndex:indexPath.row]]) {
        cell.hidden=NO;
    }else{
        cell.hidden=YES;
    }
    

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MyClass showMenuItemwithObject:[menuArray objectAtIndex:indexPath.row]]) {
        return 44;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -1, 220, 165)];
    menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 165)];
    menuimage.contentMode=UIViewContentModeScaleAspectFit;
    [MyClass downloadImageWithImageview:menuimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
    [view addSubview:menuimage];
    return view;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor=[UIColor darkGrayColor];
    cell.backgroundColor=[UIColor darkGrayColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    [tableView setSeparatorColor:[UIColor darkGrayColor]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.prepareforsegue) {
        if ([segue.identifier isEqualToString:@"studentprofile"]) {
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            if ([self.sourceview isEqualToString:@"notification"]) {
                [(StudentInformationViewController *)vc gotostudentprofile:self.studentprofile_studentkey submenu:self.studentprofile_submenu classkeys:self.studentprofile_classkeys saleskey:self.studentprofile_saleskey];
                ((StudentInformationViewController *)vc).StudentInformationAction=@"Redirect";
            }else if ([self.sourceview isEqualToString:@"changelog"]) {
                [(StudentInformationViewController *)vc gotostudentprofile:self.studentprofile_studentkey submenu:self.studentprofile_submenu classkeys:self.studentprofile_classkeys saleskey:self.studentprofile_saleskey];
                ((StudentInformationViewController *)vc).StudentInformationAction=@"Redirect";
            }else if ([self.sourceview isEqualToString:@"marketingpromotion"]) {
                [(StudentInformationViewController *)vc gotostudentprofile:self.studentprofile_studentkey submenu:self.studentprofile_submenu classkeys:self.studentprofile_classkeys saleskey:self.studentprofile_saleskey];
                ((StudentInformationViewController *)vc).StudentInformationAction=@"Redirect";
            }else if ([self.sourceview isEqualToString:@"assessment"]){
                ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                ((StudentInformationViewController *)vc).StudentInformationATObject=self.studentinformationatobject;
            }else if ([self.sourceview isEqualToString:@"timetable"]){
                ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                ((StudentInformationViewController *)vc).StudentInformationClassScheduleObject=self.studentinformationclassscheduleobject;
            }else if ([self.sourceview isEqualToString:@"classschedule"]){
                if ([self.studentinformationaction isEqualToString:@"AddDTStudent"]) {
                    ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                    ((StudentInformationViewController *)vc).StudentInformationDTObject=self.studentinformationdtobject;
                }else if ([self.studentinformationaction isEqualToString:@"EnrollATLeadStudent"]) {
                    ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                    ((StudentInformationViewController *)vc).StudentInformationATObject=self.studentinformationatobject;
                }
            }else if ([self.sourceview isEqualToString:@"leadprofile"]){
                if ([self.studentinformationaction isEqualToString:@"EnrollLead"]) {
                    ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
//                    NSLog(@"%@",self.studentinformationaction);
                    ((StudentInformationViewController *)vc).StudentInformationLeadObject=self.studentinformationleadobject;
                }else if ([self.studentinformationaction isEqualToString:@"EnrollATLeadStudent"]) {
                    ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                    ((StudentInformationViewController *)vc).StudentInformationATObject=self.studentinformationatobject;
                }else if ([self.studentinformationaction isEqualToString:@"Redirect"]){
                    ((StudentInformationViewController *)vc).StudentInformationAction=self.studentinformationaction;
                    [(StudentInformationViewController *)vc gotostudentprofile:self.studentprofile_studentkey submenu:0 classkeys:nil saleskey:nil];

                }
            }

            
        }else if ([segue.identifier isEqualToString:@"taskassignment"]) {
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            ((TaskAssignmentViewController *)vc).selectedview=self.taskassignment_selectedview;
            ((TaskAssignmentViewController *)vc).selectedtaskview=self.taskassignment_selectedtaskview;
            ((TaskAssignmentViewController *)vc).selectedtaskkey=self.taskassignment_selectedtaskkey;
        }else if ([segue.identifier isEqualToString:@"assessment"]) {
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            
            ((DTViewController *)vc).selecteddtkey=self.assessment_selecteddtkey;
        }else if ([segue.identifier isEqualToString:@"leadprofile"]) {
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            
            [(LeadInformationViewController *)vc gotoLeadProfilewithLeadkey:self.leadprofile_leadkey submenu:self.leadprofile_submenu classkeys:nil];
            ((LeadInformationViewController *)vc).LeadInformationAction=@"Redirect";
        }else if ([segue.identifier isEqualToString:@"renewal"]) {
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            if([self.renewal_selectedview isEqualToString:@"1"]){
                [(PendingRenewalViewController *)vc gotoautorenewal];
            }
        }else if ([segue.identifier isEqualToString:@"centerinformation"]){
            UIViewController *vc = ((UINavigationController *)segue. destinationViewController).viewControllers[0];
            [((CenterInformationViewController *)vc) gotoSubmenu:self.centersetup_submenu submenukey:self.centersetup_submenukey];
        }

        self.prepareforsegue=FALSE;
    }
}




@end
