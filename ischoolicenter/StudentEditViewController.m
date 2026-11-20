//
//  StudentEditViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/3/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "StudentEditViewController.h"
#import "MyClass.h"


@interface StudentEditViewController ()
@property (nonatomic, assign) BOOL sideSelectionAnimating;
@end

#define schooltablewidth 350
#define agetablewidth 220
#define gradetablewidth 220
#define preferredlanguagetablewidth 220
#define mediatablewidth 300
#define sourcetablewidth 300
#define dobtablewidth 320
#define contactcellwidth 251
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define extrafield2tablewidth 300

@implementation StudentEditViewController
@synthesize EditViewStudent;
@synthesize EditViewStudentAction;
@synthesize studentimage,imagepicker,mypopovercontroller;
@synthesize MediaArray,SourceArray;




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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    MasterView.clipsToBounds = YES;
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBar.barTintColor = themecolor;
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    selfViewWidth = self.view.bounds.size.width - 240;
    if (selfViewWidth < 1) {
        selfViewWidth = self.view.bounds.size.width;
    }
    
    maxcontactperline=(selfViewWidth-178-140-20)/contactcellwidth;
    
    
//    UIBarButtonItem* donebutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneStudent:)];
//    self.navigationItem.rightBarButtonItem=nil;
//
//    UIBarButtonItem* cancelbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelStudent:)];
//    self.navigationItem.leftBarButtonItem=nil;
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];

    //load student image
    if ([EditViewStudentAction isEqualToString:@"AddNewStudent"]){
        EditViewStudent=[[Student alloc]init];
    }
    
    /*workingStudent.siblingarray=[[NSMutableArray alloc]init];
    if (EditViewStudent.siblingarray.count>0) {
        for (int i=0; i<EditViewStudent.siblingarray.count; i++) {
            [workingStudent.siblingarray addObject:[[SiblingRecord alloc]initSiblingRecordwithStudentname:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).studentname Studentkey:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).studentkey Relationship:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).relationship]];
        }
    }*/
//    MasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height)];
//    [self.view addSubview:MasterView];
    
    studentimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 132, 154, 180)];
    studentimage.contentMode=UIViewContentModeScaleAspectFit;
    studentimage.layer.cornerRadius=10;
    studentimage.backgroundColor=[UIColor lightGrayColor];
    studentimage.layer.masksToBounds=YES;
    [MasterView addSubview:studentimage];
    
    addphotobutton=[[UIButton alloc]initWithFrame:CGRectMake(130, 274, 30, 30)];
    [addphotobutton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [addphotobutton addTarget:self action:@selector(addphotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [MasterView addSubview:addphotobutton];

    deletephotobutton=[[UIButton alloc]initWithFrame:CGRectMake(24, 274, 30, 30)];
    [deletephotobutton setImage:[UIImage imageNamed:@"absent_icon.png"] forState:UIControlStateNormal];
    [deletephotobutton addTarget:self action:@selector(deletephotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [MasterView addSubview:deletephotobutton];

    editphotobutton=[[UIButton alloc]initWithFrame:CGRectMake(130, 274, 30, 30)];
    [editphotobutton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [editphotobutton addTarget:self action:@selector(editphotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [MasterView addSubview:editphotobutton];
    
    
    [MyClass downloadImageWithImageview:studentimage gender:EditViewStudent.gender type:@"student" typekey:EditViewStudent.studentkey image:EditViewStudent.image?EditViewStudent.image:@"No" async:YES];
    
    if ([EditViewStudent.image isEqualToString:@"Yes"]) {
        /*NSURL *url;
        if ([EditViewStudentAction isEqualToString:@"AddDTStudent"] || [EditViewStudentAction isEqualToString:@"EnrollLead"] || [EditViewStudentAction isEqualToString:@"EnrollATLeadStudent"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@leadimages/%@/lead_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, EditViewStudent.leadkey]];
        }else{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@studentimages/%@/student_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, EditViewStudent.studentkey]];
        }

        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                if ([[UIImage alloc] initWithData:data]) {
                    studentimage.image = [[UIImage alloc] initWithData:data];*/
                    addphotobutton.hidden=YES;
                    editphotobutton.hidden=NO;
                    deletephotobutton.hidden=NO;
                /*}
            }else{
                studentimage.image=nil;
                addphotobutton.hidden=NO;
                editphotobutton.hidden=YES;
                deletephotobutton.hidden=YES;
            }
        }];*/
    }else{
        //studentimage.image=nil;
        addphotobutton.hidden=NO;
        editphotobutton.hidden=YES;
        deletephotobutton.hidden=YES;
    }
    
    imageadded=FALSE;
    imageedited=FALSE;
    imagedeleted=FALSE;
    phonearraychanged=FALSE;
    siblingarraychanged=FALSE;
    
    
    
    SiblingTable=[[UITableView alloc]initWithFrame:CGRectMake(15, 371, 154, 300) style:UITableViewStylePlain];
    SiblingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    SiblingTable.editing=TRUE;
    SiblingTable.allowsSelectionDuringEditing=TRUE;
    SiblingTable.delegate=self;
    SiblingTable.dataSource=self;
    [MasterView addSubview:SiblingTable];
    
    siblingtableheader=[[UILabel alloc]initWithFrame:CGRectMake(15, 336, 154, 25)];
    siblingtableheader.text=[MyClass returntitlewithtitle:@"Siblings and Friends"];
    siblingtableheader.font=[UIFont systemFontOfSize:12];
    siblingtableheader.textColor=[UIColor darkGrayColor];
    [MasterView addSubview:siblingtableheader];
    
    UIView *siblingtableheaderseparator=[[UIView alloc]initWithFrame:CGRectMake(15, 361, 154, 1)];
    siblingtableheaderseparator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [MasterView addSubview:siblingtableheaderseparator];
    
    UIButton *addsiblingbutton=[[UIButton alloc]initWithFrame:CGRectMake(149, 338, 20, 20)];
    [addsiblingbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
    [addsiblingbutton addTarget:self action:@selector(addsiblingbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [MasterView addSubview:addsiblingbutton];
    
    
    studentlistpopovercontroller=[[StudentListPopoverViewController alloc]init];
    studentlistpopovercontroller.preferredContentSize=CGSizeMake(500, 458);
    studentlistpopovercontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    studentlistpopovercontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    studentlistpopovercontroller.delegate=self;
    
    [self initializefield];
    
    
    studentTable=[[UITableView alloc]initWithFrame:CGRectMake(178, 70, selfViewWidth-178, self.view.bounds.size.height-70) style:UITableViewStyleGrouped];
    
    
    studentTable.delegate=self;
    studentTable.dataSource=self;
    studentTable.sectionHeaderHeight=0;
    studentTable.sectionFooterHeight=0;
    [MasterView addSubview:studentTable];
    [studentTable reloadData];
    if ([studentTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        studentTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    

    
    //phonetypearray=[[NSArray alloc]initWithObjects:@"Main Contact",@"Self",@"Father",@"Mother",@"Grand Father",@"Grand Mother",@"Brother",@"Sister",@"Uncle",@"Auntie",@"Home",@"Helper",@"Emergency",@"Other", nil];
    phonetypearray=[[NSMutableArray alloc]initWithArray:globalvariables.contactrelationshiparray];
    phonetypetable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    phonetypetable.scrollEnabled=NO;
    phonetypetable.delegate=self;
    phonetypetable.dataSource=self;
    phonetypetable.separatorColor=[UIColor clearColor];
    
    sideselectionview=[[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-240, 70, self.view.bounds.size.width-240, self.view.bounds.size.height-70)];
    [MasterView addSubview:sideselectionview];
    
    filterviewbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, sideselectionview.frame.size.width, sideselectionview.frame.size.height)];
    filterviewbutton.backgroundColor=[UIColor blackColor];
    filterviewbutton.layer.opacity=0;
    [filterviewbutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [sideselectionview addSubview:filterviewbutton];
    
    //school
    schoolmasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-schooltablewidth, 0, schooltablewidth, sideselectionview.frame.size.height)];
    schoolmasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:schoolmasterview];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, schoolmasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [schoolmasterview addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"School"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    schoolsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, schoolmasterview.frame.size.width, 42)];
    schoolsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    schoolsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    schoolsearchbar.delegate=self;
    [headerView addSubview:schoolsearchbar];
    
    schooltable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+42, schooltablewidth, sideselectionview.frame.size.height-44-42) style:UITableViewStyleGrouped];
    schooltable.delegate=self;
    schooltable.dataSource=self;
    schooltable.sectionHeaderHeight=0;
    [schoolmasterview addSubview:schooltable];

    //age
    agemasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-agetablewidth, 0, agetablewidth, sideselectionview.frame.size.height)];
    agemasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:agemasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, agemasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [agemasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Age"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    agetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, agetablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    agetable.delegate=self;
    agetable.dataSource=self;
    agetable.sectionHeaderHeight=0;
    
    [agemasterview addSubview:agetable];
    
    agearray=[[NSMutableArray alloc]init];
    [agearray addObject:@""];
    for (int i=1; i<100; i++) {
        [agearray addObject:[NSString stringWithFormat:@"%d",i]];
    }

    //grade
    grademasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-gradetablewidth, 0, gradetablewidth, sideselectionview.frame.size.height)];
    grademasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:grademasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grademasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [grademasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Grade"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    gradetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, gradetablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    gradetable.delegate=self;
    gradetable.dataSource=self;
    gradetable.sectionHeaderHeight=0;
    [grademasterview addSubview:gradetable];
    
    gradearray=[NSMutableArray arrayWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    
    //preferred language
    preferredlanguagemasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-preferredlanguagetablewidth, 0, agetablewidth, sideselectionview.frame.size.height)];
    preferredlanguagemasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:preferredlanguagemasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, preferredlanguagemasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [preferredlanguagemasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Preferred Language"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    preferredlanguagetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, preferredlanguagetablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    preferredlanguagetable.delegate=self;
    preferredlanguagetable.dataSource=self;
    preferredlanguagetable.sectionHeaderHeight=0;
    [preferredlanguagemasterview addSubview:preferredlanguagetable];
    
    preferredlanguagearray=[NSMutableArray arrayWithObjects:@"Cantonese",@"English",@"Mandarin",nil];
    
    //source
    sourcemasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-sourcetablewidth, 0, sourcetablewidth, sideselectionview.frame.size.height)];
    sourcemasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:sourcemasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sourcemasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [sourcemasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Source"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    sourcetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, sourcetablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    sourcetable.delegate=self;
    sourcetable.dataSource=self;
    sourcetable.sectionHeaderHeight=0;
    [sourcemasterview addSubview:sourcetable];
    
    sourcearray=[[NSMutableArray alloc]initWithArray:SourceArray];
    
    //media
    mediamasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-mediatablewidth, 0, mediatablewidth, sideselectionview.frame.size.height)];
    mediamasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:mediamasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mediamasterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [mediamasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Media"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    mediatable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, mediatablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    mediatable.delegate=self;
    mediatable.dataSource=self;
    mediatable.sectionHeaderHeight=0;
    [mediamasterview addSubview:mediatable];
    
    mediaarray=[[NSMutableArray alloc]initWithArray:MediaArray];
    
    //extrafield2
    extrafield2masterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-extrafield2tablewidth, 0, extrafield2tablewidth, sideselectionview.frame.size.height)];
    extrafield2masterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:extrafield2masterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, extrafield2masterview.frame.size.width,88)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [extrafield2masterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"ExtraField2"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    extrafield2table=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, extrafield2tablewidth, sideselectionview.frame.size.height-44) style:UITableViewStyleGrouped];
    extrafield2table.delegate=self;
    extrafield2table.dataSource=self;
    extrafield2table.sectionHeaderHeight=0;
    [extrafield2masterview addSubview:extrafield2table];
    
    extrafield2array=[[NSArray alloc]initWithArray:[globalvariables.centerrecord.studentextrafield2 componentsSeparatedByString:@","]];
    
    //DoB
    dobmasterview=[[UIView alloc]initWithFrame:CGRectMake(sideselectionview.frame.size.width-dobtablewidth, 0, dobtablewidth, sideselectionview.frame.size.height)];
    dobmasterview.backgroundColor=[UIColor whiteColor];
    [sideselectionview addSubview:dobmasterview];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dobmasterview.frame.size.width,sideselectionview.frame.size.height)];
    headerView.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.2];
    [dobmasterview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Date of Birth"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor darkGrayColor];
    [headerView addSubview:label];
    
    myDatePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, dobtablewidth, 290)];
    myDatePickerView.datePickerMode=UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        myDatePickerView.preferredDatePickerStyle=UIDatePickerStyleWheels;
    }
    myDatePickerView.backgroundColor=[UIColor whiteColor];
    [myDatePickerView addTarget:self action:@selector(dobdateChanged) forControlEvents:UIControlEventValueChanged];
    
    if ([globalvariables.language isEqualToString:@"English"]) {
        myDatePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }else{
        myDatePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    
    
    [myDatePickerView setMaximumDate:[NSDate date]];
    
    if (![workingStudent.dateofbirth isEqualToString:@""]) {
        NSDateFormatter *df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date=[df dateFromString:workingStudent.dateofbirth];
        [myDatePickerView setDate:date];
    }
    
    [dobmasterview addSubview:myDatePickerView];
    
    
    UIButton *dobdonebutton=[[UIButton alloc]initWithFrame:CGRectMake(dobtablewidth-100, 300+44, 80, 30)];
    [dobdonebutton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    [dobdonebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    dobdonebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [dobdonebutton addTarget:self action:@selector(closedobtable) forControlEvents:UIControlEventTouchUpInside];
    [dobmasterview addSubview:dobdonebutton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) closedobtable
{
    [self closesidewindow];
}

-(void) dobdateChanged
{
    NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    workingStudent.dateofbirth=[df stringFromDate:[myDatePickerView date]];
    workingStudent.age=[MyClass calculateagewithbirthday:workingStudent.dateofbirth];
    //[self closesidewindow];
    [studentTable reloadData];
    [studentTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)keyboardWillHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

- (CGFloat)visibleEditWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) {
        return width;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (CGFloat)visibleEditHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) {
        return height;
    }
    CGPoint bottom = [self.view convertPoint:CGPointMake(0, CGRectGetMaxY(window.bounds)) fromView:nil];
    return MIN(MAX(bottom.y, 0), height);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutStudentEditForCurrentSize];
}

- (void)pinEditSidePanel:(UIView *)panel width:(CGFloat)panelWidth
{
    if (!panel) {
        return;
    }
    CGFloat height = sideselectionview.bounds.size.height;
    panel.frame = CGRectMake(MAX(sideselectionview.bounds.size.width - panelWidth, 0), 0, panelWidth, height);
    for (UIView *subview in panel.subviews) {
        CGRect frame = subview.frame;
        BOOL stretches = [subview isKindOfClass:[UITableView class]] || (frame.origin.y < 1 && frame.size.height > 100);
        if (stretches) {
            frame.size.height = MAX(height - frame.origin.y, 0);
            frame.size.width = panelWidth;
            subview.frame = frame;
        }
    }
}

// The edit form and its picker panel were sized once from the storyboard.
// Keep both on the current view so the form fills the window and the panel
// stays on the trailing edge.
- (void)layoutStudentEditForCurrentSize
{
    CGFloat width = [self visibleEditWidth];
    CGFloat height = [self visibleEditHeight];
    if (width < 1 || height < 1 || !studentTable || !sideselectionview) {
        return;
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            if (fabs(constraint.constant - overflow) > 0.5) {
                constraint.constant = overflow;
            }
        }
    }
    BOOL widthChanged = fabs(selfViewWidth - width) > 0.5;
    selfViewWidth = width;
    maxcontactperline = (selfViewWidth - 178 - 140 - 20) / contactcellwidth;
    if (maxcontactperline < 1) {
        maxcontactperline = 1;
    }
    studentTable.frame = CGRectMake(178, 70, MAX(width - 178, 0), MAX(height - keyboardheight - 70, 0));
    if (self.sideSelectionAnimating) {
        if (widthChanged) {
            [studentTable reloadData];
        }
        return;
    }
    BOOL sideOpen = sideselectionview.frame.origin.x < 1;
    sideselectionview.frame = CGRectMake(sideOpen ? 0 : width, 70, width, MAX(height - 70, 0));
    filterviewbutton.frame = sideselectionview.bounds;
    [self pinEditSidePanel:schoolmasterview width:schooltablewidth];
    [self pinEditSidePanel:agemasterview width:agetablewidth];
    [self pinEditSidePanel:grademasterview width:gradetablewidth];
    [self pinEditSidePanel:preferredlanguagemasterview width:preferredlanguagetablewidth];
    [self pinEditSidePanel:sourcemasterview width:sourcetablewidth];
    [self pinEditSidePanel:mediamasterview width:mediatablewidth];
    [self pinEditSidePanel:extrafield2masterview width:extrafield2tablewidth];
    [self pinEditSidePanel:dobmasterview width:dobtablewidth];
    if (widthChanged) {
        [studentTable reloadData];
    }
}

-(void) adjusttablesize
{
    //if ([globalvariables.leftmenuindex isEqualToString:@"1"]) {
        studentTable.frame=CGRectMake(178, 70, MAX([self visibleEditWidth] - 178, 0), MAX([self visibleEditHeight] - keyboardheight - 70, 0));
    /*}else{
        studentTable.frame=CGRectMake(178, 64, studentTable.frame.size.width, 728-keyboardheight-64+20);
    }*/
}




/*
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completionBlock(YES, data);
        } else {
            completionBlock(NO, nil);
        }
    }];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) checkIfMissingRequiredFields
{
    NSString *fcgroup=globalvariables.centerrecord.fcgroup;

    if ([workingStudent.firstname isEqualToString:@""]) {
//        if ([fcgroup isEqualToString:@"popularlearning"] || [fcgroup isEqualToString:@"cornerstone"]) {
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student's first name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        [MyClass presentViewController:missingalert View:self];
            return FALSE;
//        }
    }
    
    if ([workingStudent.lastname isEqualToString:@""]) {
        if ([fcgroup isEqualToString:@"popularlearning"] || [fcgroup isEqualToString:@"cornerstone"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student's last name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if([workingStudent.othername isEqualToString:@""]){
        if ([fcgroup isEqualToString:@"popularlearning"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student's other name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if([workingStudent.dateofbirth isEqualToString:@""]){
        if ([fcgroup isEqualToString:@"popularlearning"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student's date of birth"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if([workingStudent.age isEqualToString:@""]){
        if ([fcgroup isEqualToString:@"cornerstone"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student's age"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if([workingStudent.grade isEqualToString:@""]){
//        if ([fcgroup isEqualToString:@"popularlearning"]) {
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input grade"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        [MyClass presentViewController:missingalert View:self];
            return FALSE;
//        }
    }
    
    if([workingStudent.school isEqualToString:@""]){
        if ([fcgroup isEqualToString:@"popularlearning"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input school"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if ([workingStudent.parentname isEqualToString:@""]) {
        if ([fcgroup isEqualToString:@"popularlearning"] || [fcgroup isEqualToString:@"cornerstone"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input parent name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if ([workingStudent.parentaddress isEqualToString:@""]) {
        if ([fcgroup isEqualToString:@"popularlearning"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input address"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    if ([workingStudent.extrafield2 isEqualToString:@""]) {
        if ([fcgroup isEqualToString:@"cornerstone"]) {
            UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Please input student extrafield2"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missingalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missingalert addAction:OKAction];
            [MyClass presentViewController:missingalert View:self];
            return FALSE;
        }
    }
    
    return TRUE;
}


-(IBAction) doneStudent:(id)sender{
    
    [self.view endEditing:YES];
    [self closesidewindow];
    
    NSInteger phonecount=0;
    for (int i=0; i<workingStudent.phonearray.count; i++) {
        ContactRecord *obj=[workingStudent.phonearray objectAtIndex:i];
        if (![[MyClass returnLocalNumberWithContact:obj.contact ISOCode:obj.iso_code] isEqualToString:@""]) {
            phonecount++;
        }
    }

    if([self checkIfMissingRequiredFields]){
        if([self isStudentIDBeingUsed]){
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Information"] message:[MyClass returntitlewithtitle:@"Student ID already been used. Do you want to continue?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self checkUpdateEnrollmentTuitionFee];
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            //[self presentViewController:disablealert animated:YES completion:nil];
            [MyClass presentViewController:disablealert View:self];
        }else{
            [self checkUpdateEnrollmentTuitionFee];
        }
    }
}

-(void) checkUpdateEnrollmentTuitionFee
{
    //check if need to update tuition fee for any enrollments
    if ([self updateEnrollmentsTuitionFee]) {
        UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Do you want to update the tuition fee for those not yet started and unpaid enrollments?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self updateStudentWithUpdateEnrollmentsTuitionFee:YES];
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self updateStudentWithUpdateEnrollmentsTuitionFee:NO];
        }];
        
        [disablealert addAction:OKAction];
        [disablealert addAction:CancelAction];
        
        //[self presentViewController:disablealert animated:YES completion:nil];
        [MyClass presentViewController:disablealert View:self];
    }else{
        [self updateStudentWithUpdateEnrollmentsTuitionFee:NO];
    }
}

-(BOOL) updateEnrollmentsTuitionFee
{
    __block BOOL value=FALSE;
    if ([EditViewStudentAction isEqualToString:@"EditStudent"]) {
        if (![EditViewStudent.grade isEqualToString:workingStudent.grade]) {
            if ([self hasGradeTuitionMethodSubject]) {
                
                NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updateenrollmentforgradechange&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,EditViewStudent.studentkey];
                
                __block BOOL result=FALSE;
                [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                    if (succeeded) {
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                            JSONArray = jsonreturned[@"content"];
                        NSString * result=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
                        if ([result isEqualToString:@"Y"]) {
                            value= YES;
                        }
                    }
                }];
                
                /*
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                NSURLSession *session = [NSURLSession sharedSession];
                [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    // handle response
                    
                    if (!error) {
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        JSONArray = jsonreturned[@"content"];
                    NSString * result=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
                    if ([result isEqualToString:@"Y"]) {
                        value= YES;
                    }
                }
                    dispatch_semaphore_signal(semaphore);
                }] resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            }
        }
    }
    return value;
}

-(BOOL) hasGradeTuitionMethodSubject
{
    NSMutableArray *tmpsubjectlistarray=[[NSMutableArray alloc]initWithArray:[globalvariables.subjectlistarray allValues]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.centerkey=%@ and self.tuition_method=%@",globalvariables.centerrecord.centerkey,@"Grade"];
    tmpsubjectlistarray=[[NSMutableArray alloc]initWithArray:[tmpsubjectlistarray filteredArrayUsingPredicate:predicate]];
    
    
    return tmpsubjectlistarray.count>0?TRUE:FALSE;
    
    /*
    
    for (int i=0; i<globalvariables.subjectlistarray.count; i++) {
        if ([((SubjectRecord *)[globalvariables.subjectlistarray objectAtIndex:i]).tuition_method isEqualToString:@"Grade"]) {
            return TRUE;
        }
    }
    return FALSE;*/
}


-(void) updateStudentWithUpdateEnrollmentsTuitionFee:(BOOL)updateenrollmentstuitionfee
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *sqldateofbirth;
        NSString *image;
        //NSString *workingStudent.age;
        //Student *tmpstudent=[[Student alloc]init];
        
        [self updateuserphonearray];
        
        if (![workingStudent.dateofbirth isEqualToString:@""]) {
            sqldateofbirth=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:workingStudent.dateofbirth];
            //workingStudent.age=@"";
        }else{
            sqldateofbirth=@"";
            //workingStudent.age=destStudentEditTableViewController.agelabel.text;
        }
        
        
        if (imagedeleted) {
            image=@"No";
        }else if (imageadded || imageedited || [EditViewStudent.image isEqualToString:@"Yes"]) {
            image=@"Yes";
        }else{
            image=@"No";
        }
        /*
         if (![self getstudentdefaultvalue]) {
         return;
         }*/
        
        
        if ([EditViewStudentAction isEqualToString:@"AddNewStudent"] || [EditViewStudentAction isEqualToString:@"AddDTStudent"] || [EditViewStudentAction isEqualToString:@"EnrollLead"] || [EditViewStudentAction isEqualToString:@"EnrollATLeadStudent"] || [EditViewStudentAction isEqualToString:@"AddSiblingStudent"] || [EditViewStudentAction isEqualToString:@"AddStudentAndSubject"]) {
            

            
            if (![self hasEnoughParentLicenseWithNewStudent:workingStudent OldStudent:nil]) {
                
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iParent"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                return;
            }
            
            NSString *studentkey=[self updateStudentWithStudent:workingStudent Action:@"Add" UpdateEnrollmentsTuitionFee:updateenrollmentstuitionfee];
            
            if (studentkey) {
                //save image file
                [self uploadimagestudentkey:studentkey];
                
                //[self.delegate updateStudentCategoryCount];
                [self.delegate gotostudentprofile:studentkey submenu:0 classkeys:nil saleskey:nil];
                //[self.delegate showstudentlist:studentkey];
                //[self.delegate refreshStudentView:studentkey];
                [MyClass insertViewHistoryWithType:@"student" Typekey:studentkey Name:@"" IDNumber:@"" Gender:@""];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
                
                return;
            }
        }else{ //edit student
            //create string contains url address for php file
            if (![self hasEnoughParentLicenseWithNewStudent:workingStudent OldStudent:EditViewStudent]) {
                
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iParent"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                return;
            }
            
            
            NSString *studentkey=[self updateStudentWithStudent:workingStudent Action:@"Edit" UpdateEnrollmentsTuitionFee:updateenrollmentstuitionfee];
            if (studentkey) {
                //save image file
                [self uploadimagestudentkey:EditViewStudent.studentkey];
                
                [self.delegate updatestudentinformationlist:EditViewStudent.studentkey reloadlist:YES];
                [self.delegate refreshStudentView:EditViewStudent.studentkey];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
                return;
            }
        }
        
        [self.delegate dataChanged];
        [self.navigationController popViewControllerAnimated:YES];
        if ([EditViewStudentAction isEqualToString:@"EnrollATLeadStudent"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            [self.delegate enrollATSubject];
        }else if ([EditViewStudentAction isEqualToString:@"AddStudentAndSubject"]){
            [self.delegate addStudentSubject];
        }
    });

}

-(BOOL) hasEnoughParentLicenseWithNewStudent:(Student *)newstudent OldStudent:(Student *)oldstudent
{
    int newparentcount=0;
    int oldparentcount=0;
    
    for (int i=0; i<newstudent.phonearray.count; i++) {
        if (((ContactRecord *)[newstudent.phonearray objectAtIndex:i]).enableparentapp) {
            newparentcount+=1;
        }
    }
    
    if (oldstudent) {
        for (int i=0; i<oldstudent.phonearray.count; i++) {
            if (((ContactRecord *)[oldstudent.phonearray objectAtIndex:i]).enableparentapp) {
                oldparentcount+=1;
            }
        }
    }
    
    if (newparentcount>oldparentcount) {
        if ([MyClass getremaininglicensewithtype:@"iparent"]>=newparentcount-oldparentcount) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }

}

-(NSString *) updateStudentWithStudent:(Student *)student Action:(NSString *)action UpdateEnrollmentsTuitionFee:(BOOL)updateenrollmentstuitionfee
{
    //generate json student array
 
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updatestudent" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    
    [dictionary setValue:action forKey:@"action"];

    
    
    if ([action isEqualToString:@"Add"]) {
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.firstname] forKey:@"firstname"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.lastname] forKey:@"lastname"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.othername] forKey:@"othername"];
        [dictionary setValue:student.gender forKey:@"gender"];
        [dictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:student.dateofbirth] forKey:@"dateofbirth"];
        [dictionary setValue:![student.dateofbirth isEqualToString:@""]?@"":student.age forKey:@"age"];
        //[dictionary setValue:student.age forKey:@"age"];
        [dictionary setValue:student.grade forKey:@"grade"];
        [dictionary setValue:student.preferredlanguage forKey:@"preferredlanguage"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.school] forKey:@"school"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.parentname] forKey:@"parentname"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.parentname2] forKey:@"parentname2"];
        [dictionary setValue:[MyClass allspacestrimmed:student.parentemail] forKey:@"parentemail"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.parentaddress] forKey:@"parentaddress"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.remarks] forKey:@"remarks"];
        [dictionary setValue:student.image forKey:@"image"];
        [dictionary setValue:student.studentid forKey:@"studentid"];
        [dictionary setValue:student.studentmedia forKey:@"studentmedia"];
        [dictionary setValue:student.studentsource forKey:@"studentsource"];
        [dictionary setValue:student.fcmemberid forKey:@"fcmemberid"];
        
        [dictionary setValue:student.flag forKey:@"flag"];
        [dictionary setValue:student.status forKey:@"status"];
        [dictionary setValue:student.promotion forKey:@"promotion"];
        [dictionary setValue:student.sendmessage?@"Yes":@"No" forKey:@"sendmessage"];
//        [dictionary setValue:student.math_hq forKey:@"math_hq"];
//        [dictionary setValue:student.eng_hq forKey:@"eng_hq"];
//        [dictionary setValue:student.playmath_hq forKey:@"playmath_hq"];
//        [dictionary setValue:student.spark_hq forKey:@"spark_hq"];
//        [dictionary setValue:student.htalk_hq forKey:@"htalk_hq"];
        [dictionary setValue:student.leadkey forKey:@"leadkey"];
        [dictionary setValue:student.ddaenabled?@"Yes":@"No" forKey:@"ddaenabled"];
        [dictionary setValue:student.ddaaccountno forKey:@"ddaaccountno"];
        [dictionary setValue:student.ddaaccountname forKey:@"ddaaccountname"];
        [dictionary setValue:student.ddadebtorreference forKey:@"ddadebtorreference"];
        [dictionary setValue:student.ddalimit forKey:@"ddalimit"];
        [dictionary setValue:student.extrafield1 forKey:@"extrafield1"];
        [dictionary setValue:student.extrafield2 forKey:@"extrafield2"];
    }else{
        [dictionary setValue:student.studentkey forKey:@"studentkey"];
        
        if (![student.firstname isEqualToString:EditViewStudent.firstname]) {
            [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.firstname] forKey:@"firstname"];
        }

        if (![student.lastname isEqualToString:EditViewStudent.lastname]) {
            [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.lastname] forKey:@"lastname"];
        }
        
        if (![student.othername isEqualToString:EditViewStudent.othername]) {
            [dictionary setValue:[MyClass leadingtrailingspacestrimmed:student.othername] forKey:@"othername"];
        }
        
        if (![student.gender isEqualToString:EditViewStudent.gender]) {
            [dictionary setValue:student.gender forKey:@"gender"];
        }
        
        if(![student.dateofbirth isEqualToString:@""]){
            //dob entered
            if (![student.dateofbirth isEqualToString:/*[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:*/EditViewStudent.dateofbirth/*]*/]) {
                [dictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:student.dateofbirth] forKey:@"dateofbirth"];
            }
            
            if (![EditViewStudent.age isEqualToString:@""]) {
                [dictionary setValue:@"" forKey:@"age"];
            }
        }else{
            //age entered
            if (![EditViewStudent.dateofbirth isEqualToString:@""]) {
                [dictionary setValue:@"" forKey:@"dateofbirth"];
            }
            
            if (![student.age isEqualToString:EditViewStudent.age]) {
                [dictionary setValue:student.age forKey:@"age"];
            }
        }
        
        if (![student.grade isEqualToString:EditViewStudent.grade]) {
            [dictionary setValue:student.grade forKey:@"grade"];
        }
        
        if (![student.preferredlanguage isEqualToString:EditViewStudent.preferredlanguage]) {
            [dictionary setValue:student.preferredlanguage forKey:@"preferredlanguage"];
        }
        
        if (![student.school isEqualToString:EditViewStudent.school]) {
            [dictionary setValue:student.school forKey:@"school"];
        }
        
        if (![student.parentname isEqualToString:EditViewStudent.parentname]) {
            [dictionary setValue:student.parentname forKey:@"parentname"];
        }
        
        if (![student.parentname2 isEqualToString:EditViewStudent.parentname2]) {
            [dictionary setValue:student.parentname2 forKey:@"parentname2"];
        }
        
        if (![student.parentemail isEqualToString:EditViewStudent.parentemail]) {
            [dictionary setValue:student.parentemail forKey:@"parentemail"];
        }
        
        if (![student.parentaddress isEqualToString:EditViewStudent.parentaddress]) {
            [dictionary setValue:student.parentaddress forKey:@"parentaddress"];
        }

        if (![student.remarks isEqualToString:EditViewStudent.remarks]) {
            [dictionary setValue:student.remarks forKey:@"remarks"];
        }
        
        if (![student.image isEqualToString:EditViewStudent.image]) {
            [dictionary setValue:student.image forKey:@"image"];
        }
        
        if (![student.studentid isEqualToString:EditViewStudent.studentid]) {
            [dictionary setValue:student.studentid forKey:@"studentid"];
        }
        
        if (![student.fcmemberid isEqualToString:EditViewStudent.fcmemberid]) {
            [dictionary setValue:student.fcmemberid forKey:@"fcmemberid"];
        }
        
        if (![student.studentmedia isEqualToString:EditViewStudent.studentmedia]) {
            [dictionary setValue:student.studentmedia forKey:@"studentmedia"];
        }
        
        if (![student.studentsource isEqualToString:EditViewStudent.studentsource]) {
            [dictionary setValue:student.studentsource forKey:@"studentsource"];
        }
        
        if (student.ddaenabled != EditViewStudent.ddaenabled) {
            [dictionary setValue:student.ddaenabled?@"Yes":@"No" forKey:@"ddaenabled"];
        }
        
        if (![student.ddaaccountno isEqualToString:EditViewStudent.ddaaccountno]) {
            [dictionary setValue:student.ddaaccountno forKey:@"ddaaccountno"];
        }
        
        if (![student.ddaaccountname isEqualToString:EditViewStudent.ddaaccountname]) {
            [dictionary setValue:student.ddaaccountname forKey:@"ddaaccountname"];
        }
        
        if (![student.ddadebtorreference isEqualToString:EditViewStudent.ddadebtorreference]) {
            [dictionary setValue:student.ddadebtorreference forKey:@"ddadebtorreference"];
        }
        
        if (![student.ddalimit isEqualToString:EditViewStudent.ddalimit]) {
            [dictionary setValue:student.ddalimit forKey:@"ddalimit"];
        }
        
        if (![student.extrafield1 isEqualToString:EditViewStudent.extrafield1]) {
            [dictionary setValue:student.extrafield1 forKey:@"extrafield1"];
        }
        
        if (![student.extrafield2 isEqualToString:EditViewStudent.extrafield2]) {
            [dictionary setValue:student.extrafield2 forKey:@"extrafield2"];
        }
        
        if (updateenrollmentstuitionfee) {
            [dictionary setValue:@"Yes" forKey:@"updateenrollmentstuitionfee"];
        }
    }
    
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonphonecontactarray=[[NSArray alloc]init];
    NSArray *jsonsiblingarray=[[NSArray alloc]init];
    ContactRecord *contactobject=[[ContactRecord alloc]init];
    

    
    //generate json phone contact array
    if ([action isEqualToString:@"Add"] || phonearraychanged) {
        if (student.phonearray.count>0) {
            
            arrayOfDicts = [[NSMutableArray alloc] init];
            keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"studentkey",@"type",@"relationship",@"contact",@"enableparentapp",@"primarycontact",@"enablesms",@"iso_code",@"enablewechat",nil];
            
            for (int i = 0; i<student.phonearray.count; i++) {
                contactobject=[student.phonearray objectAtIndex:i];

                values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,student.studentkey,contactobject.type,contactobject.relationship,contactobject.contact,contactobject.enableparentapp?@"Yes":@"No",contactobject.primarycontact?@"Yes":@"No",contactobject.enablesms?@"Yes":@"No",contactobject.iso_code,contactobject.enablewechat?@"Yes":@"No", nil];
                dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [arrayOfDicts addObject:dict];
                
            }
            jsonphonecontactarray = [NSArray arrayWithArray:arrayOfDicts];
            
            
        }
        [dictionary setValue:jsonphonecontactarray forKey:@"phonearray"];
    }
    
    if ([action isEqualToString:@"Add"] || siblingarraychanged) {
        //generate json phone contact array
        if (student.siblingarray.count>0) {
            
            arrayOfDicts = [[NSMutableArray alloc] init];
            keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"siblingstudentkey",@"relationship",nil];
            
            for (int i = 0; i<student.siblingarray.count; i++) {
                siblingobject=[student.siblingarray objectAtIndex:i];
                values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,siblingobject.studentkey,siblingobject.relationship,nil];
                dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [arrayOfDicts addObject:dict];
            }
            jsonsiblingarray = [NSArray arrayWithArray:arrayOfDicts];
            
        }
        [dictionary setValue:jsonsiblingarray forKey:@"siblingarray"];
    }


    
    __block NSString *result=nil;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                result= [[JSONArray objectAtIndex:0] objectForKey:@"studentkey"];
            }
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
    
    __block NSString *result=nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
            result= [[JSONArray objectAtIndex:0] objectForKey:@"studentkey"];
        }
    } else {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", error);
    }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}



-(void) uploadimagestudentkey:(NSString *)studentkey
{
    
    if (imagedeleted) {
        //delete image file
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletestudentimage&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey];
        
        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // handle response
            
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
    }else if (imageadded || imageedited){
        //NSData *imageData = UIImageJPEGRepresentation(studentimage.image,0.8);     //change Image to NSData
        NSData *imageData = [MyClass returnCompressedImageDataWithImage:studentimage.image];
        
        if (imageData != nil){
            //NSString *urlString =[NSString stringWithFormat:@"%@",globalvariables.generalphpfullpath];
            
            //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
            //[request setURL:[NSURL URLWithString:urlString]];
            //[request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            //NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            //[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            // add parameters
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
            //add image data
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@##student_%@_%@.jpg\"\r\n",globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //  parameter action
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"postaction\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"imageupload" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            [MyClass callPOSTwithData:body Boundary:boundary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"File uploaded: %@",returnString);
                }
            }];
            
            /*
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"File uploaded: %@",returnString);
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
        }
    }
}

-(IBAction) cancelStudent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate cancelStudent];
    
    if ([EditViewStudentAction isEqualToString:@"AddSiblingStudent"]) {
        if (workingStudent.siblingarray.count>0) {
            [self.delegate gotostudentprofile:((SiblingRecord *)[workingStudent.siblingarray firstObject]).studentkey submenu:0 classkeys:nil saleskey:nil];
        }
    }
}

/*
-(void) deleteStudent:(NSString *)studentkey
{
    [self confirmdeletestudent:EditViewStudent.studentkey];
}*/


-(void) confirmdeletestudent:(NSString *)studentkey
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate deleteStudent:studentkey];
}

/*
- (IBAction)addphotobuttonpressed:(id)sender {
    
    [self popupimagepicker];
    
}*/

- (IBAction)addphotobuttonpressed:(id)sender {
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add"];
    }else{
        [self addphotofromsource:@"library"];
    }
}

-(void) popupaddphotodialogueboxwithoption:(NSString *)option
{
        [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"PhotoSource" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addphotobutton ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Take Photo",@"Photo Library", nil] Title:nil];
    /*
    UIView *dialogueview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    UIButton *TakePhotobutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [TakePhotobutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    TakePhotobutton.titleLabel.font=[UIFont systemFontOfSize:17];
    TakePhotobutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [TakePhotobutton setTitle:[MyClass returntitlewithtitle:@"Take Photo"] forState:UIControlStateNormal];
    [TakePhotobutton addTarget:self action:@selector(takephotobuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:TakePhotobutton];
    
    UIButton *PhotoLibrarybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [PhotoLibrarybutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    PhotoLibrarybutton.titleLabel.font=[UIFont systemFontOfSize:17];
    PhotoLibrarybutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [PhotoLibrarybutton setTitle:[MyClass returntitlewithtitle:@"Photo Library"] forState:UIControlStateNormal];
    [PhotoLibrarybutton addTarget:self action:@selector(photolibrarybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:PhotoLibrarybutton];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [dialogueview addSubview:separator];
    
    UIViewController *dialoguevc=[[UIViewController alloc]init];
    dialoguevc.preferredContentSize=CGSizeMake(dialogueview.frame.size.width, dialogueview.frame.size.height);
    dialoguevc.view=dialogueview;
    dialoguevc.modalPresentationStyle=UIModalPresentationPopover;
    mypopovercontroller=dialoguevc.popoverPresentationController;
    mypopovercontroller.delegate=self;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionLeft;
    mypopovercontroller.sourceView=addphotobutton;
    mypopovercontroller.sourceRect=addphotobutton.bounds;
    
    [self presentViewController:dialoguevc animated:YES completion:nil];*/

}



-(void) addphotofromsource:(NSString *)source
{
    imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.allowsEditing=NO;
    
    
    
    if ([source isEqualToString:@"camera"]) {
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.view.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        [MasterView addSubview:imagepicker.view];
        
        self.navigationItem.leftBarButtonItem.enabled=NO;
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.title=[MyClass returntitlewithtitle:@"Take Photo"];
        
        
    }else{
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        imagepicker.modalPresentationStyle=UIModalPresentationPopover;
        mypopovercontroller=imagepicker.popoverPresentationController;
        mypopovercontroller.delegate=self;
        mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionLeft;
        mypopovercontroller.sourceView=addphotobutton;
        mypopovercontroller.sourceRect=addphotobutton.bounds;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
}



-(void) photolibrarybuttonpressed
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"library"];
}

-(void) takephotobuttonpressed
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"camera"];
}


- (void) deletephotobuttonpressed:(id)sender
{
    studentimage.image=nil;
    addphotobutton.hidden=NO;
    editphotobutton.hidden=YES;
    deletephotobutton.hidden=YES;
    imagedeleted=TRUE;
}

- (void)editphotobuttonpressed:(id)sender {
    
    //[self popupimagepicker];
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add"];
    }else{
        [self addphotofromsource:@"library"];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];//info[UIImagePickerControllerEditedImage];
    
    [self.studentimage setImage:[self resizeImageWithImage:chosenImage ForSize:CGSizeMake(548, 640)]];

    if ([EditViewStudent.image isEqualToString:@"Yes"]) {
        imageedited=TRUE;
    }else{
        imageadded=TRUE;
    }
    imagedeleted=FALSE;
    
    addphotobutton.hidden=YES;
    editphotobutton.hidden=NO;
    deletephotobutton.hidden=NO;
    
    //if (imagepicker.isBeingPresented) {
        [imagepicker dismissViewControllerAnimated:YES completion:nil];
    //}else{
        [imagepicker.view removeFromSuperview];
        self.navigationItem.leftBarButtonItem.enabled=YES;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.navigationItem.title=nil;
    //}
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //if ([mypopovercontroller presentingViewController].isBeingPresented) {
        [imagepicker dismissViewControllerAnimated:YES completion:nil];
    //}else{
        [imagepicker.view removeFromSuperview];
        self.navigationItem.leftBarButtonItem.enabled=YES;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.navigationItem.title=nil;
    //}
}


- (UIImage*)resizeImageWithImage:(UIImage *)sourceImage ForSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==studentTable) {
        if ([EditViewStudentAction isEqualToString:@"EditStudent"] && [globalvariables.leftmenuindex isEqualToString:@"1"]) {
            return 5;
        }else{
            return 4;
        }
    }else{
        return 1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==SiblingTable){
        return  workingStudent.siblingarray.count;
    }else if (tableView==studentTable){
        if (section==0) {
//            return globalvariables.centerrecord.studentextrafield1?12:11;
            return 13;
        }else if (section==1){
            return 5;
        }else if (section==2){
            return globalvariables.centerrecord.ddaenabled?5:0;
        }else if (section==3){
            return 1;
        }else if (section==4){
            return 1;
        }
    }else if (tableView==phonetypetable){
        return phonetypearray.count;
    }else if (tableView==schooltable){
        return filteredschoolarray.count;
    }else if (tableView==agetable){
        return agearray.count;
    }else if (tableView==preferredlanguagetable){
        return preferredlanguagearray.count;
    }else if (tableView==gradetable){
        return gradearray.count;
    }else if (tableView==sourcetable){
        return sourcearray.count;
    }else if (tableView==mediatable){
        return mediaarray.count;
    }else if (tableView==extrafield2table){
        return extrafield2array.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView==SiblingTable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            siblingnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 112, 21)];
            siblingnamelabel.font=[UIFont systemFontOfSize:12];
            siblingnamelabel.textColor=[UIColor blackColor];
            siblingnamelabel.tag=701;
            siblingnamelabel.numberOfLines=0;
            siblingnamelabel.minimumScaleFactor=0.7;
            siblingnamelabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:siblingnamelabel];
            
            
            siblingrelationshiplabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 112, 12)];
            siblingrelationshiplabel.font=[UIFont systemFontOfSize:10];
            siblingrelationshiplabel.adjustsFontSizeToFitWidth=YES;
            siblingrelationshiplabel.textColor=[UIColor grayColor];
            siblingrelationshiplabel.tag=702;
            [cell.contentView addSubview:siblingrelationshiplabel];
            
            
        }else{
            siblingnamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            siblingrelationshiplabel=(UILabel *)[cell.contentView viewWithTag:702];

        }
        
        siblingobject=[workingStudent.siblingarray objectAtIndex:indexPath.row];
        
        siblingnamelabel.text=[MyClass returnStudentnameWithStudentkey:siblingobject.studentkey option:@"fullbutid"];//siblingobject.studentname;
        siblingrelationshiplabel.text=[MyClass returntitlewithtitle:siblingobject.relationship];
        
        
        
        siblingnamelabel.frame=CGRectMake(5, 3, 112, 40);
        [siblingnamelabel sizeToFit];
        
        if (siblingnamelabel.frame.size.height>38-12-2) {
            siblingnamelabel.frame=CGRectMake(5, 3, siblingnamelabel.frame.size.width, 38-12-2);
        }else{
            siblingnamelabel.frame=CGRectMake(5, (42-siblingnamelabel.frame.size.height-2-12)/2, siblingnamelabel.frame.size.width, siblingnamelabel.frame.size.height);
        }
        
        siblingrelationshiplabel.frame=CGRectMake(5, siblingnamelabel.frame.origin.y+siblingnamelabel.frame.size.height+2, 112, 12);
        
    }else if (tableView==studentTable){
        
        UILabel *studentlabel;
        UISwitch *menuswitch;

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Name"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                lastnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 120, 30)];
                lastnametext.font=[UIFont systemFontOfSize:15];
                lastnametext.textColor=[UIColor darkGrayColor];
                lastnametext.textAlignment=NSTextAlignmentRight;
                lastnametext.text=workingStudent.lastname;
                lastnametext.borderStyle = UITextBorderStyleRoundedRect;
                lastnametext.placeholder=[MyClass returntitlewithtitle:@"student_Last name_placeholder"];
                [lastnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:lastnametext];
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;

                
                firstnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 186, 30)];
                firstnametext.font=[UIFont systemFontOfSize:15];
                firstnametext.textColor=[UIColor darkGrayColor];
                firstnametext.textAlignment=NSTextAlignmentRight;
                firstnametext.text=workingStudent.firstname;
                firstnametext.borderStyle = UITextBorderStyleRoundedRect;
                firstnametext.placeholder=[MyClass returntitlewithtitle:@"student_First name_placeholder"];
                [firstnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:firstnametext];

                othernametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-327, 5, 120, 30)];
                othernametext.font=[UIFont systemFontOfSize:15];
                othernametext.textColor=[UIColor darkGrayColor];
                othernametext.textAlignment=NSTextAlignmentRight;
                othernametext.text=workingStudent.othername;
                othernametext.borderStyle = UITextBorderStyleRoundedRect;
                othernametext.placeholder=[MyClass returntitlewithtitle:@"student_Other name_placeholder"];
                [othernametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:othernametext];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Student ID"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentidtext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                studentidtext.font=[UIFont systemFontOfSize:15];
                studentidtext.textColor=[UIColor darkGrayColor];
                studentidtext.textAlignment=NSTextAlignmentRight;
                studentidtext.text=workingStudent.studentid;
                studentidtext.borderStyle = UITextBorderStyleRoundedRect;
                studentidtext.placeholder=globalvariables.centerrecord.autofillstudentid && ([EditViewStudentAction isEqualToString:@"AddNewStudent"] || [EditViewStudentAction isEqualToString:@"AddDTStudent"] || [EditViewStudentAction isEqualToString:@"EnrollLead"] || [EditViewStudentAction isEqualToString:@"EnrollLeadAndSubject"] || [EditViewStudentAction isEqualToString:@"AddSiblingStudent"] )?[MyClass returntitlewithtitle:@"Automatically assign"]:[MyClass returntitlewithtitle:@"Student ID"];
                [studentidtext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                studentidtext.enabled=![globalvariables.centerrecord.fcgroup isEqualToString:@"popularlearning"];
                [cell.contentView addSubview:studentidtext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2){
                if (![((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@""]) {
                    studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                    studentlabel.font=[UIFont systemFontOfSize:17];
                    studentlabel.textColor=[UIColor blackColor];
                    studentlabel.text=[MyClass returntitlewithtitle:@"FC Member ID"];
                    studentlabel.tag=301;
                    [cell.contentView addSubview:studentlabel];
                    
                    fcmemberidtext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                    fcmemberidtext.font=[UIFont systemFontOfSize:15];
                    fcmemberidtext.textColor=[UIColor darkGrayColor];
                    fcmemberidtext.textAlignment=NSTextAlignmentRight;
                    fcmemberidtext.text=workingStudent.fcmemberid;
                    fcmemberidtext.borderStyle = UITextBorderStyleRoundedRect;
                    fcmemberidtext.placeholder=[MyClass returntitlewithtitle:@"FC Member ID"];
                    [fcmemberidtext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:fcmemberidtext];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.hidden=NO;
                }else{
                    cell.hidden=YES;
                }
            }else if (indexPath.row==3){
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Gender"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                scgender = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Male"],[MyClass returntitlewithtitle:@"Female"],nil]];
                scgender.frame = CGRectMake(selfViewWidth-450, 5, 243, 30);
                [scgender addTarget:self action:@selector(selectgender:) forControlEvents: UIControlEventValueChanged];
                scgender.selectedSegmentIndex=[workingStudent.gender isEqualToString:@"Male"] ? 0:1;
                [cell.contentView addSubview:scgender];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Date of Birth"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=[MyClass returndateformatwithdate:workingStudent.dateofbirth];
                [cell.contentView addSubview:studentlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==5){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Age"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=workingStudent.age;
                [cell.contentView addSubview:studentlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==6){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Grade"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=workingStudent.grade;
                [cell.contentView addSubview:studentlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==7){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"School"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                schooltext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                schooltext.font=[UIFont systemFontOfSize:15];
                schooltext.textColor=[UIColor darkGrayColor];
                schooltext.textAlignment=NSTextAlignmentRight;
                schooltext.text=workingStudent.school;
                schooltext.borderStyle = UITextBorderStyleRoundedRect;
                schooltext.clearButtonMode = UITextFieldViewModeWhileEditing;
                schooltext.placeholder=[MyClass returntitlewithtitle:@"School"];
                [schooltext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:schooltext];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==8){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Preferred Language"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=[MyClass returntitlewithtitle:workingStudent.preferredlanguage];
                [cell.contentView addSubview:studentlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==9){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Student Media"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-539, 0, 325, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=workingStudent.studentmedia;
                [cell.contentView addSubview:studentlabel];
                
                if (MediaArray.count>0) {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
                
                
            }else if (indexPath.row==10){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Student Source"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-539, 0, 325, 40)];
                studentlabel.font=[UIFont systemFontOfSize:15];
                studentlabel.textColor=[UIColor darkGrayColor];
                studentlabel.textAlignment=NSTextAlignmentRight;
                studentlabel.text=workingStudent.studentsource;
                [cell.contentView addSubview:studentlabel];
                if (SourceArray.count>0) {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
            }else if (indexPath.row==11){
                if (globalvariables.centerrecord.studentextrafield1) {
                    studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                    studentlabel.font=[UIFont systemFontOfSize:17];
                    studentlabel.textColor=[UIColor blackColor];
                    studentlabel.text=[MyClass returntitlewithtitle:@"ExtraField1"];
                    studentlabel.tag=301;
                    [cell.contentView addSubview:studentlabel];
                    
                    extrafield1text = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                    extrafield1text.font=[UIFont systemFontOfSize:15];
                    extrafield1text.textColor=[UIColor darkGrayColor];
                    extrafield1text.textAlignment=NSTextAlignmentRight;
                    extrafield1text.text=workingStudent.extrafield1;
                    extrafield1text.borderStyle = UITextBorderStyleRoundedRect;
                    extrafield1text.clearButtonMode = UITextFieldViewModeWhileEditing;
                    extrafield1text.placeholder=[MyClass returntitlewithtitle:@"ExtraField1"];
                    [extrafield1text addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:extrafield1text];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.hidden=YES;
                }
            }else if(indexPath.row==12){
                if(![globalvariables.centerrecord.studentextrafield2 isEqualToString:@""]){
                    studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                    studentlabel.font=[UIFont systemFontOfSize:17];
                    studentlabel.textColor=[UIColor blackColor];
                    studentlabel.text=[MyClass returntitlewithtitle:@"ExtraField2"];
                    studentlabel.tag=301;
                    [cell.contentView addSubview:studentlabel];
                    
                    studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-539, 0, 325, 40)];
                    studentlabel.font=[UIFont systemFontOfSize:15];
                    studentlabel.textColor=[UIColor darkGrayColor];
                    studentlabel.textAlignment=NSTextAlignmentRight;
                    studentlabel.text=[MyClass returntitlewithtitle:workingStudent.extrafield2];
                    [cell.contentView addSubview:studentlabel];
                    //                if (SourceArray.count>0) {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    //                }else{
                    //                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                    //                }
                }else{
                    cell.hidden=YES;
                }
            }
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Parent Name"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                parentnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                parentnametext.font=[UIFont systemFontOfSize:15];
                parentnametext.textColor=[UIColor darkGrayColor];
                parentnametext.textAlignment=NSTextAlignmentRight;
                parentnametext.text=workingStudent.parentname;
                parentnametext.borderStyle = UITextBorderStyleRoundedRect;
                parentnametext.placeholder=[MyClass returntitlewithtitle:@"Parent Name"];
                [parentnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentnametext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Parent Name 2"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                parentname2text = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                parentname2text.font=[UIFont systemFontOfSize:15];
                parentname2text.textColor=[UIColor darkGrayColor];
                parentname2text.textAlignment=NSTextAlignmentRight;
                parentname2text.text=workingStudent.parentname2;
                parentname2text.borderStyle = UITextBorderStyleRoundedRect;
                parentname2text.placeholder=[MyClass returntitlewithtitle:@"Parent Name 2"];
                [parentname2text addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentname2text];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2){
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Email"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                parentemailtext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                parentemailtext.font=[UIFont systemFontOfSize:15];
                parentemailtext.textColor=[UIColor darkGrayColor];
                parentemailtext.textAlignment=NSTextAlignmentRight;
                parentemailtext.text=workingStudent.parentemail;
                parentemailtext.borderStyle = UITextBorderStyleRoundedRect;
                parentemailtext.placeholder=[MyClass returntitlewithtitle:@"Email"];
                [parentemailtext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentemailtext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==3){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Address"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                parentaddresstext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                parentaddresstext.font=[UIFont systemFontOfSize:15];
                parentaddresstext.textColor=[UIColor darkGrayColor];
                parentaddresstext.textAlignment=NSTextAlignmentRight;
                parentaddresstext.text=workingStudent.parentaddress;
                parentaddresstext.borderStyle = UITextBorderStyleRoundedRect;
                parentaddresstext.placeholder=[MyClass returntitlewithtitle:@"Address"];
                [parentaddresstext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentaddresstext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4){
                
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Contact"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                
                
                for (int i=0; i<workingStudent.phonearray.count; i++) {
                    pceditbutton=[[UIButton alloc]initWithFrame:CGRectMake(140+(i%maxcontactperline)*contactcellwidth-15, 4+(i/maxcontactperline)*53, 45, 15)];
                    [pceditbutton setImage:[UIImage imageNamed:@"paymentoverridebutton.png"] forState:UIControlStateNormal];
                    [pceditbutton applyImageInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
                    [pceditbutton addTarget:self action:@selector(pceditbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    pceditbutton.tag=i;
                    [cell.contentView addSubview:pceditbutton];
                    
                    
                    pclabel=[[UILabel alloc]initWithFrame:CGRectMake(159+(i%maxcontactperline)*contactcellwidth, 2+(i/maxcontactperline)*53, 120, 21)];
                    pclabel.textColor=[UIColor blackColor];
                    pclabel.font=[UIFont systemFontOfSize:12];
                    pclabel.tag=4000+i;
                    pclabel.text=[MyClass returntitlewithtitle:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).relationship];
                    [cell.contentView addSubview:pclabel];
                    
                    parentcontacttext=[[UITextField alloc]initWithFrame:CGRectMake(140+(i%maxcontactperline)*contactcellwidth, 20+(i/maxcontactperline)*53, contactcellwidth-2, 30)];
                    parentcontacttext.font=[UIFont systemFontOfSize:15];
                    parentcontacttext.textColor=[UIColor blackColor];
                    parentcontacttext.text=[MyClass returnLocalNumberWithContact:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).contact ISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).iso_code];
                    parentcontacttext.borderStyle = UITextBorderStyleRoundedRect;
                    parentcontacttext.placeholder=[MyClass returntitlewithtitle:@"Phone"];
                    [parentcontacttext addTarget:self action:@selector(updateparentcontacttext:) forControlEvents:UIControlEventEditingChanged];
                    parentcontacttext.tag=1000+i;
                    
                    parentcontacttext.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
                    [parentcontacttext setLeftViewMode:UITextFieldViewModeAlways];
                    
                    
                    [cell.contentView addSubview:parentcontacttext];
                    

                    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, parentcontacttext.frame.size.height)];
                    
                    UIImageView *parentimage=[[UIImageView alloc]initWithFrame:CGRectMake(5,(parentcontacttext.frame.size.height-18)/2,18,18)];
                    parentimage.layer.cornerRadius=4;
                    parentimage.layer.masksToBounds=YES;
                    [parentimage setImage:[UIImage imageNamed:@"primarycontact_icon.png"]];
                    parentimage.layer.opacity=((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).primarycontact?1:0.2;
                    
                    [spacerView addSubview:parentimage];
                    
                    UIButton *button=[[UIButton alloc]initWithFrame:parentimage.frame];
                    [button addTarget:self action:@selector(primarycontactbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag=i;
                    [spacerView addSubview:button];
                    
                    parentimage=[[UIImageView alloc]initWithFrame:CGRectMake(26,(parentcontacttext.frame.size.height-18)/2,18,18)];
                    parentimage.layer.cornerRadius=4;
                    parentimage.layer.masksToBounds=YES;
                    [MyClass downloadImageWithImageview:parentimage gender:nil type:@"studentappimage" typekey:globalvariables.centerrecord.standaloneparentappid image:@"Yes" async:YES];
                    parentimage.layer.opacity=((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).enableparentapp?1:0.2;
                    [spacerView addSubview:parentimage];

                    
                    button=[[UIButton alloc]initWithFrame:parentimage.frame];
                    [button addTarget:self action:@selector(studentappbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag=i;
                    [spacerView addSubview:button];
                    
                    parentimage=[[UIImageView alloc]initWithFrame:CGRectMake(47,(parentcontacttext.frame.size.height-18)/2,18,18)];
                    parentimage.layer.cornerRadius=4;
                    parentimage.layer.masksToBounds=YES;
                    [parentimage setImage:[UIImage imageNamed:@"messagecenter_icon.png"]];
                    parentimage.layer.opacity=((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).enablesms?1:0.2;
                    
                    [spacerView addSubview:parentimage];
                    
                    button=[[UIButton alloc]initWithFrame:parentimage.frame];
                    [button addTarget:self action:@selector(smsbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag=i;
                    [spacerView addSubview:button];
                    
                    parentimage=[[UIImageView alloc]initWithFrame:CGRectMake(68,(parentcontacttext.frame.size.height-18)/2,18,18)];
                    parentimage.layer.cornerRadius=4;
                    parentimage.layer.masksToBounds=YES;
                    [parentimage setImage:[UIImage imageNamed:@"wechat_icon.png"]];
                    parentimage.layer.opacity=((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).enablewechat?1:0.2;
                    
                    [spacerView addSubview:parentimage];
                    
                    button=[[UIButton alloc]initWithFrame:parentimage.frame];
                    [button addTarget:self action:@selector(wechatbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag=i;
                    [spacerView addSubview:button];
                    
                    UIImageView *ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(89, (parentcontacttext.frame.size.height-18)/2, 27, 18)];
                    [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).iso_code image:@"Yes" async:YES];
                    ccimage.contentMode=UIViewContentModeScaleAspectFill;
                    ccimage.layer.cornerRadius=3;
                    ccimage.layer.masksToBounds=YES;
                    [spacerView addSubview:ccimage];
                    
                    
                    UIButton *ccbutton=[[UIButton alloc]initWithFrame:ccimage.frame];
                    [ccbutton addTarget:self action:@selector(ccbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    ccbutton.tag=i;
                    [spacerView addSubview:ccbutton];
                    
                    
                    UILabel *cclabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
                    cclabel.font=[UIFont systemFontOfSize:15];
                    cclabel.textColor=[UIColor darkGrayColor];
                    cclabel.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).iso_code]];
                    [cclabel sizeToFit];
                    cclabel.frame=CGRectMake(89+3+27, 0, cclabel.frame.size.width, 30);
                    
                    [spacerView addSubview:cclabel];
                    
                    spacerView.frame=CGRectMake(0, 0, 89+27+cclabel.frame.size.width, parentcontacttext.frame.size.height);// = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, parentcontacttext.frame.size.height)];
                    
                    [parentcontacttext setLeftView:spacerView];
                    

                    
                    if (i==workingStudent.phonearray.count-1){
                        pcaddbutton=[[UIButton alloc]initWithFrame:CGRectMake(140+contactcellwidth*(i%maxcontactperline+1)+5, 28+(i/maxcontactperline)*53-5, 15+15, 15+10)];
                        [pcaddbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                        [pcaddbutton applyImageInsets:UIEdgeInsetsMake(5, 0, 5, 15)];
                        [pcaddbutton addTarget:self action:@selector(pcaddbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                        pcaddbutton.tag=i;
                        [cell.contentView addSubview:pcaddbutton];
                    }
                    
                }


                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }else if (indexPath.section==2){
            if (indexPath.row==0) {
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Enable"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(selfViewWidth-switchSize.width-207,4.0f,switchSize.width,switchSize.height);
                //menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(enableddaenabled:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=workingStudent.ddaenabled;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==1){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Account Number"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                ddaaccountnotext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                ddaaccountnotext.font=[UIFont systemFontOfSize:15];
                ddaaccountnotext.textColor=[UIColor darkGrayColor];
                ddaaccountnotext.textAlignment=NSTextAlignmentRight;
                ddaaccountnotext.text=workingStudent.ddaaccountno;
                ddaaccountnotext.borderStyle = UITextBorderStyleRoundedRect;
                ddaaccountnotext.placeholder=[MyClass returntitlewithtitle:@"Account Number"];
                [ddaaccountnotext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:ddaaccountnotext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Account Name"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                ddaaccountnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                ddaaccountnametext.font=[UIFont systemFontOfSize:15];
                ddaaccountnametext.textColor=[UIColor darkGrayColor];
                ddaaccountnametext.textAlignment=NSTextAlignmentRight;
                ddaaccountnametext.text=workingStudent.ddaaccountname;
                ddaaccountnametext.borderStyle = UITextBorderStyleRoundedRect;
                ddaaccountnametext.placeholder=[MyClass returntitlewithtitle:@"Account Name"];
                [ddaaccountnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:ddaaccountnametext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"Debtor Reference"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                ddadebtorreferencetext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                ddadebtorreferencetext.font=[UIFont systemFontOfSize:15];
                ddadebtorreferencetext.textColor=[UIColor darkGrayColor];
                ddadebtorreferencetext.textAlignment=NSTextAlignmentRight;
                ddadebtorreferencetext.text=workingStudent.ddadebtorreference;
                ddadebtorreferencetext.borderStyle = UITextBorderStyleRoundedRect;
                ddadebtorreferencetext.placeholder=[MyClass returntitlewithtitle:@"Debtor Reference"];
                [ddadebtorreferencetext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:ddadebtorreferencetext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4){
                studentlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                studentlabel.font=[UIFont systemFontOfSize:17];
                studentlabel.textColor=[UIColor blackColor];
                studentlabel.text=[MyClass returntitlewithtitle:@"DDA_Limit"];
                studentlabel.tag=301;
                [cell.contentView addSubview:studentlabel];
                
                ddalimittext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                ddalimittext.font=[UIFont systemFontOfSize:15];
                ddalimittext.textColor=[UIColor darkGrayColor];
                ddalimittext.textAlignment=NSTextAlignmentRight;
                ddalimittext.text=workingStudent.ddalimit;
                ddalimittext.borderStyle = UITextBorderStyleRoundedRect;
                ddalimittext.placeholder=[MyClass returntitlewithtitle:@"DDA_Limit"];
                [ddalimittext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:ddalimittext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==3){
            remarkstext = [[UITextView alloc]initWithFrame:CGRectMake(10, 3, studentTable.frame.size.width-20, 84)];
            remarkstext.font=[UIFont systemFontOfSize:15];
            remarkstext.textColor=[UIColor darkGrayColor];
            remarkstext.textAlignment=NSTextAlignmentLeft;
            remarkstext.text=workingStudent.remarks;
            remarkstext.delegate=self;
            [cell.contentView addSubview:remarkstext];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==4){
            UIButton *DeleteStudentBtn=[[UIButton alloc]init];
            DeleteStudentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            DeleteStudentBtn.frame=CGRectMake(0, 5, studentTable.frame.size.width, 30);
            DeleteStudentBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            
            DeleteStudentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [DeleteStudentBtn addTarget: self action:@selector(deleteStudentRecord) forControlEvents: UIControlEventTouchUpInside];

            DeleteStudentBtn.enabled=YES;
            [DeleteStudentBtn setTitle:[MyClass returntitlewithtitle:@"Delete Student Record"] forState:UIControlStateNormal];
            [DeleteStudentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [cell.contentView addSubview:DeleteStudentBtn];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else  if (tableView==phonetypetable) {
        static NSString *CellIdentifier = @"Cell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            phonetypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 34)];
            phonetypeLabel.font=[UIFont systemFontOfSize:15];
            phonetypeLabel.textColor=[UIColor darkGrayColor];
            phonetypeLabel.textAlignment=NSTextAlignmentCenter;
            phonetypeLabel.tag=168;
            [cell.contentView addSubview:phonetypeLabel];
            
            
            UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 220, 1)];
            GeneralLabel.backgroundColor=[UIColor lightGrayColor];
            GeneralLabel.alpha=0.3;
            [cell.contentView addSubview:GeneralLabel];
            
        }else{
            phonetypeLabel=(UILabel *)[cell.contentView viewWithTag:168];
        }
        
        if ([addoreditphonebutton isEqualToString:@"edit"] && [((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).relationship isEqualToString:[phonetypearray objectAtIndex:indexPath.row]]) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
        }else{
            cell.backgroundColor=[UIColor clearColor];
        }
        
        phonetypeLabel.text=[MyClass returntitlewithtitle:[phonetypearray objectAtIndex:indexPath.row]];
        
    }else if (tableView==schooltable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, schooltablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=[filteredschoolarray objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==agetable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, agetablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            schoollabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=[agearray objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==gradetable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, gradetablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            schoollabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=[gradearray objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==preferredlanguagetable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, preferredlanguagetablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=[MyClass returntitlewithtitle:[preferredlanguagearray objectAtIndex:indexPath.row]];
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==mediatable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, mediatablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=((MarketingRecord *)[mediaarray objectAtIndex:indexPath.row]).description;
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==sourcetable){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, sourcetablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=((MarketingRecord *)[sourcearray objectAtIndex:indexPath.row]).description;
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }else if (tableView==extrafield2table){
        
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *schoollabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, extrafield2tablewidth-40, 38)];
            schoollabel.font=[UIFont systemFontOfSize:15];
            schoollabel.textColor=[UIColor darkGrayColor];
            schoollabel.tag=701;
            schoollabel.numberOfLines=0;
            schoollabel.minimumScaleFactor=0.7;
            schoollabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:schoollabel];
        }else{
            schoollabel=(UILabel *)[cell.contentView viewWithTag:701];
        }
        
        schoollabel.text=[MyClass returntitlewithtitle:[extrafield2array objectAtIndex:indexPath.row]];
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.05];
    }
    return cell;

    
}

-(void) deleteStudentRecord
{
    [self.view endEditing:YES];
    
    UIAlertController *deletestudent = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Student Record"] message:[NSString stringWithFormat:@"%@ %@?",[MyClass returntitlewithtitle:@"Are you sure to delete"],[MyClass returnStudentnameWithStudentkey:EditViewStudent.studentkey option:@"full"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *enrollmentsalescount=[self retrieveEnrollmentAndSalesCountWithStudentkey:EditViewStudent.studentkey];
        if (enrollmentsalescount) {
            if ([enrollmentsalescount intValue]>0) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student record cannot be deleted"] message:[MyClass returntitlewithtitle:@"There are associated enrollment(s) or sales record(s) for this student"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }else{
                [self confirmdeletestudent:EditViewStudent.studentkey];
            }
        }
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deletestudent dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deletestudent addAction:OKAction];
    [deletestudent addAction:CancelAction];
    
    //[self presentViewController:deletestudent animated:YES completion:nil];
    [MyClass presentViewController:deletestudent View:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==SiblingTable){
        return 44;
    }else if (tableView==studentTable){
        if (indexPath.section==0) {
            if (indexPath.row==2) {
                return [((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@""]?CGFLOAT_MIN:40;
            }else if (indexPath.row==11){
                return globalvariables.centerrecord.studentextrafield1?40:CGFLOAT_MIN;
            }else if (indexPath.row==12){
                return [globalvariables.centerrecord.studentextrafield2 isEqualToString:@""]?CGFLOAT_MIN:40;
            }
            return 40;
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                return 40;
            }else if (indexPath.row==4){
                return 57+(((workingStudent.phonearray.count-1)/maxcontactperline)*53);
            }else{
                return 40;
            }
        }else if (indexPath.section==3){
            return 90;
        }else if (indexPath.section==4){
            return 40;
        }
    }else if (tableView==phonetypetable){
        return 34;
    }
    return 38;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyClass returntitlewithtitle:@"Delete"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==SiblingTable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            
            [workingStudent.siblingarray removeObjectAtIndex:indexPath.row];
            siblingarraychanged=TRUE;
            [SiblingTable reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==SiblingTable) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==studentTable) {
        if (section==0){
            if ([EditViewStudentAction isEqualToString:@"EditStudent"]) {
                return [NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Student Information"],EditViewStudent.studentkey];
            }else{
                return [MyClass returntitlewithtitle:@"Student Information"];
            }
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Parent Information"];
        }else if (section==2){
            if (globalvariables.centerrecord.ddaenabled) {
                return [MyClass returntitlewithtitle:@"Direct Debit Authorization"];
            }
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"General Remarks"];
        }
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (title.length == 0) {
        return nil;
    }
    CGFloat headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, headerHeight)];
    header.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAX(tableView.bounds.size.width - 20, 0), headerHeight)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor secondaryLabelColor];
    titleLabel.text = title;
    [header addSubview:titleLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==studentTable) {
        if (section==2) {
            if (!globalvariables.centerrecord.ddaenabled) {
                return CGFLOAT_MIN;
            }
        }
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==studentTable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if(tableView==SiblingTable){
        studentlistpopovercontroller.siblingrecord=[workingStudent.siblingarray objectAtIndex:indexPath.row];
        studentlistpopovercontroller.selfstudentkey=EditViewStudent.studentkey;
        //[self presentViewController:studentlistpopovercontroller animated:YES completion:nil];
        [MyClass presentViewController:studentlistpopovercontroller View:self];
        
    }else if (tableView==studentTable) {
        if (indexPath.section==0 && indexPath.row==4) {
            [self showsidewindowwithtablename:@"dob"];
        }else if (indexPath.section==0 && indexPath.row==5){
            [self showsidewindowwithtablename:@"age"];
        }else if (indexPath.section==0 && indexPath.row==6){
            [self showsidewindowwithtablename:@"grade"];
        }else if (indexPath.section==0 && indexPath.row==7){
            [self retrieveschoollist];
            [self showsidewindowwithtablename:@"school"];
        }else if (indexPath.section==0 && indexPath.row==8){
            [self showsidewindowwithtablename:@"preferredlanguage"];
        }else if (indexPath.section==0 && indexPath.row==9) {
            if (MediaArray.count>0) {
                [self showsidewindowwithtablename:@"media"];
            }
        }else if (indexPath.section==0 && indexPath.row==10) {
            if (SourceArray.count>0) {
                [self showsidewindowwithtablename:@"source"];
            }
        }else if (indexPath.section==0 && indexPath.row==12) {
            [self showsidewindowwithtablename:@"extrafield2"];
        }
    }else if (tableView==phonetypetable){
        [phonetypetable reloadData];

        if ([addoreditphonebutton isEqualToString:@"add"]) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            
            CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];

                
            [workingStudent.phonearray addObject:[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[phonetypearray objectAtIndex:indexPath.row] contact:local.country_code enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:NO parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:local.iso_code enablewechat:NO] ];
            
        }else{
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).relationship=[phonetypearray objectAtIndex:indexPath.row];
        }
        phonearraychanged=TRUE;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [studentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }else if (tableView==schooltable){
        workingStudent.school=[filteredschoolarray objectAtIndex:indexPath.row];
        schooltext.text=workingStudent.school;
        [self closesidewindow];
    }else if (tableView==agetable){
        workingStudent.dateofbirth=@"";
        workingStudent.age=[agearray objectAtIndex:indexPath.row];
        [studentTable reloadData];
        [self closesidewindow];
    }else if (tableView==gradetable){
        workingStudent.grade=[gradearray objectAtIndex:indexPath.row];
        [studentTable reloadData];
        [self closesidewindow];
    }else if (tableView==preferredlanguagetable){
        workingStudent.preferredlanguage=[preferredlanguagearray objectAtIndex:indexPath.row];
        [studentTable reloadData];
        [self closesidewindow];
    }else if (tableView==mediatable){
        workingStudent.studentmedia=((MarketingRecord *)[mediaarray objectAtIndex:indexPath.row]).description;
        [studentTable reloadData];
        [self closesidewindow];
    }else if (tableView==sourcetable){
        workingStudent.studentsource=((MarketingRecord *)[sourcearray objectAtIndex:indexPath.row]).description;
        [studentTable reloadData];
        [self closesidewindow];
    }else if (tableView==extrafield2table){
        workingStudent.extrafield2=[extrafield2array objectAtIndex:indexPath.row];
        [studentTable reloadData];
        [self closesidewindow];
    }
}

-(void) addsiblingbuttonpressed
{
    studentlistpopovercontroller.siblingrecord=nil;
    studentlistpopovercontroller.selfstudentkey=EditViewStudent.studentkey;
    //[self presentViewController:studentlistpopovercontroller animated:YES completion:nil];
    [MyClass presentViewController:studentlistpopovercontroller View:self];
}

-(void) donesibling:(SiblingRecord *)siblingrecord
{
    if ([siblingrecord.studentkey isEqualToString:@"999999999"]) {
        //add new sibling student
        [self.delegate addNewSiblingStudent];
        EditViewStudentAction=@"AddSiblingStudent";
        [self initializefield];
        [studentTable reloadData];
        
        siblingarraychanged=TRUE;
        
        [workingStudent.siblingarray addObject:[[SiblingRecord alloc]initSiblingRecordwithStudentname:EditViewStudent.firstname Studentkey:EditViewStudent.studentkey Relationship:siblingrecord.relationship]];
        [SiblingTable reloadData];
        
        EditViewStudent=[[Student alloc]init];
        
        [MyClass downloadImageWithImageview:studentimage gender:@"Male" type:@"student" typekey:nil image:@"No" async:YES];
        
        addphotobutton.hidden=NO;
        editphotobutton.hidden=YES;
        deletephotobutton.hidden=YES;
        
        imageadded=FALSE;
        imageedited=FALSE;
        imagedeleted=FALSE;
        phonearraychanged=TRUE;
        siblingarraychanged=TRUE;
        
        
    }else{
        siblingarraychanged=TRUE;
        for (int i=0; i<workingStudent.siblingarray.count; i++) {
            if ([((SiblingRecord *)[workingStudent.siblingarray objectAtIndex:i]).studentkey isEqualToString:siblingrecord.studentkey]) {
                [workingStudent.siblingarray replaceObjectAtIndex:i withObject:siblingrecord];
                [SiblingTable reloadData];
                return;
            }
        }
        
        [workingStudent.siblingarray addObject:siblingrecord];
        
        [SiblingTable reloadData];
    }
}

-(void) closesidewindow
{
    filterviewbutton.layer.opacity=0;
    self.sideSelectionAnimating = YES;
    CGFloat width = [self visibleEditWidth];
    CGFloat height = MAX(self.view.bounds.size.height - 70, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self->sideselectionview.frame=CGRectMake(width, 70, width, height);
    } completion:^(BOOL finished) {
        self.sideSelectionAnimating = NO;
    }];
    
    [studentTable deselectRowAtIndexPath:[studentTable indexPathForSelectedRow] animated:YES];
}

-(void) initializefield
{
    
    if ([EditViewStudentAction isEqualToString:@"EditStudent"]) {
        workingStudent=[[Student alloc]init];
        workingStudent.studentkey=EditViewStudent.studentkey;
        workingStudent.firstname=EditViewStudent.firstname;
        workingStudent.lastname=EditViewStudent.lastname;
        workingStudent.othername=EditViewStudent.othername;
        workingStudent.gender=EditViewStudent.gender;
        
        workingStudent.dateofbirth=EditViewStudent.dateofbirth;
        if (![workingStudent.dateofbirth isEqualToString:@""]){
            workingStudent.age=[MyClass calculateagewithbirthday:workingStudent.dateofbirth];
        }else{
            workingStudent.age=EditViewStudent.age;
        }
        
        workingStudent.grade=EditViewStudent.grade;
        workingStudent.school=EditViewStudent.school;
        workingStudent.preferredlanguage=EditViewStudent.preferredlanguage;
        workingStudent.studentid=EditViewStudent.studentid;
        workingStudent.fcmemberid=EditViewStudent.fcmemberid;
        workingStudent.extrafield1=EditViewStudent.extrafield1;
        workingStudent.extrafield2=EditViewStudent.extrafield2;
        workingStudent.parentname=EditViewStudent.parentname;
        workingStudent.parentname2=EditViewStudent.parentname2;
        workingStudent.parentemail=EditViewStudent.parentemail;
        workingStudent.parentaddress=EditViewStudent.parentaddress;
        workingStudent.remarks=EditViewStudent.remarks;
        workingStudent.studentmedia=EditViewStudent.studentmedia;
        workingStudent.studentsource=EditViewStudent.studentsource;
        workingStudent.ddaenabled=EditViewStudent.ddaenabled;
        workingStudent.ddaaccountno=EditViewStudent.ddaaccountno;
        workingStudent.ddaaccountname=EditViewStudent.ddaaccountname;
        workingStudent.ddadebtorreference=EditViewStudent.ddadebtorreference;
        workingStudent.ddalimit=EditViewStudent.ddalimit;
        
        if (EditViewStudent.phonearray.count==0) {
            CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
            workingStudent.phonearray=[[NSMutableArray alloc]initWithObjects:[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[globalvariables.contactrelationshiparray firstObject] contact:local.country_code enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:YES parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:local.iso_code enablewechat:NO], nil];
        }else{
            workingStudent.phonearray=[[NSMutableArray alloc]init];
            for (int i=0; i<EditViewStudent.phonearray.count; i++) {
                [workingStudent.phonearray addObject:[[ContactRecord alloc]initContactRecordwithtype:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).type relationship:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).relationship contact:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).contact enableparentapp:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).enableparentapp primarycontact:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).primarycontact parentapplastlogin:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).parentapplastlogin enablesms:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).enablesms iso_code:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).iso_code enablewechat:((ContactRecord *)[EditViewStudent.phonearray objectAtIndex:i]).enablewechat]];
            }
        }
        
        workingStudent.siblingarray=[[NSMutableArray alloc]init];
        if (EditViewStudent.siblingarray.count>0) {
            for (int i=0; i<EditViewStudent.siblingarray.count; i++) {
                [workingStudent.siblingarray addObject:[[SiblingRecord alloc]initSiblingRecordwithStudentname:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).studentname Studentkey:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).studentkey Relationship:((SiblingRecord *)[EditViewStudent.siblingarray objectAtIndex:i]).relationship]];
            }
        }
        


        
    }else if([EditViewStudentAction isEqualToString:@"AddDTStudent"] || [EditViewStudentAction isEqualToString:@"EnrollLead"] || [EditViewStudentAction isEqualToString:@"EnrollATLeadStudent"] ){
        workingStudent=[[Student alloc]init];
        workingStudent.studentkey=@"";
        workingStudent.firstname=EditViewStudent.firstname;
        workingStudent.lastname=EditViewStudent.lastname;
        workingStudent.othername=EditViewStudent.othername;
        workingStudent.gender=EditViewStudent.gender;
        workingStudent.dateofbirth=EditViewStudent.dateofbirth;
        
        if (![workingStudent.dateofbirth isEqualToString:@""]){
            workingStudent.age=[MyClass calculateagewithbirthday:EditViewStudent.dateofbirth];
        }else{
            workingStudent.age=EditViewStudent.age;
        }
        
        workingStudent.grade=[EditViewStudent.grade isEqualToString:@""]?((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).defaultstudentgrade:EditViewStudent.grade;
        workingStudent.school=EditViewStudent.school;
        workingStudent.preferredlanguage=EditViewStudent.preferredlanguage;
        workingStudent.studentid=EditViewStudent.studentid;
        workingStudent.parentname=EditViewStudent.parentname;
        workingStudent.parentname2=EditViewStudent.parentname2;
        workingStudent.fcmemberid=EditViewStudent.fcmemberid;
        workingStudent.extrafield1=EditViewStudent.extrafield1;
        workingStudent.extrafield2=EditViewStudent.extrafield2;
        workingStudent.promotion=EditViewStudent.promotion;
        workingStudent.flag=EditViewStudent.flag;
        workingStudent.sendmessage=EditViewStudent.sendmessage;
        workingStudent.status=EditViewStudent.status;
        workingStudent.leadkey=EditViewStudent.leadkey;
        workingStudent.parentemail=EditViewStudent.parentemail;
        workingStudent.parentaddress=EditViewStudent.parentaddress;
        workingStudent.remarks=EditViewStudent.remarks;
        workingStudent.studentmedia=EditViewStudent.studentmedia;
        workingStudent.studentsource=EditViewStudent.studentsource;
        workingStudent.ddaenabled=EditViewStudent.ddaenabled;
        workingStudent.ddaaccountno=EditViewStudent.ddaaccountno;
        workingStudent.ddaaccountname=EditViewStudent.ddaaccountname;
        workingStudent.ddadebtorreference=EditViewStudent.ddadebtorreference;
        workingStudent.ddalimit=EditViewStudent.ddalimit;
        
        workingStudent.phonearray=[[NSMutableArray alloc]initWithArray:EditViewStudent.phonearray];

        
    }else if ([EditViewStudentAction isEqualToString:@"AddNewStudent"]|| [EditViewStudentAction isEqualToString:@"AddStudentAndSubject"]){
        workingStudent=[[Student alloc]init];
        workingStudent.studentkey=@"";
        workingStudent.firstname=@"";
        workingStudent.lastname=@"";
        workingStudent.othername=@"";
        workingStudent.gender=@"Male";
        workingStudent.dateofbirth=@"";
        workingStudent.preferredlanguage=@"Cantonese";
        workingStudent.grade=((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).defaultstudentgrade;
        
        CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
        workingStudent.phonearray=[[NSMutableArray alloc]initWithObjects:[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[globalvariables.contactrelationshiparray firstObject] contact:local.country_code enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:YES parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:local.iso_code enablewechat:NO], nil];
        workingStudent.siblingarray=[[NSMutableArray alloc]init];
        
        workingStudent.school=@"";
        workingStudent.studentid=@"";
        workingStudent.fcmemberid=@"";
        workingStudent.extrafield1=@"";
        workingStudent.extrafield2=@"";
        workingStudent.parentname=@"";
        workingStudent.parentname2=@"";
        workingStudent.parentemail=@"";
        workingStudent.parentaddress=@"";
        workingStudent.remarks=@"";
        workingStudent.studentmedia=@"";
        workingStudent.studentsource=@"";
        workingStudent.age=@"";
        workingStudent.ddaenabled=NO;
        workingStudent.ddaaccountno=@"";
        workingStudent.ddaaccountname=@"";
        workingStudent.ddadebtorreference=@"";
        workingStudent.ddalimit=@"";
        workingStudent.sendmessage=YES;
        workingStudent.promotion=globalvariables.centerrecord.studentpromotiondefault?@"Yes":@"No";
        workingStudent.flag=@"No";
        workingStudent.status=@"";
        
    }else{
        workingStudent.studentkey=@"";
        workingStudent.firstname=@"";
        workingStudent.lastname=@"";
        workingStudent.othername=@"";
        workingStudent.gender=@"Male";
        workingStudent.dateofbirth=@"";
        workingStudent.preferredlanguage=@"Cantonese";
        workingStudent.grade=((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).defaultstudentgrade;
        
        workingStudent.siblingarray=[[NSMutableArray alloc]init];
        
        //workingStudent.school=@"";
        workingStudent.studentid=@"";
        workingStudent.fcmemberid=@"";
        workingStudent.extrafield1=@"";
        workingStudent.extrafield2=@"";
        workingStudent.remarks=@"";
        workingStudent.studentmedia=@"";
        workingStudent.studentsource=@"";
        workingStudent.age=@"";
        //workingStudent.ddaenabled=NO;
        //workingStudent.ddaaccountno=@"";
        //workingStudent.ddaaccountname=@"";
        workingStudent.ddadebtorreference=@"";
        //workingStudent.ddalimit=@"";
    }

}

-(void) updatetextfield:(UITextField *)sender
{
    if (sender==firstnametext) {
        workingStudent.firstname=sender.text;
    }else if (sender==lastnametext) {
        workingStudent.lastname=sender.text;
    }else if (sender==othernametext) {
        workingStudent.othername=sender.text;
    }else if (sender==schooltext) {
        workingStudent.school=sender.text;
    }else if (sender==studentidtext) {
        workingStudent.studentid=sender.text;
    }else if (sender==fcmemberidtext) {
        workingStudent.fcmemberid=sender.text;
    }else if (sender==extrafield1text) {
        workingStudent.extrafield1=sender.text;
    }else if (sender==parentnametext) {
        workingStudent.parentname=sender.text;
    }else if (sender==parentname2text) {
        workingStudent.parentname2=sender.text;
    }else if (sender==parentemailtext) {
        workingStudent.parentemail=sender.text;
    }else if (sender==parentaddresstext) {
        workingStudent.parentaddress=sender.text;
    }else if (sender==ddaaccountnotext) {
        workingStudent.ddaaccountno=sender.text;
    }else if (sender==ddaaccountnametext) {
        workingStudent.ddaaccountname=sender.text;
    }else if (sender==ddadebtorreferencetext) {
        workingStudent.ddadebtorreference=sender.text;
    }else if (sender==ddalimittext){
        sender.text=[MyClass allspacestrimmed:sender.text];
        if (![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
            sender.text=workingStudent.ddalimit;
        }else{
            workingStudent.ddalimit=sender.text;
        }
    }
}

-(void) updateparentcontacttext:(UITextField *)sender
{
    sender.text=[MyClass allspacestrimmed:sender.text];
    
    if (![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
        sender.text=[MyClass returnLocalNumberWithContact:((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag-1000]).contact ISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag-1000]).iso_code];
    }else{
        ((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag-1000]).contact=[NSString stringWithFormat:@"%@%@", [MyClass returnCountryCodeWithISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag-1000]).iso_code], sender.text];
        phonearraychanged=TRUE;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==remarkstext) {
        workingStudent.remarks=textView.text;
    }
}



- (NSString *) retrieveEnrollmentAndSalesCountWithStudentkey:(NSString *)studentkey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveenrollmentandsalescount&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey];
    
    __block NSString *result=nil;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            result = jsonreturned[@"content"];
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            result = jsonreturned[@"content"];
            //result=  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else{
            [MyClass showconnectionlostdialogbox];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(int) returnmediasourceindexwitharray:(NSMutableArray *)mediasourcearray description:(NSString *)description
{
    for (int i=0; i<mediasourcearray.count; i++) {
        if ([((MarketingRecord *)[mediasourcearray objectAtIndex:i]).description isEqualToString:description]) {
            return i;
        }
    }
    
    return 0;
}

- (void)selectgender:(UISegmentedControl *)sender {
    workingStudent.gender=sender.selectedSegmentIndex==0?@"Male":@"Female";
}

- (void) pcaddbuttonpressed:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"relationship" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:nil Title:nil];
    
    addoreditphonebutton=@"add";
    //[self popupphonetypeselectionwindowwithbutton:sender];
}

- (void) pceditbuttonpressed:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).relationship, nil] DataType:@"relationship" DataIndex:sender.tag ShowSearchBar:NO BottomMode:workingStudent.phonearray.count>1?@"Delete":nil PreferredContentSize:CGSizeMake(220, 488) View:self Button:sender ItemsArray:nil Title:nil];
    
    
    //phoneeditbuttonselected=sender.tag-2000;
    addoreditphonebutton=@"edit";
    //[self popupphonetypeselectionwindowwithbutton:sender];
}


-(void) smsbuttonpressed:(UIButton *)sender
{
    ((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enablesms=!((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enablesms;
    phonearraychanged=TRUE;
    [studentTable reloadData];
}

-(void) wechatbuttonpressed:(UIButton *)sender
{
    ((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enablewechat=!((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enablewechat;
    phonearraychanged=TRUE;
    [studentTable reloadData];
}


-(void) studentappbuttonpressed:(UIButton *)sender
{
    ((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enableparentapp=!((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).enableparentapp;
    phonearraychanged=TRUE;
    [studentTable reloadData];
}

-(void) primarycontactbuttonpressed:(UIButton *)sender
{
    for (int i=0; i<workingStudent.phonearray.count; i++) {
        if (i==sender.tag) {
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).primarycontact=YES;
        }else{
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).primarycontact=NO;
        }
    }
    phonearraychanged=TRUE;
    [studentTable reloadData];
}

-(void) ccbuttonpressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:((ContactRecord *)[workingStudent.phonearray objectAtIndex:sender.tag]).iso_code, nil] DataType:@"countrycode" DataIndex:sender.tag ShowSearchBar:YES BottomMode:nil PreferredContentSize:CGSizeMake(220, 200) View:self Button:sender ItemsArray:nil Title:nil];
}
/*
-(void) enableprimarycontact:(UIButton *)sender
{
    if ([addoreditphonebutton isEqualToString:@"edit"]) {
        if (phoneeditbuttonselected!=0) {
            if (sender.tag==0) {
                ContactRecord *primaryrecord=[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected];
                primaryrecord.primarycontact=YES;
                [workingStudent.phonearray removeObjectAtIndex:phoneeditbuttonselected];
                
                for (int i=0; i<workingStudent.phonearray.count; i++) {
                    ((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).primarycontact=NO;
                }
                
                [workingStudent.phonearray insertObject:primaryrecord atIndex:0];
                sender.layer.opacity=1;
                sender.tag=1;
                [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
            }
        }
    }else{
        if (sender.tag==0) {
            sender.layer.opacity=1;
            sender.tag=1;
        }else{
            sender.layer.opacity=0.3;
            sender.tag=0;
        }
    }
    
    phonearraychanged=TRUE;
    [studentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) enableparentapp:(UIButton *)sender
{
    if ([addoreditphonebutton isEqualToString:@"edit"]) {
        if (((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enableparentapp) {
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enableparentapp=NO;
            sender.layer.opacity=0.3;
            sender.tag=0;
        }else{
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enableparentapp=YES;
            sender.layer.opacity=1;
            sender.tag=1;
        }
    }else{
        if (sender.tag==0) {
            sender.layer.opacity=1;
            sender.tag=1;
        }else{
            sender.layer.opacity=0.3;
            sender.tag=0;
        }
    }
    phonearraychanged=TRUE;
    [studentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) enablesms:(UIButton *)sender
{
    if ([addoreditphonebutton isEqualToString:@"edit"]) {
        if (((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enablesms) {
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enablesms=NO;
            sender.layer.opacity=0.3;
            sender.tag=0;
        }else{
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enablesms=YES;
            sender.layer.opacity=1;
            sender.tag=1;
        }
    }else{
        if (sender.tag==0) {
            sender.layer.opacity=1;
            sender.tag=1;
        }else{
            sender.layer.opacity=0.3;
            sender.tag=0;
        }
    }
    phonearraychanged=TRUE;
    [studentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}*/

-(void) popupphonetypeselectionwindowwithbutton:(UIButton *)sender
{
    int windowwidth=220;
    
    UIView *phonetypeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, phonetypearray.count*34+44)];
    phonetypeview.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.15];
    
    /*UIView *sideview=[[UIView alloc]initWithFrame:CGRectMake(windowwidth, 0, 200, phonetypeview.frame.size.height)];
    [phonetypeview addSubview:sideview];*/
    
    //add toolbar
    UIToolbar *taskAddToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 420, 44)];
    taskAddToolbar.barStyle=UIBarStyleDefault;
    taskAddToolbar.barTintColor=[UIColor systemGroupedBackgroundColor];
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    //UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deletephonebox:)];
    deleteButton.tag=sender.tag;
    
    /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [addoreditphonebutton isEqualToString:@"edit"]?((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).contact:@"";
    label.textColor=[UIColor darkGrayColor];
    label.textAlignment=NSTextAlignmentRight;
    UIBarButtonItem *contactnumberItem = [[UIBarButtonItem alloc] initWithCustomView:label];*/

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [MyClass returntitlewithtitle:@"Please select"];
    label.textColor=[UIColor darkGrayColor];
    UIBarButtonItem *pleaseSelectItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    
    /*UIImageView *parenticon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 44+5, 25, 25)];
    //[parenticon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",globalvariables.centerrecord.standaloneparentappid]]];
    [MyClass downloadImageWithImageview:parenticon gender:nil type:@"studentappimage" typekey:globalvariables.centerrecord.standaloneparentappid image:@"Yes" async:YES];
    parenticon.layer.cornerRadius=4;
    parenticon.layer.masksToBounds=YES;
    [sideview addSubview:parenticon];
    
    embededparentbutton =  [[UIButton alloc]initWithFrame:CGRectMake(200-25-20, 44+5, 25, 25)];
    [embededparentbutton addTarget:self action:@selector(enableparentapp:)forControlEvents:UIControlEventTouchUpInside];
    [embededparentbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
    embededparentbutton.layer.cornerRadius=4;
    embededparentbutton.layer.masksToBounds=YES;
    [sideview addSubview:embededparentbutton];

    UIImageView *smsicon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 44+5+34, 25, 25)];
    [smsicon setImage:[UIImage imageNamed:@"messagecenter_icon.png.png"]];
    smsicon.layer.cornerRadius=4;
    smsicon.layer.masksToBounds=YES;
    [sideview addSubview:smsicon];

    
    embededsmsbutton =  [[UIButton alloc]initWithFrame:CGRectMake(200-25-20, 44+5+34, 25, 25)];
    [embededsmsbutton addTarget:self action:@selector(enablesms:)forControlEvents:UIControlEventTouchUpInside];
    [embededsmsbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
    embededsmsbutton.layer.cornerRadius=4;
    embededsmsbutton.layer.masksToBounds=YES;
    [sideview addSubview:embededsmsbutton];
    
    UILabel *maindisplay=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+34*2, 120, 34)];
    maindisplay.text=[MyClass returntitlewithtitle:@"Primary contact"];
    maindisplay.textColor=[UIColor darkGrayColor];
    maindisplay.font=[UIFont systemFontOfSize:15];
    [sideview addSubview:maindisplay];
    
    embededprimarybutton =  [[UIButton alloc]initWithFrame:CGRectMake(200-25-20, 44+5+34*2, 25, 25)];
    [embededprimarybutton addTarget:self action:@selector(enableprimarycontact:)forControlEvents:UIControlEventTouchUpInside];
    [embededprimarybutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
    embededprimarybutton.layer.cornerRadius=4;
    embededprimarybutton.layer.masksToBounds=YES;
    [sideview addSubview:embededprimarybutton];
    
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, 44+34-0.5, 200, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [sideview addSubview:separator];

    separator=[[UIView alloc]initWithFrame:CGRectMake(0, 44+34*2-0.5, 200, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [sideview addSubview:separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, 44+34*3-0.5, 200, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [sideview addSubview:separator];*/
    
    
    if (workingStudent.phonearray.count>1 && [addoreditphonebutton isEqualToString:@"edit"]) {
        barItems = [[NSMutableArray alloc]initWithObjects:deleteButton, nil];
    }else{
        barItems = [[NSMutableArray alloc]initWithObjects:pleaseSelectItem, nil];
    }
    
    /*if ([addoreditphonebutton isEqualToString:@"edit"]) {
        if (!((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enableparentapp) {
            embededparentbutton.layer.opacity=0.3;
            embededparentbutton.tag=0;
        }else{
            embededparentbutton.layer.opacity=1;
            embededparentbutton.tag=1;
        }
        
        if (!((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).enablesms) {
            embededsmsbutton.layer.opacity=0.3;
            embededsmsbutton.tag=0;
        }else{
            embededsmsbutton.layer.opacity=1;
            embededsmsbutton.tag=1;
        }
        
        if (!((ContactRecord *)[workingStudent.phonearray objectAtIndex:phoneeditbuttonselected]).primarycontact ) {
            embededprimarybutton.layer.opacity=0.3;
            embededprimarybutton.tag=0;
        }else{
            embededprimarybutton.layer.opacity=1;
            embededprimarybutton.tag=1;
        }
    }else{
        if (globalvariables.centerrecord.parentappdefault) {
            embededparentbutton.layer.opacity=1;
            embededparentbutton.tag=1;
        }else{
            embededparentbutton.layer.opacity=0.3;
            embededparentbutton.tag=0;
        }
        
        if (globalvariables.centerrecord.smsdefault) {
            embededsmsbutton.layer.opacity=1;
            embededsmsbutton.tag=1;
        }else{
            embededsmsbutton.layer.opacity=0.3;
            embededsmsbutton.tag=0;
        }
        
        
        

        embededprimarybutton.layer.opacity=0.3;
        embededprimarybutton.tag=0;
    
    }*/
    
    [taskAddToolbar setItems:barItems];
    [phonetypeview addSubview:taskAddToolbar];
    
    //add table
    phonetypetable.frame=CGRectMake(0, 44, windowwidth, phonetypearray.count*34);
    [phonetypeview addSubview:phonetypetable];
    [phonetypetable reloadData];
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=phonetypeview;
    viewcontroller.preferredContentSize=CGSizeMake(220, phonetypeview.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    mypopovercontroller=viewcontroller.popoverPresentationController;
    mypopovercontroller.delegate=self;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
    
    
    
    //mypopovercontroller=[[UIPopoverController alloc]initWithContentViewController:viewcontroller];
    
    if ([addoreditphonebutton isEqualToString:@"edit"]) {
        CGRect rect=CGRectMake(sender.bounds.origin.x+30, sender.bounds.origin.y+7.5, 0, 0);
        
        mypopovercontroller.sourceView=sender;
        mypopovercontroller.sourceRect=rect;
    }else{
        mypopovercontroller.sourceView=sender;
        mypopovercontroller.sourceRect=sender.bounds;
    }
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    

}

-(void) deletephonebox:(UIButton *)sender
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[self storeuserphonearray];
    [workingStudent.phonearray removeObjectAtIndex:sender.tag-2000];
    
    if (sender.tag==2000) {
        ((ContactRecord *)[workingStudent.phonearray firstObject]).primarycontact=YES;
    }
    
    
    //[self loaduserphonearray];
    phonearraychanged=TRUE;
    [studentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



-(void) updateuserphonearray{
    //[self storeuserphonearray];
    for (int i=0; i<workingStudent.phonearray.count; i++) {
        if ([[MyClass returnLocalNumberWithContact:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).contact ISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).iso_code] isEqualToString:@""]) {
            if (((ContactRecord *)[workingStudent.phonearray objectAtIndex:i]).primarycontact) {
                ((ContactRecord *)[workingStudent.phonearray objectAtIndex:0]).primarycontact=YES;
            }
            [workingStudent.phonearray removeObjectAtIndex:i];
            i-=1;
        }
    }
}

-(void) retrieveschoollist
{
    schoolarray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveschoollist]];
    filteredschoolarray=[[NSMutableArray alloc]initWithArray:schoolarray];
    [schooltable reloadData];
    
    schoolsearchbar.text=@"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==schoolsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredschoolarray=[[NSMutableArray alloc]initWithArray:schoolarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
            filteredschoolarray=[[NSMutableArray alloc]initWithArray:[schoolarray filteredArrayUsingPredicate:predicate]];
        }
        [schooltable reloadData];
        [schooltable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==schooltable) {
        [self.view endEditing:YES];
    }
}

-(void) showsidewindowwithtablename:(NSString *)tablename
{
    schoolmasterview.hidden=YES;
    grademasterview.hidden=YES;
    agemasterview.hidden=YES;
    preferredlanguagemasterview.hidden=YES;
    sourcemasterview.hidden=YES;
    mediamasterview.hidden=YES;
    dobmasterview.hidden=YES;
    extrafield2masterview.hidden=YES;
    
    UITableView *tableview;
    
    long row=-1;
    if ([tablename isEqualToString:@"school"]) {
        row=[filteredschoolarray indexOfObject:workingStudent.school];
        tableview=schooltable;
        schoolmasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"grade"]){
        row=[gradearray indexOfObject:workingStudent.grade];
        tableview=gradetable;
        grademasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"age"]){
        row=[agearray indexOfObject:workingStudent.age];
        tableview=agetable;
        agemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"preferredlanguage"]){
        row=[preferredlanguagearray indexOfObject:workingStudent.preferredlanguage];
        tableview=preferredlanguagetable;
        preferredlanguagemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"source"]){
        row=[self returnsourcemediaindexwitharray:sourcearray item:workingStudent.studentsource];
        tableview=sourcetable;
        sourcemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"media"]){
        row=[self returnsourcemediaindexwitharray:mediaarray item:workingStudent.studentmedia];
        tableview=mediatable;
        mediamasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"dob"]){
        dobmasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"extrafield2"]){
        row=[extrafield2array indexOfObject:workingStudent.extrafield2];
        tableview=extrafield2table;
        extrafield2masterview.hidden=NO;
    }
    
    if (tableview) {
        if (row && row>=0) {
            [tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }else{
            [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

    
    
    self.sideSelectionAnimating = YES;
    CGFloat width = [self visibleEditWidth];
    CGFloat height = MAX(self.view.bounds.size.height - 70, 0);
    sideselectionview.frame = CGRectMake(width, 70, width, height);
    [self pinEditSidePanel:schoolmasterview width:schooltablewidth];
    [self pinEditSidePanel:agemasterview width:agetablewidth];
    [self pinEditSidePanel:grademasterview width:gradetablewidth];
    [self pinEditSidePanel:preferredlanguagemasterview width:preferredlanguagetablewidth];
    [self pinEditSidePanel:sourcemasterview width:sourcetablewidth];
    [self pinEditSidePanel:mediamasterview width:mediatablewidth];
    [self pinEditSidePanel:extrafield2masterview width:extrafield2tablewidth];
    [self pinEditSidePanel:dobmasterview width:dobtablewidth];
    [UIView animateWithDuration:0.3f animations:^{
        sideselectionview.frame=CGRectMake(0, 70, width, height);
    } completion:^(BOOL finished) {
        self.sideSelectionAnimating = NO;
        [UIView animateWithDuration:0.2f animations:^{
            filterviewbutton.layer.opacity=0.1;
        } completion:nil];
    }];
    

}

-(long) returnsourcemediaindexwitharray:(NSMutableArray *)array item:(NSString *)item
{
    for (long i=0; i<array.count; i++) {
        if ([((MarketingRecord *)[array objectAtIndex:i]).description isEqualToString:item]) {
            return i;
        }
    }
    return -1;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        if (textView==remarkstext) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:studentTable];
            NSIndexPath *indexpath =[studentTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [studentTable rectForRowAtIndexPath:indexpath];
            
            if (rectInTableView.origin.y+rectInTableView.size.height-studentTable.frame.size.height>0) {
                [studentTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-studentTable.frame.size.height) animated:YES];
            }else{
                [studentTable setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
}

-(BOOL) isStudentIDBeingUsed
{
    if(![workingStudent.studentid isEqualToString:@""] && ![workingStudent.studentid isEqualToString:EditViewStudent.studentid]){
        NSMutableArray *allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.studentid = %@ and self.studentkey !=%@",globalvariables.centerrecord.centerkey,workingStudent.studentid,EditViewStudent.studentkey];
        
        allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
        
        return allstudentarray.count>0;
    }
    return NO;
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"countrycode"]) {
        NSString *localnumber=[MyClass returnLocalNumberWithContact:((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).contact ISOCode:((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).iso_code];
        ((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).iso_code=[selecteditems firstObject];
        ((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).contact=[NSString stringWithFormat:@"%@%@",[MyClass returnCountryCodeWithISOCode:[selecteditems firstObject]],localnumber];
        phonearraychanged=TRUE;
        
        [studentTable reloadData];
    }else if ([datatype isEqualToString:@"relationship"]){
        if ([addoreditphonebutton isEqualToString:@"edit"]) {
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).relationship=[selecteditems firstObject];
            phonearraychanged=TRUE;
            [studentTable reloadData];
        }else if ([addoreditphonebutton isEqualToString:@"add"]){
            CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
            [workingStudent.phonearray addObject:[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[selecteditems firstObject] contact:local.country_code enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:NO parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:local.iso_code enablewechat:NO] ];
            phonearraychanged=TRUE;
            [studentTable reloadData];
            
        }
        
    }else if ([datatype isEqualToString:@"PhotoSource"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Take Photo"]) {
            [self takephotobuttonpressed];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self photolibrarybuttonpressed];
        }
    }
}

-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"relationship"]) {
        if (((ContactRecord *)[workingStudent.phonearray objectAtIndex:dataindex]).primarycontact) {
            [workingStudent.phonearray removeObjectAtIndex:dataindex];
            ((ContactRecord *)[workingStudent.phonearray objectAtIndex:0]).primarycontact=YES;
        }else{
            [workingStudent.phonearray removeObjectAtIndex:dataindex];
        }
        phonearraychanged=TRUE;
        [studentTable reloadData];
    }
}

-(void) enableddaenabled:(UISwitch *)sender
{
    workingStudent.ddaenabled=sender.on;
}

@end
