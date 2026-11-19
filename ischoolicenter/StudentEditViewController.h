//
//  StudentEditViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/3/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "StudentListPopoverViewController.h"
#import "PickerViewController.h"

@protocol myStudentEditViewControllerDelegate <NSObject>

-(void) refreshStudentView:(NSString *)studentkey;
-(void) updateStudentCategoryCount;
-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload;
-(void) deleteStudent:(NSString *)studentkey;
-(void) addNewSiblingStudent;
-(void) enrollATSubject;
-(void) addStudentSubject;
-(void) cancelStudent;
-(void) dataChanged;
//-(void) showstudentlist:(NSString *)studentkey;
-(void) disableAddStudentButton;
//-(void) gotostudentprofile;
-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys saleskey:(NSString *)saleskey;

@end

@interface StudentEditViewController : UIViewController<UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,myStudentListPopoverViewControllerDelegate,UITextViewDelegate,UISearchBarDelegate,myPickerViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;

    BOOL imageedited;
    BOOL imagedeleted;
    BOOL imageadded;
    
    UIButton *addphotobutton;
    UIButton *deletephotobutton;
    UIButton *editphotobutton;
    
    NSMutableArray *JSONArray;

    NSString *newstudentkey;
    
    UITableView *SiblingTable;
    
    UILabel *siblingnamelabel;
    UILabel *siblingrelationshiplabel;
    
    SiblingRecord *siblingobject;
    UILabel *siblingtableheader;
    //NSMutableArray *usersiblingarray;
    
    StudentListPopoverViewController *studentlistpopovercontroller;
    

    
    UITableView *studentTable;
    
    UITextField *lastnametext;
    UITextField *firstnametext;
    UITextField *othernametext;
    UITextField *schooltext;
    UITextField *extrafield1text;
    UITextField *studentidtext;
    UITextField *fcmemberidtext;
    UITextField *parentnametext;
    UITextField *parentname2text;
    UITextField *parentemailtext;
    UITextField *parentaddresstext;
    UITextField *ddaaccountnotext;
    UITextField *ddaaccountnametext;
    UITextField *ddadebtorreferencetext;
    UITextField *ddalimittext;
    UITextView *remarkstext;
    UISegmentedControl *scgender;
    
    Student *workingStudent;

    
    int presetRow;
    
    NSString *selectedItem;
    NSString *selectedValue;
    
    NSMutableArray *pickerViewMenu;
    UIPickerView *myPickerView;
    UIDatePicker *myDatePickerView;

    
    UITableView *phonetypetable;
    
    NSArray *phonetypearray;
    long phoneeditbuttonselected;
    NSString *addoreditphonebutton;
    
    UILabel *phonetypeLabel;
    
    UIButton *pceditbutton;
    UIButton *pcaddbutton;
    UILabel *pclabel;
    UITextField *parentcontacttext;
    
    float keyboardheight;
    
    //UIBarButtonItem *enableparentappbutton;
    //UIButton *embededparentbutton;
    
    //UIBarButtonItem *enablesmsbutton;
    //UIButton *embededsmsbutton;
    //UIButton *embededprimarybutton;
    
    float offset;
    
//    UIView *MasterView;
    __weak IBOutlet UIView *MasterView;
    
    BOOL phonearraychanged;
    BOOL siblingarraychanged;
    
    UIView *sideselectionview;
    UIButton *filterviewbutton;
    
    //float sideselectionviewwidth;
    
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
    
    UIView *extrafield2masterview;
    UITableView *extrafield2table;
    NSArray *extrafield2array;
    
    UIView *dobmasterview;
    
    float selfViewWidth;
    int maxcontactperline;

    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *doneButton;
    
}


@property (nonatomic,strong) Student *EditViewStudent;
@property (nonatomic,strong) NSString *EditViewStudentAction;
//@property (nonatomic,strong) StudentEditTableViewController *destStudentEditTableViewController;
@property (nonatomic,strong) UIPopoverPresentationController *mypopovercontroller;

@property (nonatomic,strong) UIImagePickerController *imagepicker;

@property (nonatomic,weak)id<myStudentEditViewControllerDelegate>delegate;
@property (strong, nonatomic) UIImageView *studentimage;
@property (strong,nonatomic) NSMutableArray *MediaArray;
@property (strong,nonatomic) NSMutableArray *SourceArray;

//- (IBAction)addphotobuttonpressed:(id)sender;
//- (IBAction)deletephotobuttonpressed:(id)sender;
//- (IBAction)editphotobuttonpressed:(id)sender;

-(IBAction) doneStudent:(id)sender;
-(IBAction) cancelStudent:(id)sender;

@end
