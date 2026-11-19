//
//  StaffGroupViewController.h
//  iCenter
//
//  Created by Jasmond on 5/11/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "GCPlaceholderTextView.h"

@protocol myStaffGroupViewControllerDelegate <NSObject>

-(void) closestaffgroupviewcontrollerwithreload:(BOOL)reload;

@end

NS_ASSUME_NONNULL_BEGIN

@interface StaffGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UILabel *titlelabel;
    __weak IBOutlet UIView *memberview;
    __weak IBOutlet UIView *groupview;
    __weak IBOutlet UIButton *groupbutton;
    __weak IBOutlet UIButton *memberbutton;
    __weak IBOutlet UITableView *staff_groupnametable;
    __weak IBOutlet UITableView *staff_groupdetailstable;
    __weak IBOutlet UITableView *staff_membertable;
    __weak IBOutlet UIButton *closebutton;
    UIScrollView *staff_membergroupview;
    UITableView *staff_membergrouptable;
    
    NSInteger selectedGroupNameRow;
    NSMutableArray *GroupArray;
    NSMutableDictionary *groupcountdictionary;
    NSMutableArray *allStaffArray;
    NSUInteger tableViewCellIdentifierCount;
    NSString *tableViewCellIdentifier;
    NSMutableArray *JSONArray;
    NSArray *groupalertarray;
    GCPlaceholderTextView *groupdescriptiontext;
    
    BOOL informationupdated;
    
}
@property (nonatomic,weak) id<myStaffGroupViewControllerDelegate>delegate;
- (IBAction)addgroup:(id)sender;
- (IBAction)deletegroup:(id)sender;
- (IBAction)closebuttonpressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
