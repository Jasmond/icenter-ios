//
//  ClassRemarksPopoverViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "ClassRemarksPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"
//#import "afCheckBoxCollectionViewCell.h"
//#import "afTextCollectionViewCell.h"
#import "afCheckBoxTextCViewCell.h"
#import "afMultipleChoiceCViewCell.h"
#import "afTextMCCViewCell.h"
//#import "AFNetworking.h"
#import "AssessmentPrintView.h"
#import <PDFKit/PDFKit.h>
#import "AssessmentReportView.h"

@interface ClassRemarksPopoverViewController ()

@end

#define maxPopupHeight self.view.frame.size.height
#define tablewidth 480
#define assessmentwidth 900
#define extendedtopmargin 1
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation ClassRemarksPopoverViewController
@synthesize classScheduleObject;
@synthesize nextClassClasskey,jsonArray;
@synthesize nextClassRemarks,presentingview,previousClassRemarks,previousClassClasskey,parentNoteStudentClassKeys;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    globalvariables=[GlobalVariables singleObj];
    UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, assessmentwidth, 20)];
    topbar.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
    UIView *toptopbar=[[UIView alloc]initWithFrame:topbar.frame];
    toptopbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.15];
    [topbar addSubview:toptopbar];

    
    self.view.backgroundColor=[UIColor systemGroupedBackgroundColor];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    thisclassduration=[classScheduleObject.extensiontime intValue];
    
    
    
    BOOL showassessmentbutton;
    BOOL showextendbutton;
    
    if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
        showassessmentbutton=FALSE;
    }else if ([presentingview isEqualToString:@"dailyclassschedule"]) {
        if ([classScheduleObject.classtype isEqualToString:@"Class"] && [classScheduleObject.attendance isEqualToString:@"Makeup"]) {
            showassessmentbutton=FALSE;
        }else if ([classScheduleObject.attendance isEqualToString:@"Absent"]){
            showassessmentbutton=FALSE;
        }else if ([classScheduleObject.classtype isEqualToString:@"Makeup"] && [classScheduleObject.makeupattendance isEqualToString:@"Absent"]){
            showassessmentbutton=FALSE;
        }else if ([classScheduleObject.attendance isEqualToString:@"Extend"]){
            showassessmentbutton=FALSE;
        }else{
            if (globalvariables.centerrecord.studentassessmentform) {
                showassessmentbutton=TRUE;
            }else{
                showassessmentbutton=FALSE;
            }
        }
    }else{
        if ([classScheduleObject.classtype isEqualToString:@"Class"] && [classScheduleObject.attendance isEqualToString:@"Makeup"] && ([classScheduleObject.makeupattendance isEqualToString:@"Absent"] || [classScheduleObject.makeupdate isEqualToString:@""])) {
            showassessmentbutton=FALSE;
        }else if ([classScheduleObject.attendance isEqualToString:@"Absent"]){
            showassessmentbutton=FALSE;
        }else if ([classScheduleObject.attendance isEqualToString:@"Extend"]){
            showassessmentbutton=FALSE;
        }else{
            if (globalvariables.centerrecord.studentassessmentform) {
                showassessmentbutton=TRUE;
            }else{
                showassessmentbutton=FALSE;
            }
        }
    }
    
    if (globalvariables.centerrecord.enableattendanceextend) {
        if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
            showextendbutton=FALSE;
        }else{
            showextendbutton=TRUE;
        }
    }else{
        showextendbutton=FALSE;
    }

    
    tableoffset=(globalvariables.centerrecord.enableattendanceextend || (globalvariables.centerrecord.studentassessmentform && showassessmentbutton))?44:0;
    
    
    // Do any additional setup after loading the view.
    
//    RemarksToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, tablewidth, 44)];
//    RemarksToolBar.clipsToBounds=YES;
//    //[RemarksToolBar setBarTintColor:[UIColor lightGrayColor]];
//    RemarksToolBar.barTintColor=themecolor;//[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
//    //[self.view addSubview:RemarksToolBar];
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    doneButton.tintColor=[UIColor whiteColor];
//    deleteButton.tintColor=[UIColor clearColor];
//    deleteButton.hidden=YES;
//    shareButton.tintColor=[UIColor clearColor];
//    shareButton.hidden=YES;
    
    deleteButton.hidden=YES;
    shareButton.hidden=YES;
    doneButton.hidden=NO;
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    doneButton.tintColor=[UIColor whiteColor];
//
//    deletebutton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed)];
//    deletebutton.tintColor=[UIColor clearColor];
//    deleteButton.hidden=YES;
//    
//    shareButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed:)];
//    shareButton.tintColor=[UIColor clearColor];
//    shareButton.hidden=YES;
//    
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,shareButton,deletebutton,doneButton,nil];
//    
//    [RemarksToolBar setItems:buttons animated:NO];
    
    remarkstitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, tablewidth-100, 44)];
    remarkstitle.text=[MyClass returntitlewithtitle:@"Class Information"];
    remarkstitle.textColor=[UIColor whiteColor];
    //remarkstitle.textAlignment=NSTextAlignmentCenter;
    remarkstitle.font=[UIFont systemFontOfSize:18];
    
    
    tmpthisclassremarks=classScheduleObject.remarks;
    tmpallclassremarks=classScheduleObject.allclassremarks;
    tmpabsentmakeupreason=classScheduleObject.absentmakeupreason;
    tmpparentnote=classScheduleObject.parentnote;
    
    /*
    if (![nextClassClasskey isEqualToString:@""]) {
        tmpnextclassremarks=nextClassRemarks;
    }else{
        tmpnextclassremarks=@"Next class not available";
    }
    
    if (![previousClassClasskey isEqualToString:@""]) {
        tmppreviousclassremarks=previousClassRemarks;
    }else{
        tmppreviousclassremarks=@"Previous class not available";
    }*/
    

    
    //add buttons
    /*remarksbutton=[[UIButton alloc]init];
    remarksbutton.backgroundColor=[UIColor darkGrayColor];
    [remarksbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    remarksbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    remarksbutton.titleLabel.textAlignment=NSTextAlignmentCenter;*/
    [remarksbutton setTitle:[MyClass returntitlewithtitle:@"Class Remarks"] forState:UIControlStateNormal];
    /*[remarksbutton addTarget:self action:@selector(remarksbuttonpressed) forControlEvents:UIControlEventTouchUpInside];

    extendbutton=[[UIButton alloc]init];
    extendbutton.backgroundColor=[UIColor grayColor];
    [extendbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    extendbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    extendbutton.titleLabel.textAlignment=NSTextAlignmentCenter;*/
    [extendbutton setTitle:[MyClass returntitlewithtitle:@"Extend Class"] forState:UIControlStateNormal];
    /*[extendbutton addTarget:self action:@selector(extendbuttonpressed) forControlEvents:UIControlEventTouchUpInside];

    assessmentbutton=[[UIButton alloc]init];
    assessmentbutton.backgroundColor=[UIColor grayColor];
    [assessmentbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    assessmentbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    assessmentbutton.titleLabel.textAlignment=NSTextAlignmentCenter;*/
    [assessmentbutton setTitle:[MyClass returntitlewithtitle:@"Evaluation Form"] forState:UIControlStateNormal];
//    [assessmentbutton addTarget:self action:@selector(assessmentbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    
    buttonStackWidthConstraints.constant=tablewidth;
    
    
    extendmasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 88+20, tablewidth, self.view.bounds.size.height-88-20)];
    extendmasterview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    [self.view addSubview:extendmasterview];

    
    assessmentblockbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, assessmentwidth, 1000)];
    assessmentblockbutton.backgroundColor=[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.05];
    [assessmentblockbutton addTarget:self action:@selector(assessmentblockbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    assessmentblockbutton.hidden=YES;
    [assessmentmasterview addSubview:assessmentblockbutton];
    
    assessmentformcenterlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, assessmentwidth, 10*44)];
    assessmentformcenterlabel.textColor=[UIColor lightGrayColor];
    assessmentformcenterlabel.backgroundColor=[UIColor whiteColor];
    assessmentformcenterlabel.textAlignment=NSTextAlignmentCenter;
    [assessmentmasterview addSubview:assessmentformcenterlabel];
    
    assessmentformlisttable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    assessmentformlisttable.delegate=self;
    assessmentformlisttable.dataSource=self;
    assessmentformlisttable.backgroundColor=[UIColor colorWithRed:177.0/255.0 green:242.0/255.0 blue:226.0/255.0 alpha:1];
    [assessmentmasterview addSubview:assessmentformlisttable];
    
//    [self.view addSubview:RemarksToolBar];
//    [self.view addSubview:remarkstitle];
    
//    NSInteger noofbutton=1+(showextendbutton?1:0)+(showassessmentbutton?1:0);
//    remarksbutton.frame=CGRectMake(0,44+20,tablewidth/noofbutton,44);
//    [self.view addSubview:remarksbutton];
//    if (showextendbutton) {
//        extendbutton.frame=CGRectMake(tablewidth/noofbutton,44+20,tablewidth/noofbutton,44);
//        [self.view addSubview:extendbutton];
//    }
    extendbutton.hidden=!showextendbutton;
    assessmentbutton.hidden=!showassessmentbutton;
    
//    if (showassessmentbutton) {
//        assessmentbutton.frame=CGRectMake(tablewidth*(noofbutton-1)/noofbutton,44+20,tablewidth/noofbutton,44);
//    }

    formtitleview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, assessmentwidth, 44)];
    formtitleview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]];
    [assessmentmasterview addSubview:formtitleview];
    
    formtitlelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 3, assessmentwidth-70, 25)];
    formtitlelabel.font=[UIFont boldSystemFontOfSize:16];
    [formtitleview addSubview:formtitlelabel];

    formlastsubmittedtimelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 27, assessmentwidth-70, 12)];
    formlastsubmittedtimelabel.font=[UIFont boldSystemFontOfSize:12];
    formlastsubmittedtimelabel.textColor=[UIColor darkGrayColor];
    [formtitleview addSubview:formlastsubmittedtimelabel];
    
    formselectionimage=[[UIImageView alloc]initWithFrame:CGRectMake(assessmentwidth-40, 13, 18, 18)];
    [formtitleview addSubview:formselectionimage];
    
    changeformbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, formtitleview.frame.size.width, formtitleview.frame.size.height)];
    [changeformbutton addTarget:self action:@selector(changeformbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    changeformbutton.tag=0;
    [formtitleview addSubview:changeformbutton];
    

    
    //Extend From header view
    extendedfromheaderview=[[UIView alloc]initWithFrame:CGRectMake(0, extendedtopmargin, tablewidth, 132)];
//    extendedfromheaderview.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.1];
    extendedfromheaderview.backgroundColor=[UIColor whiteColor];
    [extendmasterview addSubview:extendedfromheaderview];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tablewidth, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [extendedfromheaderview addSubview:separator];
    
    UILabel *extendedminutetitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    extendedminutetitle.font=[UIFont boldSystemFontOfSize:17];
    extendedminutetitle.textColor=[UIColor darkGrayColor];
    extendedminutetitle.text=[MyClass returntitlewithtitle:@"Time Extended"];
    [extendedfromheaderview addSubview:extendedminutetitle];
    
    extendedtimelabel=[[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 0, 100, 44)];
    extendedtimelabel.font=[UIFont systemFontOfSize:17];
    extendedtimelabel.textAlignment=NSTextAlignmentRight;
    extendedtimelabel.textColor=[UIColor darkGrayColor];
    [extendedfromheaderview addSubview:extendedtimelabel];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(20, 44, tablewidth-20, 1)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [extendedfromheaderview addSubview:separator];
    
    UILabel *outstandingbalancetitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 44, 300, 44)];
    outstandingbalancetitle.font=[UIFont boldSystemFontOfSize:17];
    outstandingbalancetitle.textColor=[UIColor darkGrayColor];
    outstandingbalancetitle.text=[MyClass returntitlewithtitle:@"Outstanding Extension Time"];
    [extendedfromheaderview addSubview:outstandingbalancetitle];
    
    outstandingbalancelabel=[[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 44, 100, 44)];
    outstandingbalancelabel.font=[UIFont systemFontOfSize:17];
    outstandingbalancelabel.textAlignment=NSTextAlignmentRight;
    outstandingbalancelabel.textColor=[UIColor darkGrayColor];
    [extendedfromheaderview addSubview:outstandingbalancelabel];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(20, 88, tablewidth-20, 1)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [extendedfromheaderview addSubview:separator];
    
    UILabel *timetoextendtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 88, 200, 44)];
    timetoextendtitle.font=[UIFont boldSystemFontOfSize:17];
    timetoextendtitle.textColor=[UIColor darkGrayColor];
    timetoextendtitle.text=[MyClass returntitlewithtitle:@"Time to Extend"];
    [extendedfromheaderview addSubview:timetoextendtitle];
    
    timetoextendtext=[[UITextField alloc]initWithFrame:CGRectMake(tablewidth-80-25, 88+7, 80, 30)];
    timetoextendtext.font=[UIFont systemFontOfSize:17];
    timetoextendtext.textAlignment=NSTextAlignmentRight;
    timetoextendtext.textColor=[UIColor darkGrayColor];
    timetoextendtext.placeholder=[MyClass returntitlewithtitle:@"mins"];
    [timetoextendtext setBorderStyle:UITextBorderStyleRoundedRect];
    timetoextendtext.keyboardType=UIKeyboardTypeNumberPad;
    [timetoextendtext addTarget:self action:@selector(validateinput)forControlEvents:UIControlEventEditingChanged];
    timetoextendtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    [extendedfromheaderview addSubview:timetoextendtext];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, 132, tablewidth, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [extendedfromheaderview addSubview:separator];

    
    //Extend To header view
    extendedtoheaderview=[[UIView alloc]initWithFrame:CGRectMake(0, extendedtopmargin, tablewidth, 132)];
    extendedtoheaderview.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.1];
    [extendmasterview addSubview:extendedtoheaderview];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tablewidth, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [extendedtoheaderview addSubview:separator];
    
    UILabel *classdurationtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    classdurationtitle.font=[UIFont boldSystemFontOfSize:17];
    classdurationtitle.textColor=[UIColor darkGrayColor];
    classdurationtitle.text=[MyClass returntitlewithtitle:@"Extension Time"];
    [extendedtoheaderview addSubview:classdurationtitle];

    classdurationlabel=[[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 0, 100, 44)];
    classdurationlabel.font=[UIFont systemFontOfSize:17];
    classdurationlabel.textAlignment=NSTextAlignmentRight;
    classdurationlabel.textColor=[UIColor darkGrayColor];
    classdurationlabel.text=[NSString stringWithFormat:@"%li %@",thisclassduration,[MyClass returntitlewithtitle:@"mins"]];
    [extendedtoheaderview addSubview:classdurationlabel];
    
    extensiontimetext=[[UITextField alloc]initWithFrame:CGRectMake(tablewidth-100-30+20, 7, 80, 30)];
    extensiontimetext.font=[UIFont systemFontOfSize:17];
    extensiontimetext.textAlignment=NSTextAlignmentRight;
    extensiontimetext.textColor=[UIColor darkGrayColor];
    extensiontimetext.placeholder=[MyClass returntitlewithtitle:@"mins"];
    [extensiontimetext setBorderStyle:UITextBorderStyleRoundedRect];
    extensiontimetext.keyboardType=UIKeyboardTypeNumberPad;
    extensiontimetext.text=[NSString stringWithFormat:@"%ld",thisclassduration];
    [extensiontimetext addTarget:self action:@selector(validateextensiontimeinput)forControlEvents:UIControlEventEditingChanged];
    extensiontimetext.clearButtonMode = UITextFieldViewModeWhileEditing;
    extensiontimetext.hidden=YES;
    [extendedtoheaderview addSubview:extensiontimetext];
    
    
    
    UIButton *overridebutton=[[UIButton alloc]initWithFrame:CGRectMake(tablewidth-100-22-20,11, 22, 22)];
    [overridebutton addTarget:self action:@selector(overridebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [overridebutton setImage:[UIImage imageNamed:@"paymentoverridebutton.png"] forState:UIControlStateNormal];
    
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).overrideextensiontime) {
        [extendedtoheaderview addSubview:overridebutton];
    }

    
    separator=[[UIView alloc]initWithFrame:CGRectMake(20, 44, tablewidth-20, 1)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [extendedtoheaderview addSubview:separator];

    outstandingbalancetitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 44, 300, 44)];
    outstandingbalancetitle.font=[UIFont boldSystemFontOfSize:17];
    outstandingbalancetitle.textColor=[UIColor darkGrayColor];
    outstandingbalancetitle.text=[MyClass returntitlewithtitle:@"Time Used"];
    [extendedtoheaderview addSubview:outstandingbalancetitle];
    
    extendedtothisclassbalancelabel=[[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 44, 100, 44)];
    extendedtothisclassbalancelabel.font=[UIFont systemFontOfSize:17];
    extendedtothisclassbalancelabel.textAlignment=NSTextAlignmentRight;
    extendedtothisclassbalancelabel.textColor=[UIColor darkGrayColor];
    [extendedtoheaderview addSubview:extendedtothisclassbalancelabel];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(20, 88, tablewidth-20, 1)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [extendedtoheaderview addSubview:separator];
    
    outstandingbalancetitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 88, 300, 44)];
    outstandingbalancetitle.font=[UIFont boldSystemFontOfSize:17];
    outstandingbalancetitle.textColor=[UIColor darkGrayColor];
    outstandingbalancetitle.text=[MyClass returntitlewithtitle:@"Outstanding Extension Time"];
    [extendedtoheaderview addSubview:outstandingbalancetitle];
    
    extendedtototalbalancelabel=[[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 88, 100, 44)];
    extendedtototalbalancelabel.font=[UIFont systemFontOfSize:17];
    extendedtototalbalancelabel.textAlignment=NSTextAlignmentRight;
    extendedtototalbalancelabel.textColor=[UIColor darkGrayColor];
    [extendedtoheaderview addSubview:extendedtototalbalancelabel];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, 132, tablewidth, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [extendedtoheaderview addSubview:separator];



    
    
    //add tables
    extendedclasstable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    extendedclasstable.dataSource=self;
    extendedclasstable.delegate=self;
    extendedclasstable.sectionHeaderHeight=0;
    extendedclasstable.allowsMultipleSelectionDuringEditing = NO;
    [extendmasterview addSubview:extendedclasstable];
    
    //classremarkstable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //classremarkstable.dataSource=self;
    //classremarkstable.delegate=self;
    classremarkstable.sectionHeaderHeight=0;
    //[classremarkstable reloadData];
    //classremarkstable.frame=CGRectMake(0, 44+tableoffset+20, tablewidth, self.view.bounds.size.height-44-tableoffset-20);
    //[self.view addSubview:classremarkstable];
    
    extendmasterview.hidden=YES;


    self.preferredContentSize=CGSizeMake(tablewidth, self.view.bounds.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    selectedformkey=@"";
    
    [self.view addSubview:topbar];
    
    [self startAudioSession];
    workingMessage=[[OutboxMessageRecord alloc]init];
    
    if (![presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
        [self retrievenextclassremarks];
    }
    
    if (![nextClassClasskey isEqualToString:@""]) {
        tmpnextclassremarks=nextClassRemarks;
    }else{
        tmpnextclassremarks=@"Next class not available";
    }
    
    if (![previousClassClasskey isEqualToString:@""]) {
        tmppreviousclassremarks=previousClassRemarks;
    }else{
        tmppreviousclassremarks=@"Previous class not available";
    }
    
    
    audioPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    audioPanGesture.maximumNumberOfTouches = 1;
    audioPanGesture.minimumNumberOfTouches = 1;
    audioPanGesture.delegate = self;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];

    // Choose between heavy, medium, and light for style
    impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        
    // Primes feedback generator for upcoming events and reduces latency
    [impactFeedbackGenerator prepare];
    
    assessmentColorArray=[[NSArray alloc]initWithObjects:[UIColor blackColor],[UIColor blueColor],[UIColor systemPinkColor],[UIColor orangeColor],themecolor,[UIColor purpleColor],[UIColor systemGreenColor], [UIColor brownColor], [UIColor systemRedColor], nil];
    
    [self remarksbuttonpressed:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void) viewDidDisappear:(BOOL)animated
{
    if (audioPlayer.playing) {
        [audioPlayer stop];
        audioPlayer=nil;
        [sliderTimer invalidate];
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyClass returntitlewithtitle:@"Delete"];
}

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

-(void) overridebuttonpressed:(UIButton *)sender
{
    classdurationlabel.hidden=!classdurationlabel.hidden;
    extensiontimetext.hidden=!extensiontimetext.hidden;
    doneButton.enabled=!extensiontimetext.hidden?YES:NO;
}


-(IBAction)remarksbuttonpressed:(id)sender
{
    [self stopAudioPlaying];
    deleteButton.hidden=YES;
    shareButton.hidden=YES;
    doneButton.hidden=NO;
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    remarksbutton.backgroundColor=[UIColor darkGrayColor];
    [remarksbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    extendbutton.backgroundColor=[UIColor grayColor];
    [extendbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    assessmentbutton.backgroundColor=[UIColor grayColor];
    [assessmentbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    classremarkstable.hidden=NO;
    extendmasterview.hidden=YES;
    assessmentmasterview.hidden=YES;
    [self adjusttablesize];
}

-(IBAction)extendbuttonpressed:(id)sender
{
    [self stopAudioPlaying];
//    [deleteButton setTintColor:[UIColor clearColor]];
//    deleteButton.hidden=YES;
//    [shareButton setTintColor:[UIColor clearColor]];
//    shareButton.hidden=YES;
    
    deleteButton.hidden=YES;
    shareButton.hidden=YES;
    doneButton.hidden=NO;
    
    
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    [self getextendclassinformation];
    [extendedclasstable reloadData];
    //extendedclasstable.frame=CGRectMake(0, 3*44+extendedtopmargin, tablewidth, extendedclasstable.contentSize.height);
    if ([classScheduleObject.attendance isEqualToString:@"Extend"]) {
        extendedfromheaderview.hidden=YES;
        extendedtoheaderview.hidden=NO;
    }else{
        extendedfromheaderview.hidden=NO;
        extendedtoheaderview.hidden=YES;
    }
    
    
    doneButton.enabled=([classScheduleObject.attendance isEqualToString:@"Extend"]||[classScheduleObject.attendance isEqualToString:@"Absent"]|| ([classScheduleObject.attendance isEqualToString:@"Makeup"] && [classScheduleObject.classtype isEqualToString:@"Class"] && ([classScheduleObject.makeupdate isEqualToString:@""] || [classScheduleObject.makeupdate isEqualToString:@"TBD"])) || ([classScheduleObject.makeupattendance isEqualToString:@"Absent"] && [classScheduleObject.classtype isEqualToString:@"Makeup"]) || [classScheduleObject.status isEqualToString:@"Voided"])?NO:YES;
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    remarksbutton.backgroundColor=[UIColor grayColor];
    [remarksbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    assessmentbutton.backgroundColor=[UIColor grayColor];
    [assessmentbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    extendbutton.backgroundColor=[UIColor darkGrayColor];
    [extendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    classremarkstable.hidden=YES;
    extendmasterview.hidden=NO;
    assessmentmasterview.hidden=YES;
    [self adjusttablesize];
}

-(IBAction)assessmentbuttonpressed:(id)sender
{
    [self stopAudioPlaying];
    assessmentblockbutton.hidden=YES;
    changeformbutton.tag=0;
//    doneButton.enabled=YES;
    
    deleteButton.hidden=NO;
    shareButton.hidden=NO;
    doneButton.hidden=NO;
    
    remarksbutton.backgroundColor=[UIColor grayColor];
    [remarksbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    extendbutton.backgroundColor=[UIColor grayColor];
    [extendbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    assessmentbutton.backgroundColor=[UIColor darkGrayColor];
    [assessmentbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    classremarkstable.hidden=YES;
    extendmasterview.hidden=YES;
    assessmentmasterview.hidden=NO;
    [self getassessmentformlist];
    [self getassessmentformresponsewithformkey:selectedformkey];
    [doneButton setTitle:[MyClass returntitlewithtitle:[selectedForm.lastsubmittedtime isEqualToString:@""]?@"Submit":@"Update"] forState:UIControlStateNormal];
    [self adjusttablesize];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==classremarkstable) {
        return 6;
    }else if (tableView==assessmenttable){
        return assessmentformarray.count;
    }else if (tableView==assessmentformlisttable){
        return 1;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==classremarkstable) {
        if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
            if (section==5) {
                return 1;
            }
            return 0;
        }else{
            if (section==4) {
                if ([classScheduleObject.classtype isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Absent"] || [classScheduleObject.attendance isEqualToString:@"Extend"]) {
                    return 1;
                }else{
                    return 0;
                }
                
            }
            return 1;
        }
    }else if (tableView==assessmenttable){
        return [self getNoOfQuestionWithQuestionArray:((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:section]).questionarray];
    }else if (tableView==assessmentformlisttable){
        return assessmentformlistarray.count;
    }else{
        if (section==0){
            return extendedtoclassarray.count;
        }else if (section==1) {
            return extendedfromclassarray.count;
        }else{
            return outstandingextendedclassarray.count;
        }
    }
}

-(NSInteger) getNoOfQuestionWithQuestionArray:(NSMutableArray *)questionarray
{
    NSInteger noofquestion=0;
    for (int i=0; i<questionarray.count; i++) {
        AssessmentFormRowObject *obj=[questionarray objectAtIndex:i];
        if (![obj.title isEqualToString:@""]) {
            noofquestion++;
        }
    }
    return noofquestion;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==classremarkstable) {
        if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
            if (section==5) {
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Teacher Note"],[MyClass returntitlewithtitle:@"Send to Parent"]];
            }
            return nil;
        }else{
            if (section==0) {
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"This Class Remarks"],[MyClass returntitlewithtitle:@"Internal"]];
            }else if (section==1){
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Previous Class Remarks"],[MyClass returntitlewithtitle:@"Internal"]];
            }else if (section==2){
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Next Class Remarks"],[MyClass returntitlewithtitle:@"Internal"]];
            }else if (section==3){
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"All Class Remarks"],[MyClass returntitlewithtitle:@"Internal"]];
            }else if (section==4){
                if ([classScheduleObject.classtype isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Absent"] || [classScheduleObject.attendance isEqualToString:@"Extend"]) {
                    if ([classScheduleObject.attendance isEqualToString:@"Absent"]) {
                        return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Absent Reasons"],[MyClass returntitlewithtitle:@"Internal"]];
                    }else if ([classScheduleObject.attendance isEqualToString:@"Extend"]) {
                        return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Extend Reasons"],[MyClass returntitlewithtitle:@"Internal"]];
                    }else{
                        return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Makeup Reasons"],[MyClass returntitlewithtitle:@"Internal"]];
                    }
                }else{
                    return nil;
                }
            }else{
                return [NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Teacher Note"],[MyClass returntitlewithtitle:@"Send to Parent"]];
            }
            
        }
        
        
    }else if (tableView==assessmenttable){
        return [MyClass returntitlewithtitle:((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:section]).title];
    }else if (tableView==assessmentformlisttable){
        return nil;
    }else{
        if (section==0) {
            if (extendedtoclassarray.count==0) {
                return nil;
            }else{
                return [MyClass returntitlewithtitle:@"Time Extended To"];
            }
        }else if (section==1) {
            if (extendedfromclassarray.count==0) {
                return nil;
            }else{
                return [MyClass returntitlewithtitle:@"Extended Time From"];
            }
        }else{
            if (outstandingextendedclassarray.count==0) {
                return nil;
            }else{
                return [MyClass returntitlewithtitle:@"Outstanding Extension Time"];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==classremarkstable) {
        if (indexPath.section==4) {
            if ([classScheduleObject.classtype isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Absent"] || [classScheduleObject.attendance isEqualToString:@"Extend"]) {
                return UITableViewAutomaticDimension;
            }else{
                return CGFLOAT_MIN;
            }
        }
        return UITableViewAutomaticDimension;
    }else if (tableView==assessmenttable){
        return UITableViewAutomaticDimension;
    }else if (tableView==assessmentformlisttable){
        if ([((AssessmentFormListObject *)[assessmentformlistarray objectAtIndex:indexPath.row]).formkey isEqualToString:selectedformkey]) {
            return CGFLOAT_MIN;
        }else{
            return 44;
        }
    }else{
        return 50;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (!assessmenttable.hidden){
        [self autosaveassessmentresponse];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self stopAudioPlaying];
    if (keyboardheight>0) {
        if (!classremarkstable.hidden) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:classremarkstable];
            NSIndexPath *indexpath =[classremarkstable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [classremarkstable rectForRowAtIndexPath:indexpath];
            CGFloat offset = rectInTableView.origin.y+rectInTableView.size.height-classremarkstable.frame.size.height;
            if (offset>0) {
                [classremarkstable setContentOffset:CGPointMake(0, offset) animated:YES];
            }
            
        }else if (!assessmenttable.hidden){
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:assessmenttable];
            NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [assessmenttable rectForRowAtIndexPath:indexpath];
            CGFloat offset = rectInTableView.origin.y+rectInTableView.size.height-assessmenttable.frame.size.height;
            if (offset>0) {
                [assessmenttable setContentOffset:CGPointMake(0, offset) animated:YES];
            }
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (!classremarkstable.hidden) {
        MyTableViewCell *newcell=[classremarkstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:textView.tag]];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>100) {
            newcell.layoutconstraint1.constant=100;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        
        if (textView.tag==0) {
            tmpthisclassremarks=textView.text;
        }else if (textView.tag==2){
            tmpnextclassremarks=textView.text;
        }else if (textView.tag==1){
            tmppreviousclassremarks=textView.text;
        }else if (textView.tag==3){
            tmpallclassremarks=textView.text;
        }else if (textView.tag==4){
            tmpabsentmakeupreason=textView.text;
        }else{
            tmpparentnote=textView.text;
        }
        
        [classremarkstable beginUpdates];
        [classremarkstable endUpdates];
    }else if (!assessmenttable.hidden){
        if (textView.tag==100) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:assessmenttable];
            NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
            
            MyTableViewCell *newcell=[assessmenttable cellForRowAtIndexPath:indexpath];
            
            CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
            
            
            
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
            
            assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if([textView.text isEqualToString:@""]){
                if (index>=0) {
                    [assessmentformrowobject.responsearray removeObjectAtIndex:index];
                }
            }else{
                if (index>=0) {
                    [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"RMK|%@",textView.text]];
                }else{
                    [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"RMK|%@",textView.text]];
                }
            }
            [assessmenttable beginUpdates];
            [assessmenttable endUpdates];
        }else if (textView.tag==200) {
            //shortanswer2
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:assessmenttable];
            NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
            
            MyTableViewCell *newcell=[assessmenttable cellForRowAtIndexPath:indexpath];
            
            CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
            
            assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
            
            
            //show score button
            newcell.button1.hidden=[textView.text isEqualToString:@""];
            if ([textView.text isEqualToString:@""]) {
                [assessmentformrowobject.responsearray replaceObjectAtIndex:0 withObject:textView.text];
                newcell.button1.hidden=YES;
            }else{
                newcell.button1.hidden=NO;
                NSRange scorerange=[assessmentformrowobject.responsearray[0] rangeOfString:@"|"];
                if (scorerange.location!=NSNotFound) {
                    NSString *score=[assessmentformrowobject.responsearray[0] substringFromIndex:scorerange.location+1];
                    [assessmentformrowobject.responsearray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@|%@",textView.text,score]];
                }else{
                    [assessmentformrowobject.responsearray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@|",textView.text]];
                    [newcell.button1 setTitle:[MyClass returntitlewithtitle:@"Score"] forState:UIControlStateNormal];
                }
            }
            
            [assessmenttable beginUpdates];
            [assessmenttable endUpdates];
        }else{
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:assessmenttable];
            NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
            
            assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
            [assessmentformrowobject.responsearray replaceObjectAtIndex:0 withObject:textView.text];
        }
    }
}

-(void) updateshortanswer:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
    
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
    [assessmentformrowobject.responsearray replaceObjectAtIndex:0 withObject:sender.text];
}

//-(void) updatecheckboxtextcomment:(UITextField *)sender
//{
//    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
//    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
//    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
//    NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
//    if([sender.text isEqualToString:@""]){
//        if (index>=0) {
//            [assessmentformrowobject.responsearray removeObjectAtIndex:index];
//        }
//    }else{
//        if (index>=0) {
//            [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"RMK|%@",sender.text]];
//        }else{
//            [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"RMK|%@",sender.text]];
//        }
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tableView==classremarkstable) {

        if (indexPath.section==0 ) {
            
            static NSString *CellIdentifier = @"remarkscell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textview1.tag=indexPath.section;
            cell.textview1.text=tmpthisclassremarks;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier = @"remarkscell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textview1.tag=indexPath.section;
            cell.textview1.text=tmppreviousclassremarks;
            if ([tmppreviousclassremarks isEqualToString:@"Previous class not available"]) {
                cell.textview1.text=[MyClass returntitlewithtitle:tmppreviousclassremarks];
                cell.textview1.editable=NO;
            }else{
                cell.textview1.editable=YES;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.section==2) {
            static NSString *CellIdentifier = @"remarkscell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textview1.tag=indexPath.section;
            cell.textview1.text=tmpnextclassremarks;
            if ([tmpnextclassremarks isEqualToString:@"Next class not available"]) {
                cell.textview1.text=[MyClass returntitlewithtitle:tmpnextclassremarks];
                cell.textview1.editable=NO;
            }else{
                cell.textview1.editable=YES;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            
        }else if (indexPath.section==3) {
            static NSString *CellIdentifier = @"remarkscell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textview1.tag=indexPath.section;
            cell.textview1.text=tmpallclassremarks;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            
            
        }else if (indexPath.section==4) {
            static NSString *CellIdentifier = @"remarkscell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textview1.tag=indexPath.section;
            cell.textview1.text=tmpabsentmakeupreason;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            if ([classScheduleObject.classtype isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Absent"] || [classScheduleObject.attendance isEqualToString:@"Extend"]) {
                cell.hidden=NO;
            }else{
                cell.hidden=YES;
            }
            
            return cell;
            
        }else{// if (indexPath.row==3) {
            
            if (workingMessage.photoarray.count>0) {
                static NSString *CellIdentifier = @"parentnoteaudiocell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                UIImage *image=[self imageWithImage:[UIImage imageNamed:@"slider_thumb.png"] scaledToSize:CGSizeMake(12, 12)];
                [cell.slider1 setThumbImage:image forState:UIControlStateNormal];
                cell.slider1.tag=indexPath.section;
                [cell.slider1 addTarget:self action:@selector(audioSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                cell.slider1.value=0;
                cell.button4.tag=indexPath.section;
                [cell.button4 addTarget:self action:@selector(playAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
                
                if (workingMessage.messagestarttime) {
                    cell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:workingMessage.messagestarttime];
                    cell.label3.text=[NSString stringWithFormat:@"%@ / %@",cell.label3.text,[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).height]];
                }else{
                    cell.label3.text=[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).height];
                }
                
                [cell.button1 addTarget:self action:@selector(deleteAudioParentNote:) forControlEvents:UIControlEventTouchUpInside];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString *CellIdentifier = @"parentnotecell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.textview1.tag=indexPath.section;
                textinputbox=cell.view1;
                [textinputbox addGestureRecognizer:audioPanGesture];
                recordingStatusView=cell.view2;
                audioRecordingImage=cell.imageview1;
                recordingDuration=cell.label1;
                slideToCancelTitle=cell.label2;
                slideToCancelTitle.text=[MyClass returntitlewithtitle:@"Release here to cancel"];
                
                cell.textview1.text=tmpparentnote;
                
                cell.button1.hidden=!globalvariables.centerrecord.enablevoicemessage  || !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvoicemessage;
                
                [cell.button1 addTarget:self action:@selector(startAudioRecording:) forControlEvents:UIControlEventTouchDown];
                [cell.button1 addTarget:self action:@selector(stopAudioRecording:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }

    }else if (tableView==assessmenttable) {
        
        assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexPath.section]).questionarray objectAtIndex:indexPath.row];
        
        
        if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtext"]) {
            static NSString *CellIdentifier = @"checkboxtextcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
            cell.label1.text=assessmentformrowobject.title;

            UINib *cellNib;
            [cell.collectionview1 registerClass:[afCheckBoxTextCViewCell class] forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
            cellNib = [UINib nibWithNibName:@"afCheckBoxTextCViewCell" bundle:nil];
            [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
            [cell.collectionview1 reloadData];
            cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
            
            [cell.button1 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=0;
            
            cell.button1.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[0] disabled:NO]<0;
            [cell.button1 setTitleColor:assessmentColorArray[0] forState:UIControlStateNormal];
            [cell.button1 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[0]] forState:UIControlStateNormal];
            
            if (assessmentformrowobject.valuearray.count>1) {
                [cell.button2 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button2.tag=1;
                cell.button2.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[1] disabled:NO]<0;
                [cell.button2 setTitleColor:assessmentColorArray[1] forState:UIControlStateNormal];
                [cell.button2 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[1]] forState:UIControlStateNormal];
            }else{
                cell.button2.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>2) {
                [cell.button3 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button3.tag=2;
                cell.button3.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[2] disabled:NO]<0;
                [cell.button3 setTitleColor:assessmentColorArray[2] forState:UIControlStateNormal];
                [cell.button3 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[2]] forState:UIControlStateNormal];
            }else{
                cell.button3.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>3) {
                [cell.button4 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button4.tag=3;
                cell.button4.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[3] disabled:NO]<0;
                [cell.button4 setTitleColor:assessmentColorArray[3] forState:UIControlStateNormal];
                [cell.button4 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[3]] forState:UIControlStateNormal];
            }else{
                cell.button4.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>4) {
                [cell.button5 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button5.tag=4;
                cell.button5.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[4] disabled:NO]<0;
                [cell.button5 setTitleColor:assessmentColorArray[4] forState:UIControlStateNormal];
                [cell.button5 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[4]] forState:UIControlStateNormal];
            }else{
                cell.button5.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>5) {
                [cell.button6 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button6.tag=5;
                cell.button6.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[5] disabled:NO]<0;
                [cell.button6 setTitleColor:assessmentColorArray[5] forState:UIControlStateNormal];
                [cell.button6 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[5]] forState:UIControlStateNormal];
            }else{
                cell.button6.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>6) {
                [cell.button7 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button7.tag=6;
                cell.button7.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[6] disabled:NO]<0;
                [cell.button7 setTitleColor:assessmentColorArray[6] forState:UIControlStateNormal];
                [cell.button7 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[6]] forState:UIControlStateNormal];
            }else{
                cell.button7.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>7) {
                [cell.button8 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button8.tag=7;
                cell.button8.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[7] disabled:NO]<0;
                [cell.button8 setTitleColor:assessmentColorArray[7] forState:UIControlStateNormal];
                [cell.button8 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[7]] forState:UIControlStateNormal];
            }else{
                cell.button8.hidden=YES;
            }
            
            if (assessmentformrowobject.valuearray.count>8) {
                [cell.button9 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                cell.button9.tag=8;
                cell.button9.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[8] disabled:NO]<0;
                [cell.button9 setTitleColor:assessmentColorArray[8] forState:UIControlStateNormal];
                [cell.button9 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[8]] forState:UIControlStateNormal];
            }else{
                cell.button9.hidden=YES;
            }
            
            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"]) {
            static NSString *CellIdentifier = @"checkboxtextcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
            cell.label1.text=assessmentformrowobject.title;

            UINib *cellNib;
            [cell.collectionview1 registerClass:[afCheckBoxTextCViewCell class] forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
            cellNib = [UINib nibWithNibName:@"afCheckBoxTextCViewCell" bundle:nil];
            [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
            [cell.collectionview1 reloadData];
            cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
            
            cell.button1.hidden=YES;
            cell.button2.hidden=YES;
            cell.button3.hidden=YES;
            cell.button4.hidden=YES;
            cell.button5.hidden=YES;
            cell.button6.hidden=YES;
            cell.button7.hidden=YES;
            cell.button8.hidden=YES;
            cell.button9.hidden=YES;

            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer2"]) {
            static NSString *CellIdentifier = @"shortanswer2cell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label1.text=assessmentformrowobject.title;
            
            
            
            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            
            [cell.button1 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=0;
            
            cell.button1.hidden=[assessmentformrowobject.responsearray[0] isEqualToString:@""];
            [cell.button1 setTitleColor:assessmentColorArray[0] forState:UIControlStateNormal];
            [cell.button1 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[0]] forState:UIControlStateNormal];
            
            cell.gctextview2.textContainer.lineFragmentPadding=0;
            cell.gctextview2.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview2.text=[self returnshortanswer2text:assessmentformrowobject.responsearray[0]];
            cell.gctextview2.textColor=[UIColor blackColor];
            if([cell.gctextview2.text isEqualToString:@""]){
                cell.gctextview2.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview2.tag=200;

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer2nr"]) {
            static NSString *CellIdentifier = @"shortanswer2nrcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label1.text=assessmentformrowobject.title;
            
            
            
            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            
            [cell.button1 addTarget:self action:@selector(scorebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=0;
            
            cell.button1.hidden=[assessmentformrowobject.responsearray[0] isEqualToString:@""];
            [cell.button1 setTitleColor:assessmentColorArray[0] forState:UIControlStateNormal];
            [cell.button1 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[0]] forState:UIControlStateNormal];
            
            cell.gctextview2.textContainer.lineFragmentPadding=0;
            cell.gctextview2.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview2.text=[self returnshortanswer2text:assessmentformrowobject.responsearray[0]];
            cell.gctextview2.textColor=[UIColor blackColor];
            if([cell.gctextview2.text isEqualToString:@""]){
                cell.gctextview2.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview2.tag=200;

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2"]) {
            static NSString *CellIdentifier = @"checkboxtextcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.button1.hidden=YES;
            cell.button2.hidden=YES;
            cell.button3.hidden=YES;
            cell.button4.hidden=YES;
            cell.button5.hidden=YES;
            cell.button6.hidden=YES;
            cell.button7.hidden=YES;
            cell.button8.hidden=YES;
            cell.button9.hidden=YES;
            
            cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
            cell.label1.text=assessmentformrowobject.title;

            UINib *cellNib;
            [cell.collectionview1 registerClass:[afMultipleChoiceCViewCell class] forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
            cellNib = [UINib nibWithNibName:@"afMultipleChoiceCViewCell" bundle:nil];
            [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
            [cell.collectionview1 reloadData];
            cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
            
            cell.gctextview1.hidden=NO;
            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2nr"]) {
            static NSString *CellIdentifier = @"checkboxcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
            cell.label1.text=assessmentformrowobject.title;

            UINib *cellNib;
            [cell.collectionview1 registerClass:[afMultipleChoiceCViewCell class] forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
            cellNib = [UINib nibWithNibName:@"afMultipleChoiceCViewCell" bundle:nil];
            [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
            [cell.collectionview1 reloadData];
            cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
            
            cell.gctextview1.hidden=YES;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"] || [assessmentformrowobject.questiontype isEqualToString:@"textremarks"]) {
            static NSString *CellIdentifier = @"checkboxtextcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
            cell.label1.text=assessmentformrowobject.title;

            UINib *cellNib;
            [cell.collectionview1 registerClass:[afTextMCCViewCell class] forCellWithReuseIdentifier:@"afTextMCCViewCell"];
            cellNib = [UINib nibWithNibName:@"afTextMCCViewCell" bundle:nil];
            [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afTextMCCViewCell"];
            [cell.collectionview1 reloadData];
            cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
            
            cell.button1.hidden=YES;
            cell.button2.hidden=YES;
            cell.button3.hidden=YES;
            cell.button4.hidden=YES;
            cell.button5.hidden=YES;
            cell.button6.hidden=YES;
            cell.button7.hidden=YES;
            cell.button8.hidden=YES;
            cell.button9.hidden=YES;

            cell.gctextview1.textContainer.lineFragmentPadding=0;
            cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
            if(index>=0){
                NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
                if(range.location!=NSNotFound){
                    cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
                }else{
                    cell.gctextview1.text=@"";
                    cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
                }
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
            cell.gctextview1.tag=100;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *CellIdentifier = @"assessmentcell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexPath.section]).questionarray objectAtIndex:indexPath.row];
            
            cell.label1.text=assessmentformrowobject.title;
            cell.layoutconstraint1.constant=[self returnAnswerViewithAnswerView:cell.view1 AssessmentFormRowObject:assessmentformrowobject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    }else if (tableView==assessmentformlisttable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *formlisttitlelabel;
        UILabel *listlastsubmittedtimelabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            formlisttitlelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 3, assessmentwidth-70, 25)];
            formlisttitlelabel.font=[UIFont systemFontOfSize:15];
            formlisttitlelabel.textColor=[UIColor darkGrayColor];
            formlisttitlelabel.tag=102;
            [cell.contentView addSubview:formlisttitlelabel];
            
            listlastsubmittedtimelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 27, assessmentwidth-70, 12)];
            listlastsubmittedtimelabel.font=[UIFont systemFontOfSize:11];
            listlastsubmittedtimelabel.textColor=[UIColor grayColor];
            listlastsubmittedtimelabel.tag=103;
            [cell.contentView addSubview:listlastsubmittedtimelabel];
            
        }else{
            formlisttitlelabel=(UILabel *)[cell.contentView viewWithTag:102];
            listlastsubmittedtimelabel=(UILabel *)[cell.contentView viewWithTag:103];
        }
        
        assessmentformlistobject=[assessmentformlistarray objectAtIndex:indexPath.row];
        if ([assessmentformlistobject.formkey isEqualToString:selectedformkey]) {
            cell.hidden=YES;
        }else{
            cell.hidden=NO;
            formlisttitlelabel.text=assessmentformlistobject.formname;
            if ([assessmentformlistobject.lastsubmittedtime isEqualToString:@""]) {
                listlastsubmittedtimelabel.text=[MyClass returntitlewithtitle:@"Not submitted"];
            }else{
                listlastsubmittedtimelabel.text=[NSString stringWithFormat:@"%@%@%@",[MyClass returnstaffnamewithusername:assessmentformlistobject.submitter firstorfullname:@"full"],[MyClass returntitlewithtitle:@" submitted on "],[MyClass returndateformatYYYYMMDDHHMMSSwithdate:assessmentformlistobject.lastsubmittedtime]];
            }
        }
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
    }else{
        //static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell;
        
        if (indexPath.section==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_0_cell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_0_cell"];
                
                extendedto_classdatetime = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
                extendedto_classdatetime.font=[UIFont systemFontOfSize:14];
                extendedto_classdatetime.textColor=[UIColor darkGrayColor];
                extendedto_classdatetime.tag=300;
                [cell.contentView addSubview:extendedto_classdatetime];
                
                extendedto_extendedminute = [[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 0, 100, 50)];
                extendedto_extendedminute.font=[UIFont systemFontOfSize:17];
                extendedto_extendedminute.textColor=[UIColor darkGrayColor];
                extendedto_extendedminute.textAlignment=NSTextAlignmentRight;
                extendedto_extendedminute.tag=301;
                [cell.contentView addSubview:extendedto_extendedminute];
                
                extendedto_schedulename = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, tablewidth-30-100-20, 19)];
                extendedto_schedulename.font=[UIFont systemFontOfSize:13];
                extendedto_schedulename.textColor=[UIColor darkGrayColor];
                extendedto_schedulename.minimumScaleFactor=0.7;
                extendedto_schedulename.adjustsFontSizeToFitWidth=YES;
                extendedto_schedulename.tag=302;
                [cell.contentView addSubview:extendedto_schedulename];
            }else{
                extendedto_classdatetime=(UILabel *)[cell.contentView viewWithTag:300];
                extendedto_extendedminute=(UILabel *)[cell.contentView viewWithTag:301];
                extendedto_schedulename=(UILabel *)[cell.contentView viewWithTag:302];
            }
            extendedclassobject=[extendedtoclassarray objectAtIndex:indexPath.row];
            extendedto_classdatetime.text=[NSString stringWithFormat:@"%@ %@",[MyClass returndateformatwithdate:extendedclassobject.classdate],extendedclassobject.classtime];
            extendedto_extendedminute.text=[NSString stringWithFormat:@"%d %@",extendedclassobject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
            extendedto_schedulename.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returnsubjectnamewithsubject_shortname:extendedclassobject.subject centerkey:globalvariables.centerrecord.centerkey],[MyClass returnschedulenamewithsubject_shortname:extendedclassobject.subject schedulekey:extendedclassobject.schedulekey centerkey:globalvariables.centerrecord.centerkey]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.section==1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_1_cell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_1_cell"];
                
                extendedfrom_classdatetime = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
                extendedfrom_classdatetime.font=[UIFont systemFontOfSize:14];
                extendedfrom_classdatetime.textColor=[UIColor darkGrayColor];
                extendedfrom_classdatetime.tag=100;
                [cell.contentView addSubview:extendedfrom_classdatetime];
                
                extendedfrom_extendedminute = [[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 0, 100, 50)];
                extendedfrom_extendedminute.font=[UIFont systemFontOfSize:17];
                extendedfrom_extendedminute.textColor=[UIColor darkGrayColor];
                extendedfrom_extendedminute.textAlignment=NSTextAlignmentRight;
                extendedfrom_extendedminute.tag=101;
                [cell.contentView addSubview:extendedfrom_extendedminute];
                
                extendedfrom_schedulename = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, tablewidth-30-100-20, 19)];
                extendedfrom_schedulename.font=[UIFont systemFontOfSize:13];
                extendedfrom_schedulename.textColor=[UIColor darkGrayColor];
                extendedfrom_schedulename.minimumScaleFactor=0.7;
                extendedfrom_schedulename.adjustsFontSizeToFitWidth=YES;
                extendedfrom_schedulename.tag=102;
                [cell.contentView addSubview:extendedfrom_schedulename];
            }else{
                extendedfrom_classdatetime=(UILabel *)[cell.contentView viewWithTag:100];
                extendedfrom_extendedminute=(UILabel *)[cell.contentView viewWithTag:101];
                extendedfrom_schedulename=(UILabel *)[cell.contentView viewWithTag:102];
            }
            extendedclassobject=[extendedfromclassarray objectAtIndex:indexPath.row];
            extendedfrom_classdatetime.text=[NSString stringWithFormat:@"%@ %@",[MyClass returndateformatwithdate:extendedclassobject.classdate],extendedclassobject.classtime];
            extendedfrom_extendedminute.text=[NSString stringWithFormat:@"%d %@",extendedclassobject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
            extendedfrom_schedulename.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returnsubjectnamewithsubject_shortname:extendedclassobject.subject centerkey:globalvariables.centerrecord.centerkey],[MyClass returnschedulenamewithsubject_shortname:extendedclassobject.subject schedulekey:extendedclassobject.schedulekey centerkey:globalvariables.centerrecord.centerkey]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_2_cell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_2_cell"];
                
                outstanding_fromclassdatetime = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
                outstanding_fromclassdatetime.font=[UIFont systemFontOfSize:14];
                outstanding_fromclassdatetime.textColor=[UIColor darkGrayColor];
                outstanding_fromclassdatetime.tag=200;
                [cell.contentView addSubview:outstanding_fromclassdatetime];
                
                outstanding_remainingtime = [[UILabel alloc]initWithFrame:CGRectMake(tablewidth-100-30, 0, 100, 50)];
                outstanding_remainingtime.font=[UIFont systemFontOfSize:17];
                outstanding_remainingtime.textColor=[UIColor darkGrayColor];
                outstanding_remainingtime.textAlignment=NSTextAlignmentRight;
                outstanding_remainingtime.tag=201;
                [cell.contentView addSubview:outstanding_remainingtime];
                
                outstanding_schedulename = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, tablewidth-30-100-20, 19)];
                outstanding_schedulename.font=[UIFont systemFontOfSize:13];
                outstanding_schedulename.textColor=[UIColor darkGrayColor];
                outstanding_schedulename.minimumScaleFactor=0.7;
                outstanding_schedulename.adjustsFontSizeToFitWidth=YES;
                outstanding_schedulename.tag=202;
                [cell.contentView addSubview:outstanding_schedulename];
            }else{
                outstanding_fromclassdatetime=(UILabel *)[cell.contentView viewWithTag:200];
                outstanding_remainingtime=(UILabel *)[cell.contentView viewWithTag:201];
                outstanding_schedulename=(UILabel *)[cell.contentView viewWithTag:202];
            }
            extendedclassobject=[outstandingextendedclassarray objectAtIndex:indexPath.row];
            outstanding_fromclassdatetime.text=[NSString stringWithFormat:@"%@ %@",[MyClass returndateformatwithdate:extendedclassobject.classdate],extendedclassobject.classtime];
            outstanding_remainingtime.text=[NSString stringWithFormat:@"%d %@",extendedclassobject.extensiontime-extendedclassobject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
            outstanding_schedulename.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returnsubjectnamewithsubject_shortname:extendedclassobject.subject centerkey:globalvariables.centerrecord.centerkey],[MyClass returnschedulenamewithsubject_shortname:extendedclassobject.subject schedulekey:extendedclassobject.schedulekey centerkey:globalvariables.centerrecord.centerkey]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    


}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == assessmentformlisttable){
        selectedformkey=((AssessmentFormListObject *)[assessmentformlistarray objectAtIndex:indexPath.row]).formkey;
        selectedForm=[assessmentformlistarray objectAtIndex:indexPath.row];
        [self getassessmentformresponsewithformkey:selectedformkey];
        [self updateformnameandlastsubmittedtime];
        [self changeformbuttonpressed:changeformbutton];
        [doneButton setTitle:[MyClass returntitlewithtitle:[selectedForm.lastsubmittedtime isEqualToString:@""]?@"Submit":@"Update"] forState:UIControlStateNormal];
        [self adjusttablesize];
    }
}

-(void) doneButtonPressed:(id)sender
{
    [self stopAudioPlaying];
    [self.view endEditing:YES];
    //update remarks to mysql
 
    if (!classremarkstable.hidden) {
        if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {

            UIAlertController *deleteassessmentresponse = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Parent Note"] message:[MyClass returntitlewithtitle:@"Are you sure to send the parent note to the selected student(s)?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [MyClass loadingindicatorwithoption:@"start" color:@"white"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self sendparentnote];
                    
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [deleteassessmentresponse dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [deleteassessmentresponse addAction:OKAction];
            [deleteassessmentresponse addAction:CancelAction];
            
            //[self presentViewController:deleteassessmentresponse animated:YES completion:nil];
            [MyClass presentViewController:deleteassessmentresponse View:self];
        }else{

            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL update=FALSE;
            
            //combine arrays
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:classScheduleObject.classkey forKey:@"classkey"];
            [dictionary setValue:globalvariables.username forKey:@"updatedby"];
            [dictionary setValue:@"icenter" forKey:@"platform"];
            [dictionary setValue:@"remarkswindow" forKey:@"function"];
            
            if (![classScheduleObject.remarks isEqualToString:tmpthisclassremarks]) {
                [dictionary setValue:tmpthisclassremarks forKey:@"remarks"];
                update=TRUE;
            }
            
            if (![nextClassClasskey isEqualToString:@""] && ![nextClassRemarks isEqualToString:tmpnextclassremarks]) {
                [dictionary setValue:tmpnextclassremarks forKey:@"nextclassremarks"];
                [dictionary setValue:nextClassClasskey forKey:@"nextclasskey"];
                update=TRUE;
            }
            
            if (![previousClassClasskey isEqualToString:@""] && ![previousClassRemarks isEqualToString:tmppreviousclassremarks]) {
                [dictionary setValue:tmppreviousclassremarks forKey:@"previousclassremarks"];
                [dictionary setValue:previousClassClasskey forKey:@"previousclasskey"];
                update=TRUE;
            }
            
            if (![classScheduleObject.allclassremarks isEqualToString:tmpallclassremarks]) {
                [dictionary setValue:tmpallclassremarks forKey:@"allclassremarks"];
                [dictionary setValue:classScheduleObject.studentkey forKey:@"studentkey"];
                [dictionary setValue:classScheduleObject.subject forKey:@"subject"];
                [dictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:classScheduleObject.startdate] forKey:@"startdate"];
                [dictionary setValue:classScheduleObject.classtime forKey:@"classtime"];
                update=TRUE;
            }
            
            if (![classScheduleObject.absentmakeupreason isEqualToString:tmpabsentmakeupreason]) {
                [dictionary setValue:tmpabsentmakeupreason forKey:@"absentmakeupreason"];
                update=TRUE;
            }
            
            tmpparentnote=[MyClass leadingtrailingspacestrimmed:tmpparentnote];
            if (![classScheduleObject.parentnote isEqualToString:tmpparentnote]) {
                [dictionary setValue:tmpparentnote forKey:@"parentnote"];
                [dictionary setValue:classScheduleObject.studentkey forKey:@"studentkey"];
                [dictionary setValue:globalvariables.username forKey:@"username"];
                update=TRUE;
            }
            
            BOOL sendaudioparentnote=FALSE;
            if (workingMessage.photoarray.count>0) {
                if (((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).internalurl) {
                    update=TRUE;
                    sendaudioparentnote=TRUE;
                }
            }
            
            if (update) {
                __block BOOL result=FALSE;
                [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                    if (succeeded) {
                        result=TRUE;
                    }
                }];
                
                if (sendaudioparentnote) {
                    [self sendaudioparentnotewithstudentkeys:@[@{@"classkey":classScheduleObject.classkey,@"studentkey":classScheduleObject.studentkey}]];
                }else{
                    if(result){
                        [self.delegate dismissclassremarkspopover];
                    }
                }
                

                
            }else{
                [self.delegate dismissclassremarkspopover];
            }
            });
        }
    }else if (!assessmentmasterview.hidden){
        
        
        [self.view endEditing:YES];
        
        
        UIAlertController *deleteassessmentresponse = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Evaluation Form"] message:[MyClass returntitlewithtitle:@"Are you sure to submit the data?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //update remarks to mysql
                
                [self saveassessmentresponse];
            });
            
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [deleteassessmentresponse dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [deleteassessmentresponse addAction:OKAction];
        [deleteassessmentresponse addAction:CancelAction];
        
        //[self presentViewController:deleteassessmentresponse animated:YES completion:nil];
        [MyClass presentViewController:deleteassessmentresponse View:self];
    }else if (!extensiontimetext.hidden){
        // override extension time
        if ([extensiontimetext.text isEqualToString:@""]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Please input extension time value"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            //[self presentViewController:erroralert animated:YES completion:nil];
            [MyClass presentViewController:erroralert View:self];
        }else if([extensiontimetext.text intValue]<[extendedtothisclassbalancelabel.text intValue]){
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Extension time value should not be less than the time used"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            //[self presentViewController:erroralert animated:YES completion:nil];
            [MyClass presentViewController:erroralert View:self];
        }else{
            
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            
            [dictionary setValue:globalvariables.username forKey:@"updatedby"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
            [dictionary setValue:classScheduleObject.classkey forKey:@"classkey"];
            [dictionary setValue:extensiontimetext.text forKey:@"extensiontime"];
            
            __block BOOL result=FALSE;
            [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result=TRUE;
                }
            }];
            /*
            NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
            
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            [postRequest setHTTPMethod:@"POST"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
            [postRequest setHTTPBody:finalData];
            
            __block BOOL result=FALSE;
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    result=TRUE;
                    
                }
                
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
            if(result){
                [self.delegate dismissclassremarkspopover];
            }/*else{
                [MyClass showconnectionlostdialogbox];
            }*/
        }
    }else{
        //extend class
        if ([timetoextendtext.text isEqualToString:@""] || [timetoextendtext.text intValue]==0) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Please input time to extend value"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            //[self presentViewController:erroralert animated:YES completion:nil];
            [MyClass presentViewController:erroralert View:self];
        }else if ([classScheduleObject.attendance isEqualToString:@"Makeup"] && [classScheduleObject.makeupattendance isEqualToString:@"Absent"]){
            //check if the makeup class attendance is absent
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Cannot extend for an absent makeup class"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            //[self presentViewController:erroralert animated:YES completion:nil];
            [MyClass presentViewController:erroralert View:self];
        }else{

            [self getextendclassinformation];
            [extendedclasstable reloadData];
            
            if ([timetoextendtext.text intValue]>outstandingextendedtime) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Input value is greater than the total outstanding extension time"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
            }else{
                [self extendclasstime];
                [self.delegate dismisssextendpopover];
            }
        }
        

    }
}

-(BOOL) extendclasstime
{
    NSMutableArray *extendclassarray=[[NSMutableArray alloc]init];
    int timetoextend=[timetoextendtext.text intValue];
    for (int i=0; i<outstandingextendedclassarray.count; i++) {
        long remainingminute=((ExtendedClassRecord *)[outstandingextendedclassarray objectAtIndex:i]).extensiontime-((ExtendedClassRecord *)[outstandingextendedclassarray objectAtIndex:i]).extendedminute;
        if (remainingminute >= timetoextend ) {
            [extendclassarray addObject:[NSString stringWithFormat:@"%i",timetoextend]];
            break;
        }else{
            [extendclassarray addObject:[NSString stringWithFormat:@"%li",remainingminute]];
            timetoextend-=remainingminute;
        }
    }
    
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *keys;
    NSArray *values;
    NSArray *jsonextendclassarray=[[NSArray alloc]init];
    NSDictionary *dict;

    
    arrayOfDicts = [[NSMutableArray alloc] init];
    keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"fromclasskey",@"toclasskey",@"extendedminute",nil];
    
    for (int i=0; i<extendclassarray.count; i++) {
        values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,((ExtendedClassRecord *)[outstandingextendedclassarray objectAtIndex:i]).fromclasskey,classScheduleObject.classkey,[extendclassarray objectAtIndex:i], nil];
        
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    jsonextendclassarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"postaction" : @"extendclasstime",
                                 @"extendclasstimearray" : jsonextendclassarray};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                result=TRUE;
            }
            
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if(result){
        [self getextendclassinformation];
        timetoextendtext.text=@"";
        [extendedclasstable reloadData];
        [self adjusttablesize];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(BOOL)retrievenextclassremarks
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }

    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectpreviousandnextclass&classkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classScheduleObject.classkey];

    __block BOOL resultstring;
    //__block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            nextClassClasskey=jsondictionary[@"nextclasskey"];
            nextClassRemarks=jsondictionary[@"nextclassremarks"];
            previousClassClasskey=jsondictionary[@"previousclasskey"];
            previousClassRemarks=jsondictionary[@"previousclassremarks"];
            NSDictionary *messagephotodict=jsondictionary[@"messagephotorecord"];
            if (![messagephotodict isEqual:[NSNull null]]) {
                if (messagephotodict.count>0) {
                    NSString *filetype=[messagephotodict objectForKey:@"filetype"];
                    float height=[[messagephotodict objectForKey:@"height"] floatValue];
                    float width=[[messagephotodict objectForKey:@"width"] floatValue];
                    NSString *filename=[messagephotodict objectForKey:@"filename"];
                    NSString *fileurl=[messagephotodict objectForKey:@"fileurl"];
                    NSString *messagestarttime=[messagephotodict objectForKey:@"messagestarttime"];
                    
                    workingMessage=[[OutboxMessageRecord alloc]init];
                    workingMessage.messagestarttime=messagestarttime;
                    workingMessage.photoarray=[[NSMutableArray alloc]initWithObjects:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:fileurl ImageView:nil Width:width Height:height FileType:filetype InternalURL:nil FileName:filename ThumbnailURL:nil], nil];
                }
            }
            resultstring= TRUE;
        }else{
            resultstring= FALSE;
        }
    }];
    
    return resultstring;
    
}

-(BOOL)getextendclassinformation
{
    NSString *classtype;
    if ([classScheduleObject.attendance isEqualToString:@"Makeup"]) {
        classtype=@"Makeup";
    }else{
        classtype=classScheduleObject.classtype;
    }
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getextendedclassinformation&studentkey=%@&subject=%@&classkey=%@&classtype=%@&category=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classScheduleObject.studentkey,[MyClass enurlstring:classScheduleObject.subject],classScheduleObject.classkey,classtype,((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:classScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_category];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonoutstandingextendedclassarray = jsondictionary[@"outstandingextendedclassrecords"];
            NSArray *jsonextendedfromclassarray = jsondictionary[@"extendedfromclassrecords"];
            NSArray *jsonextendedtoclassarray = jsondictionary[@"extendedtoclassrecords"];
            
            extendedfromtime=0;
            extendedtotime=0;
            outstandingextendedtime=0;
            outstandingextendedclassarray=[[NSMutableArray alloc]init];
            extendedfromclassarray=[[NSMutableArray alloc]init];
            extendedtoclassarray=[[NSMutableArray alloc]init];
            
            for (int i=0; i<jsonoutstandingextendedclassarray.count; i++) {
                NSString *centerkey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString *fromclasskey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"classkey"];
                NSString *classdate=[MyClass convertDateFormatWithDate:[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString *classtime=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"classtime"];
                int extensiontime=[[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"extensiontime"] intValue];
                int extendedminute=[[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
                NSString *schedulekey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString *subject=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"subject"];
                outstandingextendedtime+=(extensiontime-extendedminute);
                [outstandingextendedclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:@"" FromClasskey:fromclasskey ToClasskey:@"" Classdate:classdate Classtime:classtime Extensiontime:extensiontime Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
            }
            
            for (int i=0; i<jsonextendedfromclassarray.count; i++) {
                NSString *centerkey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString *extendkey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"extendkey"];
                NSString *fromclasskey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"fromclasskey"];
                NSString *toclasskey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"toclasskey"];
                NSString *classdate=[MyClass convertDateFormatWithDate:[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString *classtime=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"classtime"];
                int extendedminute=[[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
                NSString *schedulekey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString *subject=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"subject"];
                [extendedfromclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:extendkey FromClasskey:fromclasskey ToClasskey:toclasskey Classdate:classdate Classtime:classtime Extensiontime:-1 Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
                extendedfromtime+=extendedminute;
                
            }
            
            for (int i=0; i<jsonextendedtoclassarray.count; i++) {
                NSString *centerkey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString *extendkey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"extendkey"];
                NSString *fromclasskey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"fromclasskey"];
                NSString *toclasskey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"toclasskey"];
                NSString *classdate=[MyClass convertDateFormatWithDate:[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString *classtime=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"classtime"];
                int extendedminute=[[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
                NSString *schedulekey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString *subject=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"subject"];
                [extendedtoclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:extendkey FromClasskey:fromclasskey ToClasskey:toclasskey Classdate:classdate Classtime:classtime Extensiontime:-1 Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
                extendedtotime+=extendedminute;
                
            }
        }
    }];
    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        // handle response
//        
//        if (!error) {
//            result=TRUE;
//        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
//        NSDictionary *jsondictionary = jsonreturned[@"content"];
//        NSArray *jsonoutstandingextendedclassarray = jsondictionary[@"outstandingextendedclassrecords"];
//        NSArray *jsonextendedfromclassarray = jsondictionary[@"extendedfromclassrecords"];
//        NSArray *jsonextendedtoclassarray = jsondictionary[@"extendedtoclassrecords"];
//        
//        extendedfromtime=0;
//        extendedtotime=0;
//        outstandingextendedtime=0;
//        outstandingextendedclassarray=[[NSMutableArray alloc]init];
//        extendedfromclassarray=[[NSMutableArray alloc]init];
//        extendedtoclassarray=[[NSMutableArray alloc]init];
//        
//        
//        
//        for (int i=0; i<jsonoutstandingextendedclassarray.count; i++) {
//            NSString *centerkey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"centerkey"];
//            NSString *fromclasskey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"classkey"];
//            NSString *classdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"startdate"]];
//            NSString *classtime=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"classtime"];
//            int extensiontime=[[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"extensiontime"] intValue];
//            int extendedminute=[[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
//            NSString *schedulekey=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
//            NSString *subject=[[jsonoutstandingextendedclassarray objectAtIndex:i] objectForKey:@"subject"];
//            outstandingextendedtime+=(extensiontime-extendedminute);
//            [outstandingextendedclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:@"" FromClasskey:fromclasskey ToClasskey:@"" Classdate:classdate Classtime:classtime Extensiontime:extensiontime Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
//        }
//        
//        for (int i=0; i<jsonextendedfromclassarray.count; i++) {
//            NSString *centerkey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"centerkey"];
//            NSString *extendkey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"extendkey"];
//            NSString *fromclasskey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"fromclasskey"];
//            NSString *toclasskey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"toclasskey"];
//            NSString *classdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"startdate"]];
//            NSString *classtime=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"classtime"];
//            int extendedminute=[[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
//            NSString *schedulekey=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
//            NSString *subject=[[jsonextendedfromclassarray objectAtIndex:i] objectForKey:@"subject"];
//            [extendedfromclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:extendkey FromClasskey:fromclasskey ToClasskey:toclasskey Classdate:classdate Classtime:classtime Extensiontime:-1 Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
//            extendedfromtime+=extendedminute;
//            
//        }
//
//        for (int i=0; i<jsonextendedtoclassarray.count; i++) {
//            NSString *centerkey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"centerkey"];
//            NSString *extendkey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"extendkey"];
//            NSString *fromclasskey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"fromclasskey"];
//            NSString *toclasskey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"toclasskey"];
//            NSString *classdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"startdate"]];
//            NSString *classtime=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"classtime"];
//            int extendedminute=[[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"extendedminute"] intValue];
//            NSString *schedulekey=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"schedulekey"];
//            NSString *subject=[[jsonextendedtoclassarray objectAtIndex:i] objectForKey:@"subject"];
//            [extendedtoclassarray addObject:[[ExtendedClassRecord alloc]initExtendedClassRecordwithCenterkey:centerkey Extendkey:extendkey FromClasskey:fromclasskey ToClasskey:toclasskey Classdate:classdate Classtime:classtime Extensiontime:-1 Extendedminute:extendedminute Schedulekey:schedulekey Subject:subject]];
//            extendedtotime+=extendedminute;
//            
//        }
//    }
//                
//    dispatch_semaphore_signal(semaphore);
//    }] resume];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (result) {
        extendedtimelabel.text=[NSString stringWithFormat:@"%d %@",extendedfromtime,[MyClass returntitlewithtitle:@"mins"]];
        outstandingbalancelabel.text=[NSString stringWithFormat:@"%d %@",outstandingextendedtime,[MyClass returntitlewithtitle:@"mins"]];
    }
    
    return result;
    
}

-(BOOL) getassessmentformresponsewithformkey:(NSString *)form_key
{
    AssessmentFormListObject *obj=[self returnFormListObjectWithFormKey:form_key];
    BOOL submitted=![obj.lastsubmittedtime isEqualToString:@""];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getassessmentformresponse&classkey=%@&formkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classScheduleObject.classkey,form_key];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            
            assessmentformarray=[[NSMutableArray alloc]init];

            for (int i=0; i<jsonArray.count; i++) {
                NSString *sectiontitle=[[jsonArray objectAtIndex:i] objectForKey:@"sectiontitle"];
                NSArray *questionarray=[[jsonArray objectAtIndex:i] objectForKey:@"questionarray"];
                
                NSMutableArray *cquestionarray=[[NSMutableArray alloc]init];
                for (int j=0; j<questionarray.count; j++) {
                    NSString *formitemkey=[[questionarray objectAtIndex:j] objectForKey:@"formitemkey"];
                    NSString *rowtitle=[[questionarray objectAtIndex:j] objectForKey:@"rowtitle"];
                    NSString *questiontype=[[questionarray objectAtIndex:j] objectForKey:@"questiontype"];
                    NSArray *valuearray=[[questionarray objectAtIndex:j] objectForKey:@"valuearray"];
                    NSArray *responsearray=[[questionarray objectAtIndex:j] objectForKey:@"response"];
                    
                    NSMutableArray *cvaluearray=[[NSMutableArray alloc]init];
                    for (int k=0; k<valuearray.count; k++) {
                        [cvaluearray addObject:[valuearray objectAtIndex:k]];
                    }
                    
                    NSMutableArray *cresponsearray=[[NSMutableArray alloc]init];
                    for (int k=0; k<responsearray.count; k++) {
                        [cresponsearray addObject:[responsearray objectAtIndex:k]];
                    }
                    
                    
                    [cquestionarray addObject:[[AssessmentFormRowObject alloc]initAssessmentFormRowObjectwithFormItemKey:formitemkey Title:rowtitle QuestionType:questiontype ValueArray:cvaluearray ResponseArray:cresponsearray]];
                }
                
                [assessmentformarray addObject:[[AssessmentFormSectionObject alloc]initAssessmentFormSectionObjectwithTitle:sectiontitle QuestionArray:cquestionarray]];

            }
        }
    }];
    
    if(result){
        [self recoverAutoSavedAssessmentResponse];
        if(!submitted){
            [self addDefaultRemarksWithAssessmentForm];
        }
        [assessmenttable reloadData];
        float tableframeheight;
        if (assessmenttable.contentSize.height+88+44>maxPopupHeight){
            tableframeheight=maxPopupHeight-88-44;
        }else{
            tableframeheight=assessmenttable.contentSize.height;
        }
        assessmenttable.frame=CGRectMake(0, 44, assessmentwidth, tableframeheight);
        if (assessmentformarray.count>0) {
            [assessmenttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    return result;
}

-(void) addDefaultRemarksWithAssessmentForm
{
    for(int i=0;i<assessmentformarray.count;i++){
        AssessmentFormSectionObject *sectionObject=[assessmentformarray objectAtIndex:i];
        NSMutableArray *questionArray=sectionObject.questionarray;
        for(int j=0;j<questionArray.count;j++){
            AssessmentFormRowObject *rowObject=[questionArray objectAtIndex:j];
            if([rowObject.questiontype isEqualToString:@"textmultiplechoiceremarks"]||[rowObject.questiontype isEqualToString:@"textremarks"]){
                NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:rowObject Value:@"RMK" disabled:NO];
                if(index<0){
                    NSRange percentagerange=[rowObject.valuearray[rowObject.valuearray.count-1] rangeOfString:@"%%"];
                    NSString *defaultremarks=[rowObject.valuearray[rowObject.valuearray.count-1] substringFromIndex:percentagerange.location+2];
                    [rowObject.responsearray addObject:[NSString stringWithFormat:@"RMK|%@",defaultremarks]];
                }
            }
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==extendedclasstable) {
        if (indexPath.section==0 || indexPath.section==1) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *deleteitem = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the extended time?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteextendclassrecord&extendkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,indexPath.section==0?((ExtendedClassRecord *)[extendedtoclassarray objectAtIndex:indexPath.row]).extendkey:((ExtendedClassRecord *)[extendedfromclassarray objectAtIndex:indexPath.row]).extendkey];
        
        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];
        
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // handle response
            
            if (!error) {
                result=TRUE;
            }
        
                
            dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if(result){
            [self.delegate dismissclassremarkspopover];
        }
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deleteitem dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteitem addAction:OKAction];
    [deleteitem addAction:CancelAction];
    
    //[self presentViewController:deleteitem animated:YES completion:nil];
    [MyClass presentViewController:deleteitem View:self];
}


-(void) adjusttablesize
{
    float tableheight;

    
    tableheight=maxPopupHeight-keyboardheight;
    if (!classremarkstable.hidden) {

        
//        if (self.preferredContentSize.width!=tablewidth) {
            [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
//        }
        remarkstablebottomconstraint.constant=keyboardheight;
        buttonStackWidthConstraints.constant=tablewidth;
        
    }else if (!extendmasterview.hidden){
        [extendedclasstable setFrame:CGRectMake(0, 120+20, tablewidth, tableheight-44-44-120-20)];
//        if (self.preferredContentSize.width!=tablewidth) {
            [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
//        }
        
        self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
        RemarksToolBar.frame=CGRectMake(0, 20, tablewidth, 44);
        buttonStackWidthConstraints.constant=tablewidth;
    }else{
//        [assessmenttable setFrame:CGRectMake(0, 44, assessmentwidth, tableheight-44-tableoffset-44)];
        //if (self.preferredContentSize.width!=assessmentwidth) {
            [self.delegate adjustpresentingviewwidthwithwidth:assessmentwidth];
        //}
        
//        self.preferredContentSize=CGSizeMake(assessmentwidth, tableheight);
        assessmenttablebottomconstraint.constant=keyboardheight;
        RemarksToolBar.frame=CGRectMake(0, 20, assessmentwidth, 44);
        buttonStackWidthConstraints.constant=assessmentwidth;
    }
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==extendedclasstable) {
        if (section==0) {
            if (extendedtoclassarray.count==0) {
                return CGFLOAT_MIN;
            }
        }else if (section==1) {
            if (extendedfromclassarray.count==0) {
                return CGFLOAT_MIN;
            }
        }else if (section==2){
            if (outstandingextendedclassarray.count==0) {
                return CGFLOAT_MIN;
            }
        }
    }else if (tableView==classremarkstable){
        if ([presentingview isEqualToString:@"dailyclassscheduleparentnote"]) {
            if (section!=5) {
                return CGFLOAT_MIN;
            }
        }else{
            if (section==4) {
                if ([classScheduleObject.classtype isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Makeup"] || [classScheduleObject.attendance isEqualToString:@"Absent"] || [classScheduleObject.attendance isEqualToString:@"Extend"]) {
                    return 44;
                }else{
                    return CGFLOAT_MIN;
                }
            }
        }
    }else if (tableView==assessmentformlisttable){
        return CGFLOAT_MIN;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView==assessmentformlisttable){
        return CGFLOAT_MIN;
    }else{
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }else{
            return CGFLOAT_MIN;
        }
    }
}

-(void) validateinput
{
    if ([timetoextendtext.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        timetoextendtext.text=@"";
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Please input a valid extend value"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        //[self presentViewController:erroralert animated:YES completion:nil];
        [MyClass presentViewController:erroralert View:self];
    }
}

-(void) validateextensiontimeinput
{
    if ([extensiontimetext.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        extensiontimetext.text=@"";
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Extend Class"] message:[MyClass returntitlewithtitle:@"Please input a valid value"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        //[self presentViewController:erroralert animated:YES completion:nil];
        [MyClass presentViewController:erroralert View:self];
    }
}

-(CGFloat) returnAnswerViewithAnswerView:(UIView *)answerview AssessmentFormRowObject:(AssessmentFormRowObject *)rowobject
{
    UILabel *answserlabel;
    
    [answerview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if ([rowobject.questiontype isEqualToString:@"multiplechoice"]) {
        UIButton *answerbutton;
        UIImageView *buttonimage;
        for (int i=0; i<rowobject.valuearray.count; i++) {
            answserlabel=[[UILabel alloc]initWithFrame:CGRectMake(47, i*32, assessmentwidth-45-10, 32)];
            answserlabel.font=[UIFont systemFontOfSize:15];
            answserlabel.text=[rowobject.valuearray objectAtIndex:i];
            [answerview addSubview:answserlabel];
            
            answerbutton=[[UIButton alloc]initWithFrame:CGRectMake(20, i*32, assessmentwidth-40, 32)];
            [answerbutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            answerbutton.tag=i;
            [answerview addSubview:answerbutton];
            
            buttonimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, i*32+7, 18, 18)];
            if ([rowobject.responsearray containsObject:[rowobject.valuearray objectAtIndex:i]]) {
                [buttonimage setImage:[UIImage imageNamed:@"multiplechoicebutton_selected.png"]];
            }else{
                [buttonimage setImage:[UIImage imageNamed:@"multiplechoicebutton_unselect.png"]];
            }
            [answerview addSubview:buttonimage];
        }
        
        return rowobject.valuearray.count*30;
        //answerview.frame=CGRectMake(answerview.frame.origin.x, answerview.frame.origin.y, answerview.frame.size.width, rowobject.valuearray.count*30);
    }else if ([rowobject.questiontype isEqualToString:@"checkbox"]) {
        UIButton *answerbutton;
        UIImageView *buttonimage;
        for (int i=0; i<rowobject.valuearray.count; i++) {
            answserlabel=[[UILabel alloc]initWithFrame:CGRectMake(47, i*32, assessmentwidth-45-10, 32)];
            answserlabel.font=[UIFont systemFontOfSize:15];
            answserlabel.text=[rowobject.valuearray objectAtIndex:i];
            [answerview addSubview:answserlabel];
            
            answerbutton=[[UIButton alloc]initWithFrame:CGRectMake(20, i*32, assessmentwidth-40, 32)];
            [answerbutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            answerbutton.tag=i;
            [answerview addSubview:answerbutton];
            
            buttonimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, i*32+7, 18, 18)];
            if ([rowobject.responsearray containsObject:[rowobject.valuearray objectAtIndex:i]]) {
                [buttonimage setImage:[UIImage imageNamed:@"checkboxbutton_selected.png"]];
            }else{
                [buttonimage setImage:[UIImage imageNamed:@"checkboxbutton_unselect.png"]];
            }
            [answerview addSubview:buttonimage];
        }
        
        return rowobject.valuearray.count*30;
        //answerview.frame=CGRectMake(answerview.frame.origin.x, answerview.frame.origin.y, answerview.frame.size.width, rowobject.valuearray.count*30);
    }else if ([rowobject.questiontype isEqualToString:@"shortanswer"]){
        UITextField *answertext=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, assessmentwidth-40, 32)];
        answertext.placeholder=[MyClass returntitlewithtitle:@"Your input"];
        answertext.font=[UIFont systemFontOfSize:15];
        answertext.text=[rowobject.responsearray firstObject];
        [answertext addTarget:self action:@selector(updateshortanswer:) forControlEvents:UIControlEventEditingChanged];
        [answerview addSubview:answertext];
        return 32;
        //answerview.frame=CGRectMake(answerview.frame.origin.x, answerview.frame.origin.y, answerview.frame.size.width, 32);
    }else if ([rowobject.questiontype isEqualToString:@"paragraph"]){
        answertextview=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(15, 0, assessmentwidth-30, 60)];
        answertextview.placeholder=[MyClass returntitlewithtitle:@"Your input"];
        answertextview.font=[UIFont systemFontOfSize:15];
        answertextview.text=[rowobject.responsearray firstObject];
        answertextview.delegate=self;
        [answerview addSubview:answertextview];
        return 64;
        //answerview.frame=CGRectMake(answerview.frame.origin.x, answerview.frame.origin.y, answerview.frame.size.width, 64);
    }
    return 0;
}

-(CGFloat) returnAnswerViewHeightWithAssessmentFormRowObject:(AssessmentFormRowObject *)rowobject
{
    CGFloat height=50;
    if ([rowobject.questiontype isEqualToString:@"multiplechoice"]) {
        height= rowobject.valuearray.count*32;
    }else if ([rowobject.questiontype isEqualToString:@"checkbox"]) {
        height= rowobject.valuearray.count*32;
    }else if ([rowobject.questiontype isEqualToString:@"shortanswer"]) {
        height= 32;
    }else if ([rowobject.questiontype isEqualToString:@"paragraph"]) {
        height= 64;
    }
    return height+30+5;
}

-(void) multiplechoicebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
    MyTableViewCell *cell = [assessmenttable cellForRowAtIndexPath:indexpath];
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
    
    if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice"]) {
        [assessmentformrowobject.responsearray removeAllObjects];
        [assessmentformrowobject.responsearray addObject:[assessmentformrowobject.valuearray objectAtIndex:sender.tag]];
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2"] || [assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2nr"]) {
        [assessmentformrowobject.responsearray removeAllObjects];
        [assessmentformrowobject.responsearray addObject:[assessmentformrowobject.valuearray objectAtIndex:sender.tag]];
        [cell.collectionview1 reloadData];
        [assessmenttable reloadData];
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"checkbox"]) {
        if ([assessmentformrowobject.responsearray containsObject:[assessmentformrowobject.valuearray objectAtIndex:sender.tag]]) {
            [assessmentformrowobject.responsearray removeObject:[assessmentformrowobject.valuearray objectAtIndex:sender.tag]];
        }else{
            [assessmentformrowobject.responsearray addObject:[assessmentformrowobject.valuearray objectAtIndex:sender.tag]];
        }
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtext"] || [assessmentformrowobject.questiontype isEqualToString:@"checkbox2"]|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"]) {
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:sender.tag] disabled:NO];
        if (index>=0) {
            [assessmentformrowobject.responsearray removeObjectAtIndex:index];
        }else{
            NSRange andrange=[assessmentformrowobject.valuearray[sender.tag] rangeOfString:@"&&"];
            if (andrange.location!=NSNotFound) {
                [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"%@&&|",[[assessmentformrowobject.valuearray objectAtIndex:sender.tag] substringToIndex:andrange.location]]];
            }else{
                [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"%@|",[assessmentformrowobject.valuearray objectAtIndex:sender.tag]]];
            }
        }
        [cell.collectionview1 reloadData];
        [assessmenttable reloadData];
        [self autosaveassessmentresponse];
        return;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"]) {
        //remove all choice except remarks and score
        for(int i=0;i<assessmentformrowobject.responsearray.count;i++){
            NSRange remarksrange=[assessmentformrowobject.responsearray[i] rangeOfString:@"RMK|"];
            NSRange scorerange=[assessmentformrowobject.responsearray[i] rangeOfString:@"TXT|"];
            if(remarksrange.location==NSNotFound && scorerange.location==NSNotFound){
                [assessmentformrowobject.responsearray removeObjectAtIndex:i];
                i-=1;
            }
        }
        

        NSRange andrange=[assessmentformrowobject.valuearray[sender.tag] rangeOfString:@"&&"];
        NSRange percentagerange=[assessmentformrowobject.valuearray[sender.tag] rangeOfString:@"%%"];
        if (andrange.location!=NSNotFound) {
            [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"&&%@",[[assessmentformrowobject.valuearray objectAtIndex:sender.tag] substringFromIndex:andrange.location+2]]];
        }else if (percentagerange.location!=NSNotFound) {
            [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"%@%@",[[assessmentformrowobject.valuearray objectAtIndex:sender.tag] substringToIndex:percentagerange.location],@"%%"]];
        }else{
            [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"%@",[assessmentformrowobject.valuearray objectAtIndex:sender.tag]]];
        }
//        }


        [cell.collectionview1 reloadData];
        [assessmenttable reloadData];
        [self autosaveassessmentresponse];
        return;
    }
    
    [self autosaveassessmentresponse];
    
    [self returnAnswerViewithAnswerView:cell.view1 AssessmentFormRowObject:assessmentformrowobject];
}

-(BOOL) textmultiplechoiceremarkscontainsValue:(NSString *)value responsearray:(NSMutableArray *)responsearray
{
    for(int i=0;i<responsearray.count;i++){
        NSRange andrange=[value rangeOfString:@"&&"];
        NSRange percentagerange=[value rangeOfString:@"%%"];
        if(andrange.location!=NSNotFound){
            NSRange andrange2=[responsearray[i] rangeOfString:@"&&"];
            if(andrange2.location!=NSNotFound){
                return TRUE;
            }
        }else if(percentagerange.location!=NSNotFound){
            NSRange andrange2=[responsearray[i] rangeOfString:@"%%"];
            if(andrange2.location!=NSNotFound){
                return TRUE;
            }
        }else{
            if([value isEqualToString:responsearray[i]]){
                return TRUE;
            }
        }
        
    }
    return FALSE;
}

-(NSString *) returnMarkWithResponseArray:(NSMutableArray *)array Value:(NSString *)value
{
    NSRange andrange=[value rangeOfString:@"&&"];
    if (andrange.location!=NSNotFound) {
        value=[value substringToIndex:andrange.location];
    }
    
    for (int i=0; i<array.count; i++) {
        NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"%@%@",value,andrange.location!=NSNotFound?@"&&":@"|"]];
        if(range.location!=NSNotFound){
            NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"|"]];
            if(range.location!=NSNotFound){
                NSString *mark=[array[i] substringFromIndex:range.location+range.length];
                return [mark isEqualToString:@""]?[MyClass returntitlewithtitle:@"Score"]:mark;
            }
        }
    }
    
    return [MyClass returntitlewithtitle:@"Score"];
}


-(NSString *) returnshortanswer2text:(NSString *)value
{
    if ([value isEqualToString:@""]) {
        return @"";
    }else{
        NSRange scorerange=[value rangeOfString:@"|"];
        return [value substringToIndex:scorerange.location];
    }
}

-(NSString *) returnValueFromValue:(NSString *)value questiontype:(NSString *)questiontype
{
    NSRange andrange=[value rangeOfString:@"&&"];
    NSRange percentagerange=[value rangeOfString:@"%%"];
    if (andrange.location!=NSNotFound) {
        if([questiontype isEqualToString:@"textmultiplechoiceremarks"]){
            value=[value substringFromIndex:andrange.location+2];
        }else{
            value=[value substringToIndex:andrange.location];
        }
    }else if (percentagerange.location!=NSNotFound){
        value=[value substringToIndex:percentagerange.location];
    }
    return value;
}

-(NSInteger) returnResponseArrayindexWithAssessmentFormRowObject:(AssessmentFormRowObject *)object Value:(NSString *)value disabled:(BOOL)disabled
{
    NSString *newvalue =[self returnValueFromValue:value questiontype:object.questiontype];
    
    if(disabled){
        for (int i=0; i<object.responsearray.count; i++) {
            NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"<>%@",newvalue]];
            if(range.location!=NSNotFound){
                return i;
            }
        }
    }else{
        for (int i=0; i<object.responsearray.count; i++) {
            if([object.questiontype isEqualToString:@"textmultiplechoiceremarks"]){
                NSRange andrange=[value rangeOfString:@"&&"];
                NSRange percentagerange=[value rangeOfString:@"%%"];
                if([value isEqualToString:@"RMK"]){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"RMK|"]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if([value isEqualToString:@"TXT"]){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"TXT|"]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if([value isEqualToString:newvalue]){
                    if([object.responsearray[i] isEqualToString:newvalue]){
                        return i;
                    }
                }else if (andrange.location!=NSNotFound){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"&&%@",newvalue]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if (percentagerange.location!=NSNotFound){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@%%",newvalue]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }
            }else{
                NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@%@",newvalue,![value isEqualToString:newvalue]?@"&&":@"|"]];
                NSRange scorerange=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@",@"|"]];
                if(range.location!=NSNotFound && range.location==0 && scorerange.location!=NSNotFound){
                    return i;
                }
            }
            
        }
    }
    
    return -1;
}

-(void) multiplechoicetitlebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
    MyTableViewCell *cell = [assessmenttable cellForRowAtIndexPath:indexpath];
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
    
    if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtext"] || [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"]){
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:sender.tag] disabled:YES];
        if(index>=0){
            [assessmentformrowobject.responsearray removeObjectAtIndex:index];
        }else{
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:sender.tag] disabled:NO];
            if (index>=0) {
                [assessmentformrowobject.responsearray removeObjectAtIndex:index];
            }
            
            [assessmentformrowobject.responsearray addObject:[NSString stringWithFormat:@"<>%@",[self returnValueFromValue:[assessmentformrowobject.valuearray objectAtIndex:sender.tag] questiontype:assessmentformrowobject.questiontype]]];
        }
        
//        NSRange range = NSMakeRange(indexpath.section,1);
//        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
        [cell.collectionview1 reloadData];
        [assessmenttable reloadData];
        [self autosaveassessmentresponse];
    }
    
}

-(void) updatecheckboxtextexample:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
    NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:sender.tag] disabled:NO];
    //名詞+動詞+物件&&sample2|3
    NSString *oldvalue=assessmentformrowobject.responsearray[index];
    NSRange andrange=[oldvalue rangeOfString:@"&&"];
    NSRange scorerange=[oldvalue rangeOfString:@"|"];
    NSString *newvalue=[NSString stringWithFormat:@"%@&&%@|%@",[oldvalue substringToIndex:andrange.location],sender.text,[oldvalue substringFromIndex:scorerange.location+1]];
    [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:newvalue];
}

-(void) updatemultiplechoicetext:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:assessmenttable];
    NSIndexPath *indexpath =[assessmenttable indexPathForRowAtPoint:point];
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexpath.section]).questionarray objectAtIndex:indexpath.row];
    NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"TXT" disabled:NO];
    NSString *newvalue=[NSString stringWithFormat:@"TXT|%@",sender.text];
    if(index>0){
        [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:newvalue];
    }else{
        [assessmentformrowobject.responsearray addObject:newvalue];
    }
    
}

-(void) autosaveassessmentresponse
{
//    char *err;
    NSString *sql;
    char *csql;
    NSString *assessmentresponse;
    sqlite3_stmt *stmt;
    
    sql=[NSString stringWithFormat:@"delete from assessmentresponse where classkey=%@ and formkey=%@",classScheduleObject.classkey,selectedformkey];
    sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,NULL);
    
    csql="INSERT INTO assessmentresponse ('classkey','formkey','response','section','row') VALUES (?,?,?,?,?)";
    if (sqlite3_prepare_v2(globalvariables.isdb, csql, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_exec(globalvariables.isdb, "BEGIN TRANSACTION", NULL, NULL, NULL);
        for (int i=0; i<assessmentformarray.count; i++) {
            assessmentformsectionobject=[assessmentformarray objectAtIndex:i];
            for (int j=0; j<assessmentformsectionobject.questionarray.count; j++) {
                assessmentformrowobject=[assessmentformsectionobject.questionarray objectAtIndex:j];
                
                if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer"] || [assessmentformrowobject.questiontype isEqualToString:@"paragraph"]) {
                    assessmentresponse=[assessmentformrowobject.responsearray firstObject];
                }else{
                    assessmentresponse=(assessmentformrowobject.responsearray.count>0)?[assessmentformrowobject.responsearray componentsJoinedByString:@"##"]:@"";
                }
                
                sqlite3_bind_text(stmt, 1, [classScheduleObject.classkey UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 2, [selectedformkey UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 3, [assessmentresponse UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%d",i] UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%d",j] UTF8String], -1, NULL);
                
                sqlite3_step(stmt);
                sqlite3_clear_bindings(stmt);
                sqlite3_reset(stmt);
            }
        }
        
        sqlite3_exec(globalvariables.isdb, "END TRANSACTION", NULL, NULL, NULL);
        sqlite3_finalize(stmt);
    }
    
    NSLog(@"autosaveresponse");
    
}

-(AssessmentFormListObject *) returnFormListObjectWithFormKey:(NSString *)formkey
{
    for(int i=0;i<assessmentformlistarray.count;i++){
        AssessmentFormListObject *obj=[assessmentformlistarray objectAtIndex:i];
        if([obj.formkey isEqualToString:formkey]){
            return obj;
        }
    }
    return [[AssessmentFormListObject alloc]init];
}

-(void) recoverAutoSavedAssessmentResponse
{
    NSString *sql;
    sqlite3_stmt *statement;
    
    for(int i=0;i<assessmentformlistarray.count;i++){
        AssessmentFormListObject *obj=[assessmentformlistarray objectAtIndex:i];
        if([obj.formkey isEqualToString:selectedformkey]){
            if(![obj.lastsubmittedtime isEqualToString:@""]){
                sql=[NSString stringWithFormat:@"delete from assessmentresponse where classkey=%@ and formkey=%@",classScheduleObject.classkey,selectedformkey];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,NULL);
                return;
            }
        }
    }
    
    sql =[NSString stringWithFormat:@"SELECT response,section,row FROM assessmentresponse where classkey='%@' and formkey='%@' order by section,row",classScheduleObject.classkey,selectedformkey];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *response=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
            NSInteger section=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)] integerValue];
            NSInteger row=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)] integerValue];
            
            AssessmentFormSectionObject *sectionobject=[assessmentformarray objectAtIndex:section];
            AssessmentFormRowObject *rowobject=[sectionobject.questionarray objectAtIndex:row];
            rowobject.responsearray=[[NSMutableArray alloc]initWithArray:[response componentsSeparatedByString:@"##"]];
        }
    }
}

-(void) saveassessmentresponse
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSString *sql;
//    sqlite3_stmt *stmt;
    
    NSString *assessmentresponse;
    
    //combine arrays
    
    [dictionary setValue:@"updateassessmentresponse" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:classScheduleObject.classkey forKey:@"classkey"];
    [dictionary setValue:selectedformkey forKey:@"formkey"];
    [dictionary setValue:globalvariables.username forKey:@"submitter"];
    
    keys=[NSArray arrayWithObjects:@"formitemkey",@"response",nil];
    
    for (int i=0; i<assessmentformarray.count; i++) {
        assessmentformsectionobject=[assessmentformarray objectAtIndex:i];
        for (int j=0; j<assessmentformsectionobject.questionarray.count; j++) {
            assessmentformrowobject=[assessmentformsectionobject.questionarray objectAtIndex:j];
            
            if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer"] || [assessmentformrowobject.questiontype isEqualToString:@"paragraph"]) {
                assessmentresponse=[assessmentformrowobject.responsearray firstObject];
            }else{
                assessmentresponse=(assessmentformrowobject.responsearray.count>0)?[assessmentformrowobject.responsearray componentsJoinedByString:@"##"]:@"";
            }
            
            values=[NSArray arrayWithObjects:assessmentformrowobject.formitemkey,assessmentresponse, nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
    }
    
    [dictionary setValue:arrayOfDicts forKey:@"responsearray"];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        sql=[NSString stringWithFormat:@"delete from assessmentresponse where classkey=%@ and formkey=%@",classScheduleObject.classkey,selectedformkey];
        sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,NULL);
        [self.delegate dismissclassremarkspopover];
        
    }
}

-(void) deleteButtonPressed:(UIButton *)sender
{
    
    
    [self.view endEditing:YES];
    
    
    UIAlertController *deleteassessmentresponse = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Evaluation Form"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the data?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [MyClass loadingindicatorwithoption:@"start" color:@"white"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self deleteassessmentresponse];
            
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deleteassessmentresponse dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteassessmentresponse addAction:OKAction];
    [deleteassessmentresponse addAction:CancelAction];
    
    //[self presentViewController:deleteassessmentresponse animated:YES completion:nil];
    [MyClass presentViewController:deleteassessmentresponse View:self];
}

-(void) shareButtonPressed:(UIButton *)sender
{
//    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 120) View:self BarButtonItem:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send Message",@"Send Email",@"More", nil] Title:nil];
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 120) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send Message",@"Send Email",@"More", nil] Title:nil MultipleSelection:NO];
}

-(void) deleteassessmentresponse
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteassessmentresponse&classkey=%@&formkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classScheduleObject.classkey,selectedformkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        if(result){
            [self.delegate dismissclassremarkspopover];
        }
    }];
        

}

-(void) getassessmentformlist
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getassessmentformlist&classkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classScheduleObject.classkey];
    
    __block NSString *tmpseelectedformkey=@"";
    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            assessmentformlistarray=[[NSMutableArray alloc]init];

            for (int i=0; i<jsonArray.count; i++) {
                NSString *cformkey=[[jsonArray objectAtIndex:i] objectForKey:@"formkey"];
                NSString *cformname=[[jsonArray objectAtIndex:i] objectForKey:@"formname"];
                NSString *clastsubmittedtime=[[jsonArray objectAtIndex:i] objectForKey:@"lastsubmittedtime"];
                NSString *csubmitter=[[jsonArray objectAtIndex:i] objectForKey:@"submitter"];
                NSString *cformtype=[[jsonArray objectAtIndex:i] objectForKey:@"formtype"];
                NSString *cremarks=[[jsonArray objectAtIndex:i] objectForKey:@"remarks"];
                
                if ([tmpseelectedformkey isEqualToString:@""]) {
                    if ([csubmitter isEqualToString:globalvariables.username] || [clastsubmittedtime isEqualToString:@""] || ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).overrideassessmentresponse) {
                        tmpseelectedformkey=cformkey;
                    }
                }

                [assessmentformlistarray addObject:[[AssessmentFormListObject alloc]initAssessmentFormListObjectwithFormKey:cformkey FormName:cformname LastSubmittedTime:clastsubmittedtime Submitter:csubmitter formType:cformtype subjectarray:nil active:NO gradearray:nil remarks:cremarks]];
            }
            
            if(assessmentformlistarray.count>0){
                selectedForm=[assessmentformlistarray firstObject];
            }
        }
    }];
        
    if(result){
        if (assessmentformlistarray.count>0) {
            formtitleview.hidden=NO;
            assessmentformcenterlabel.hidden=YES;
            if ([selectedformkey isEqualToString:@""]) {
                if ([tmpseelectedformkey isEqualToString:@""]) {
                    tmpseelectedformkey=((AssessmentFormListObject *)[assessmentformlistarray firstObject]).formkey;
                }
                selectedformkey=tmpseelectedformkey;
            }
            [assessmentformlisttable reloadData];
            CGFloat tableheight=assessmentformlisttable.contentSize.height>8*44?8*44:assessmentformlisttable.contentSize.height;
            assessmentformlisttable.frame=CGRectMake(0, -tableheight, assessmentwidth, tableheight);
            [self updateformnameandlastsubmittedtime];
        }else{
            assessmentformcenterlabel.hidden=NO;
            assessmentformcenterlabel.text=[MyClass returntitlewithtitle:@"No form found"];
            assessmentformcenterlabel.frame=CGRectMake(0, 0, assessmentwidth, self.view.frame.size.height-20-44-44);
            formtitleview.hidden=YES;
            
            doneButton.hidden=YES;
            shareButton.hidden=YES;
            deleteButton.hidden=YES;
        }
    }
}

-(void) updateformnameandlastsubmittedtime
{
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    formtitlelabel.text=[self returnAssessmentFormListObjectWithFormKey:selectedformkey].formname;
    NSString *lastsubmitted=[self returnAssessmentFormListObjectWithFormKey:selectedformkey].lastsubmittedtime;
    NSString *submitter=[self returnAssessmentFormListObjectWithFormKey:selectedformkey].submitter;
    assessmenttable.userInteractionEnabled=YES;
    if ([lastsubmitted isEqualToString:@""]) {
        formlastsubmittedtimelabel.text=[MyClass returntitlewithtitle:@"Not submitted"];
        deleteButton.hidden=YES;
//        [deleteButton setTintColor:[UIColor clearColor]];
        shareButton.hidden=YES;
//        [shareButton setTintColor:[UIColor clearColor]];
        doneButton.hidden=NO;
//        [doneButton setTintColor:[UIColor whiteColor]];
        assessmentformcenterlabel.hidden=YES;
        assessmenttable.hidden=NO;
        
//        NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,shareButton,deletebutton,doneButton,nil];
//        
//        [RemarksToolBar setItems:buttons animated:NO];
        
        shareButton.hidden=NO;
        deleteButton.hidden=NO;
        doneButton.hidden=NO;
    }else{
        formlastsubmittedtimelabel.text=[NSString stringWithFormat:@"%@%@%@",[MyClass returnstaffnamewithusername:submitter firstorfullname:@"full"],[MyClass returntitlewithtitle:@" submitted on "],[MyClass returndateformatYYYYMMDDHHMMSSwithdate:lastsubmitted]];
//        [deleteButton setTintColor:[UIColor whiteColor]];
        deleteButton.hidden=NO;
//        [shareButton setTintColor:[UIColor whiteColor]];
        shareButton.hidden=NO;
        
        if ([globalvariables.username isEqualToString:submitter] || ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).overrideassessmentresponse) {
            assessmentformcenterlabel.hidden=YES;
            assessmenttable.hidden=NO;
            deleteButton.hidden=NO;
//            [deleteButton setTintColor:[UIColor whiteColor]];
            doneButton.enabled=YES;
//            [doneButton setTintColor:[UIColor whiteColor]];
            
//            NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,shareButton,deletebutton,doneButton,nil];
//            
//            [RemarksToolBar setItems:buttons animated:NO];
            
            shareButton.hidden=NO;
            deleteButton.hidden=NO;
            doneButton.hidden=NO;
        }else{
            assessmentformcenterlabel.hidden=YES;
            assessmenttable.hidden=NO;
//            deleteButton.hidden=YES;
//            [deletebutton setTintColor:[UIColor clearColor]];
//            doneButton.enabled=NO;
//            [doneButton setTintColor:[UIColor clearColor]];
            assessmenttable.userInteractionEnabled=NO;
            
            
//            assessmentformcenterlabel.hidden=NO;
//            assessmentformcenterlabel.text=[MyClass returntitlewithtitle:@"Form already submitted"];
//            assessmentformcenterlabel.frame=CGRectMake(0, 0, assessmentwidth, self.view.frame.size.height-88);
//            assessmenttable.hidden=YES;
//            deleteButton.hidden=YES;
//            [deletebutton setTintColor:[UIColor clearColor]];
//            doneButton.enabled=NO;
//            [doneButton setTintColor:[UIColor clearColor]];
            
            
            shareButton.hidden=NO;
            deleteButton.hidden=YES;
            doneButton.hidden=YES;
            
//            
//            NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,shareButton,nil];
//            
//            [RemarksToolBar setItems:buttons animated:NO];
        }
    }
    
    if (assessmentformlistarray.count>1) {
        [formselectionimage setImage:[UIImage imageNamed:@"downarrowbutton.png"]];
    }else{
        [formselectionimage setImage:nil];
    }
}

-(AssessmentFormListObject *) returnAssessmentFormListObjectWithFormKey:(NSString *)formkey
{
    for (int i=0; i<assessmentformlistarray.count; i++) {
        if ([((AssessmentFormListObject *)[assessmentformlistarray objectAtIndex:i]).formkey isEqualToString:formkey]) {
            return [assessmentformlistarray objectAtIndex:i];
        }
    }
    return nil;
}

-(void) changeformbuttonpressed:(UIButton *)sender
{
    if (assessmentformlistarray.count>1) {
        sender.tag=sender.tag==0?1:0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(formlistdidclose)];
        assessmentformlisttable.frame=CGRectMake(0, sender.tag==0?-assessmentformlisttable.frame.size.height:44, assessmentwidth, /*assessmentformlisttable.frame.size.height-44*/(assessmentformlistarray.count-1)*44);
        [UIView commitAnimations];
        
    }
}

-(void)formlistdidclose{
    if (changeformbutton.tag==0) {
        [assessmentformlisttable reloadData];
        [formselectionimage setImage:[UIImage imageNamed:@"downarrowbutton.png"]];
        assessmentblockbutton.hidden=YES;
    }else{
        [formselectionimage setImage:[UIImage imageNamed:@"closescreen_darkgray.png"]];
        assessmentblockbutton.hidden=NO;
    }
}

-(void) assessmentblockbuttonpressed:(UIButton *)sender
{
    [self changeformbuttonpressed:changeformbutton];
}

-(void) sendparentnote
{
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    for (int i=0; i<parentNoteStudentClassKeys.count; i++) {
        dict= [[NSMutableDictionary alloc]init];
        NSDictionary *studentclassdict=[parentNoteStudentClassKeys objectAtIndex:i];
        [dict setValue:studentclassdict[@"classkey"] forKey:@"classkey"];
        [dict setValue:studentclassdict[@"studentkey"] forKey:@"studentkey"];
        [arrayOfDicts addObject:dict];
    }
    jsonclasskeyarray=[NSArray arrayWithArray:arrayOfDicts];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"sendbulkparentnote" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:tmpparentnote forKey:@"parentnote"];
    [dictionary setValue:jsonclasskeyarray forKey:@"studentclasskeys"];
    
    BOOL sendaudioparentnote=FALSE;
    if (workingMessage.photoarray.count>0) {
        if (((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).internalurl) {
            sendaudioparentnote=TRUE;
        }
    }
    
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (sendaudioparentnote) {
        [self sendaudioparentnotewithstudentkeys:jsonclasskeyarray];
    }else{
        if(result){
            [self.delegate dismissclassremarkspopover];
        }
    }

    
}

- (BOOL) startAudioSession
{
    // Prepare the audio session
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];

    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }


    if (![session setActive:YES error:&error])
    {
        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
        return NO;
    }

    return session.isInputAvailable;
}




- (void)stopAudioRecording:(id)sender {
    if (audioRecorder.currentTime<1 || !audioRecorder.isRecording) {
        [self cancelAudioRecording];
    }else{
        [self stopAudioRecording];
    }
}

- (void)startAudioRecording:(id)sender {
    [MyClass playBeepSoundWithType:@"audiostart"];
    [impactFeedbackGenerator impactOccurred];
    //[self stopAudioPlaying];
    [self startAudioRecording];
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (audioRecorder.recording) {
        CGPoint touchpoint= [recognizer locationInView:textinputbox];
        CGRect cancellationframe = [textinputbox convertRect:slideToCancelTitle.frame fromView:slideToCancelTitle.superview];
        //NSLog(@"Touchpoint: %f:%f Frame:%f:%f:%f:%f",touchpoint.x,touchpoint.y,cancellationframe.origin.x,cancellationframe.origin.y,cancellationframe.size.width,cancellationframe.size.height);
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x) && touchpoint.x>cancellationframe.origin.x && touchpoint.y>cancellationframe.origin.y && touchpoint.y<(cancellationframe.origin.y+cancellationframe.size.height)) {
                //[self cancelAudioRecording];
                [audioRecordingImage setImage:[UIImage imageNamed:@"trashbin_red.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:16];
                slideToCancelTitle.textColor=[UIColor lightGrayColor];
            }else{
                [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:17];
                slideToCancelTitle.textColor=[UIColor grayColor];
            }
        }else{
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x)) {
                [self cancelAudioRecording];
            }else{
                [self stopAudioRecording];
            }
        }
    }
}

- (BOOL) startAudioRecording
{
    if (audioRecorder.isRecording) {
        return YES;
    }
    
    NSError *error;

    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];

    [settings setValue: [NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex: 0];
    NSString* filePath = [documentPath stringByAppendingPathComponent:@"tmpischool"];
    filePath = [filePath stringByAppendingPathComponent:[MyClass returnAudioRecordingFileName]];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];

    // Create recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:settings error:&error];
    if (!audioRecorder)
    {
        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
        return NO;
    }

    // Initialize degate, metering, etc.
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    //self.title = @"0:00";

    if (![audioRecorder prepareToRecord])
    {
        NSLog(@"Error: Prepare to record failed");
        return NO;
    }
    
    // Set a timer to monitor levels, current time
    audioRecorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    workingMessage.photoarray=[[NSMutableArray alloc]initWithObjects:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"audio" InternalURL:audioURL FileName:@"" ThumbnailURL:@""],nil];
    recordingStatusView.hidden=NO;
    [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
    slideToCancelTitle.font=[UIFont systemFontOfSize:17];
    slideToCancelTitle.textColor=[UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![audioRecorder record])
        {
            NSLog(@"Error: Record failed");
            //return NO;
        }

        NSLog(@"Audio recording started");
        //return YES;
    });
    return YES;
}

-(void) updateMeters
{
    NSTimeInterval duration=audioRecorder.currentTime;
    NSInteger second=(NSInteger)duration%60;
    NSInteger minute=duration/60;
    
    recordingDuration.text=[NSString stringWithFormat:@"%ld:%02li",(long)minute,(long)second];
}

-(void) deleteAudioParentNote:(id)sender
{
    [self stopAudioPlaying];
    workingMessage.photoarray=[[NSMutableArray alloc]init];
    tmpparentnote=@"";
    [classremarkstable reloadData];
}

- (void) cancelAudioRecording
{
    NSLog(@"Audio recording cancelled");
    [impactFeedbackGenerator impactOccurred];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [impactFeedbackGenerator impactOccurred];
    });
    [MyClass playBeepSoundWithType:@"audiocancel"];
    recordingStatusView.hidden=YES;
    [audioRecorder stop];
    audioRecorder=nil;
    [audioRecorderTimer invalidate];
    workingMessage.photoarray=[[NSMutableArray alloc]init];
    //[workingMessage.photoarray removeAllObjects];
    //sendinstantmessagebutton.enabled=[self enableSendButton];
}

- (void) stopAudioRecording
{
    if (audioRecorder.isRecording) {
        NSLog(@"Audio recording stopped");
        [impactFeedbackGenerator impactOccurred];
        recordingStatusView.hidden=YES;
        ((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).height=audioRecorder.currentTime;
        //workingClass.parentnote=@"";
        [audioRecorder stop];
        audioRecorder=nil;
        [audioRecorderTimer invalidate];
        //informationupdated=TRUE;
        //recordAudioButton.enabled=NO;
        [MyClass playBeepSoundWithType:@"audiostop"];
        //[self sendmessagebuttonpressed];
        [classremarkstable reloadData];
    }else{
        [self cancelAudioRecording];
    }
}

-(void) audioSliderValueChanged:(UISlider *)sender
{
    MyTableViewCell *cell=[classremarkstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if (audioPlayer) {
        [audioPlayer stop];
        CGFloat secondToPlay=sender.value;
        audioPlayer.currentTime=secondToPlay;
        [audioPlayer play];
        [cell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
    }else{
        [self playAudioButtonPressed:cell.button4];
    }
}

-(void) playAudioButtonPressed:(UIButton *)sender
{
    MyTableViewCell *newcell=[classremarkstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];

    if ([newcell.slider1 isEqual:selectedUIslide]) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            [sliderTimer invalidate];
            [newcell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }else{
            [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
            [audioPlayer play];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
    }else{
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        MessagePhotoRecord *obj=[workingMessage.photoarray firstObject];

        NSURL *audioURL;
        if (obj.internalurl) {
            audioURL=obj.internalurl;
        }else{
            NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.messagephotourl];
            audioURL = [NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:audioURL];
        
        audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        audioPlayer.delegate=self;
        audioPlayer.currentTime=newcell.slider1.value;

        
        selectedUIslide=newcell.slider1;
        
        [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
        [audioPlayer play];
        newcell.slider1.maximumValue = audioPlayer.duration;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}

- (void)updateSlider {
    // Update the slider about the music time
    selectedUIslide.value = audioPlayer.currentTime;
    NSLog(@"sliderTimer Running");
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [sliderTimer invalidate];
        MyTableViewCell *cell=[classremarkstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedUIslide.tag]];
        [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        cell.slider1.value=cell.slider1.minimumValue;
        audioPlayer=nil;
        selectedUIslide=nil;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

-(void) stopAudioPlaying
{
    if (audioPlayer) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            [sliderTimer invalidate];
            MyTableViewCell *previouscell=[classremarkstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedUIslide.tag]];
            [previouscell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }
        audioPlayer=nil;
        selectedUIslide=nil;
    }
    //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(void) sendaudioparentnotewithstudentkeys:(NSArray *)studentclasskeys
{
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *recipientgroup=[[NSArray alloc]init];
    NSMutableArray *classkeydicts=[[NSMutableArray alloc]init];
    
    keys=[NSArray arrayWithObjects:@"group",@"recipient",nil];
    
    for (int i=0; i<studentclasskeys.count; i++) {
        NSString *studentkey=[[studentclasskeys objectAtIndex:i] objectForKey:@"studentkey"];
        NSString *classkey=[[studentclasskeys objectAtIndex:i] objectForKey:@"classkey"];
        
        values=[NSArray arrayWithObjects:@"student",studentkey, nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
        
        [classkeydicts addObject:@{@"classkey":classkey}];
    }

    recipientgroup = [NSArray arrayWithArray:arrayOfDicts];
    
    [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"composer"];
    [dictionary setValue:globalvariables.username forKey:@"sender"];
    [dictionary setValue:@"Student" forKey:@"recipienttype"];
    [dictionary setValue:@"Teacher Note" forKey:@"messagetype"];
    [dictionary setValue:@"" forKey:@"messageenglish"];
    [dictionary setValue:@"" forKey:@"messagechinese"];
    [dictionary setValue:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"messagestarttime"];
    [dictionary setValue:@"" forKey:@"notificationqueuedflag"];
    [dictionary setValue:@"N" forKey:@"automessageflag"];
    [dictionary setValue:@"N" forKey:@"broadcastmessageflag"];
    [dictionary setValue:@"A" forKey:@"channel"];
    [dictionary setValue:@"" forKey:@"status"];
    [dictionary setValue:recipientgroup.count>0?recipientgroup:@"" forKey:@"recipientgroup"];
    [dictionary setValue:@"Yes" forKey:@"imagechanged"];
    [dictionary setValue:@"No" forKey:@"hotnews"];
    [dictionary setValue:@"" forKey:@"hn_expiry_date"];
    [dictionary setValue:@"Add" forKey:@"action"];
    [dictionary setValue:[NSArray arrayWithArray:classkeydicts] forKey:@"parentnoteclasskeys"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
            returndata=responseObject;
        }
    }];
    
    if (result) {
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        workingMessage.photoarray=[[NSMutableArray alloc]init];
        [self.delegate dismissclassremarkspopover];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [MyClass showconnectionlostdialogbox];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    return assessmentformrowobject.valuearray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    
//    NSLog(@"%@ %ld",assessmentformrowobject.questiontype,(long)collectionView.tag);
    if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtext"] || [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"]) {
        __weak afCheckBoxTextCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afCheckBoxTextCViewCell" forIndexPath:indexPath];
        
        
        [cell.checkboxbutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.checkboxbutton.tag=indexPath.item;
        
        [cell.checkboxtitlebutton addTarget:self action:@selector(multiplechoicetitlebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.checkboxtitlebutton.tag=indexPath.item;
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        if(range.location==NSNotFound){
            cell.textstack.hidden=YES;
            cell.checkboxtitle.text=titlestring;
        }else{
            cell.textstack.hidden=NO;
            cell.checkboxtitle.text=[titlestring substringToIndex:range.location];
            cell.texttitle.text=[titlestring substringFromIndex:range.location+2];
        }
        
        if([self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] disabled:YES]>=0){
            cell.checkboxtitle.textColor=[UIColor lightGrayColor];
            cell.checkboxbutton.enabled=NO;
            cell.checkboximage.layer.opacity=0.4;
            [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_unselect.png"]];
            cell.texttitle.textColor=[UIColor lightGrayColor];
            cell.textfield.text=@"";
            cell.textfield.enabled=NO;
        }else{
            cell.checkboxtitle.textColor=[UIColor blackColor];
            cell.checkboxbutton.enabled=YES;
            cell.checkboximage.layer.opacity=1.0;
            cell.texttitle.textColor=[UIColor blackColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] disabled:NO];
            if (index>=0) {
                [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_selected.png"]];
                cell.checkboxtitle.textColor=[self returnCheckBoxTitleColorWithIndex:indexPath.item];
                NSRange andrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"&&"];
                if (andrange.location!=NSNotFound) {
                    NSRange scorerange=[assessmentformrowobject.responsearray[index] rangeOfString:@"|"];
                    cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:andrange.location+2];
                    cell.textfield.text=[cell.textfield.text substringToIndex:scorerange.location-andrange.location-2];
                    cell.textfield.enabled=YES;
                    cell.textfield.tag=indexPath.item;
                    [cell.textfield addTarget:self action:@selector(updatecheckboxtextexample:) forControlEvents:UIControlEventEditingChanged];
                    [cell.textfield addTarget:self action:@selector(autosaveassessmentresponse) forControlEvents:UIControlEventEditingDidEnd];
                }
            }else{
                [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_unselect.png"]];
                cell.checkboxtitle.textColor=[UIColor blackColor];
                cell.textfield.text=@"";
                cell.textfield.enabled=NO;
            }
        }
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2"] || [assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2nr"]){
        __weak afMultipleChoiceCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afMultipleChoiceCViewCell" forIndexPath:indexPath];
        
        
        [cell.multiplechoicebutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.multiplechoicebutton.tag=indexPath.item;
        

        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        cell.multiplechoicetitle.text=titlestring;
        
        if ([assessmentformrowobject.responsearray containsObject:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item]]) {
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_selected.png"]];
        }else{
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_unselect.png"]];
        }
        
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"]) {
        __weak afTextMCCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afTextMCCViewCell" forIndexPath:indexPath];
        
        
        [cell.multiplechoicebutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.multiplechoicebutton.tag=indexPath.item;
        
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        cell.mcstack.hidden=NO;
        if(range.location!=NSNotFound){
            cell.textstack.hidden=NO;
            cell.texttitle.text=[titlestring substringToIndex:range.location];
            cell.multiplechoicetitle.text=[titlestring substringFromIndex:range.location+2];
        }else if(range2.location!=NSNotFound){
            cell.textstack.hidden=YES;
            cell.multiplechoicetitle.text=[titlestring substringToIndex:range2.location];;
        }else{
            cell.textstack.hidden=YES;
            cell.multiplechoicetitle.text=titlestring;
        }

        
        if([self textmultiplechoiceremarkscontainsValue:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] responsearray:assessmentformrowobject.responsearray]){
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_selected.png"]];
        }else{
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_unselect.png"]];
        }
        
        [cell.textfield addTarget:self action:@selector(updatemultiplechoicetext:) forControlEvents:UIControlEventEditingChanged];
        [cell.textfield addTarget:self action:@selector(autosaveassessmentresponse) forControlEvents:UIControlEventEditingDidEnd];
        cell.textfield.enabled=YES;
        cell.textfield.tag=indexPath.item;
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"TXT" disabled:NO];
        if (index>=0) {
            NSRange txtrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"TXT|"];
            if (txtrange.location!=NSNotFound) {
                cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:txtrange.location+4];
            }
        }else{
            cell.textfield.text=@"";
        }
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textremarks"]) {
        __weak afTextMCCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afTextMCCViewCell" forIndexPath:indexPath];
        
        cell.mcstack.hidden=YES;
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        cell.textstack.hidden=NO;
        cell.texttitle.text=[titlestring substringToIndex:range2.location];

        
        [cell.textfield addTarget:self action:@selector(updatemultiplechoicetext:) forControlEvents:UIControlEventEditingChanged];
        [cell.textfield addTarget:self action:@selector(autosaveassessmentresponse) forControlEvents:UIControlEventEditingDidEnd];
        cell.textfield.enabled=YES;
        cell.textfield.tag=indexPath.item;
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"TXT" disabled:NO];
        if (index>=0) {
            NSRange txtrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"TXT|"];
            if (txtrange.location!=NSNotFound) {
                cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:txtrange.location+4];
            }
        }else{
            cell.textfield.text=@"";
        }
        
        return cell;
    }
    
    return nil;
    
    
}

-(UIColor *) returnCheckBoxTitleColorWithIndex:(NSInteger)index
{
    return assessmentColorArray[index];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    
    if([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"]){
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range1=[titlestring rangeOfString:@"&&"];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label.font=[UIFont systemFontOfSize:14];
        if(range1.location!=NSNotFound){
            label.text=[titlestring substringFromIndex:range1.location+2];
            label.numberOfLines=0;
            [label sizeToFit];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
            label2.font=[UIFont systemFontOfSize:14];
            label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringToIndex:range1.location] ];
            label2.numberOfLines=0;
            [label2 sizeToFit];
            
            CGSize size= CGSizeMake(15+5+label.frame.size.width+20+label2.frame.size.width+6+50+10, 19);
            return size;
        }else if(range2.location!=NSNotFound){
            label.text=[titlestring substringToIndex:range2.location];
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }else{
            label.text=titlestring;
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }
    }else if([assessmentformrowobject.questiontype isEqualToString:@"textremarks"]){
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range1=[titlestring rangeOfString:@"%%"];

        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label2.font=[UIFont systemFontOfSize:14];
        label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringToIndex:range1.location] ];
        label2.numberOfLines=0;
        [label2 sizeToFit];
        
        CGSize size= CGSizeMake(label2.frame.size.width+6+40+10, 19);
        return size;

    }else{
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label.font=[UIFont systemFontOfSize:14];
        if(range.location==NSNotFound){
            label.text=titlestring;
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }else{
            label.text=[titlestring substringToIndex:range.location];
            label.numberOfLines=0;
            [label sizeToFit];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
            label2.font=[UIFont systemFontOfSize:14];
            label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringFromIndex:range.location+2] ];
            label2.numberOfLines=0;
            [label2 sizeToFit];
            
            CGSize size= CGSizeMake(15+5+label.frame.size.width+20+label2.frame.size.width+6+200+10, 19);
            return size;
        }
    }
    
    
    
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

-(void) scorebuttonpressed:(UIButton *)button
{
    NSMutableArray *itemsarray=[[NSMutableArray alloc]init];
    [itemsarray addObject:@"0"];
    [itemsarray addObject:@"1"];
    [itemsarray addObject:@"2"];
    [itemsarray addObject:@"3"];
    [itemsarray addObject:@"4"];
    [itemsarray addObject:@"5"];
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"assessmentscore" DataIndex:button.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(60, 6*40) View:self Button:button ItemsArray:itemsarray Title:nil];
}


-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if([datatype isEqualToString:@"assessmentscore"]){
        NSString *result=[selecteditems firstObject];
        
        CGPoint point = [button.superview convertPoint:CGPointZero toView:assessmenttable];
        NSIndexPath *indexPath=[assessmenttable indexPathForRowAtPoint:point];
        
        assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexPath.section]).questionarray objectAtIndex:indexPath.row];
        
        if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer2"]) {
            NSInteger index=0;
            NSRange scorerange=[assessmentformrowobject.responsearray[index] rangeOfString:@"|"];
            [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@|%@",[assessmentformrowobject.responsearray[index] substringToIndex:scorerange.location],result]];
            
        }else{
            NSString *value=[assessmentformrowobject.valuearray objectAtIndex:button.tag];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:value disabled:NO];
            
            NSRange scorerange=[assessmentformrowobject.responsearray[index] rangeOfString:@"|"];
            [assessmentformrowobject.responsearray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@|%@",[assessmentformrowobject.responsearray[index] substringToIndex:scorerange.location],result]];
        }
        [self autosaveassessmentresponse];
        [assessmenttable reloadData];
        
    }else if ([datatype isEqualToString:@"sharedocument"]){
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Print"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSData *pdfData;
                if ([selectedForm.formtype isEqualToString:@"ELDP"]) {
                    NSMutableDictionary *assessmentReportDict=[MyClass retrieveAssessmentReportWithSendOutboxDocument:@"" studentkey:classScheduleObject.studentkey formkey:selectedForm.formkey periodstart:@"2023-12-01" periodend:@"2024-02-29" classkey:classScheduleObject.classkey];
                    pdfData=[MyClass generateAssessmentReportWithAssessmentReportDict:assessmentReportDict sendAssessmentReport:NO];
                }else{
                    AssessmentPrintView *view=[[AssessmentPrintView alloc]initWithFrame:CGRectZero assessmentformarray:assessmentformarray classrecord:classScheduleObject assessmentformobject:[self returnAssessmentFormListObjectWithFormKey:selectedformkey] tableheight:assessmenttable.contentSize.height];
                    pdfData=[self returnAssessmentPrintPDFWithAssessmentView:view];
                }
                
                if (pdfData) {
                    [self printPDF:pdfData button:button];
                }
                            
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send Message"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSData *pdfData;
                if ([selectedForm.formtype isEqualToString:@"ELDP"]) {
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    dict=[[NSMutableDictionary alloc]init];
                    [dict setValue:classScheduleObject.studentkey forKey:@"studentkey"];
                    [dict setValue:selectedForm.formkey forKey:@"formkey"];
                    [dict setValue:@"" forKey:@"periodstart"];
                    [dict setValue:@"" forKey:@"periodend"];
                    [dict setValue:classScheduleObject.classkey forKey:@"classkey"];
                    [documentArray addObject:dict];
                    [MyClass submitDocumentSendingRequestWithType:@"Assessment" documentArray:documentArray];
                    
                    UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Evaluation"] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [missinginput dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [missinginput addAction:OKAction];
                    //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
                    
                }else{
                    AssessmentPrintView *view=[[AssessmentPrintView alloc]initWithFrame:CGRectZero assessmentformarray:assessmentformarray classrecord:classScheduleObject assessmentformobject:[self returnAssessmentFormListObjectWithFormKey:selectedformkey] tableheight:assessmenttable.contentSize.height];
                    pdfData=[self returnAssessmentPrintPDFWithAssessmentView:view];
                }
                
                if (pdfData) {
                    [self messagePDF:pdfData sender:classScheduleObject.instructor];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send Email"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSData *pdfData;
                if ([selectedForm.formtype isEqualToString:@"ELDP"]) {
                    NSMutableDictionary *assessmentReportDict=[MyClass retrieveAssessmentReportWithSendOutboxDocument:@"" studentkey:classScheduleObject.studentkey formkey:selectedForm.formkey periodstart:@"2023-12-01" periodend:@"2024-02-29" classkey:classScheduleObject.classkey];
                    pdfData=[MyClass generateAssessmentReportWithAssessmentReportDict:assessmentReportDict sendAssessmentReport:NO];
                }else{
                    AssessmentPrintView *view=[[AssessmentPrintView alloc]initWithFrame:CGRectZero assessmentformarray:assessmentformarray classrecord:classScheduleObject assessmentformobject:[self returnAssessmentFormListObjectWithFormKey:selectedformkey] tableheight:assessmenttable.contentSize.height];
                    pdfData=[self returnAssessmentPrintPDFWithAssessmentView:view];
                }
                
                if (pdfData) {
                    [self emailPDF:pdfData];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"More"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSData *pdfData;
                if ([selectedForm.formtype isEqualToString:@"ELDP"]) {
                    NSMutableDictionary *assessmentReportDict=[MyClass retrieveAssessmentReportWithSendOutboxDocument:@"" studentkey:classScheduleObject.studentkey formkey:selectedForm.formkey periodstart:@"2023-12-01" periodend:@"2024-02-29" classkey:classScheduleObject.classkey];
                    pdfData=[MyClass generateAssessmentReportWithAssessmentReportDict:assessmentReportDict sendAssessmentReport:NO];
                }else{
                    AssessmentPrintView *view=[[AssessmentPrintView alloc]initWithFrame:CGRectZero assessmentformarray:assessmentformarray classrecord:classScheduleObject assessmentformobject:[self returnAssessmentFormListObjectWithFormKey:selectedformkey] tableheight:assessmenttable.contentSize.height];
                    pdfData=[self returnAssessmentPrintPDFWithAssessmentView:view];
                }

                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Assessment.pdf"]];
                [pdfData writeToFile:filePath atomically:YES];
                
                // Open the controller.
                documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                documentInteractionController.delegate = self;
                documentInteractionController.UTI = @"com.adobe.pdf";
                [documentInteractionController setName:@"Evaluation"];

                [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];

//                [documentInteractionController presentOptionsMenuFromBarButtonItem:shareButton animated:YES];
                [documentInteractionController presentOptionsMenuFromRect:[shareButton frame] inView:self.view animated:YES];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
    }
}

- (void)printPDF:(NSData*)pdfData button:(UIButton *)button{
    UIPrintInteractionController *printer=[UIPrintInteractionController sharedPrintController];
    UIPrintInfo *info = [UIPrintInfo printInfo];
    info.orientation = UIPrintInfoOrientationPortrait;
    info.outputType = UIPrintInfoOutputGeneral;
    info.jobName=@"assessment_report.pdf";
    info.duplex=UIPrintInfoDuplexLongEdge;
    printer.printInfo = info;
    printer.showsPageRange=YES;
    printer.printingItem=pdfData;
    printer.showsPaperSelectionForLoadedPapers=YES;
    printer.delegate=self;
    
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
//    [printer presentFromBarButtonItem:shareButton animated:YES completionHandler:nil];
    [documentInteractionController presentOptionsMenuFromRect:[shareButton frame] inView:self.view animated:YES];
//    [printer presentFromRect:button.frame inView:button animated:YES completionHandler:nil];
//   [printer presentFromBarButtonItem:shareButton animated:YES completionHandler:nil];
    
}

-(void) messagePDF:(NSData *)pdfData sender:(NSString *)sender
{
    AssessmentFormListObject *obj=[self returnAssessmentFormListObjectWithFormKey:selectedformkey];
    
    if (![obj.formtype isEqualToString:@""]) {
        NSMutableArray *documentArray=[[NSMutableArray alloc]init];
        NSMutableDictionary *dict;
        dict=[[NSMutableDictionary alloc]init];
        [dict setValue:classScheduleObject.studentkey forKey:@"studentkey"];
        [dict setValue:selectedForm.formkey forKey:@"formkey"];
        [dict setValue:@"" forKey:@"periodstart"];
        [dict setValue:@"" forKey:@"periodend"];
        [dict setValue:classScheduleObject.classkey forKey:@"classkey"];
        [documentArray addObject:dict];
        [MyClass submitDocumentSendingRequestWithType:@"Assessment" documentArray:documentArray];
        

    }else{
        NSString *filename=obj.formname;
        OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
        object.photoarray=[[NSMutableArray alloc]init];
        object.messageenglish=[NSString stringWithFormat:@"%@.pdf",filename];
        object.messagechinese=[NSString stringWithFormat:@"%@.pdf",filename];
        object.recipienttype=@"Student";
        object.recipientgroup=[[RecipientGroupRecord alloc]init];
        object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithObjects:classScheduleObject.studentkey, nil];
        object.messagetype=@"Assessment";
        object.sender=[sender isEqualToString:@"TBD"]?nil:sender;
        
        NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
        [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", filename] ThumbnailURL:@""]];
        

        
        MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
        [viewController sendMessageWithOutBoxMessage:object];
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
    //    if(acknowledge){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Evaluation"] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
            [MyClass presentViewController:missinginput View:self];
    //    }
    }
}

-(void) emailPDF:(NSData *)pdfData
{
    AssessmentFormListObject *obj=[self returnAssessmentFormListObjectWithFormKey:selectedformkey];
    NSString *filename=obj.formname;
    Student *student=[MyClass returnstudentwithstudentkey:classScheduleObject.studentkey];
    if ([student.parentemail isEqualToString:@""]) {
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"] message:@"No email address is found" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [successalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [successalert addAction:OKAction];
        //[self presentViewController:successalert animated:YES completion:nil];
                    [MyClass presentViewController:successalert View:self];
    }else{
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"%@ - %@.pdf",globalvariables.centerrecord.centername,filename]];
        [mail addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",filename]];
        [mail setToRecipients:@[student.parentemail]];
        [mail setMessageBody:[MyClass returntitlewithtitle:@"Please edit your email content"] isHTML:YES];
        
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        if (mail) {
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"] message:[MyClass returntitlewithtitle:@"Mail account is not available"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            [self presentViewController:missinginput animated:YES completion:nil];
        }
    }
}

-(NSData *) returnAssessmentPrintPDFWithAssessmentView:(AssessmentPrintView *)printView
{

    
    NSInteger pageHeight = 792; // Standard page height - adjust as needed
    NSInteger pageWidth = 612;  // Standard page width - adjust as needed
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0,0,pageWidth,pageHeight), nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    for (int page=0; printView.frame.size.width*pageHeight/pageWidth * page < printView.frame.size.height; page++)
    {
        UIGraphicsBeginPDFPage();
        CGContextTranslateCTM(pdfContext, 24, 30);
        CGContextConcatCTM(pdfContext,CGAffineTransformMakeScale(.71, .71));
        UIView *printview2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, printView.frame.size.width, printView.frame.size.width*pageHeight/pageWidth)];
        printview2.layer.masksToBounds=TRUE;
        printView.frame=CGRectMake(0, -(printView.frame.size.width*pageHeight/pageWidth-10) * page, printView.frame.size.width, printView.frame.size.height);
        [printview2 addSubview:printView];
        [printview2.layer renderInContext:pdfContext];
    }

    UIGraphicsEndPDFContext();
    
    return pdfData;
    
}



@end


