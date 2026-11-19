//
//  ClassTimeTableDetailsPopoverViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 15/11/2021.
//  Copyright © 2021 DreamHigh Company Limited. All rights reserved.
//

#import "ClassTimeTableDetailsPopoverViewController.h"
#import "MyTableViewCell.h"
#import "MakeupPopoverViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "ClassRemarksPopoverViewController.h"
#import "DTAddEditViewController.h"
#import "MessagePopoverViewController.h"
#import "StudentDetailsNavController.h"
#import "LeadDetailsNavController.h"
#import "StudentDetailsViewController.h"
#import "LeadDetailsViewController.h"
#import "SceneDelegate.h"




@interface ClassTimeTableDetailsPopoverViewController ()<myMakeupPopoverViewControllerDelegate,myClassTimeTableDetailsPopoverViewController,myDTAddEditViewControllerDelegate,myMessagePopoverViewControllerDelegate,myStudentViewController,myLeadDetailsViewController,myClassRemarksPopoverViewControllerDelegate>

@end

@implementation ClassTimeTableDetailsPopoverViewController
@synthesize ClassScheduleRecordArray,lesson,dateselected,timetablemode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }
    reloadclasstimetable=NO;
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    mainviewcontroller = (MainViewController*) [mainWindow rootViewController];
    sidewindowviewclosebutton=[[UIButton alloc]initWithFrame:mainWindow.bounds];
    sidewindowviewclosebutton.backgroundColor=[UIColor blackColor];
    sidewindowviewclosebutton.layer.opacity=0.3;
    sidewindowviewclosebutton.tag=-200;
    sidewindowviewclosebutton.hidden=YES;
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:sidewindowviewclosebutton];
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 320, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(152.5,mainWindow.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [sidewindowview addSubview:ailoadindicator];
    
    ClassScheduleTable.sectionHeaderHeight=CGFLOAT_MIN;
    clpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(classTableLongPress:)];
    clpgr.delegate = self;
    [ClassScheduleTable addGestureRecognizer:clpgr];
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [ClassScheduleTable addGestureRecognizer:panGesture];
    
    selectededitattendanceclasskeyarray=[[NSMutableArray alloc]init];
    [canceleditattendancebutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [canceleditattendancebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [canceleditattendancebutton addTarget: self action:@selector(canceleditattendancebuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    
    selectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    selectallicon.layer.cornerRadius=6;
    selectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    selectallicon.layer.borderWidth=1;
    selectallicon.layer.opacity=1;
    deselectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    deselectallicon.layer.cornerRadius=6;
    deselectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    deselectallicon.layer.borderWidth=1;
    deselectallicon.layer.opacity=0.3;
    
    regularattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnregularattendancebuttonarray]];
    makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
    
    NSArray *buttonarray=[MyClass returnregularattendancebuttonarray];
    attendancePresentButton.hidden=YES;
    attendanceUnknownButton.hidden=YES;
    attendanceAbsentButton.hidden=YES;
    attendanceMakeupButton.hidden=YES;
    attendanceExtendButton.hidden=YES;
    
    for (int i=0; i<buttonarray.count; i++) {
        if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Present"]) {
            attendancePresentButton.hidden=NO;
        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@""]) {
            attendanceUnknownButton.hidden=NO;
        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Absent"]) {
            attendanceAbsentButton.hidden=NO;
        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Makeup"]) {
            attendanceMakeupButton.hidden=NO;
        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Extend"]) {
            attendanceExtendButton.hidden=NO;
        }
    }
    
    editattendanceviewopened=FALSE;
    editattendanceview.hidden=YES;
    [self refreshlanguage];
    [self loadtableheader];
    [self returnfilterdailyclassschedulearray];
    
    if([timetablemode isEqualToString:@"Consolidated"]){
        attendancestackview.hidden=YES;
        sendParentNoteButton.hidden=YES;
    }else{
        attendancestackview.hidden=NO;
        sendParentNoteButton.hidden=NO;
    }
    editlessonbutton.hidden=[timetablemode isEqualToString:@"Consolidated"];
    editlessonbutton.enabled=![MyClass lockLessonWithClassScheduleRecord:ClassScheduleRecordArray];
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) refreshlanguage
{
    [sendParentNoteButton setTitle:[MyClass returntitlewithtitle:@"Send Parent Note"] forState:UIControlStateNormal];
    [sendMessageButton setTitle:[MyClass returntitlewithtitle:@"Send Message"] forState:UIControlStateNormal];
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectallbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [selectbutton setTitle:[MyClass returntitlewithtitle:@"Select"] forState:UIControlStateNormal];
    [actionsButton setTitle:[MyClass returntitlewithtitle:@"Actions"] forState:UIControlStateNormal];
    searchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }
    [self.delegate reloadClassTimeTable:reloadclasstimetable];
}


-(void) loadtableheader
{
    if([timetablemode isEqualToString:@"Consolidated"]){
        title_datetime.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:lesson.classday],lesson.classtime];
    }else{
        title_datetime.text=[NSString stringWithFormat:@"%@ %@",[MyClass convertToNSStringWithNSDate:dateselected ToDateFormat:@"dd-MMM-yyyy" Translate:YES],lesson.classtime];
    }
    
    title_subject.text=[lesson.subjecttype isEqualToString:@"subject"]?[MyClass returnsubjectnamewithsubject_shortname:lesson.subject centerkey:globalvariables.centerrecord.centerkey]:[MyClass returnsubjectcategorynamewithscategorykey:lesson.subject];
    title_classroom.text=[MyClass returntitlewithtitle:lesson.classroom];
    title_instructor.text=[MyClass returnstaffnamewithusername:lesson.instructor firstorfullname:@"full"];
    title_sinstructor.text=[MyClass returnstaffnamewithusername:lesson.sinstructor firstorfullname:@"full"];
    sinstructorStack.hidden=!globalvariables.centerrecord.secondaryinstructor;
    
    title_Class_Level.text=[MyClass returntitlewithtitle:@"Level/Grade"];
    title_Class_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_Class_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
    title_Class_Instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    title_Class_Room.text=[MyClass returntitlewithtitle:@"Room"];
    title_Class_Contact.text=[MyClass returntitlewithtitle:@"Contact"];
    title_Class_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_Class_Attendance.text=[MyClass returntitlewithtitle:@"Attendance"];
    title_Class_Attendance.hidden=[timetablemode isEqualToString:@"Consolidated"];
    title_Class_OutstandingClass.text=[MyClass returntitlewithtitle:@"Sch/TBD.Cl/TBD.MU Left"];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        title_Class_OutstandingClass.hidden=YES;
    }else{
        title_Class_OutstandingClass.hidden=NO;
    }

    
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        title_Class_OutstandingAmount.text=[MyClass returntitlewithtitle:@""];
    }else{
        title_Class_OutstandingAmount.text=[MyClass returntitlewithtitle:@"Outstanding (Courses)"];
    }


//    title_Class_Time.hidden=YES;
//    title_Class_Duration.hidden=YES;
//    title_Class_Instructor.hidden=YES;
//    title_Class_Room.hidden=YES;
//    title_Class_Contact.hidden=YES;
    title_Class_Subject.text=[MyClass returntitlewithtitle:@"Contact"];
//    title_Class_Level.hidden=YES;
    title_Class_Select.hidden=!editattendanceviewopened;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (attendanceringview) {
        
        UIView *windowview = self.view;
        while (windowview.superview != Nil) {
            windowview = windowview.superview;
        }
        
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
//            CGPoint point= [recognizer locationInView:windowview];
            CGPoint point= [recognizer locationInView:ClassScheduleTable];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y+ClassScheduleTable.frame.origin.y;
            lasttouchedsector= [MyClass updateattendanceringwithtouchpoint:point attendanceringview:attendanceringview attendancebuttonarray:attendancebuttonarray lasttouchedsector:lasttouchedsector size:@"large"];
        }else{
//            CGPoint point= [recognizer locationInView:windowview];
            CGPoint point= [recognizer locationInView:ClassScheduleTable];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y+ClassScheduleTable.frame.origin.y;
            
            [self attendanceringreleasedwithtouchpoint:point];
            
            [UIView animateWithDuration:0.4 animations:^{self->attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [self->attendanceringview removeFromSuperview]; }];
            attendanceringview=nil;
            ClassScheduleTable.scrollEnabled=TRUE;
            [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated: YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
        NSIndexPath *selectedIndexPath = [ClassScheduleTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
    [ClassScheduleTable addGestureRecognizer:clpgr];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self returnfilterdailyclassschedulearray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==ClassScheduleTable){
        return filteredClassScheduleRecordArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    if (tableView == ClassScheduleTable) {

        static NSString *CellIdentifier;
        if(editattendanceviewopened){
            CellIdentifier=@"classcell1";
        }else{
            CellIdentifier=@"classcell0";
        }

        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];

        //duration
        cell.label2.text=[NSString stringWithFormat:@"%@%@",ClassScheduleObject.classduration,[MyClass returntitlewithtitle:@"mins"]];
        
        //class type
        cell.label3.text=[MyClass returntitlewithtitle:[ClassScheduleObject.classtype isEqualToString:@"Assessment"]?@"Assess":ClassScheduleObject.classtype];
        if ([ClassScheduleObject.classtype isEqualToString:@"Class"]) {
            cell.label3.textColor=[UIColor darkTextColor];
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            cell.label3.textColor=[UIColor orangeColor];
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
            cell.label3.textColor=[UIColor redColor];
        }
        
        //level
            cell.label4.hidden=YES;
            cell.label19.hidden=NO;
            cell.label19.text=[MyClass returnLevelGradeLessonwithClassScheduleRecord:ClassScheduleObject];

        
        //student name
        if ([ClassScheduleObject.type isEqualToString:@"student"]) {
            cell.label5.text=[MyClass returnStudentnameWithStudentkey:ClassScheduleObject.studentkey option:@"full"];
        }else{
            cell.label5.text=[MyClass returnLeadnameWithLeadkey:ClassScheduleObject.studentkey option:@"full"];
        }
        
        //student image and warning button
        if([self moveLessonFailedWithClasskey:ClassScheduleObject]){
            cell.imageview8.hidden=YES;
            cell.imageview12.hidden=YES;
            [cell.button4 addTarget:self action:@selector(warningbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button4.tag=indexPath.row;
        }else{
            cell.imageview8.hidden=NO;
            cell.imageview12.hidden=NO;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            cell.imageview8.layer.cornerRadius=14.5f;
            cell.imageview8.layer.masksToBounds=YES;
            cell.imageview8.userInteractionEnabled = YES;
            [cell.imageview8 addGestureRecognizer:singleTap];
            cell.imageview8.tag=indexPath.row;
            [MyClass downloadImageWithImageview:cell.imageview8 gender:ClassScheduleObject.gender type:ClassScheduleObject.type typekey:ClassScheduleObject.studentkey image:ClassScheduleObject.image async:YES];
            
            if ([ClassScheduleObject.type isEqualToString:@"student"]) {
                Student *studentObject=[MyClass retrieveStudent:ClassScheduleObject.studentkey];
                if([studentObject.due isEqualToString:@"B"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"redpurple.png"]];
                }else if([studentObject.due isEqualToString:@"C"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"red_background.png"]];
                }else if([studentObject.due isEqualToString:@"S"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"purple_background.png"]];
                }else{
                    [cell.imageview12 setImage:nil];
                }
            }else{
                [cell.imageview12 setImage:nil];
            }
        }
        
        //parent contact
        //cell.label9.text=ClassScheduleObject.parentcontact;
        
        if (![ClassScheduleObject.parentcontact isEqualToString:@""]) {
            ContactRecord *record=[MyClass returnprimarycontactwithtype:ClassScheduleObject.type typekey:ClassScheduleObject.studentkey];
            if (record) {
                cell.label9.text=[MyClass returnLocalNumberWithContact:record.contact ISOCode:record.iso_code];
                [MyClass downloadImageWithImageview:cell.imageview13 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
                cell.imageview13.hidden=NO;
            }else{
                cell.label9.text = ClassScheduleObject.parentcontact;
                cell.imageview13.hidden=YES;
            }
        }else{
            cell.label9.text=@"";
            cell.imageview13.hidden=YES;
        }
        
        //class left
        cell.imageview2.layer.cornerRadius=4;
        cell.imageview2.layer.masksToBounds=YES;
        cell.imageview3.layer.cornerRadius=4;
        cell.imageview3.layer.masksToBounds=YES;
        cell.imageview4.layer.cornerRadius=4;
        cell.imageview4.layer.masksToBounds=YES;
        
        cell.label13.layer.cornerRadius=4;
        cell.label13.layer.masksToBounds=YES;
        cell.label14.layer.cornerRadius=4;
        cell.label14.layer.masksToBounds=YES;
        cell.label15.layer.cornerRadius=4;
        cell.label15.layer.masksToBounds=YES;
        
        if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
            cell.label13.text=@"";
            cell.label14.text=@"";
            cell.label15.text=@"";
            
            cell.label13.layer.borderWidth=0;
            cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
            
            [cell.imageview2 setImage:nil];
            [cell.imageview3 setImage:nil];
            [cell.imageview4 setImage:nil];
            
        }else{
            cell.label13.layer.borderWidth=0;
            cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
            cell.label13.text=ClassScheduleObject.remainingclassscheduled;
            if ([ClassScheduleObject.remainingclassscheduled intValue]==0) {
                if ([ClassScheduleObject.remainingclassscheduledall intValue]==0) {
                    [cell.imageview2 setImage:[UIImage imageNamed:@"red_background.png"]];
                    cell.label13.layer.borderWidth=0;
                    cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
                }else{
                    cell.label13.layer.borderWidth=1.5;
                    cell.label13.layer.borderColor=[UIColor redColor].CGColor;
                    [cell.imageview2 setImage:[UIImage imageNamed:@"gray_background.png"]];
                    
                }
            }else if ([ClassScheduleObject.remainingclassscheduled intValue]==1) {
                [cell.imageview2 setImage:[UIImage imageNamed:@"orange_background.png"]];
            }else{
                [cell.imageview2 setImage:[UIImage imageNamed:@"gray_background.png"]];
            }
            cell.label14.text=ClassScheduleObject.remainingclassTBDclass;
            cell.label15.text=ClassScheduleObject.remainingclassTBDmakeup;
            [cell.imageview3 setImage:[UIImage imageNamed:@"gray_background.png"]];
            [cell.imageview4 setImage:[UIImage imageNamed:@"gray_background.png"]];
        }
        
        
        //outstanding due
        if ([ClassScheduleObject.outstandingpayment intValue]==0) {
            cell.button1.hidden=YES;
        }else{
            cell.button1.layer.cornerRadius=4;
            cell.button1.layer.masksToBounds=YES;
            cell.button1.layer.opacity=0.8;
            [cell.button1 addTarget:self action:@selector(outstandingpaymentbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=indexPath.row;
            [cell.button1 setTitle:[NSString stringWithFormat:@"$%@",ClassScheduleObject.outstandingpayment] forState:UIControlStateNormal];
            cell.button1.hidden=NO;
        }
        
        //outstanding extension time
        if ([ClassScheduleObject.outstandingextendtime intValue]==0) {
            cell.label16.text=@"";
            cell.imageview7.hidden=YES;
        }else{
            cell.label16.text=ClassScheduleObject.outstandingextendtime;
            cell.imageview7.layer.cornerRadius=4;
            [cell.imageview7 setImage:[UIImage imageNamed:@"blue_background.png"]];
            cell.imageview7.layer.masksToBounds=YES;
            cell.imageview7.hidden=NO;
        }
        
        //parent note
        cell.imageview10.hidden=[ClassScheduleObject.parentnote isEqualToString:@""];
        
        //time, subject, instructor, room, remarks, extension time
        if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            cell.view1.hidden=YES;
            cell.stackview1.hidden=NO;
            
            NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
            cell.label6.text=ClassScheduleObject.subjectfullname;
            cell.imageview14.hidden=YES;
            if (![schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                cell.label6.text=[NSString stringWithFormat:@"%@ (%@)",cell.label6.text,schedulename];
            }
            
            
            cell.label1.text=ClassScheduleObject.makeuptime;
            
            cell.label7.text= [ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
            [cell.view3 setBackgroundColor:[MyClass returnInstructorColorWithUsername:ClassScheduleObject.makeupinstructor]];
            cell.label8.text=[ClassScheduleObject.makeupclassroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.makeupclassroom;
            
            
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            
            if ([MyClass isDateFallsThisYear:[MyClass convertToNSDateWithDate:ClassScheduleObject.startdate DateFormat:@"dd-MMM-yyyy"]]) {
                [tmpremarks addObject:[MyClass returnreplacedtitlewithtitle:@"(Original class on %@1)" replacementarray:@[[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatDDMMMwithdate:[MyClass convertDDMMMYYYYtoDDMMMwithdate:ClassScheduleObject.startdate]],ClassScheduleObject.classtime,ClassScheduleObject.classday]]]];
            }else{
                [tmpremarks addObject:[MyClass returnreplacedtitlewithtitle:@"(Original class on %@1)" replacementarray:@[[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatwithdate:[MyClass convertDDMMMYYYYtoDDMMMYYYY2withdate:ClassScheduleObject.startdate]],ClassScheduleObject.classtime,ClassScheduleObject.classday]]]];
            }
            
            if (![ClassScheduleObject.parentnote isEqualToString:@""]) {
                [tmpremarks addObject:[NSString stringWithFormat:@"<%@>",ClassScheduleObject.parentnote]];
            }
            
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.allclassremarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            if (![ClassScheduleObject.makeupdate isEqualToString:@""]) {
                
                if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6], ClassScheduleObject.classtime]]){
                    
                    if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                        [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last scheduled class"]] atIndex:0];
                    }else{
                        [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last_class"]] atIndex:0];
                    }
                }
                
                if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"First_class"]] atIndex:0];
                }
            }
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];;
            
            ///switchMakeup.hidden=YES;
            cell.button2.hidden=YES;
            cell.label11.text=@"";
            cell.imageview11.hidden=YES;
            
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Class"]){
            
            NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
            cell.label6.text=[MyClass returnsubjectnamewithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey];
            cell.imageview14.hidden=YES;
            if (![schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                cell.label6.text=[NSString stringWithFormat:@"%@ (%@)",cell.label6.text,schedulename];
            }
            
            cell.label1.text = ClassScheduleObject.classtime;
            cell.label7.text = [MyClass returninstructornamewithusername:ClassScheduleObject.instructor firstorfullname:@"first"];
            [cell.view3 setBackgroundColor:[MyClass returnInstructorColorWithUsername:ClassScheduleObject.instructor]];
            cell.label8.text=[ClassScheduleObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.classroom;
            
            cell.view4.hidden=[timetablemode isEqualToString:@"Consolidated"];
            
            if ([ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                cell.view1.hidden=YES;
                cell.stackview1.hidden=NO;
                cell.button2.hidden=NO;
                [cell.button2 addTarget: self action:@selector(makeupdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                cell.button2.tag=indexPath.row;
                cell.button2.enabled=![MyClass classLocked:ClassScheduleObject.locked];
                if (![ClassScheduleObject.makeupdate isEqualToString:@""]) {
                    [cell.button2 setTitle:[NSString stringWithFormat:@"%@ %@",[globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.makeupdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.makeupdate] substringFromIndex:5],ClassScheduleObject.makeuptime] forState:UIControlStateNormal];
                    if ([ClassScheduleObject.makeupdate isEqualToString:@""] || [ClassScheduleObject.makeuptime isEqualToString:@""] || [ClassScheduleObject.makeupinstructor isEqualToString:@""]||[ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]) {
                        [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    }else{
                        [cell.button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    }
                    
                    cell.label11.text=[ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
                    cell.imageview11.hidden=NO;
                    [cell.imageview11 setImage:[UIImage imageNamed:[MyClass returnmakeupattendanceimagewithmakeupattendance:ClassScheduleObject.makeupattendance]]];
                    
                }else{
                    [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Select time"] forState:UIControlStateNormal];
                    [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    cell.label11.text=@"";
                    cell.imageview11.hidden=YES;
                }
                

                
            }else if ([ClassScheduleObject.attendance isEqualToString:@"Extend"]){
                cell.view1.hidden=NO;
                cell.stackview1.hidden=YES;
                
                cell.view1.layer.cornerRadius=8;
                cell.view1.layer.masksToBounds=YES;
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
                cell.label18.text=ClassScheduleObject.extensiontime;
            }else{
                cell.view1.hidden=YES;
                cell.stackview1.hidden=NO;
                
                cell.button2.hidden=YES;
                //[MakeupDateTimeButton setTitle:@"" forState:UIControlStateNormal];
                cell.label11.text=@"";
                cell.label12.text=@"";
                cell.imageview11.hidden=YES;
            }
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            
            if (![ClassScheduleObject.parentnote isEqualToString:@""]) {
                [tmpremarks addObject:[NSString stringWithFormat:@"<%@>",ClassScheduleObject.parentnote]];
            }
            
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.allclassremarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            
            if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]){
                
                if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last scheduled class"]] atIndex:0];
                }else{
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last_class"]] atIndex:0];
                }
            }
            
            if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"First_class"]] atIndex:0];
            }
            
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];
            
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
            cell.view1.hidden=YES;
            
            cell.label6.text=[MyClass returnsubjectnamewithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey];
            cell.imageview14.hidden=YES;
            cell.label1.text = ClassScheduleObject.classtime;
            cell.label7.text = [MyClass returninstructornamewithusername:ClassScheduleObject.instructor firstorfullname:@"first"];
            [cell.view3 setBackgroundColor:[MyClass returnInstructorColorWithUsername:ClassScheduleObject.instructor]];
            cell.label8.text=[ClassScheduleObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.classroom;
            cell.button2.hidden=YES;
            cell.imageview11.hidden=YES;
            
            cell.label11.text=@"";
            
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];
        }
        
        
        //extended time
        if ([ClassScheduleObject.extendedminute intValue] !=0) {
            cell.label12.hidden=NO;
            cell.label12.text=[NSString stringWithFormat:@"+%@%@",ClassScheduleObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
            if (!cell.button2.hidden) {
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:10];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
                //MakeupInstructorLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 0, 117, cellheight);
                cell.label11.font=[UIFont systemFontOfSize:10];
                //ExtendedMinuteLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, cellheight/3*2, 117, cellheight/3);
                cell.label12.font=[UIFont systemFontOfSize:10];
            }else{
                //ExtendedMinuteLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 0, 117, cellheight);
                cell.label12.font=[UIFont systemFontOfSize:13];
            }
        }else{
            if ([ClassScheduleObject.makeupdate isEqualToString:@""]) {
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:12];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(13, 0, 0, 0)];
            }else{
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:12];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
            }
            //MakeupInstructorLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 20, 117, cellheight/2);
            //ExtendedMinuteLabel.text=@"";
            cell.label12.hidden=YES;
        }
        
        //auto renew
        cell.imageview6.layer.cornerRadius=4;
        cell.imageview6.layer.masksToBounds=YES;
        cell.imageview6.hidden=([ClassScheduleObject.autorenew isEqualToString:@"Yes"] && globalvariables.centerrecord.enableautobatchrenew)?NO:YES;
        
        //evaluation form
        if (!globalvariables.centerrecord.studentassessmentform || ClassScheduleObject.assessmentformcount==0 || ([ClassScheduleObject.classtype isEqualToString:@"Class"] && [ClassScheduleObject.attendance isEqualToString:@"Makeup"])) {
            cell.label17.hidden=YES;
            cell.imageview9.hidden=YES;
        }else{
            cell.label17.text=[NSString stringWithFormat:@"%i",ClassScheduleObject.assessmentformcount];
            cell.label17.hidden=NO;
            cell.imageview9.hidden=NO;
            cell.imageview9.layer.cornerRadius=4;
            cell.imageview9.layer.masksToBounds=YES;
        }
        
        //select icon

        
        if (editattendanceviewopened) {
            //cell.view2.hidden=NO;
            //cell.imageview5.hidden=NO;
            
            cell.imageview5.layer.cornerRadius=8;
            cell.imageview5.layer.borderColor=[UIColor whiteColor].CGColor;
            cell.imageview5.layer.borderWidth=1;
            
            if ([selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                cell.imageview5.layer.opacity=1;
            }else{
                cell.imageview5.layer.opacity=0.3;
            }
        }
        
        //attendance button
        [cell.button3 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [cell.button3 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button3 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button3.tag=indexPath.row;
        [cell.button3 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:ClassScheduleObject.classtype attendance:ClassScheduleObject.attendance makeupattendance:ClassScheduleObject.makeupattendance]] forState:UIControlStateNormal];
        cell.button3.enabled=![MyClass classLocked:ClassScheduleObject.locked];
        
//        if ([viewmode isEqualToString:@"lesson"]) {
            cell.label1.hidden=NO;
            cell.label2.hidden=NO;
            cell.label7.hidden=YES;
            cell.view3.hidden=YES;
            cell.label8.hidden=YES;
            cell.label9.hidden=YES;
            cell.imageview13.hidden=YES;
            
            //cell.label6.text=ClassScheduleObject.parentcontact;
            if (![ClassScheduleObject.parentcontact isEqualToString:@""]) {
                ContactRecord *record=[MyClass returnprimarycontactwithtype:ClassScheduleObject.type typekey:ClassScheduleObject.studentkey];
                if (record) {
                    cell.label6.text=[MyClass returnLocalNumberWithContact:record.contact ISOCode:record.iso_code];
                    [MyClass downloadImageWithImageview:cell.imageview14 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
                    cell.imageview14.hidden=NO;
                }else{
                    cell.label6.text = ClassScheduleObject.parentcontact;
                    cell.imageview14.hidden=YES;
                }
            }else{
                cell.label6.text=@"";
                cell.imageview14.hidden=YES;
            }
            
            if(indexPath.row%2==0){
                cell.backgroundColor=[UIColor whiteColor];
            }else{
                cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
            }
        /*}else{
            cell.label1.hidden=NO;
            cell.label2.hidden=NO;
            cell.label7.hidden=NO;
            cell.view3.hidden=NO;
            cell.label8.hidden=NO;
            cell.label9.hidden=NO;
            //cell.imageview13.hidden=NO;
            editattendancestatusimageview.frame=CGRectMake(15, (cellheight-16)/2, 16, 16);
            
            //alternative background color;
            if (cellcolorarray && cellcolorarray.count>0) {
                if ([[cellcolorarray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
                }else{
                    cell.backgroundColor=[UIColor whiteColor];
                }
            }else{
                cell.backgroundColor=[UIColor whiteColor];
            }
            
        }*/
        
        
        
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(BOOL) moveLessonFailedWithClasskey:(ClassScheduleRecord *)object
{
    NSString *classkey;
    
    if([object.classtype isEqualToString:@"Assessment"] || [object.classtype isEqualToString:@"Trial"]){
        classkey=object.dtkey;
    }else{
        classkey=object.classkey;
    }
    
    ClassValidateRecord *obj=[validateclassarray objectForKey:classkey];
    if(obj){
        return YES;
    }
    return NO;
}

-(void) returnfilterdailyclassschedulearray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];

    if (![searchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.studentdisplayname contains[c] %@ or self.parentcontact contains[c] %@ or self.subject contains[c] %@ or self.levelmain contains[c] %@ or self.realclasstime contains[c] %@ or self.instructorfullname contains[c] %@ or self.realclassroom contains[c] %@ or self.remarks contains[c] %@ or self.allclassremarks contains[c] %@ or self.subjectfullname contains[c] %@ or self.makeupclassroom contains[c] %@ or self.absentmakeupreason contains[c] %@ or self.studentid contains[c] %@",searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredClassScheduleRecordArray= [[NSMutableArray alloc]initWithArray:[ClassScheduleRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredClassScheduleRecordArray= [[NSMutableArray alloc]initWithArray:ClassScheduleRecordArray];
    }
    [self sortdailyclassschedulelist];
}

-(void) returnsortingarray
{
    sortingarray=[MyClass returnsortingarraywithtype:@"dailyclassschedulelistsortingorder"];
}

-(void) sortdailyclassschedulelist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    for (int i=0; i<sortingarray.count; i++) {
        SortingRecord * sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredClassScheduleRecordArray=[NSMutableArray arrayWithArray:[filteredClassScheduleRecordArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [ClassScheduleTable reloadData];
}

-(void) classTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:ClassScheduleTable];
        NSIndexPath *indexPath = [ClassScheduleTable indexPathForRowAtPoint:point];
        
        for(int i=0;i<[ClassScheduleTable numberOfSections];i++) {
            CGRect headerViewRect = [ClassScheduleTable rectForHeaderInSection:i];
            BOOL isInside = CGRectContainsPoint (headerViewRect, point);
            if(isInside) {
                return;
            }
        }
        
        if (indexPath) {
            ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            //ClassScheduleObject=[((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:indexPath.section]).classScheduleRecordArray objectAtIndex:indexPath.row];
            if (![selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
            }
        }
        //[attendanceringview removeFromSuperview];
        
        editattendanceviewopened=TRUE;
        [self openeditattendanceview:editattendanceviewopened];
        [self updateEditAttendanceMenu];
    }
}

-(void) openeditattendanceview:(BOOL)open
{
    [UIView animateWithDuration:0.3 animations:^{
        if (open) {
            editattendanceview.hidden=NO;
            [self updateEditAttendanceMenu];
        }else{
            [selectededitattendanceclasskeyarray removeAllObjects];
            editattendanceview.hidden=YES;
        }
        [validateclassarray removeAllObjects];
        
    } completion:^(BOOL finished){
        [self loadtableheader];
        [ClassScheduleTable reloadData];
        [self.view layoutIfNeeded];
    }];
}

-(void) updateEditAttendanceMenu
{
    attendancecountlabel.text=[@(selectededitattendanceclasskeyarray.count) stringValue];
    if (selectededitattendanceclasskeyarray.count==0){
        attendanceUnknownButton.enabled=NO;
        attendancePresentButton.enabled=NO;
        attendanceAbsentButton.enabled=NO;
        attendanceMakeupButton.enabled=NO;
        attendanceExtendButton.enabled=NO;
        sendMessageButton.enabled=NO;
        sendParentNoteButton.enabled=NO;
        [sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sendParentNoteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        BOOL lockattendance=[MyClass lockLessonWithClassScheduleRecord:ClassScheduleRecordArray];
        attendanceUnknownButton.enabled=!lockattendance;
        attendancePresentButton.enabled=!lockattendance;
        attendanceAbsentButton.enabled=!lockattendance;
        attendanceMakeupButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu] &&!lockattendance;
        attendanceExtendButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu] &&!lockattendance;
        sendMessageButton.enabled=[self enableMessageButtonInAttendanceMenu];
        sendParentNoteButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu];
        
        if(sendMessageButton.isEnabled){
            [sendMessageButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        if(sendParentNoteButton.isEnabled){
            [sendParentNoteButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [sendParentNoteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
    }
}

-(BOOL) enableMakeupExtendButtonInAttendanceMenu
{
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord * classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.classtype isEqualToString:@"Class"]) {
            return TRUE;
        }
    }
    return FALSE;
}


-(BOOL) enableMessageButtonInAttendanceMenu
{
    BOOL Student=FALSE;
    BOOL Lead=FALSE;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord * classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.type isEqualToString:@"student"]) {
            Student= TRUE;
        }else{
            Lead=TRUE;
        }
    }
    if(Student && Lead){
        return FALSE;
    }
    return TRUE;
}

-(void) canceleditattendancebuttonpressed
{
    editattendanceviewopened=FALSE;
    [self openeditattendanceview:editattendanceviewopened];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ClassScheduleTable) {
        if (!attendanceringview) {
            ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            
            if (editattendanceviewopened) {
                if ([selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                    [selectededitattendanceclasskeyarray removeObject:ClassScheduleObject];
                }else{
                    [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
                }
                [self updateEditAttendanceMenu];
                [ClassScheduleTable reloadData];
            }else{
                //Popup remarks
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    [self startsidewindowanimationwithwidth:320];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DTAddEditViewController *dtpopover = (DTAddEditViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
                        dtpopover.DTAddEditViewDTkey=ClassScheduleObject.dtkey;
                        dtpopover.PopoverMode=@"PopoverDTFromClassSchedule";
                        dtpopover.DTTableMode=@"View";
                        dtpopover.delegate=self;
                        
                        dtpopover.subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:YES];
                        if (!dtpopover.subjectArray) {
                            return;
                        }
                        
                        dtpopover.view.frame=mainWindow.bounds;
                        [sidewindowview addSubview:dtpopover.view];
                        [self addChildViewController:dtpopover];
                        [dtpopover didMoveToParentViewController:self];
                        [ailoadindicator stopAnimating];
                        ailoadindicator.hidden=YES;
                    });
                    
                }else{
                    //popup make up information
                    [self startsidewindowanimationwithwidth:480];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ClassRemarksPopoverViewController *remarksuppopover = (ClassRemarksPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassRemarksPopoverViewController"];
                        remarksuppopover.delegate=self;
                        remarksuppopover.presentingview=@"dailyclassschedule";
                        remarksuppopover.classScheduleObject=ClassScheduleObject;
                        remarksuppopover.preferredContentSize=CGSizeMake(480, self.view.frame.size.height);
                        
                        remarksuppopover.view.frame=mainWindow.bounds;
                        [sidewindowview addSubview:remarksuppopover.view];
                        [self addChildViewController:remarksuppopover];
                        [remarksuppopover didMoveToParentViewController:self];
                        [ailoadindicator stopAnimating];
                        ailoadindicator.hidden=YES;
                    });
                }
            }
        }
    }
}

- (IBAction)attendanceUnknownButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@""];
}

- (IBAction)attendancePresentButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Present"];
}

- (IBAction)attendanceMakeupButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Makeup"];
}

- (IBAction)attendanceAbsentButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Absent"];
}

- (IBAction)attendanceExtendButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Extend"];
}

- (IBAction)sendParentNoteButtonPressed:(id)sender {
    [self startsidewindowanimationwithwidth:480];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassRemarksPopoverViewController *remarksuppopover = (ClassRemarksPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassRemarksPopoverViewController"];
        remarksuppopover.delegate=self;
        remarksuppopover.presentingview=@"dailyclassscheduleparentnote";
        remarksuppopover.parentNoteStudentClassKeys=[self getClasskeysForParentNote];
        
        remarksuppopover.preferredContentSize=CGSizeMake(480, self.view.frame.size.height);

        
        remarksuppopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:remarksuppopover.view];
        [self addChildViewController:remarksuppopover];
        [remarksuppopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

- (IBAction)sendMessageButtonPressed:(id)sender {
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadMessageRecipient];
        MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
        messagepopover.delegate=self;
        messagepopover.MessageTableMode=@"RemoteAdd";
        messagepopover.CallingSource=@"DailySchedule";
        messagepopover.allleadarray=allleadarray;
        messagepopover.allstudentarray=allstudentarray;
        messagepopover.allstaffarray=allstaffarray;
        
        OutboxMessageRecord *omessagerecordobject=[[OutboxMessageRecord alloc]init];
        
        omessagerecordobject.messagetype=@"General";
        omessagerecordobject.messagestarttime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
        omessagerecordobject.messageenglish=@"";
        omessagerecordobject.messagechinese=@"";
        omessagerecordobject.recipienttype=[((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).type isEqualToString:@"student"]?@"Student":@"Lead";
        omessagerecordobject.recipientgroup=[[RecipientGroupRecord alloc]init];
        omessagerecordobject.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.gradearray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.individualarray=[self getStudentOrLeadkeysForMessage];
        omessagerecordobject.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.staffgrouparray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.droparray=[[NSMutableArray alloc]init];
        omessagerecordobject.photoarray=[[NSMutableArray alloc]init];
        omessagerecordobject.channel=globalvariables.centerrecord.defaultstudentmessagechannel;// [MyClass returnChannelCodeWithRecipientType:omessagerecordobject.recipienttype Index:[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"]];
        messagepopover.OMessageRecordObject=omessagerecordobject;
        
        if (![messagepopover InitializeField]) {
            return;
        }
        
        messagepopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:messagepopover.view];
        [self addChildViewController:messagepopover];
        [messagepopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

-(void) loadMessageRecipient
{
    allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
    allstaffarray=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
    allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
    allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status contains[c] %@ and self.role!=%@",globalvariables.centerrecord.centerkey,@"Yes",@"System"];
    allstaffarray=[[NSMutableArray alloc]initWithArray:[allstaffarray filteredArrayUsingPredicate:predicate2]];
    
    allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    allleadarray = [NSMutableArray arrayWithArray:[allleadarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
    
    NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
    allstaffarray = [NSMutableArray arrayWithArray:[allstaffarray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(NSMutableArray *) getStudentOrLeadkeysForMessage
{
    NSMutableArray *studentkeys=[[NSMutableArray alloc]init];
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord *object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        //if ([object.type isEqualToString:@"student"]) {
            [studentkeys addObject:object.studentkey];
        //}
    }
    return studentkeys;
}

-(NSMutableArray *) getClasskeysForParentNote
{
    NSMutableArray *classkeys=[[NSMutableArray alloc]init];
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord *object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([object.type isEqualToString:@"student"]) {
            NSMutableDictionary *studentclasskeydict=[[NSMutableDictionary alloc]init];
            [studentclasskeydict setValue:object.classkey forKey:@"classkey"];
            [studentclasskeydict setValue:object.studentkey forKey:@"studentkey"];
            [classkeys addObject:studentclasskeydict];
        }
    }
    return classkeys;
}

-(void) confirmBulkAttendanceChangeWithStatus:(NSString *)status
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",status]] message:[MyClass returntitlewithtitle:@"Are you sure to change the attendance status for the selected items?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatebulkattendancewithstatus:status validationCheck:YES];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];
}

-(void) updatebulkattendancewithstatus:(NSString *)status validationCheck:(BOOL)validationcheck
{
    if ([status isEqualToString:@"Absent"] || [status isEqualToString:@"Present"] || [status isEqualToString:@""]) {
        validationcheck=NO;
    }
    
    selectedAttendanceStatus=status;
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];
    __block NSMutableArray *JSONArray;
    
    NSString *classroomcapacity;
    ClassroomRecord *classroomobj;
    NSMutableDictionary *dict;

    BOOL addToJson=FALSE;
    
    NSString *leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:status];
    
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        addToJson=FALSE;
        ClassScheduleObject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if (![ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            //class
            if (![ClassScheduleObject.attendance isEqualToString:status]) {
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    if (![status isEqualToString:@"Makeup"] && ![status isEqualToString:@"Extend"]) {
                        addToJson=TRUE;
                    }
                }else{
                    addToJson=TRUE;
                }
            }
        }else{
            //makeup class
            if (![ClassScheduleObject.makeupattendance isEqualToString:status]) {
                if (![status isEqualToString:@"Makeup"] && ![status isEqualToString:@"Extend"]) {
                    if (![self isOriginalClassExistsInSelectedEditAttendanceClasskeyArrayWithMakeupClasskey:ClassScheduleObject.classkey]) {
                        addToJson=TRUE;
                    }
                }
            }
        }
        
        if (addToJson) {
            dict= [[NSMutableDictionary alloc]init];
            [dict setValue:ClassScheduleObject.classtype forKey:@"classtype"];
            [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dict setValue:ClassScheduleObject.subject forKey:@"subject"];
            if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {

                classroomobj=[MyClass returnclassroominformationwithclassroom:ClassScheduleObject.classroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                [dict setValue:ClassScheduleObject.dtkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.attendance forKey:@"currentattendance"];
                [dict setValue:[status isEqualToString:@"Extend"]?((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration:@"" forKey:@"extensiontime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?globalvariables.centerrecord.defaultattendancestatus:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[MyClass convertDateFormatWithDate:ClassScheduleObject.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]  forKey:@"classdate"];
                [dict setValue:ClassScheduleObject.classtime forKey:@"classtime"];
                [dict setValue:ClassScheduleObject.instructor forKey:@"instructor"];
                [dict setValue:ClassScheduleObject.classroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]) valueForKey:[ClassScheduleObject.classtype isEqualToString:@"Assessment"]?@"classduration_assessment":@"classduration_trial"] forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@""];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
                
            }else if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                //values=[NSArray arrayWithObjects:ClassScheduleObject.classkey,ClassScheduleObject.classtype,ClassScheduleObject.makeupattendance,@"",@"",nil];
                
                classroomobj=[MyClass returnclassroominformationwithclassroom:ClassScheduleObject.makeupclassroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                [dict setValue:ClassScheduleObject.classkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.makeupattendance forKey:@"currentattendance"];
                [dict setValue:@"" forKey:@"extensiontime"];
                [dict setValue:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[MyClass convertDateFormatWithDate:ClassScheduleObject.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"classdate"];
                [dict setValue:ClassScheduleObject.makeuptime forKey:@"classtime"];
                [dict setValue:ClassScheduleObject.makeupinstructor forKey:@"instructor"];
                [dict setValue:ClassScheduleObject.makeupsinstructor forKey:@"sinstructor"];
                [dict setValue:ClassScheduleObject.makeupclassroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@"enrollmentkey"];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
            }else{
                classroomobj=[MyClass returnclassroominformationwithclassroom:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupclassroom:ClassScheduleObject.classroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                
                [dict setValue:ClassScheduleObject.classkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.attendance forKey:@"currentattendance"];
                [dict setValue:[status isEqualToString:@"Extend"]?((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration:@"" forKey:@"extensiontime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?globalvariables.centerrecord.defaultattendancestatus:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[status isEqualToString:@"Makeup"]?[MyClass convertDateFormatWithDate:ClassScheduleObject.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]:[MyClass convertDateFormatWithDate:ClassScheduleObject.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"classdate"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeuptime:ClassScheduleObject.classtime forKey:@"classtime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupinstructor:ClassScheduleObject.instructor forKey:@"instructor"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupsinstructor:ClassScheduleObject.sinstructor forKey:@"sinstructor"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupclassroom:ClassScheduleObject.classroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@"enrollmentkey"];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
                
            }
            

            [arrayOfDicts addObject:dict];
        }
    }
    
    jsonclasskeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : jsonclasskeyarray,
                                 @"attendance" : status,
                                 @"validationcheck" : validationcheck?@"Yes":@"No",
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"updateattendancev2"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];

    
    //[MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        if(validationcheck){
            validateclassarray=[MyClass returnValidateClassArrayWithJSONArray:JSONArray Combined:NO];
            //if ([remarks isEqualToString:@""]) {
                if(validateclassarray.count==0){
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSString *classkey=nil;
                        if(selectededitattendanceclasskeyarray.count==1 && jsonclasskeyarray.count==1 && [selectedAttendanceStatus isEqualToString:@"Makeup"]){
                            classkey=((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).classkey;
                        }
                        [self refreshtable];
                        if(editattendanceviewopened){
                            [self canceleditattendancebuttonpressed];
                        }
                        
                        if(classkey){
                            [self popUpMakeWindowWithClassKey:classkey];
                        }

                        
                    });
                }else{
                    if (selectededitattendanceclasskeyarray.count==1) {
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        ClassValidateRecord *obj=[self returnClassValidateRecordWithClassScheduleObject:ClassScheduleObject];
                        classvalidatemessage=obj.classvalidatemessage;
                        classvalidatestatus=obj.classvalidatestatus;
                        [self checkvalidatemessage];
                    }else{
                        [selectededitattendanceclasskeyarray removeAllObjects];
                        [self updateEditAttendanceMenu];
                        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
                        //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
                        
                        
                        UIAlertController *notsuccessalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Attendance"] message:[MyClass returntitlewithtitle:@"Some classes were not able to be updated. Please tap on the warning icon to see the details"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [notsuccessalert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [notsuccessalert addAction:OKAction];
                        [self presentViewController:notsuccessalert animated:YES completion:nil];
                    }
                }
            //}
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *classkey=nil;
                if(selectededitattendanceclasskeyarray.count==1 && jsonclasskeyarray.count==1 && [selectedAttendanceStatus isEqualToString:@"Makeup"]){
                    classkey=((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).classkey;
                }
                [validateclassarray removeObjectForKey:([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"])?ClassScheduleObject.dtkey:ClassScheduleObject.classkey];
                [selectededitattendanceclasskeyarray removeAllObjects];
                [self refreshtable];
                if(validateclassarray.count==0){
                    if(editattendanceviewopened){
                        [self canceleditattendancebuttonpressed];
                    }
                }
                if(classkey){
                    [self popUpMakeWindowWithClassKey:classkey];
                }
                
                
            });


        }
        
    }else{
        [MyClass showconnectionlostdialogbox];
    }

}

-(BOOL) isOriginalClassExistsInSelectedEditAttendanceClasskeyArrayWithMakeupClasskey:(NSString *)makeupclasskey
{
    ClassScheduleRecord *classobject;
    
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.classtype isEqualToString:@"Class"] && [classobject.classkey isEqualToString:makeupclasskey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(void) popUpMakeWindowWithClassKey:(NSString *)classkey
{

//    NSInteger index=[self returnClassScheduleRecordIndexWithClassKey:classkey];
//    [ClassScheduleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//
//    [self startsidewindowanimationwithwidth:320];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
//        makeuppopover.delegate=self;
//        makeuppopover.PopoverClassRecord=[filteredClassScheduleRecordArray objectAtIndex:index];
//        makeuppopover.PopoverOption=@"FromClassSchedule";
//        //classpopover.PopoverStudent=DetailsViewStudent;
//        makeuppopover.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
//
//        makeuppopover.view.frame=mainWindow.bounds;
//        [sidewindowview addSubview:makeuppopover.view];
//        [self addChildViewController:makeuppopover];
//        [makeuppopover didMoveToParentViewController:self];
//        [ailoadindicator stopAnimating];
//        ailoadindicator.hidden=YES;
//    });
}

-(ClassValidateRecord *) returnClassValidateRecordWithClassScheduleObject:(ClassScheduleRecord *)object
{
    if([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
        return [validateclassarray objectForKey:object.dtkey];
    }else{
        return [validateclassarray objectForKey:object.classkey];
    }
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];

}

-(void) validationPassed:(BOOL)pass
{
    warningbuttonselected.enabled=YES;
    if(pass){
        if(selectedAttendanceStatus){
            [selectededitattendanceclasskeyarray removeAllObjects];
            [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
            [self updatebulkattendancewithstatus:selectedAttendanceStatus validationCheck:NO];
        }else{
            [MyClass validateAndMoveLessonWithFreeScheduleArray:[[NSMutableArray alloc]initWithObjects:[self returnmovelessonfreescheduleclasswithclassschedule:ClassScheduleObject freescheduleclass:freescheduleclassobject], nil] studentkeyarray:[[NSMutableArray alloc]initWithObjects:ClassScheduleObject.studentkey, nil] validationcheck:NO updatefollowinglessons:NO updatefollowinglessonsfields:[[NSMutableArray alloc]init]];
            [validateclassarray removeObjectForKey:ClassScheduleObject.classkey];
            if ([self validateclassallpassed]) {
                
                [self.delegate closesidewindow];
            
            }
            [self retrieveClassScheduleWithclassdate:selecteddate];
            //[self moveIndividualLessonWithfreescheduleclass:freescheduleclassobject resetattendance:resetattendance];
        }
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

- (IBAction)actionsButtonPressed:(id)sender {
    NSMutableArray *actionarray=[[NSMutableArray alloc]init];
    if([self enableMakeupExtendButtonInAttendanceMenu]){
        [actionarray addObject:@"Send Parent Note"];
    }
    
    if([self enableMessageButtonInAttendanceMenu]){
        [actionarray addObject:@"Send Message"];
    }
    
    if(![timetablemode isEqualToString:@"Consolidated"]){
        [actionarray addObject:@"Delete Classes"];
        [actionarray addObject:@"Postpone Classes"];
    }
    
    if(validateclassarray.count>0 && [self isConflictClassesSelected]){
        [actionarray addObject:@"Override Conflicts"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init]  DataType:@"ClassAction" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(200, actionarray.count*44) View:self Button:sender ItemsArray:actionarray Title:nil];
}

-(BOOL) isConflictClassesSelected
{
    ClassScheduleRecord *object;
    ClassValidateRecord *cvobj;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        cvobj=[validateclassarray objectForKey:object.classkey];
        if (cvobj) {
            return TRUE;
        }
    }
    return FALSE;
}

- (IBAction)addstudentbuttonpressed:(id)sender {
    NSMutableArray *allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
    allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
    allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
        pickerviewcontroller.delegate=self;
        pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
        pickerviewcontroller.datatype=@"Student";
        pickerviewcontroller.showsearchbar=YES;
        pickerviewcontroller.bottommode=@"New Student";
        pickerviewcontroller.viewtitle=@"Select Student";
        pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*allstudentarray.count);
        pickerviewcontroller.itemsarray=allstudentarray;
        
        CGRect frame=mainWindow.bounds;
        frame.size.width=320;
        pickerviewcontroller.view.frame=frame;
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self addChildViewController:pickerviewcontroller];
        [pickerviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

- (IBAction)editlessonbuttonpressed:(id)sender {
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [validateclassarray removeAllObjects];
        
        LessonRecord *lessonrecord=[[LessonRecord alloc]initLessonRecordwithlessonkey:nil classdate:[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"] classtime:lesson.classtime subject:lesson.subject instructor:lesson.instructor classroom:lesson.classroom classcount:nil subjecttype:lesson.subjecttype checkouttime:nil remarks:@"" classduration:nil sinstructor:lesson.sinstructor];
        //popup make up information
        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
        makeuppopover.delegate=self;

        LessonAndClassRecord *obj=[[LessonAndClassRecord alloc]initLessonAndClassRecordwithLesson:lessonrecord ClassScheduleRecordArray:ClassScheduleRecordArray];
        makeuppopover.PopoverLessonAndClassRecord=obj;
        makeuppopover.PopoverOption=@"DailyScheduleLesson";
        
        makeuppopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:makeuppopover.view];
        [self addChildViewController:makeuppopover];
        [makeuppopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

- (IBAction)selectbuttonpressed:(id)sender {
    editattendanceviewopened=!editattendanceviewopened;
    [self openeditattendanceview:editattendanceviewopened];
}

- (IBAction)deselectallbuttonpressed:(id)sender {
    [selectededitattendanceclasskeyarray removeAllObjects];
    [ClassScheduleTable reloadData];
    [self updateEditAttendanceMenu];
}

- (IBAction)selectallbuttonpressed:(id)sender {
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<filteredClassScheduleRecordArray.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[filteredClassScheduleRecordArray objectAtIndex:i]];
    }
    
    [ClassScheduleTable reloadData];
    [self updateEditAttendanceMenu];
}

-(FreeScheduleClass *) returnmovelessonfreescheduleclasswithclassschedule:(ClassScheduleRecord *)classscheduleobject freescheduleclass:(FreeScheduleClass *)freescheduleclass
{
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.subject=freescheduleclass.subject;
    freescheduleclass_object.classdate=freescheduleclass.classdate;
    freescheduleclass_object.classtime=freescheduleclass.classtime;
    freescheduleclass_object.instructor=freescheduleclass.instructor;
    freescheduleclass_object.classroom=freescheduleclass.classroom;
    freescheduleclass_object.attendance=classscheduleobject.attendance;
    freescheduleclass_object.makeupdate=freescheduleclass.makeupdate;
    freescheduleclass_object.makeuptime=freescheduleclass.makeuptime;
    freescheduleclass_object.makeupinstructor=freescheduleclass.makeupinstructor;
    freescheduleclass_object.makeupsinstructor=freescheduleclass.makeupsinstructor;
    freescheduleclass_object.makeupclassroom=freescheduleclass.makeupclassroom;
    freescheduleclass_object.makeupattendance=freescheduleclass.makeupattendance;
    freescheduleclass_object.classremarks=freescheduleclass.classremarks;
    freescheduleclass_object.allclassremarks=freescheduleclass.allclassremarks;
    freescheduleclass_object.action=freescheduleclass.action;
    freescheduleclass_object.classtype=classscheduleobject.classtype;
    freescheduleclass_object.leavenaturelistkey=freescheduleclass.leavenaturelistkey;
//    freescheduleclass_object.lesson=freescheduleclass.lesson;
    freescheduleclass_object.lesson=freescheduleclass.lesson?freescheduleclass.lesson:classscheduleobject.lesson;
    
    if ([freescheduleclass_object.classtype isEqualToString:@"Assessment"] ||[freescheduleclass_object.classtype isEqualToString:@"Trial"]  ) {
        freescheduleclass_object.classkey=classscheduleobject.dtkey;
    }else{
        freescheduleclass_object.classkey=classscheduleobject.classkey;
    }
    
    return freescheduleclass_object;
}

-(BOOL) validateclassallpassed
{
    return validateclassarray.count==0;

}


-(void) refreshtable
{

    [self retrieveClassScheduleWithclassdate:selecteddate];
    
//    if (tablerefresh) {
//        [tablerefresh endRefreshing];
//    }
    
}

-(void) retrieveClassScheduleWithclassdate:(NSString *)date
{
    reloadclasstimetable=YES;
    ClassScheduleRecordArray=[self.delegate refreshClassScheduleWithLesson:lesson];
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    [self returnfilterdailyclassschedulearray];
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
        [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
        ClassScheduleTable.scrollEnabled=TRUE;
        [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated: YES];
        [ClassScheduleTable addGestureRecognizer:clpgr];
    }];
    

}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    //in case if there is any freeze ring remain previously
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }else{
        if (!editattendanceviewopened) {
            [ClassScheduleTable removeGestureRecognizer:clpgr];
            
            ClassScheduleTable.scrollEnabled=FALSE;
            //CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassScheduleTable];
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:sender.tag inSection:0];
            
            
            [ClassScheduleTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
            
                ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];

            
            if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.makeupattendance highlightbutton:ClassScheduleObject.makeupattendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }else if ([ClassScheduleObject.classtype isEqualToString:@"Trial"] || [ClassScheduleObject.classtype isEqualToString:@"Assessment"]) {
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.attendance highlightbutton:ClassScheduleObject.attendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }else{
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:regularattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.attendance highlightbutton:ClassScheduleObject.attendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }
            
            [self.view addSubview:attendanceringview];
            lasttouchedsector=0;
        }
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    selectedAttendanceStatus=value;

    ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];
    
    if (![value isEqualToString:ClassScheduleObject.attendance]) {
        
        [selectededitattendanceclasskeyarray removeAllObjects];
        [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatebulkattendancewithstatus:value validationCheck:YES];
            //[MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
       
    }
}

-(void) outstandingpaymentbuttonpressed:(UIButton *)sender
{
    if (!editattendanceviewopened) {
        
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"quickpay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:@"Add to Folder" PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:nil Title:nil];
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"quickpay"]) {
        ClassScheduleRecord *obj=[filteredClassScheduleRecordArray objectAtIndex:dataindex];
        UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with payment?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self quickPayWithStudentKey:obj.studentkey paidMethod:[selecteditems firstObject] subject:obj.subject];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [changealert addAction:OKAction];
        [changealert addAction:CancelAction];
        
        [self presentViewController:changealert animated:YES completion:nil];
    }else if ([datatype isEqualToString:@"Student"]){
        NSString *item=[selecteditems firstObject];
        [self closesidewindow];
        [self.delegate enrollStudentwithlessonobject:lesson studentkey:item classscheduleobject:[filteredClassScheduleRecordArray firstObject]];

    }else if([datatype isEqualToString:@"ClassAction"]){
        NSString *item=[selecteditems firstObject];
        if ([item isEqualToString:@"Delete Classes"]) {
            [self confirmDeleteClasses];
        }else if ([item isEqualToString:@"Send Parent Note"]) {
            [self sendParentNoteButtonPressed:nil];
        }else if ([item isEqualToString:@"Send Message"]){
            [self sendMessageButtonPressed:nil];
        }else if ([item isEqualToString:@"Postpone Classes"]) {
            [self confirmPostponeClasses];
        }else if([item isEqualToString:@"Override Conflicts"]){
            [self confirmOverrideConflicts];
        }
    }
}

-(void) confirmOverrideConflicts
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to override the conflicting classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedOverrideConflicts];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}
-(void) proceedOverrideConflicts
{
    NSMutableArray *FreeScheduleArray=[[NSMutableArray alloc]init];
    NSMutableArray *studentkeyarray=[[NSMutableArray alloc]init];
    FreeScheduleClass *freescheduleclass_object;
    ClassScheduleRecord *classobj;
    ClassValidateRecord *cvobj;
    
    for (int i=0; i<[selectededitattendanceclasskeyarray count]; i++) {
        //skipvalidateclasscheck=FALSE;
        classobj=[selectededitattendanceclasskeyarray objectAtIndex:i];
        cvobj=[validateclassarray objectForKey:classobj.classkey];
        if(cvobj){
            freescheduleclass_object=[self returnmovelessonfreescheduleclasswithclassschedule:classobj freescheduleclass:return_freescheduleclass];
            [FreeScheduleArray addObject:freescheduleclass_object];
            [studentkeyarray addObject:ClassScheduleObject.studentkey];
            [validateclassarray removeObjectForKey:classobj.classkey];
        }
    }
    
    validateclassarray=[MyClass validateAndMoveLessonWithFreeScheduleArray:FreeScheduleArray studentkeyarray:studentkeyarray validationcheck:NO updatefollowinglessons:return_updatefollowinglessons updatefollowinglessonsfields:return_updatefollowinglessonsfields];
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

-(void) confirmDeleteClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedDeleteClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) deleteClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords
{
    [self closesidewindow];
    
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<classrecords.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[classrecords objectAtIndex:i]];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self proceedDeleteClasses];
//        [self.delegate dismissTimeTableScheduleViewController:self];
        [self.delegate closesidewindow];
    });
}

-(void) proceedDeleteClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    __block NSMutableArray *JSONArray;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"deletemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        [selectededitattendanceclasskeyarray removeAllObjects];
        [self canceleditattendancebuttonpressed];
        [self retrieveClassScheduleWithclassdate:selecteddate];
    }
}

-(void) confirmPostponeClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to postpone the classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedPostponeClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) postponeClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords
{
    [self closesidewindow];
    
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<classrecords.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[classrecords objectAtIndex:i]];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self proceedPostponeClasses];
//        [self.delegate dismissTimeTableScheduleViewController:self];
        [self.delegate closesidewindow];
    });
}

-(void) proceedPostponeClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    __block NSMutableArray *JSONArray;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"postponemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        [selectededitattendanceclasskeyarray removeAllObjects];
        [self canceleditattendancebuttonpressed];
        [self retrieveClassScheduleWithclassdate:selecteddate];
    }
}

-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"quickpay"]) {
        if ([bottommode isEqualToString:@"Add to Folder"]) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:dataindex inSection:0];
            ClassScheduleRecord *obj=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            if([self retrieveStudentOutstandingPaymentsWithStudentkey:obj.studentkey Enrollmentkey:obj.enrollmentkey documentFolder:globalvariables.documentfolder]){

            }
        }
    }else if ([datatype isEqualToString:@"Student"]){
        if([bottommode isEqualToString:@"New Student"]){
            [self closesidewindow];
            [self.delegate enrollStudentwithlessonobject:lesson studentkey:nil classscheduleobject:[filteredClassScheduleRecordArray firstObject]];
        }
    }
}

-(void) quickPayWithStudentKey:(NSString *)studentkey paidMethod:(NSString *)paymethod subject:(NSString *)subject
{
    //quick pay upload
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:@"quickpay4" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:studentkey forKey:@"studentkey"];
    [dictionary setValue:paymethod forKey:@"paidmethod"];
    [dictionary setValue:subject forKey:@"subject"];
    [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            returndata=data;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonenrollmentkeysarray = jsondictionary[@"receiptenrollmentkeys"];
            NSArray *jsonsaleskeysarray = jsondictionary[@"receiptsaleskeys"];

            if (jsonenrollmentkeysarray.count+jsonsaleskeysarray.count>0) {
                globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
                
                for (int i=0; i<jsonenrollmentkeysarray.count; i++) {
                    NSString *enrollmentkey=[NSString stringWithFormat:@"%@",[jsonenrollmentkeysarray objectAtIndex:i]];
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:enrollmentkey];
                    }
                    
                    if(![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:enrollmentkey]){
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:enrollmentkey];
                    }
                }
                
                for (int i=0; i<jsonsaleskeysarray.count; i++) {
                    NSString *saleskey=[NSString stringWithFormat:@"%@",[jsonsaleskeysarray objectAtIndex:i]];
                    [globalvariables.documentfolder.salesreceiptarray addObject:saleskey];
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:saleskey];
                }
                result=YES;
            }else{
                result= NO;
            }
        }
    }];

    if (result) {
        [self retrieveClassScheduleWithclassdate:selecteddate];
//        [self refreshdocumentfoldercount];
        /*if(globalvariables.centerrecord.autosendereceipt){
            NSDictionary *dict=[MyClass loaddocumentfolderarraywithpaymethod:paymethod returndata:returndata];
            [MyClass autoSendeReceiptWithClassReceiptArray:dict[@"documentfolderclassreceiptarray"] SalesReceiptArray:dict[@"documentfoldersalesreceiptarray"]];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }*/
    }else{
        [MyClass showconnectionlostdialogbox];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
    
}

-(BOOL) retrieveStudentOutstandingPaymentsWithStudentkey:(NSString *)studentkey Enrollmentkey:(NSString *)enrollmentkey documentFolder:(DocumentFolder *)documentfolder
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestudentoutstandingpayments&studentkey=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey,enrollmentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            
            
            NSArray *classpaymentkeys = jsondictionary[@"classpaymentkeys"];
            NSArray *salespaymentkeys = jsondictionary[@"salespaymentkeys"];
            //NSArray *classreceiptkeys = jsondictionary[@"classreceiptkeys"];
            
            if (classpaymentkeys.count+salespaymentkeys.count>0) {
                
                for (int i=0; i<classpaymentkeys.count; i++) {
                    NSString *enrollmentkey=[[classpaymentkeys objectAtIndex:i] objectForKey:@"enrollmentkey"];
                    
                    if (![documentfolder.classinvoicearray containsObject:enrollmentkey]) {
                        [documentfolder.classinvoicearray addObject:enrollmentkey];
                    }
                    
                    if (![documentfolder.classpaymentarray containsObject:enrollmentkey]) {
                        [documentfolder.classpaymentarray addObject:enrollmentkey];
                    }

                    
                    if (![documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:enrollmentkey]) {
                        [documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:enrollmentkey];
                    }
                    
                    if (![documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:enrollmentkey]) {
                        [documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:enrollmentkey];
                    }

                }

                for (int i=0; i<salespaymentkeys.count; i++) {
                    NSString *saleskey=[[salespaymentkeys objectAtIndex:i] objectForKey:@"saleskey"];
                    
                    if (![documentfolder.salesinvoicearray containsObject:saleskey]) {
                        [documentfolder.salesinvoicearray addObject:saleskey];
                    }
                    
                    if (![documentfolder.salespaymentarray containsObject:saleskey]) {
                        [documentfolder.salespaymentarray addObject:saleskey];
                    }

                    
                    if (![documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:saleskey]) {
                        [documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:saleskey];
                    }
                    
                    if (![documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:saleskey]) {
                        [documentfolder.defaultcheckedsalespaymentsaleskeys addObject:saleskey];
                    }

                }

               
            
            }
        }
    }];
        
    if (result) {
//        [self refreshdocumentfoldercount];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}


-(void) makeupdatetimebuttonpressed:(UIButton *)sender
{
    if (!editattendanceviewopened) {
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:sender.tag];
        
        [ClassScheduleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
            makeuppopover.delegate=self;
            makeuppopover.PopoverClassRecord=ClassScheduleObject;
            makeuppopover.PopoverOption=@"FromClassSchedule";
            //classpopover.PopoverStudent=DetailsViewStudent;
            makeuppopover.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
            
            makeuppopover.view.frame=mainWindow.bounds;
            [sidewindowview addSubview:makeuppopover.view];
            [self addChildViewController:makeuppopover];
            [makeuppopover didMoveToParentViewController:self];
            [ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
    }
}

-(void) closesidewindow
{
    [self adjustpresentingviewwidthwithwidth:0];
    [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated:YES];
    
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    if (ailoadindicator.hidden && sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        return;
    }
    
    if (mainWindow.bounds.size.width-width == sidewindowview.frame.origin.x) {
        return;
    }
    
    if (width>0 && sidewindowview.frame.origin.x== mainWindow.bounds.size.width) {
        [MyClass playsoundwithoption:@"open"];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.frame=CGRectMake(mainWindow.bounds.size.width-width, sidewindowview.frame.origin.y, width, sidewindowview.frame.size.height);
        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        if (width==0) {
            NSArray *viewcontrollers=self.childViewControllers;
            for (int i=0; i<viewcontrollers.count; i++) {
                UIViewController *viewcontroller=viewcontrollers[i];
                [viewcontroller willMoveToParentViewController:nil];
                [viewcontroller.view removeFromSuperview];
                [viewcontroller removeFromParentViewController];
            }
            for (id object in [sidewindowview subviews]) {
                if (![object isKindOfClass:[UIActivityIndicatorView class]]) {
                    [object removeFromSuperview];
                }
            }
        }
    }];
    sidewindowviewclosebutton.hidden=width==0;
    
}

-(void) warningbuttonpressed:(UIButton *)sender
{
    sender.enabled=NO;
    warningbuttonselected=sender;
    ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:sender.tag];

    ClassValidateRecord *classvalidaterecord=[self returnClassValidateRecordWithClassScheduleObject:ClassScheduleObject];
    classvalidatemessage=classvalidaterecord.classvalidatemessage;
    classvalidatestatus=classvalidaterecord.classvalidatestatus;
    
    [self checkvalidatemessage];
}

-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    
    if (!editattendanceviewopened) {
        UIImageView *theTappedImageView=(UIImageView *)gr.view;
        
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:theTappedImageView.tag inSection:0];
        
        //dirty fix for first row cannot obtain indexpath

        [ClassScheduleTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];

        if ([ClassScheduleObject.type isEqualToString:@"student"]) {
            //popup student details view record
            if(![MyClass showMenuItemwithObject:@"Student Profile"]){
                return;
            }
            
            
            [MyClass insertViewHistoryWithType:@"student" Typekey:ClassScheduleObject.studentkey Name:@"" IDNumber:@"" Gender:@""];

            [self startsidewindowanimationwithwidth:mainWindow.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:ClassScheduleObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil  leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];

                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=ClassScheduleObject.enrollmentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=ClassScheduleObject.classkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
                
                /*if (![(StudentDetailsViewController *)[studentdetailsnavcontroller topViewController] retrieveStudent:ClassScheduleObject.studentkey]) {
                    return;
                }*/
                
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(mainWindow.frame.size.width-240, self.view.frame.size.height);
                
                
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(mainWindow.frame.size.width-501, 2, 129, 29);
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(mainWindow.frame.size.width-204, 2, 187, 29);
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(mainWindow.frame.size.width-204, 2, 187, 29);
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
                [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];
                
                studentdetailsnavcontroller.view.frame=CGRectMake(0, 0, mainWindow.frame.size.width-240, self.view.frame.size.height);
                [sidewindowview addSubview:studentdetailsnavcontroller.view];
                [self addChildViewController:studentdetailsnavcontroller];
                [studentdetailsnavcontroller didMoveToParentViewController:self];
                [ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
                

                
            });

        }else{
            if(![MyClass showMenuItemwithObject:@"Lead Profile"]){
                return;
            }

            [MyClass insertViewHistoryWithType:@"lead" Typekey:ClassScheduleObject.studentkey Name:@"" IDNumber:@"" Gender:@""];
            [self startsidewindowanimationwithwidth:mainWindow.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LeadDetailsNavController *leaddetailsnavcontroller = (LeadDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeadDetailsNavController"];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).delegate=self;
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).leadAction=@"PopoverLead";
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead=[[Lead alloc]init];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead.leadkey=ClassScheduleObject.studentkey;

                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
                
                
                if (![(LeadDetailsViewController *)[leaddetailsnavcontroller topViewController] retrieveLead:ClassScheduleObject.studentkey]) {
                    return;
                }
                
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(mainWindow.frame.size.width-240, self.view.frame.size.height);
                
                leaddetailsnavcontroller.view.frame=CGRectMake(0, 0, mainWindow.frame.size.width-240, self.view.frame.size.height);
                [sidewindowview addSubview:leaddetailsnavcontroller.view];
                [self addChildViewController:leaddetailsnavcontroller];
                [leaddetailsnavcontroller didMoveToParentViewController:self];
                [ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });

        }
    }
}

-(void) refreshparentviewdocumentfoldercount
{
    
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    
}

-(void) dismisspopover
{
    [self closesidewindow];
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

- (void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh
{
    [self closesidewindow];
    if (refresh) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveClassScheduleWithclassdate:selecteddate];
        });
    }
}

-(void) dismissMessagePopoverVC
{
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    [self closesidewindow];
    if (editattendanceviewopened) {
        [self canceleditattendancebuttonpressed];
    }
}

-(void) dismissclassremarkspopover
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self closesidewindow];
    
    UIAlertController *updatedalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Information"] message:[MyClass returntitlewithtitle:@"Information is updated"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [updatedalert addAction:OKAction];
    [self presentViewController:updatedalert animated:YES completion:nil];
    
//    [self retrieveClassScheduleWithclassdate:selecteddate];
    
    if (editattendanceviewopened) {
        [self canceleditattendancebuttonpressed];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
    
}

-(void) dismisssextendpopover
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self closesidewindow];
//    [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

-(void) passfreeclassscheduleforlessonmove:(FreeScheduleClass *)freescheduleclass updatefollowinglessons:(BOOL)updatefollowinglessons updatefollowinglessonsfields:(NSMutableArray *)updatefollowinglessonsfields
{
    [self closesidewindow];
    selectedAttendanceStatus=nil;
    freescheduleclassobject=freescheduleclass;
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    return_freescheduleclass=freescheduleclass;
    return_updatefollowinglessons=updatefollowinglessons;
    return_updatefollowinglessonsfields=updatefollowinglessonsfields;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([self validateAndMoveLessonWithfreescheduleclass:freescheduleclass validationcheck:YES updatefollowinglessons:updatefollowinglessons updatefollowinglessonsfields:updatefollowinglessonsfields]){
            if ([self validateclassallpassed]) {
                [self.delegate closesidewindow];
            }else{
                //partial success message
                UIAlertController *notsuccessalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Some classes were not able to be updated. Please tap on the warning icon to see the details"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [notsuccessalert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [notsuccessalert addAction:OKAction];
                [self presentViewController:notsuccessalert animated:YES completion:nil];
            }
            
            [self retrieveClassScheduleWithclassdate:selecteddate];
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }
    });
}

-(BOOL) validateAndMoveLessonWithfreescheduleclass:(FreeScheduleClass *)freescheduleclass validationcheck:(BOOL)validationcheck updatefollowinglessons:(BOOL)updatefollowinglessons updatefollowinglessonsfields:(NSMutableArray *)updatefollowinglessonsfields
{
    NSMutableArray *FreeScheduleArray=[[NSMutableArray alloc]init];
    NSMutableArray *studentkeyarray=[[NSMutableArray alloc]init];

    FreeScheduleClass *freescheduleclass_object;

//    long lessonclassrecordindex=[self returnLessonIndex];
//    NSMutableArray *classschedulearray=((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:lessonclassrecordindex]).classScheduleRecordArray;
//    LessonRecord *lessonrecord=((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:lessonclassrecordindex]).lesson;

    NSMutableArray *classschedulearray=ClassScheduleRecordArray;
    LessonRecord *lessonrecord=[[LessonRecord alloc]initLessonRecordwithlessonkey:nil classdate:[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"] classtime:lesson.classtime subject:lesson.subject instructor:lesson.instructor classroom:lesson.classroom classcount:nil subjecttype:lesson.subjecttype checkouttime:nil remarks:@"" classduration:nil sinstructor:lesson.sinstructor];
    
    if ([self isMoveToOtherLessonWithFreeScheduleClass:freescheduleclass Lesson:lessonrecord] || updatefollowinglessons) {
        for (int i=0; i<[classschedulearray count]; i++) {

            ClassScheduleObject=[classschedulearray objectAtIndex:i];
            freescheduleclass_object=[self returnmovelessonfreescheduleclasswithclassschedule:ClassScheduleObject freescheduleclass:freescheduleclass];

                    
                    [FreeScheduleArray addObject:freescheduleclass_object];
                    [studentkeyarray addObject:ClassScheduleObject.studentkey];

        }
        
        validateclassarray=[MyClass validateAndMoveLessonWithFreeScheduleArray:FreeScheduleArray studentkeyarray:studentkeyarray validationcheck:validationcheck updatefollowinglessons:updatefollowinglessons updatefollowinglessonsfields:updatefollowinglessonsfields];
        return TRUE;
    }else{
        if (freescheduleclass.classremarks|| freescheduleclass.lesson) {

            [self updateclasseswithclassschedulearray:classschedulearray remarks:freescheduleclass.classremarks lesson:freescheduleclass.lesson];
                return TRUE;

        }
    }
    return FALSE;
}

-(BOOL) isMoveToOtherLessonWithFreeScheduleClass:(FreeScheduleClass *)freescheduleclass Lesson:(LessonRecord *)lesson
{
    if (![lesson.classdate isEqualToString:freescheduleclass.makeupdate]) {
        return TRUE;
    }else if (![lesson.classtime isEqualToString:freescheduleclass.makeuptime]) {
        return TRUE;
    }else if (![lesson.instructor isEqualToString:freescheduleclass.makeupinstructor]) {
        return TRUE;
    }else if (![lesson.classroom isEqualToString:freescheduleclass.makeupclassroom]) {
        return TRUE;
    }else if (![[lesson.sinstructor isEqualToString:@""]?@"TBD":lesson.sinstructor isEqualToString:freescheduleclass.makeupsinstructor]) {
        return TRUE;
    }
    return FALSE;
}

-(void) updateclasseswithclassschedulearray:(NSMutableArray *)classschedulearray remarks:(NSString *)remarks lesson:(NSString *)lesson
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];

    keys=[NSArray arrayWithObjects:@"classkey",@"classtype",@"attendance",nil];
    
    //BOOL addToJson=FALSE;
    
    for (int i=0; i<classschedulearray.count; i++) {
        ClassScheduleObject=[classschedulearray objectAtIndex:i];
        values=[NSArray arrayWithObjects:ClassScheduleObject.classkey,ClassScheduleObject.classtype,ClassScheduleObject.attendance,nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    jsonclasskeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:jsonclasskeyarray forKey:@"classkeys"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:@"updatemultipleclasses" forKey:@"postaction"];
    
    if(remarks){
        [dictionary setValue:remarks forKey:@"remarks"];
    }

    if(lesson){
        [dictionary setValue:lesson forKey:@"lesson"];
    }
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
//        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        editattendanceviewopened=FALSE;
        [self openeditattendanceview:editattendanceviewopened];
    }
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

-(void) refreshleaddetailviewpresentingviewcontent
{
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

-(void) updateCategoryCount
{
    
}

-(void) disableAddStudentButton
{
    
}

-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys
{
    
}

-(void) donotrunviewdidappearinstudentinformation
{
    
}

-(void) donotrunviewdidappearinleadinformation
{
    
}

-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys
{
    
}

-(void) dismissEditStudentView{
    
}



-(void) updateleadinformationlist:(NSString *)leadkey
{
    
}



@end
