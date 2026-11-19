//
//  TimeTableFilterViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 16/2/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myTimeTableFilterViewControllerDelegate <NSObject>
-(void) returnTimeTableFilterSelectedItems:(NSMutableDictionary *)selecteditems;
@end

@interface TimeTableFilterViewController : UIViewController{
    GlobalVariables *globalvariables;
    
    __weak IBOutlet UITableView *itemtable;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIButton *deselectallbutton;
    __weak IBOutlet UIButton *updatebutton;
    __weak IBOutlet UILabel *title_showinactiveitems;
    __weak IBOutlet UISwitch *swShowInactiveItems;
    __weak IBOutlet UISegmentedControl *typeSC;
    
    NSMutableArray *instructorArray;
    NSMutableArray *classroomArray;
    NSMutableArray *subjectArray;
    
    NSMutableArray *filteredItemArray;
    NSMutableArray *selectedInstructors;
    NSMutableArray *selectedClassrooms;
    NSMutableArray *selectedSubjects;
}
@property (strong,nonatomic) id<myTimeTableFilterViewControllerDelegate>delegate;
@property NSMutableDictionary *selectedItems;
@property NSString *headertype;

- (IBAction)selectallbuttonpressed:(id)sender;
- (IBAction)deselectallbuttonpressed:(id)sender;
- (IBAction)updateshowinactiveitems:(UISwitch *)sender;
- (IBAction)updatebuttonpressed:(id)sender;
- (IBAction)selectType:(id)sender;

@end

NS_ASSUME_NONNULL_END
