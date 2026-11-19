//
//  ClassroomPopoverViewController.h
//  
//
//  Created by Jasmond Luk on 16/6/2015.
//
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "GCPlaceholderTextView.h"

@protocol myClassroomPopoverViewControllerDelegate <NSObject>

-(void) dismissClassroomPopover;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface ClassroomPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UILabel *GeneralLabel;
    UILabel *ClassroomLabel;
    UILabel *StatusLabel;
    UILabel *RemarksLabel;
    
    GCPlaceholderTextView *ClassroomText;
    GCPlaceholderTextView *RemarksText;
    UISegmentedControl *scStatus;
    
    ClassroomRecord *workingClassroom;
    NSMutableArray *capacityArray;
    BOOL showCapacityPicker;
    NSMutableArray *pickerViewmenu;
    UIPickerView *myPickerView;
    
    GlobalVariables *globalvariables;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    NSMutableArray *JSONArray;
    
    IBOutlet UIToolbar *ClassroomToolbar;
    
    UITableView *ClassroomPopoverTable;

    NSDateFormatter *df;
    NSArray *classroomstatusarray;
    
    BOOL showColorCodeTable;
    UIToolbar *ColorCodeTableToolBar;
    UITableView *ColorCodeTable;
    UIView *ColorCodeTableMasterView;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
}

@property (strong,nonatomic) NSString *ClassroomTableMode;
@property (strong,nonatomic) ClassroomRecord *ClassroomRecordObject;
@property (weak,nonatomic)id<myClassroomPopoverViewControllerDelegate>delegate;

-(IBAction) deleteButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) editButtonPressed:(id)sender;

@end
