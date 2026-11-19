//
//  GivenOutViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 31/3/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN
@protocol myGivenOutViewControllerDelegate <NSObject>

-(void) returnSelectedSaleskeysForYetGivenOutOrder:(NSMutableArray *)saleskeys;

@end

@interface GivenOutViewController : UIViewController
{
    GlobalVariables *globalvariables;
    
    __weak IBOutlet UITableView *itemtable;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIButton *deselectallbutton;
    __weak IBOutlet UIButton *updatebutton;
    
    NSMutableArray *filteredSalesRecord;
    NSMutableArray *selectedSaleskeys;
    
    ProductRecord * productobject;

}
@property (strong,nonatomic) id<myGivenOutViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *salesrecords;

- (IBAction)selectallbuttonpressed:(id)sender;
- (IBAction)deselectallbuttonpressed:(id)sender;
- (IBAction)updatebuttonpressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
