//
//  LeadEditViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import "LeadEditViewController.h"
#import "MyClass.h"

@interface LeadEditViewController ()
@property (nonatomic, assign) BOOL sideSelectionAnimating;
@end

#define schooltablewidth 350
#define agetablewidth 220
#define gradetablewidth 220
#define preferredlanguagetablewidth 220
#define mediatablewidth 300
#define sourcetablewidth 300
#define dobtablewidth 320
//#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation LeadEditViewController
@synthesize EditViewLead;
@synthesize EditViewLeadAction;
@synthesize leadimage,imagepicker,mypopovercontroller;
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
    self.navigationItem.hidesBackButton = true;
    
    globalvariables=[GlobalVariables singleObj];
    workingLead=[[Lead alloc]init];

    selfViewWidth = self.view.bounds.size.width;
    
    // Do any additional setup after loading the view.
    
//    UIBarButtonItem* donebutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneLead:)];
//    self.navigationItem.rightBarButtonItem=donebutton;
//    
//    UIBarButtonItem* cancelbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelLead:)];
//    self.navigationItem.leftBarButtonItem=cancelbutton;
    
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    
    //load lead image
    if ([EditViewLeadAction isEqualToString:@"AddNewLead"]) {
        EditViewLead=[[Lead alloc]init];
    }
    
//    MasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height)];
//    [self.view addSubview:MasterView];
    
    leadimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 132, 154, 180)];
    leadimage.contentMode=UIViewContentModeScaleAspectFit;
    leadimage.layer.cornerRadius=10;
    leadimage.backgroundColor=[UIColor lightGrayColor];
    leadimage.layer.masksToBounds=YES;
    [MasterView addSubview:leadimage];
    
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
    
    [MyClass downloadImageWithImageview:leadimage gender:EditViewLead.gender type:@"lead" typekey:EditViewLead.leadkey image:EditViewLead.image async:YES];
    
    if ([EditViewLead.image isEqualToString:@"Yes"]) {
        addphotobutton.hidden=YES;
        editphotobutton.hidden=NO;
        deletephotobutton.hidden=NO;
    }else{
        leadimage.image=nil;
        addphotobutton.hidden=NO;
        editphotobutton.hidden=YES;
        deletephotobutton.hidden=YES;
    }
    
    imageadded=FALSE;
    imageedited=FALSE;
    imagedeleted=FALSE;
    
    leadimage.layer.cornerRadius=10;
    leadimage.layer.masksToBounds=YES;
    
    [self initializefield];
    
    leadTable=[[UITableView alloc]initWithFrame:CGRectMake(178, 70, selfViewWidth-178, self.view.bounds.size.height-70) style:UITableViewStyleGrouped];
    leadTable.delegate=self;
    leadTable.dataSource=self;
    [MasterView addSubview:leadTable];
    [leadTable reloadData];
    
    if ([leadTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        leadTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
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
    
    if (![workingLead.dateofbirth isEqualToString:@""]) {
        //NSDateFormatter *df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        //[df setDateFormat:@"dd-MMM-yyyy"];
        //NSDate *date=[df dateFromString:tmpdateofbirth];
        NSDate *date=[MyClass convertToNSDateWithDate:workingLead.dateofbirth DateFormat:@"dd-MMM-yyyy"];
        
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
    workingLead.dateofbirth=[MyClass convertToNSStringWithNSDate:[myDatePickerView date] DateFormat:@"dd-MMM-yyyy"];
    workingLead.age=[MyClass calculateagewithbirthday:workingLead.dateofbirth];
    //[self closesidewindow];
    [leadTable reloadData];
    [leadTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
    [self layoutLeadEditForCurrentSize];
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

- (void)layoutLeadEditForCurrentSize
{
    CGFloat width = [self visibleEditWidth];
    CGFloat height = [self visibleEditHeight];
    if (width < 1 || height < 1 || !leadTable || !sideselectionview) {
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
    leadTable.frame = CGRectMake(178, 70, MAX(width - 178, 0), MAX(height - keyboardheight - 70, 0));
    if (self.sideSelectionAnimating) {
        if (widthChanged) {
            [leadTable reloadData];
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
    [self pinEditSidePanel:dobmasterview width:dobtablewidth];
    if (widthChanged) {
        [leadTable reloadData];
    }
}

-(void) adjusttablesize
{
    //if ([globalvariables.leftmenuindex isEqualToString:@"9"]) {
        leadTable.frame=CGRectMake(178, 70, MAX([self visibleEditWidth] - 178, 0), MAX([self visibleEditHeight] - keyboardheight - 70, 0));
    /*}else{
        leadTable.frame=CGRectMake(178, 70, 626, 728-keyboardheight-70+20);
    }*/
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        if (textView==remarkstext) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:leadTable];
            NSIndexPath *indexpath =[leadTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [leadTable rectForRowAtIndexPath:indexpath];
            
            if (rectInTableView.origin.y+rectInTableView.size.height-leadTable.frame.size.height>0) {
                [leadTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-leadTable.frame.size.height) animated:YES];
            }else{
                [leadTable setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toLeadEditTable"]) {
        destLeadEditTableViewController=[[LeadEditTableViewController alloc]init];
        destLeadEditTableViewController=segue.destinationViewController;
        destLeadEditTableViewController.delegate=self;
        destLeadEditTableViewController.mediaarray=[[NSMutableArray alloc]initWithArray:MediaArray];
        destLeadEditTableViewController.sourearray=[[NSMutableArray alloc]initWithArray:SourceArray];
        destLeadEditTableViewController.EditTableLead = EditViewLead;
        destLeadEditTableViewController.EditTableLeadAction=EditViewLeadAction;
    }
}*/

-(IBAction) doneLead:(id)sender{
    
    [self.view endEditing:YES];
    [self closesidewindow];
    
    if ([workingLead.firstname isEqualToString:@""]) {
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Lead Information"] message:[MyClass returntitlewithtitle:@"Please input lead's first name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
        [MyClass presentViewController:missingalert View:self];
    }else if([workingLead.grade isEqualToString:@""]){
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Lead Information"] message:[MyClass returntitlewithtitle:@"Please select lead's grade"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
        [MyClass presentViewController:missingalert View:self];
    }else{
        if([self isLeadIDBeingUsed]){
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Lead Information"] message:[MyClass returntitlewithtitle:@"Lead ID already been used. Do you want to continue?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self updateLead];
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            //[self presentViewController:disablealert animated:YES completion:nil];
            [MyClass presentViewController:disablealert View:self];
        }else{
            [self updateLead];
        }

        
    }
                       
    
}

-(void) updateLead
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![workingLead.dateofbirth isEqualToString:@""]) {
            workingLead.dateofbirth=[MyClass convertDateFormatWithDate:workingLead.dateofbirth FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        }

        
        if (imagedeleted) {
            workingLead.image=@"No";
        }else if (imageadded || imageedited || [EditViewLead.image isEqualToString:@"Yes"]) {
            workingLead.image=@"Yes";
        }else{
            workingLead.image=@"No";
        }
        
        
        
        if ([EditViewLeadAction isEqualToString:@"AddNewLead"]) {

            NSString *leadkey=[self updateLeadWithLead:workingLead Action:@"Add"];
            
            
            if (leadkey) {
                //save image file
                [self uploadimageleadkey:leadkey];
                [self.delegate gotoLeadProfilewithLeadkey:leadkey submenu:0 classkeys:nil];
                [MyClass insertViewHistoryWithType:@"lead" Typekey:leadkey Name:@"" IDNumber:@"" Gender:@""];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                [MyClass showconnectionlostdialogbox];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                return;
            }
            
            
            
        }else{ //edit lead
            //create string contains url address for php file
            NSString *leadkey=[self updateLeadWithLead:workingLead Action:@"Edit"];
            
            if (leadkey) {
                //save image file
                [self uploadimageleadkey:EditViewLead.leadkey];
                
                [self.delegate updateleadinformationlist:EditViewLead.leadkey];
                [self.delegate refreshLeadView:EditViewLead.leadkey];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
                return;
            }
            
            
        }
        [self.delegate dataChanged];
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

-(NSString *) updateLeadWithLead:(Lead *)lead Action:(NSString *)action
{
    //generate json student array

    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updatelead" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
    
    [dictionary setValue:action forKey:@"action"];
    [dictionary setValue:lead.leadkey forKey:@"leadkey"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.firstname] forKey:@"firstname"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.lastname] forKey:@"lastname"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.othername] forKey:@"othername"];
    [dictionary setValue:lead.gender forKey:@"gender"];
    [dictionary setValue:lead.dateofbirth forKey:@"dateofbirth"];
    [dictionary setValue:![lead.dateofbirth isEqualToString:@""]?@"":lead.age forKey:@"age"];
    //[dictionary setValue:lead.age forKey:@"age"];
    [dictionary setValue:lead.grade forKey:@"grade"];
    [dictionary setValue:lead.preferredlanguage forKey:@"preferredlanguage"];
    [dictionary setValue:lead.school forKey:@"school"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.parentname] forKey:@"parentname"];
    if ([[MyClass returnLocalNumberWithContact:[MyClass allspacestrimmed:lead.parentcontact] ISOCode:lead.iso_code] isEqualToString:@""]) {
        [dictionary setValue:@"" forKey:@"parentcontact"];
        [dictionary setValue:@"" forKey:@"iso_code"];
    }else{
        [dictionary setValue:[MyClass allspacestrimmed:lead.parentcontact] forKey:@"parentcontact"];
        [dictionary setValue:lead.iso_code forKey:@"iso_code"];
    }
    [dictionary setValue:[MyClass allspacestrimmed:lead.parentemail] forKey:@"parentemail"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.parentaddress] forKey:@"parentaddress"];
    [dictionary setValue:[MyClass leadingtrailingspacestrimmed:lead.remarks] forKey:@"remarks"];
    [dictionary setValue:lead.image forKey:@"image"];
    [dictionary setValue:lead.leadid forKey:@"leadid"];
    [dictionary setValue:lead.leadmedia forKey:@"leadmedia"];
    [dictionary setValue:lead.leadsource forKey:@"leadsource"];
    
    if ([action isEqualToString:@"Add"]) {
        [dictionary setValue:lead.flag forKey:@"flag"];
        [dictionary setValue:lead.status forKey:@"status"];
        [dictionary setValue:lead.promotion forKey:@"promotion"];
    }
    
    __block NSString * newleadkey;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                newleadkey=[[JSONArray objectAtIndex:0] objectForKey:@"leadkey"];
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
    
    __block NSString * newleadkey;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                newleadkey=[[JSONArray objectAtIndex:0] objectForKey:@"leadkey"];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return newleadkey;
}


-(void) uploadimageleadkey:(NSString *)leadkey;
{
    
    if (imagedeleted) {
        //delete image file
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteleadimage&leadkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,leadkey];
        
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
        //NSData *imageData = UIImageJPEGRepresentation(leadimage.image,0.8);     //change Image to NSData
        NSData *imageData = [MyClass returnCompressedImageDataWithImage:leadimage.image];
        
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@##lead_%@_%@.jpg\"\r\n",globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,leadkey] dataUsingEncoding:NSUTF8StringEncoding]];
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

-(IBAction) cancelLead:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate cancelLead];
}

-(void) deleteLead:(NSString *)leadkey
{
    
    [self confirmdeletelead:EditViewLead.leadkey];
    
}


-(void) confirmdeletelead:(NSString *)leadkey
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate deleteLead:leadkey];
}

- (IBAction)addphotobuttonpressed:(id)sender {
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add"];
    }else{
        [self addphotofromsource:@"library"];
    }
    
}

- (IBAction)deletephotobuttonpressed:(id)sender {
    
    leadimage.image=nil;
    addphotobutton.hidden=NO;
    editphotobutton.hidden=YES;
    deletephotobutton.hidden=YES;
    imagedeleted=TRUE;
    
}

- (IBAction)editphotobuttonpressed:(id)sender {
    
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
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
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
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];//info[UIImagePickerControllerEditedImage];
    
    [self.leadimage setImage:[self resizeImageWithImage:chosenImage ForSize:CGSizeMake(548, 640)]];
    
    if ([EditViewLead.image isEqualToString:@"Yes"]) {
        imageedited=TRUE;
    }else{
        imageadded=TRUE;
    }
    imagedeleted=FALSE;
    
    addphotobutton.hidden=YES;
    editphotobutton.hidden=NO;
    deletephotobutton.hidden=NO;
    
    //if ([mypopovercontroller presentingViewController].isBeingPresented) {
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
    if (tableView==leadTable) {
        if ([EditViewLeadAction isEqualToString:@"EditLead"] && [globalvariables.leftmenuindex isEqualToString:@"9"]) {
            return 4;
        }else{
            return 3;
        }
    }
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==leadTable){
        if (section==0) {
            return 10;
        }else if (section==1){
            return 4;
        }else if (section==2){
            return 1;
        }else if (section==3){
            return 1;
        }
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
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView==leadTable){
        
        UILabel *leadlabel;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Name"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                
                lastnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 120, 30)];
                lastnametext.font=[UIFont systemFontOfSize:15];
                lastnametext.textColor=[UIColor darkGrayColor];
                lastnametext.textAlignment=NSTextAlignmentRight;
                lastnametext.text=workingLead.lastname;
                lastnametext.borderStyle = UITextBorderStyleRoundedRect;
                lastnametext.placeholder=[MyClass returntitlewithtitle:@"student_Last name_placeholder"];
                [lastnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:lastnametext];
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                firstnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 186, 30)];
                firstnametext.font=[UIFont systemFontOfSize:15];
                firstnametext.textColor=[UIColor darkGrayColor];
                firstnametext.textAlignment=NSTextAlignmentRight;
                firstnametext.text=workingLead.firstname;
                firstnametext.borderStyle = UITextBorderStyleRoundedRect;
                firstnametext.placeholder=[MyClass returntitlewithtitle:@"student_First name_placeholder"];
                [firstnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:firstnametext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                othernametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-327, 5, 120, 30)];
                othernametext.font=[UIFont systemFontOfSize:15];
                othernametext.textColor=[UIColor darkGrayColor];
                othernametext.textAlignment=NSTextAlignmentRight;
                othernametext.text=workingLead.othername;
                othernametext.borderStyle = UITextBorderStyleRoundedRect;
                othernametext.placeholder=[MyClass returntitlewithtitle:@"student_Other name_placeholder"];
                [othernametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:othernametext];
                
            }else if (indexPath.row==2){
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Gender"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                scgender = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Male"],[MyClass returntitlewithtitle:@"Female"],nil]];
                scgender.frame = CGRectMake(selfViewWidth-450, 5, 243, 30);
                [scgender addTarget:self action:@selector(selectgender:) forControlEvents: UIControlEventValueChanged];
                scgender.selectedSegmentIndex=[workingLead.gender isEqualToString:@"Male"] ? 0:1;
                [cell.contentView addSubview:scgender];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Date of Birth"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=[MyClass returndateformatwithdate:workingLead.dateofbirth];
                [cell.contentView addSubview:leadlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==4){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Age"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=workingLead.age;
                [cell.contentView addSubview:leadlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==5){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Grade"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=workingLead.grade;
                [cell.contentView addSubview:leadlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==6){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"School"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                schooltext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-639, 5, 428, 30)];
                schooltext.font=[UIFont systemFontOfSize:15];
                schooltext.textColor=[UIColor darkGrayColor];
                schooltext.textAlignment=NSTextAlignmentRight;
                schooltext.text=workingLead.school;
                schooltext.borderStyle = UITextBorderStyleRoundedRect;
                schooltext.placeholder=[MyClass returntitlewithtitle:@"School"];
                [schooltext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:schooltext];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==7){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Preferred Language"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-343, 0, 132, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=[MyClass returntitlewithtitle:workingLead.preferredlanguage];
                [cell.contentView addSubview:leadlabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==1){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Lead ID"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadidtext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-450, 5, 243, 30)];
                leadidtext.font=[UIFont systemFontOfSize:15];
                leadidtext.textColor=[UIColor darkGrayColor];
                leadidtext.textAlignment=NSTextAlignmentRight;
                leadidtext.text=workingLead.leadid;
                leadidtext.borderStyle = UITextBorderStyleRoundedRect;
                leadidtext.placeholder=[EditViewLeadAction isEqualToString:@"AddNewLead"] && globalvariables.centerrecord.autofillleadid?[MyClass returntitlewithtitle:@"Automatically assign"]:[MyClass returntitlewithtitle:@"lead ID"];
                [leadidtext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:leadidtext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==8){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Lead Media"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-539, 0, 325, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=workingLead.leadmedia;
                [cell.contentView addSubview:leadlabel];
                if (MediaArray.count>0) {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
                
            }else if (indexPath.row==9){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Lead Source"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-539, 0, 325, 40)];
                leadlabel.font=[UIFont systemFontOfSize:15];
                leadlabel.textColor=[UIColor darkGrayColor];
                leadlabel.textAlignment=NSTextAlignmentRight;
                leadlabel.text=workingLead.leadsource;
                [cell.contentView addSubview:leadlabel];
                if (SourceArray.count>0) {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
            }
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Parent Name"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                
                parentnametext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-644, 5, 428, 30)];
                parentnametext.font=[UIFont systemFontOfSize:15];
                parentnametext.textColor=[UIColor darkGrayColor];
                parentnametext.textAlignment=NSTextAlignmentRight;
                parentnametext.text=workingLead.parentname;
                parentnametext.borderStyle = UITextBorderStyleRoundedRect;
                parentnametext.placeholder=[MyClass returntitlewithtitle:@"Parent Name"];
                [parentnametext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentnametext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==3){
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Contact"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                parentcontacttext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-644, 5, 428, 30)];
                parentcontacttext.font=[UIFont systemFontOfSize:15];
                parentcontacttext.textColor=[UIColor darkGrayColor];
                parentcontacttext.textAlignment=NSTextAlignmentRight;
                
                if ([workingLead.parentcontact isEqualToString:@""]) {
                    CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
                    workingLead.iso_code=local.iso_code;
                    workingLead.parentcontact=local.country_code;
                }
                
                
                parentcontacttext.text=[MyClass returnLocalNumberWithContact:workingLead.parentcontact ISOCode:workingLead.iso_code];
                parentcontacttext.borderStyle = UITextBorderStyleRoundedRect;
                parentcontacttext.placeholder=[MyClass returntitlewithtitle:@"Contact"];
                [parentcontacttext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                parentcontacttext.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
                [parentcontacttext setLeftViewMode:UITextFieldViewModeAlways];
                
                UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, parentcontacttext.frame.size.height)];
              
                UIImageView *ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, (parentcontacttext.frame.size.height-18)/2, 27, 18)];
                [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:workingLead.iso_code image:@"Yes" async:YES];
                ccimage.contentMode=UIViewContentModeScaleAspectFill;
                ccimage.layer.cornerRadius=3;
                ccimage.layer.masksToBounds=YES;
                [spacerView addSubview:ccimage];
                
                UIButton *ccbutton=[[UIButton alloc]initWithFrame:ccimage.frame];
                [ccbutton addTarget:self action:@selector(ccbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                [spacerView addSubview:ccbutton];
                
                
                UILabel *cclabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
                cclabel.font=[UIFont systemFontOfSize:15];
                cclabel.textColor=[UIColor darkGrayColor];
                cclabel.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:workingLead.iso_code]];
                [cclabel sizeToFit];
                cclabel.frame=CGRectMake(5+3+27, 0, cclabel.frame.size.width, 30);
                
                [spacerView addSubview:cclabel];
                
                spacerView.frame=CGRectMake(0, 0, 5+27+3+cclabel.frame.size.width, parentcontacttext.frame.size.height);
                [parentcontacttext setLeftView:spacerView];
                [cell.contentView addSubview:parentcontacttext];

                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Email"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                
                parentemailtext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-644, 5, 428, 30)];
                parentemailtext.font=[UIFont systemFontOfSize:15];
                parentemailtext.textColor=[UIColor darkGrayColor];
                parentemailtext.textAlignment=NSTextAlignmentRight;
                parentemailtext.text=workingLead.parentemail;
                parentemailtext.borderStyle = UITextBorderStyleRoundedRect;
                parentemailtext.placeholder=[MyClass returntitlewithtitle:@"Email"];
                [parentemailtext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentemailtext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2){
                leadlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
                leadlabel.font=[UIFont systemFontOfSize:17];
                leadlabel.textColor=[UIColor blackColor];
                leadlabel.text=[MyClass returntitlewithtitle:@"Address"];
                leadlabel.tag=301;
                [cell.contentView addSubview:leadlabel];
                
                
                parentaddresstext = [[UITextField alloc]initWithFrame:CGRectMake(selfViewWidth-644, 5, 428, 30)];
                parentaddresstext.font=[UIFont systemFontOfSize:15];
                parentaddresstext.textColor=[UIColor darkGrayColor];
                parentaddresstext.textAlignment=NSTextAlignmentRight;
                parentaddresstext.text=workingLead.parentaddress;
                parentaddresstext.borderStyle = UITextBorderStyleRoundedRect;
                parentaddresstext.placeholder=[MyClass returntitlewithtitle:@"Address"];
                [parentaddresstext addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:parentaddresstext];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }else if (indexPath.section==2){
            remarkstext = [[UITextView alloc]initWithFrame:CGRectMake(10, 3, leadTable.frame.size.width-20, 84)];
            remarkstext.font=[UIFont systemFontOfSize:15];
            remarkstext.textColor=[UIColor darkGrayColor];
            remarkstext.textAlignment=NSTextAlignmentLeft;
            remarkstext.text=workingLead.remarks;
            remarkstext.delegate=self;
            [cell.contentView addSubview:remarkstext];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==3){
            UIButton *DeleteLeadBtn=[[UIButton alloc]init];
            DeleteLeadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            DeleteLeadBtn.frame=CGRectMake(0, 5, leadTable.frame.size.width, 30);
            DeleteLeadBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            
            DeleteLeadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [DeleteLeadBtn addTarget: self action:@selector(deleteLeadRecord) forControlEvents: UIControlEventTouchUpInside];
            
            DeleteLeadBtn.enabled=YES;
            [DeleteLeadBtn setTitle:[MyClass returntitlewithtitle:@"Delete Lead Record"] forState:UIControlStateNormal];
            [DeleteLeadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [cell.contentView addSubview:DeleteLeadBtn];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
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
    }
    
    return cell;
    
    
}

-(void) deleteLeadRecord
{
    [self.view endEditing:YES];
    
    UIAlertController *deletestudent = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Lead Record"] message:[NSString stringWithFormat:@"%@ %@?",[MyClass returntitlewithtitle:@"Are you sure to delete"],[MyClass returnLeadnameWithLeadkey:EditViewLead.leadkey option:@"full"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self confirmdeletelead:EditViewLead.leadkey];
            //[self deleteLead:EditViewLead.leadkey];
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
    if (tableView==leadTable){
        if (indexPath.section==0) {
            return 40;
        }else if (indexPath.section==1){
            return 40;
        }else if (indexPath.section==2){
            return 90;
        }else if (indexPath.section==3){
            return 40;
        }
    }
    return 38;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==leadTable) {
        if (section==0){
            if ([EditViewLeadAction isEqualToString:@"EditLead"]) {
                return [NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Lead Information"],EditViewLead.leadkey];
            }else{
                return [MyClass returntitlewithtitle:@"Lead Information"];
            }
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Parent Information"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"General Remarks"];
        }else if (section==3){
            return nil;
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
    if (tableView==leadTable) {
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==leadTable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==leadTable) {
        if (indexPath.section==0 && indexPath.row==3) {
            [self showsidewindowwithtablename:@"dob"];
        }else if (indexPath.section==0 && indexPath.row==4){
            [self showsidewindowwithtablename:@"age"];
        }else if (indexPath.section==0 && indexPath.row==5){
            [self showsidewindowwithtablename:@"grade"];
        }else if (indexPath.section==0 && indexPath.row==6){
            [self retrieveschoollist];
            [self showsidewindowwithtablename:@"school"];
        }else if (indexPath.section==0 && indexPath.row==7){
            [self showsidewindowwithtablename:@"preferredlanguage"];
        }else if (indexPath.section==0 && indexPath.row==8) {
            if (MediaArray.count>0) {
                [self showsidewindowwithtablename:@"media"];
            }
        }else if (indexPath.section==0 && indexPath.row==9) {
            if (SourceArray.count>0) {
                [self showsidewindowwithtablename:@"source"];
            }
        }
    }else if (tableView==schooltable){
            workingLead.school=[filteredschoolarray objectAtIndex:indexPath.row];
            schooltext.text=workingLead.school;
            [self closesidewindow];
        }else if (tableView==agetable){
            workingLead.dateofbirth=@"";
            workingLead.age=[agearray objectAtIndex:indexPath.row];
            [leadTable reloadData];
            [self closesidewindow];
        }else if (tableView==gradetable){
            workingLead.grade=[gradearray objectAtIndex:indexPath.row];
            [leadTable reloadData];
            [self closesidewindow];
        }else if (tableView==preferredlanguagetable){
            workingLead.preferredlanguage=[preferredlanguagearray objectAtIndex:indexPath.row];
            [leadTable reloadData];
            [self closesidewindow];
        }else if (tableView==mediatable){
            workingLead.leadmedia=((MarketingRecord *)[mediaarray objectAtIndex:indexPath.row]).description;
            [leadTable reloadData];
            [self closesidewindow];
        }else if (tableView==sourcetable){
            workingLead.leadsource=((MarketingRecord *)[sourcearray objectAtIndex:indexPath.row]).description;
            [leadTable reloadData];
            
    }
}

-(void) initializefield
{
    if ([EditViewLeadAction isEqualToString:@"EditLead"]) {
        workingLead=[[Lead alloc]initLeadWithleadkey:EditViewLead.leadkey firstname:EditViewLead.firstname lastname:EditViewLead.lastname othername:EditViewLead.othername gender:EditViewLead.gender dateofbirth:EditViewLead.dateofbirth age:EditViewLead.age grade:EditViewLead.grade preferredlanguage:EditViewLead.preferredlanguage school:EditViewLead.school parentname:EditViewLead.parentname parentcontact:EditViewLead.parentcontact parentemail:EditViewLead.parentemail parentaddress:EditViewLead.parentaddress remarks:EditViewLead.remarks flag:EditViewLead.flag promotion:EditViewLead.promotion status:EditViewLead.status image:EditViewLead.image leadid:EditViewLead.leadid leadmedia:EditViewLead.leadmedia leadsource:EditViewLead.leadsource studentkey:EditViewLead.studentkey photoalbumrecord:EditViewLead.photoalbumrecord centerkey:EditViewLead.centerkey iso_code:EditViewLead.iso_code avatar:EditViewLead.avatar];
        

    }else{
        NSString *grade=[((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).defaultstudentgrade isEqualToString:@""]?[gradearray firstObject]:((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).defaultstudentgrade;
        CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
        workingLead=[[Lead alloc]initLeadWithleadkey:@"" firstname:@"" lastname:@"" othername:@"" gender:@"Male" dateofbirth:@"" age:@"" grade:grade preferredlanguage:@"Cantonese" school:@"" parentname:@"" parentcontact:local.country_code parentemail:@"" parentaddress:@"" remarks:@"" flag:@"" promotion:globalvariables.centerrecord.studentpromotiondefault?@"Yes":@"No" status:@"" image:@"" leadid:@"" leadmedia:@"" leadsource:@"" studentkey:@"" photoalbumrecord:nil centerkey:globalvariables.centerrecord.centerkey iso_code:local.iso_code avatar:nil];

    }
}

-(void) updatetextfield:(UITextField *)sender
{
    if (sender==firstnametext) {
        workingLead.firstname=sender.text;
    }else if (sender==lastnametext) {
        workingLead.lastname=sender.text;
    }else if (sender==othernametext) {
        workingLead.othername=sender.text;
    }else if (sender==schooltext) {
        workingLead.school=sender.text;
    }else if (sender==leadidtext) {
        workingLead.leadid=sender.text;
    }else if (sender==parentnametext) {
        workingLead.parentname=sender.text;
    }else if (sender==parentemailtext) {
        workingLead.parentemail=sender.text;
    }else if (sender==parentaddresstext) {
        workingLead.parentaddress=sender.text;
    }else if (sender==parentcontacttext) {
        //sender.text=[MyClass leadingtrailingspacestrimmed:sender.text];
        //tmpparentcontact=sender.text;
        
        sender.text=[MyClass allspacestrimmed:sender.text];
        if (![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
            sender.text=[MyClass returnLocalNumberWithContact:workingLead.parentcontact ISOCode:workingLead.iso_code];
        }else{
            workingLead.parentcontact=[NSString stringWithFormat:@"%@%@", [MyClass returnCountryCodeWithISOCode:workingLead.iso_code], sender.text];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==remarkstext) {
        workingLead.remarks=textView.text;
    }
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
    workingLead.gender=sender.selectedSegmentIndex==0?@"Male":@"Female";
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
    
    UITableView *tableview;
    
    long row=-1;
    if ([tablename isEqualToString:@"school"]) {
        row=[filteredschoolarray indexOfObject:workingLead.school];
        tableview=schooltable;
        schoolmasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"grade"]){
        row=[gradearray indexOfObject:workingLead.grade];
        tableview=gradetable;
        grademasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"age"]){
        row=[agearray indexOfObject:workingLead.age];
        tableview=agetable;
        agemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"preferredlanguage"]){
        row=[preferredlanguagearray indexOfObject:workingLead.preferredlanguage];
        tableview=preferredlanguagetable;
        preferredlanguagemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"source"]){
        row=[self returnsourcemediaindexwitharray:sourcearray item:workingLead.leadsource];
        tableview=sourcetable;
        sourcemasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"media"]){
        row=[self returnsourcemediaindexwitharray:mediaarray item:workingLead.leadmedia];
        tableview=mediatable;
        mediamasterview.hidden=NO;
    }else if ([tablename isEqualToString:@"dob"]){
        dobmasterview.hidden=NO;
    }
    
    if (tableview) {
        if (row && row>=0) {
            [tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }else{
            [tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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

-(void) closesidewindow
{
    filterviewbutton.layer.opacity=0;
    self.sideSelectionAnimating = YES;
    CGFloat width = [self visibleEditWidth];
    CGFloat height = MAX(self.view.bounds.size.height - 70, 0);
    [UIView animateWithDuration:0.3f animations:^{
        sideselectionview.frame=CGRectMake(width, 70, width, height);
    } completion:^(BOOL finished) {
        self.sideSelectionAnimating = NO;
    }];
    
    [leadTable deselectRowAtIndexPath:[leadTable indexPathForSelectedRow] animated:YES];
}

-(void) retrieveschoollist
{
    schoolarray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveschoollist]];
    filteredschoolarray=[[NSMutableArray alloc]initWithArray:schoolarray];
    [schooltable reloadData];
    
    schoolsearchbar.text=@"";
}

-(BOOL) isLeadIDBeingUsed
{
    if(![workingLead.leadid isEqualToString:@""] && ![workingLead.leadid isEqualToString:EditViewLead.leadid]){
        NSMutableArray *allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.leadid = %@ and self.leadkey !=%@",globalvariables.centerrecord.centerkey,workingLead.leadid,EditViewLead.leadkey];
        
        allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
        
        return allleadarray.count>0;
    }
    return NO;
}

-(void) ccbuttonpressed:(UIButton *)sender
{
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:workingLead.iso_code, nil] DataType:@"countrycode" DataIndex:0 ShowSearchBar:YES BottomMode:nil PreferredContentSize:CGSizeMake(220, 200) View:self Button:sender ItemsArray:nil Title:nil];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"countrycode"]) {
        NSString *localnumber=[MyClass returnLocalNumberWithContact:workingLead.parentcontact ISOCode:workingLead.iso_code];
        workingLead.iso_code=[selecteditems firstObject];
        workingLead.parentcontact=[NSString stringWithFormat:@"%@%@",[MyClass returnCountryCodeWithISOCode:[selecteditems firstObject]],localnumber];

        [leadTable reloadData];
    }else if ([datatype isEqualToString:@"PhotoSource"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Take Photo"]) {
            [self takephotobuttonpressed];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self photolibrarybuttonpressed];
        }
    }
}

@end
