//
//  LeadInformationViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "LeadDetailsViewController.h"
#import "sqlite3.h"

@interface LeadInformationViewController : UIViewController <myLeadDetailsViewController,myLeadImageGridViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    //sqlite3 *isdb;
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    NSString *Leadkey;
    NSInteger Submenu;
    NSString *DTkey;
    
    NSMutableArray *jsonArray;
    NSMutableArray *AllArray;
    NSMutableArray *GenderArray;
    NSMutableArray *GradeArray;
    NSMutableArray *StatusArray;
    NSMutableArray *OtherArray;
    NSMutableArray *SourceArray;
    
    NSMutableArray *filteredLeadArray;
    NSMutableArray *leadArray;
    
    __weak IBOutlet UITableView *leadlisttable;
    LeadImageGridViewController *leadimagepopover;
    
    CategoryCountRecord *categorycountobject;
    
    UIView *lostconnectionview;
    UIButton *reloadbutton;
    UILabel *lostconnectviewlabel;
    
    UIRefreshControl *tablerefresh;
    
    NSString *leadTableMode;
    NSString *leadCategory;
    __weak IBOutlet UISearchBar *leadsearchbar;
    
    NSMutableArray *sortingarray;
    SortingRecord *sortingobject;
    NSIndexPath *lastindexpath;
    NSInteger selectedMenuPageIndex;
    
    Lead *leadobject;
    NSString *lastleadkey;
    ClassKeys *selectedKeys;
    
    
    __weak IBOutlet UIButton *menubutton;
    __weak IBOutlet UIButton *addNewLeadButton;
    __weak IBOutlet UIStackView *backbuttonstack;
    __weak IBOutlet UIButton *backbutton;
    __weak IBOutlet UIActivityIndicatorView *ailoadindicator;
    __weak IBOutlet UIView *topleftview;
    __weak IBOutlet UIButton *photoalbumbutton;
    __weak IBOutlet UIButton *sortingbutton;
    
    BOOL runviewdidappear;
    
}

@property (weak, nonatomic) IBOutlet UIView *LeadDetailsContainerView;
@property (strong, nonatomic) Lead *InformationViewLead;

@property (strong,nonatomic) LeadDetailsViewController *destLeadDetailsViewController;
@property (strong,nonatomic) NSString *LeadInformationAction;

//-(void) addNewLead;
-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys;
- (IBAction)menubuttonpressed:(id)sender;
- (IBAction)addnewleadbuttonpressed:(id)sender;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)photoalbumbuttonpressed:(id)sender;
- (IBAction)sortingbuttonpressed:(id)sender;
@end

