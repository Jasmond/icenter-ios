//
//  TimeTableTabViewController.h
//  
//
//  Created by Jasmond Luk on 17/9/2020.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myTimeTableTabViewControllerDelegate <NSObject>
@required
-(void) updateClassTimeTableWithSelectedHeaderArray:(NSMutableArray *)t_selectedHeaderArray;
@end

@interface TimeTableTabViewController : UIViewController
{
    GlobalVariables *globalvariables;
    
    __weak IBOutlet UITableView *itemtable;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIButton *deselectallbutton;
    __weak IBOutlet UIButton *updatebutton;
    __weak IBOutlet UILabel *title_showinactiveitems;
    __weak IBOutlet UISwitch *swShowInactiveItems;
    
    NSMutableArray *filteredHeaderArray;
    NSMutableArray *t_selectedHeaderArray;
    
}
@property (strong,nonatomic) id<myTimeTableTabViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *headerArray;
@property (nonatomic,strong) NSMutableArray *selectedHeaderArray;
@property (nonatomic,strong) NSString *headertype;
@property (nonatomic,strong) NSString *TimeTableMode;
@property (nonatomic) NSInteger buttontag;

- (IBAction)selectallbuttonpressed:(id)sender;
- (IBAction)deselectallbuttonpressed:(id)sender;
- (IBAction)updateshowinactiveitems:(UISwitch *)sender;
- (IBAction)updatebuttonpressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
