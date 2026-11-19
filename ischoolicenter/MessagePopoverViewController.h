//
//  MessagePopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 16/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
//#import "StudentImagePopoverViewController.h"
#import "LeadImageGridViewController.h"
#import "StudentImageGridViewController.h"
#import "CalendarView.h"
#import "MyTableViewCell.h"
#import "WebKit/WebKit.h"
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol myMessagePopoverViewControllerDelegate <NSObject>

-(void) dismissMessagePopoverVC;
//-(void) copyMessage;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) donotrunviewdidappear;


@end

@interface MessagePopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate,myStudentImageGridViewControllerDelegate,myLeadImageGridViewControllerDelegate,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myCalendarViewDelegate,UIDocumentPickerDelegate>{
    
    //sqlite3 *isdb;
    
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;

    OutboxMessageRecord *workingMessage;
    
    long presetRow;
    long datePresetRow;
    long minutePresetRow;
    long hourPresetRow;
    
    BOOL showStartTimeTable;
    
    UIPickerView *myPicker;
    
    BOOL showMessageTypeTable;
    BOOL showTargetTable;
    BOOL showIndividualTable;
    BOOL showSubjectTable;
    BOOL showInstructorTable;
    BOOL showClassDateTable;
    BOOL showGradeTable;
    BOOL showLeadStatusTable;
    BOOL showStudentStatusTable;
    BOOL showStaffGroupTable;
    BOOL showDropTable;
    BOOL showReadStatusTable;
    BOOL showReadStatusContactTable;
    BOOL showMessagePhoto;
    BOOL showRecipientListTable;
    
    UIButton *yearButton;
    
    
    UIView *MessageTypeTableMasterView;
    UITableView *MessageTypeTable;
    UIToolbar *MessageTypeTableToolBar;

    UIView *TargetTableMasterView;
    UITableView *TargetTable;
    UIToolbar *TargetTableToolBar;

    UIView *IndividualTableMasterView;
    UITableView *IndividualTable;
    UIToolbar *IndividualTableToolBar;
    UISearchBar *individualsearchbar;

    UIView *RecipientListTableMasterView;
    UITableView *RecipientListTable;
    UIToolbar *RecipientListTableToolBar;
    UISearchBar *RecipientListsearchbar;
    
    UIView *SubjectTableMasterView;
    UITableView *SubjectTable;
    UIToolbar *SubjectTableToolBar;
    UISearchBar *subjectsearchbar;
    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    UISearchBar *instructorsearchbar;
    
    UIView *ClassDateTableMasterView;
    UITableView *ClassDateTable;
    UIToolbar *ClassDateTableToolBar;
    
    UIView *GradeTableMasterView;
    UITableView *GradeTable;
    UIToolbar *GradeTableToolBar;

    UIView *LeadStatusTableMasterView;
    UITableView *LeadStatusTable;
    UIToolbar *LeadStatusTableToolBar;
    
    UIView *StudentStatusTableMasterView;
    UITableView *StudentStatusTable;
    UIToolbar *StudentStatusTableToolBar;
    
    UIView *StaffGroupTableMasterView;
    UITableView *StaffGroupTable;
    UIToolbar *StaffGroupTableToolBar;

    UIView *StartTimeTableMasterView;
    UITableView *StartTimeTable;
    UIToolbar *StartTimeTableToolBar;

    
    UIView *DropTableMasterView;
    UITableView *DropTable;
    UIToolbar *DropTableToolBar;

    UIView *ReadStatusTableMasterView;
    UITableView *ReadStatusTable;
    UIToolbar *ReadStatusTableToolBar;
    UISearchBar *readstatussearchbar;

    UIView *ReadStatusContactTableMasterView;
    UITableView *ReadStatusContactTable;
    UIToolbar *ReadStatusContactTableToolBar;
    NSMutableArray *readstatuscontactarray;
    ReadStatusRecord *readstatusobject;
    
    
    NSArray *messagetypearray;
    NSArray *targetarray;
    NSMutableArray *allindividualarray;
    NSMutableArray *filteredindividualarray;
    NSMutableArray *allsubjectarray;
    NSMutableArray *filteredsubjectarray;
    NSMutableArray *allinstructorarray;
    NSMutableArray *filteredinstructorarray;
    NSMutableArray *gradearray;
    NSMutableArray *leadstatusarray;
    NSMutableArray *studentstatusarray;
    NSMutableArray *droparray;
    NSMutableArray *activearray;
    NSMutableArray *allreadstatusarray;
    NSMutableArray *filteredreadstatusarray;
    //NSMutableArray *allrecipientlistarray;
    NSMutableArray *filteredrecipientlistarray;

    
    BOOL keyboardshow;
    float keyboardheight;
    
    NSMutableArray *JSONArray;

    NSMutableArray *pickerViewMenu;
    NSMutableArray *hourPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    UIPickerView *myPickerView;
    
    NSMutableArray *StudentSubjectListArray;
    NSMutableArray *StudentGroupListArray;
    NSMutableArray *LeadGroupListArray;
    NSMutableArray *LeadStatusListArray;
    NSMutableArray *recipientlistarray;
    
    UIButton *individualimagebutton;
    
    
    UIToolbar *MessageToolbar;

    __weak IBOutlet UITableView *MessagePopoverTable;
    
    NSString *selectedItem;
    
    UISegmentedControl *scassigntype;
    UISegmentedControl *scendtimetype;
    UISegmentedControl *scstarttimetype;
    
    NSDateFormatter *df;
    
    UIPopoverPresentationController *mypopovercontroller;
    UIButton *addphotobutton;
    
    StudentImageGridViewController *studentimagepopover;
    LeadImageGridViewController *leadimagepopover;
    
    NSCache *imageCache;

    UIImagePickerController *imagepicker;
    CGRect popuprect;
    
    UIScrollView *fullscreen_scrollview;
    UIButton * fullscreen_closebutton;
    UIImageView *fullscreen_messageimageview;
    UIView *MessagePhotoMasterView;
    UIToolbar *MessagePhotoToolBar;
    
    MessagePhotoRecord *messagephotoobject;
    
    UIPopoverPresentationController *sharepopup;
    
    BOOL photoimagechanged;
    BOOL automessage;
    
    NSMutableArray *recipientRowDataArray;
    __weak IBOutlet NSLayoutConstraint *tablebottomconstraint;
    
    NSMutableDictionary *outboxDocumentKeyCenterkey;
    
    WKWebView *webView;
    UIView *videoView;
    AVPlayerViewController *avplayerviewcontroller;
    
    __weak IBOutlet UIView *CenterMasterView;
    __weak IBOutlet UIToolbar *centertoolbar;
    __weak IBOutlet UIButton *centerNoneButton;
    __weak IBOutlet UIButton *centertAllButton;
    __weak IBOutlet UITableView *centertable;
    __weak IBOutlet NSLayoutConstraint *centertablebottomconstraint;
    UISearchBar *centersearchbar;
    BOOL showCenterTable;
    NSMutableArray *allcenterarray;
    NSMutableArray *filteredCenterArray;
    NSMutableArray *selectedCenters;
    __weak IBOutlet UIView *centertableseparator;
    
    NSInteger minMaxUploadFileSize;
    __weak IBOutlet UIButton *saveasdraftButton;
    __weak IBOutlet UIButton *copyButton;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *saveButton;
    
    UIButton *photocloseButton;
    UIButton *photorotateButton;
    UIButton *photoshareButton;
    
}

@property (strong,nonatomic) NSString *CallingKey;
@property (strong,nonatomic) NSString *MessageTableMode;
@property (strong,nonatomic) OutboxMessageRecord *OMessageRecordObject;
@property (weak,nonatomic)id <myMessagePopoverViewControllerDelegate>delegate;
@property (strong,nonatomic) NSString *CallingSource;
@property (strong,nonatomic) NSMutableArray *allstudentarray;
@property (strong,nonatomic) NSMutableArray *allleadarray;
@property (strong,nonatomic) NSMutableArray *allstaffarray;
@property (strong,nonatomic) NSMutableArray *staffgrouparray;

-(BOOL) InitializeField;
-(void) sendMessageWithOutBoxMessage:(OutboxMessageRecord *)outboxmessage;
-(void) sendOutboxDocument;
-(void) sendAssessmentReport;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)centernonebuttonpressed:(id)sender;
- (IBAction)centerallbuttonpressed:(id)sender;

- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)draftButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;



@end
