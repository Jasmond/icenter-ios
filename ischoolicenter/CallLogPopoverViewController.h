//
//  CallLogPopoverViewController.h
//  
//
//  Created by Jasmond Luk on 14/5/15.
//
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "CalendarView.h"

@protocol myCallLogPopoverViewControllerDelegate <NSObject>

-(void) dismissCallLogPopoverVC;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end


@interface CallLogPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,myCalendarViewDelegate>{
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;
    UILabel *CalledByLabel;
    UILabel *CalledOnLabel;
    UILabel *DetailsLabel;
    
    UITextView *DetailsText;
    
    NSString *tmpCalledBy;
    NSString *tmpCalledByUsername;
    NSString *tmpCalledOn;
    NSString *tmpDetails;
    NSString *tmpType;
    NSString *tmpTypeKey;
    
    long presetRow;
    long datePresetRow;
    
    BOOL showCalledByPicker;
    BOOL showCalledOnPicker;
    
    GlobalVariables *globalvariables;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    NSMutableArray *JSONArray;
    
    NSMutableArray *pickerViewMenu;
    //NSMutableArray *datePickerViewMenu;
    UIPickerView *myPickerView;
    
    IBOutlet UIToolbar *CallLogToolbar;
    
    UITableView *CallLogPopoverTable;
    
    NSString *selectedItem;

    NSDateFormatter *df;
    
    NSMutableArray *userListArray;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
    
}

@property (strong,nonatomic) NSString *CallLogTableMode;
@property (strong,nonatomic) CallLogRecord *CallLogRecordObject;
@property (strong,nonatomic) NSString *studentkey;
@property (weak,nonatomic)id<myCallLogPopoverViewControllerDelegate>delegate;
@property (strong,nonatomic) NSString *CallingSource;

-(BOOL) InitializeField;
-(IBAction) editButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) deleteButtonPressed:(id)sender;

@end
