//
//  StudentInformationViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 4/25/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "StudentDetailsViewController.h"
#import "sqlite3.h"




@interface StudentInformationViewController : UIViewController <myStudentViewController,UITableViewDataSource,UITableViewDelegate,myStudentImageGridViewControllerDelegate>{
    //sqlite3 *isdb;
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    NSString *Studentkey;
    NSString *selectedsaleskey;
    //NSString *Enrollmentkey;
    NSInteger Submenu;
    //NSString *Classkey;
    __weak IBOutlet UITableView *studentlisttable;
    StudentImageGridViewController *studentimagepopover;
    
    NSMutableArray *jsonArray;
    NSMutableArray *AllArray;
    NSMutableArray *TypeArray;
    NSMutableArray *SubjectArray;
    NSMutableArray *DayArray;
    NSMutableArray *StatusArray;
    NSMutableArray *OthersArray;
    NSMutableArray *GenderArray;
    NSMutableArray *GradeArray;
    NSMutableArray *studentArray;
    NSMutableArray *filteredStudentArray;
    
    
    CategoryCountRecord *categorycountobject;
    
    UIView *lostconnectionview;
    UIButton *reloadbutton;
    UILabel *lostconnectviewlabel;
    
    UIRefreshControl *tablerefresh;
    
    NSString *studentTableMode;
    NSString *studentCategory;
    __weak IBOutlet UISearchBar *studentsearchbar;
    
    NSMutableArray *sortingarray;
    NSIndexPath *lastindexpath;
    //NSInteger selectedMenuPageIndex;
    ClassKeys *selectedKeys;
    Student *studentobject;
    NSString *laststudentkey;
    __weak IBOutlet UIButton *menubutton;
    __weak IBOutlet UIButton *addNewStudentButton;
    __weak IBOutlet UIStackView *backbuttonstack;
    __weak IBOutlet UIButton *backbutton;
    __weak IBOutlet UIActivityIndicatorView *ailoadindicator;
    __weak IBOutlet UIView *topleftview;
    __weak IBOutlet UIButton *photoalbumbutton;
    __weak IBOutlet UIButton *sortingbutton;
    __weak IBOutlet UIView *editStudentButtonView;
    __weak IBOutlet UIView *cancelEditStudentButtonView;
    __weak IBOutlet UIStackView *editStudentActionStack;
    __weak IBOutlet UIButton *editStudentSelectAllButton;
    __weak IBOutlet UIButton *editStudentClearAllButton;
    __weak IBOutlet UIButton *editStudentActionButton;
    __weak IBOutlet UIView *advanceSearchButtonView;
    
    SortingRecord *sortingobject;
    
    BOOL runviewdidappear;
    
    NSMutableArray *selectedStudentKeysArray;
    
}

@property (weak, nonatomic) IBOutlet UIView *StudentDetailsContainerView;
//@property (strong, nonatomic) IBOutlet UIView *StudentCategoryContainerView;
@property (strong, nonatomic) Student *InformationViewStudent;

@property (strong,nonatomic) StudentDetailsViewController *destStudentDetailsViewController;
//@property (strong,nonatomic) StudentCategoryViewController *destStudentCategoryViewController;
@property (strong,nonatomic) DTRecord *StudentInformationDTObject;
@property (strong,nonatomic) AssessmentTrialRecord *StudentInformationATObject;
@property (strong,nonatomic) ClassScheduleRecord *StudentInformationClassScheduleObject;
@property (strong,nonatomic) Lead *StudentInformationLeadObject;
@property (strong,nonatomic) NSString *StudentInformationAction;

//-(void) addNewStudent;
//-(void) addDTStudent;
-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys saleskey:(NSString *)saleskey;
- (IBAction)menubuttonpressed:(id)sender;
- (IBAction)addnewstudentbuttonpressed:(id)sender;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)photoalbumbuttonpressed:(id)sender;
- (IBAction)sortingbuttonpressed:(id)sender;
- (IBAction)advancedSearchButtonPressed:(id)sender;
- (IBAction)editstudentbuttonpressed:(id)sender;
- (IBAction)canceleditstudentbuttonpressed:(id)sender;
- (IBAction)editstudentselectallbuttonpressed:(id)sender;
- (IBAction)editstudentclearallbuttonpressed:(id)sender;
- (IBAction)editstudentactionbuttonpressed:(id)sender;



@end
