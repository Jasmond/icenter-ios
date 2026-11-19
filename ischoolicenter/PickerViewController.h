//
//  PickerViewController.h
//  iCenter
//
//  Created by Jasmond on 12/7/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

@protocol myPickerViewControllerDelegate <NSObject>

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button;
-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems;

@end

@interface PickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    GlobalVariables *globalvariables;
    //NSMutableArray *itemarray;
    NSMutableArray *filtereditemsarray;
    __weak IBOutlet UITableView *pickerTable;
    __weak IBOutlet UISearchBar *searchbar;
    __weak IBOutlet UIButton *bottombutton;
    __weak IBOutlet UIButton *bottombutton2;
    __weak IBOutlet UIView *headerview;
    __weak IBOutlet UILabel *headertitle;
}

@property (nonatomic,weak)id<myPickerViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *selecteditems;
@property (nonatomic,strong) NSMutableArray *itemsarray;
@property (nonatomic,strong) NSString *datatype;
@property (nonatomic) NSInteger dataindex;
@property (nonatomic) BOOL showsearchbar;
@property (nonatomic) BOOL multipleSelection;
@property (nonatomic,strong) NSString *viewtitle;
@property (nonatomic,strong) NSString *bottommode;
@property (nonatomic,strong) UIButton *button;
- (IBAction)bottombuttonpressed:(id)sender;
- (IBAction)readstatusdetailsbuttonpressed:(id)sender;

@end
