//
//  LeadEditViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
//#import "LeadEditTableViewController.h"

@protocol myLeadEditViewControllerDelegate <NSObject>

-(void) refreshLeadView:(NSString *)leadkey;
-(void) updateLeadCategoryCount;
-(void) updateleadinformationlist:(NSString *)leadkey;
-(void) deleteLead:(NSString *)leadkey;
//-(void) showleadlist:(NSString *)leadkey;
-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys;
-(void) cancelLead;
- (void) dataChanged;

@end

@interface LeadEditViewController : UIViewController <UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    GlobalVariables *globalvariables;
    
    BOOL imageedited;
    BOOL imagedeleted;
    BOOL imageadded;
    
    UIButton *addphotobutton;
    UIButton *deletephotobutton;
    UIButton *editphotobutton;
    
    NSMutableArray *JSONArray;
    
    BOOL parentappdefault;
    
    UITableView *leadTable;
    
    UITextField *lastnametext;
    UITextField *firstnametext;
    UITextField *othernametext;
    UITextField *schooltext;
    UITextField *leadidtext;
    UITextField *parentnametext;
    UITextField *parentemailtext;
    UITextField *parentcontacttext;
    UITextField *parentaddresstext;
    UITextView *remarkstext;
    UISegmentedControl *scgender;
    
    
    Lead *workingLead;

    int presetRow;
    
    NSString *selectedItem;
    NSString *selectedValue;
    
    NSMutableArray *pickerViewMenu;
    UIPickerView *myPickerView;
    UIDatePicker *myDatePickerView;
    
    float keyboardheight;
    
//    UIView *MasterView;
    __weak IBOutlet UIView *MasterView;
    
    UIView *sideselectionview;
    UIButton *filterviewbutton;

    UIView *schoolmasterview;
    UITableView *schooltable;
    NSMutableArray *schoolarray;
    NSMutableArray *filteredschoolarray;
    UISearchBar *schoolsearchbar;
    
    UIView *agemasterview;
    UITableView *agetable;
    NSMutableArray *agearray;
    
    UIView *grademasterview;
    UITableView *gradetable;
    NSMutableArray *gradearray;
    
    UIView *preferredlanguagemasterview;
    UITableView *preferredlanguagetable;
    NSMutableArray *preferredlanguagearray;
    
    UIView *sourcemasterview;
    UITableView *sourcetable;
    NSMutableArray *sourcearray;
    
    UIView *mediamasterview;
    UITableView *mediatable;
    NSMutableArray *mediaarray;
    
    UIView *dobmasterview;
    
    float selfViewWidth;
    
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *doneButton;
    
}


@property (nonatomic,strong) Lead *EditViewLead;
@property (nonatomic,strong) NSString *EditViewLeadAction;
@property (nonatomic,strong) UIPopoverPresentationController *mypopovercontroller;

@property (nonatomic,strong) UIImagePickerController *imagepicker;

@property (nonatomic,weak)id<myLeadEditViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *leadimage;
@property (strong,nonatomic) NSMutableArray *MediaArray;
@property (strong,nonatomic) NSMutableArray *SourceArray;

-(IBAction) doneLead:(id)sender;
-(IBAction) cancelLead:(id)sender;


@end
