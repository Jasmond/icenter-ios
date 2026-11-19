//
//  PointViewController.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 14/7/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

@protocol myPointViewControllerDelegate <NSObject>

-(void) issuePointToStudents:(NSMutableArray *)studentkeys multipleStudents:(BOOL)multiplestudents;
-(void) dismissPointViewWithReload:(BOOL)reload;
-(void) editStudentPoint:(PointRecord *)pointrecord;

@end

@interface PointViewController : UIViewController
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    __weak IBOutlet UITableView *PointHistoryTable;
    __weak IBOutlet UISegmentedControl *typeSC;
    __weak IBOutlet UISearchBar *searchbar;
    
    __weak IBOutlet UILabel *issuedatetitle;
    __weak IBOutlet UILabel *typetitle;
    __weak IBOutlet UILabel *detailstitle;
    __weak IBOutlet UILabel *pointtitle;
    __weak IBOutlet UILabel *unusedpointtitle;
    __weak IBOutlet UILabel *expirydatetitle;
    __weak IBOutlet UILabel *remarkstitle;
    
    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UIButton *issueButton;
    
    
    NSMutableArray *typeArray;
    NSMutableArray *PointRecordArray;
    NSMutableArray *filteredPointRecordArray;
    NSDictionary *expirypointdict;
    NSString *pointbalance;
    
    UIRefreshControl *tablerefresh;
}

@property (nonatomic,weak)id<myPointViewControllerDelegate>delegate;
@property (strong,nonatomic) NSString *studentkey;
- (IBAction)typeupdated:(id)sender;
- (void) reloadPointHistoryTable;
-(void) getStudentPointHistory;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) issuePointButtonPressed:(id)sender;

@end


