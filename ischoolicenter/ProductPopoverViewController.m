//
//  ProductPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/12/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "ProductPopoverViewController.h"
#import "MyClass.h"
#import "MessagePhotoCollectionViewCell.h"
#import "SDWebImage.h"

@import Photos;
@import BSImagePicker;

@interface ProductPopoverViewController ()

@end

@implementation ProductPopoverViewController
@synthesize ProductObject,ProductTableMode,ProductCategoryArray,ProductCodeArray;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define popoverwidth 320
#define autorenewwidth 320
#define productphotowidth 550

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    workingProduct=[[ProductRecord alloc]init];
    
    [self InitializeField];
    
    
    //masterView=[[UIScrollView alloc]init];
    [self createtables];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    dayPickerViewMenu=[[NSMutableArray alloc]initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];

    // year array
    autoRenewTypePickerViewMenu=[[NSMutableArray alloc]initWithObjects:@"Days",@"Weeks",@"Months",@"Years", nil];

    //month array
    autoRenewValuePickerViewMenu=[[NSMutableArray alloc]init];
    for (int i=1; i<366; i++) {
        [autoRenewValuePickerViewMenu addObject:[NSString stringWithFormat:@"%i",i]];
    }
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [cloneButton setTitle:[MyClass returntitlewithtitle:@"Clone"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
       [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

-(void) createViewBarButton{
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *cloneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Clone"] style:UIBarButtonItemStylePlain target:self action:@selector(cloneButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:cloneButton,flexibleSpaceBarButton,editButton,nil];
//    [ProductToolBar setItems:buttons animated:NO];
    
    
    editButton.hidden=NO;
    cloneButton.hidden=NO;
    cancelButton.hidden=YES;
    doneButton.hidden=YES;
    
    editButton.enabled=(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editproduct && ![ProductObject.code isEqualToString:@"FPAY"])?YES:NO;
    
}

-(void) createEditBarButton{
//    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:cancelButton,flexibleSpaceBarButton,doneButton,nil];
//    [ProductToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    cloneButton.hidden=YES;
    cancelButton.hidden=NO;
    doneButton.hidden=NO;
    
}

-(void) createAddBarButton{
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [ProductToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    cloneButton.hidden=YES;
    cancelButton.hidden=YES;
    doneButton.hidden=NO;
    
}

-(IBAction) editButtonPressed:(id)sender{
    
    ProductTableMode=@"Edit";
    //[self createEditBarButton];
    [self InitializeField];
    
    if(showProductPhoto){
        [self createMessagePhotoToolBar];
    }
    
    //[ClassPopoverTable setFrame:CGRectMake(0, 0, 320, editTableHeight)];
    [ProductPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    ProductTableMode=@"View";
    //[self createViewBarButton];
    [ProductPopoverTable reloadData];
    [self InitializeField];
    [self showsidewindowwithwindow:@""];
    //[ClassPopoverTable setFrame:CGRectMake(0, 0, 320, editTableHeight)];
    [ProductPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) cloneButtonPressed:(id)sender{
    
    ProductTableMode=@"Clone";
    [self createAddBarButton];
    [self InitializeField];
    
    [ProductPopoverTable reloadData];
    [self adjusttablesize];
}

-(void) createtables
{
//    ProductPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    ProductPopoverTable.dataSource=self;
//    ProductPopoverTable.delegate=self;
    ProductToolBar.clipsToBounds=YES;
    
    //Message Photo
    MessagePhotoMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, productphotowidth, self.view.frame.size.height)];
    [self.view addSubview:MessagePhotoMasterView];

    
    fullscreen_scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+20, MessagePhotoMasterView.bounds.size.width, MessagePhotoMasterView.bounds.size.height-44-20)];
    fullscreen_scrollview.backgroundColor=[UIColor blackColor];
    fullscreen_scrollview.maximumZoomScale=7.0;
    fullscreen_scrollview.minimumZoomScale=1;
    fullscreen_scrollview.delegate=self;
    
    [MessagePhotoMasterView addSubview:fullscreen_scrollview];
    fullscreen_messageimageview=[[UIImageView alloc]init];
    fullscreen_messageimageview.backgroundColor=[UIColor whiteColor];
    fullscreen_messageimageview.contentMode=UIViewContentModeScaleAspectFit;
    [fullscreen_scrollview addSubview:fullscreen_messageimageview];
    fullscreen_scrollview.contentSize = fullscreen_messageimageview.frame.size;
    
    MessagePhotoToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, productphotowidth, 44)];
    [MessagePhotoMasterView addSubview:MessagePhotoToolBar];
    [self createMessagePhotoToolBar];
    
    photocloseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photocloseButton.frame = CGRectMake(20, 33, 20, 20);
    [photocloseButton setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [photocloseButton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [photocloseButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photocloseButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photocloseButton];
    
    photorotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photorotateButton.frame = CGRectMake(productphotowidth-40, 33, 20, 20);
    [photorotateButton setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
    [photorotateButton addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
    [photorotateButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photorotateButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photorotateButton];
    
    photoshareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photoshareButton.frame = CGRectMake(productphotowidth-40, 33, 20, 20);
    [photoshareButton setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
    [photoshareButton addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
    [photoshareButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photoshareButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photoshareButton];
    
    [ProductPopoverTable reloadData];
    
    
    
    [self adjusttablesize];
    
//    [self.view addSubview:ProductPopoverTable];
    
    //Validity table
    AutoRenewTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, autorenewwidth, self.view.frame.size.height)];
    [self.view addSubview:AutoRenewTableMasterView];
    
    AutoRenewTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, autorenewwidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    AutoRenewTable.dataSource=self;
    AutoRenewTable.delegate=self;
    AutoRenewTable.scrollEnabled=NO;
    
    [AutoRenewTableMasterView addSubview:AutoRenewTable];
    
    AutoRenewTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, autorenewwidth, 44)];
    AutoRenewTableToolBar.clipsToBounds=YES;
    [AutoRenewTableMasterView addSubview:AutoRenewTableToolBar];
    [self createAutoRenewTableToolBar];
    
    //add separator
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 0, 1, self.view.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
}

-(void) createMessagePhotoToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *rotateButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    photoshareButton.hidden=YES;
    photorotateButton.hidden=YES;
    
    if ([ProductTableMode isEqualToString:@"View"]) {
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,shareButton, nil];
        photoshareButton.hidden=NO;
    }else{
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,rotateButton, nil];
        photorotateButton.hidden=NO;
    }
//    [MessagePhotoToolBar setItems:barItems];
}

-(void) createAutoRenewTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    UIBarButtonItem *noneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"None"] style:UIBarButtonItemStylePlain target:self action:@selector(setAutoRenewToNone)];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,noneButton, nil];
//    [AutoRenewTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [AutoRenewTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setAutoRenewToNone) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(autorenewwidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [AutoRenewTableMasterView addSubview:button];
    
    
}

-(void) setAutoRenewToNone
{
    workingProduct.autorenew=@"";
    [ProductPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [ProductPopoverTable deselectRowAtIndexPath:[ProductPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==ProductPopoverTable) {
            if ([ProductTableMode isEqualToString:@"View"]) {
            return 6;
        }else if ([ProductTableMode isEqualToString:@"Edit"]) {
            return 7;
        }else{
            return 6;
        }
    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==ProductPopoverTable) {
        if ([ProductTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 5;
            }else if (section==3){
                return 2;
            }
        }else if ([ProductTableMode isEqualToString:@"Edit"]) {
            if (section==0) {
                return 5;
            }else if (section==3){
                return 2;
            }
        }else{
            if (section==0) {
                return 5;
            }else if (section==3){
                return 2;
            }
        }
    }
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==ProductPopoverTable) {
        if ([ProductTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Product"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Photo"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Inventory"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Status"];
            }else if (section==5){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }else if ([ProductTableMode isEqualToString:@"Edit"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Product"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Photo"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Inventory"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Status"];
            }else if (section==5){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }else{
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Product"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Photo"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Inventory"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Status"];
            }else if (section==5){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }
    }else if (tableView==AutoRenewTable){
        return [MyClass returntitlewithtitle:@"Product Auto Renew"];
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (headerTitle) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:headerTitle] uppercaseString];;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        return header;
    }

    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ProductPopoverTable) {
        if (indexPath.section==1) {
            return 80;
        }
        return UITableViewAutomaticDimension;
    }else if (tableView==AutoRenewTable){
        return 190;
    }
    return 35;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (tableView==ProductPopoverTable) {
        MyTableViewCell *myCell;
        if ([ProductTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.label2.text=workingProduct.category;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;

                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"English"];
                    myCell.label2.text=workingProduct.englishname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"中文名稱"];
                    myCell.label2.text=workingProduct.chinesename;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Code"];
                    myCell.label2.text=workingProduct.code;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Price"];
                    myCell.label2.text=[NSString stringWithFormat:@"$%@",workingProduct.price];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==2) {
                static NSString *CellIdentifier = @"rolabellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.label1.text=[MyClass returntitlewithtitle:@"Product Auto Renew"];
                myCell.label2.text=[MyClass returnautorenewlabelwithautorenewstring:workingProduct.autorenew];
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Stock Count"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingProduct.stockcount];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Alert Threshold"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingProduct.alertthreshold];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingProduct.status];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
            }else if (indexPath.section==5){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=workingProduct.remarks;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }
            
        }else if([ProductTableMode isEqualToString:@"Edit"] || [ProductTableMode isEqualToString:@"Add"]){
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.textfield1.text=workingProduct.category;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Category"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=0;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"English name"];
                    myCell.textfield1.text=workingProduct.englishname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"English name"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=1;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"中文名稱"];
                    myCell.textfield1.text=workingProduct.chinesename;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"中文名稱"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=2;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Code"];
                    myCell.textfield1.text=workingProduct.code;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"(max 10 characters)"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=3;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Price"];
                    myCell.textfield1.text=workingProduct.price;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Price"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=4;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;;
            }else if (indexPath.section==2) {
                static NSString *CellIdentifier = @"labellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.label1.text=[MyClass returntitlewithtitle:@"Product Auto Renew"];
                myCell.label2.text=[MyClass returnautorenewlabelwithautorenewstring:workingProduct.autorenew];
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Stock Count"];
                    myCell.textfield1.text=workingProduct.stockcount;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Stock Count"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(validateinventoryinput:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=0;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Alert Threshold"];
                    myCell.textfield1.text=workingProduct.alertthreshold;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Alert Threshold"];
                    [myCell.textfield1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.textfield1 addTarget:self action:@selector(validateinventoryinput:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=1;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"segmentcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Active"] atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Inactive"] atIndex:1 animated:NO];
                    
                    myCell.segmentedcontrol1.selectedSegmentIndex=[workingProduct.status isEqualToString:@"Active"] ? 0:1;
                    [myCell.segmentedcontrol1 addTarget:self action:@selector(selectStatus:) forControlEvents: UIControlEventValueChanged];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==5){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"remarkscell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.textview1.tag=0;
                    myCell.textview1.text=workingProduct.remarks;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==6){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"buttoncell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    [myCell.button1 setTitle:[MyClass returntitlewithtitle:@"Delete Product"] forState:UIControlStateNormal];
                    [myCell.button1 addTarget: self action:@selector(deleteProduct:) forControlEvents: UIControlEventTouchUpInside];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        return myCell;
    }else if (tableView==AutoRenewTable){

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        if (showAutoRenew) {
            int typePresetRow=0;
            int valuePresetRow=0;
            
            if ([workingProduct.autorenew isEqualToString:@""]) {
                typePresetRow=0;
                valuePresetRow=0;
                workingProduct.autorenew=@"D1";
                //ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingProduct.autorenew];
                [ProductPopoverTable reloadData];
            }else{
                if ([[workingProduct.autorenew substringToIndex:1] isEqualToString:@"D"]) {
                    typePresetRow=0;
                }else if ([[workingProduct.autorenew substringToIndex:1] isEqualToString:@"W"]) {
                    typePresetRow=1;
                }else if ([[workingProduct.autorenew substringToIndex:1] isEqualToString:@"M"]) {
                    typePresetRow=2;
                }else if ([[workingProduct.autorenew substringToIndex:1] isEqualToString:@"Y"]) {
                    typePresetRow=3;
                }
                valuePresetRow=(int)[autoRenewValuePickerViewMenu indexOfObject:[workingProduct.autorenew substringFromIndex:1]];
            }
            
            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];

            
            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(15, 5, 290, 150)];
            [myPicker setDataSource:self];
            [myPicker setDelegate:self];
            myPicker.tag=802;
            
            [myPicker selectRow:valuePresetRow inComponent:0 animated:NO];
            [myPicker selectRow:typePresetRow inComponent:1 animated:NO];
            
            [myPicker setShowsSelectionIndicator:YES];
            myPickerView=myPicker;
            [datepickerview addSubview:myPicker];
            
            [cell.contentView addSubview:datepickerview];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ProductPopoverTable) {
        if (![ProductTableMode isEqualToString:@"View"]) {
            if (indexPath.section==2 && indexPath.row==0) {
                
                if (showAutoRenew==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [ProductPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    [self showsidewindowwithwindow:@"showAutoRenew"];
                    [AutoRenewTable reloadData];
                    [ProductPopoverTable reloadData];
                    [self adjusttablesize];
                }
                
                
            }
        }
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showAutoRenew"]) {
        showAutoRenew=YES;
        showProductPhoto=NO;
    }else if ([windowname isEqualToString:@"showProductPhoto"]) {
        showAutoRenew=NO;
        showProductPhoto=YES;
        [self createMessagePhotoToolBar];
    }else{
        showAutoRenew=NO;
        showProductPhoto=NO;
    }
}


-(void) closeallpickers
{
    showAutoRenew=NO;
}


//-(void) storeTmpField
//{
//    if (CategoryText) {workingProduct.category=CategoryText.text;}
//    if (EnglishnameText) {workingProduct.englishname=EnglishnameText.text;}
//    if (ChinesenameText) {workingProduct.chinesename=ChinesenameText.text;}
//    if (CodeText) {workingProduct.code=CodeText.text;}
//    if (PriceText) {workingProduct.price=PriceText.text;}
//    if (RemarksText) {workingProduct.remarks=RemarksText.text;}
//
//}

-(void) InitializeField
{
    
    if ([ProductTableMode isEqualToString:@"View"]){
        workingProduct.category=ProductObject.category;
        workingProduct.englishname=ProductObject.englishname;
        workingProduct.chinesename=ProductObject.chinesename;
        workingProduct.code=ProductObject.code;
        workingProduct.price=ProductObject.price;
        workingProduct.status=ProductObject.status;
        workingProduct.remarks=ProductObject.remarks;
        workingProduct.autorenew=ProductObject.autorenew;
        workingProduct.avatar=ProductObject.avatar;
        workingProduct.stockcount=ProductObject.stockcount;
        workingProduct.alertthreshold=ProductObject.alertthreshold;
        photocornerobject=[self copyMessagePhotoRecordWithProduct:workingProduct];
        [self createViewBarButton];
        
    }else if ([ProductTableMode isEqualToString:@"Edit"]) {
        workingProduct.category=ProductObject.category;
        workingProduct.englishname=ProductObject.englishname;
        workingProduct.chinesename=ProductObject.chinesename;
        workingProduct.code=ProductObject.code;
        workingProduct.price=ProductObject.price;
        workingProduct.status=ProductObject.status;
        workingProduct.remarks=ProductObject.remarks;
        workingProduct.autorenew=ProductObject.autorenew;
        workingProduct.avatar=ProductObject.avatar;
        workingProduct.stockcount=ProductObject.stockcount;
        workingProduct.alertthreshold=ProductObject.alertthreshold;
        photocornerobject=[self copyMessagePhotoRecordWithProduct:workingProduct];
        [self createEditBarButton];
        
    }else if ([ProductTableMode isEqualToString:@"Add"]){
        workingProduct.category=@"";
        workingProduct.englishname=@"";
        workingProduct.chinesename=@"";
        workingProduct.code=@"";
        workingProduct.price=@"";
        workingProduct.status=@"Active";
        workingProduct.remarks=@"";
        workingProduct.autorenew=@"";
        workingProduct.avatar=@"";
        workingProduct.stockcount=@"";
        workingProduct.alertthreshold=@"";
        photocornerobject=nil;
        [self createAddBarButton];
        
    }else if ([ProductTableMode isEqualToString:@"Clone"]){
        ProductTableMode=@"Add";
        workingProduct.productkey=@"";
        workingProduct.category=ProductObject.category;
        workingProduct.englishname=ProductObject.englishname;
        workingProduct.chinesename=ProductObject.chinesename;
        workingProduct.code=@"";
        workingProduct.price=ProductObject.price;
        workingProduct.status=@"Active";
        workingProduct.remarks=ProductObject.remarks;
        workingProduct.autorenew=ProductObject.autorenew;
        workingProduct.stockcount=ProductObject.stockcount;
        workingProduct.alertthreshold=ProductObject.alertthreshold;
        photocornerobject=[self copyMessagePhotoRecordWithProduct:workingProduct];
        [self createAddBarButton];
    }
}

-(PhotoCornerFileRecord *) copyMessagePhotoRecordWithProduct:(ProductRecord *)obj
{
    PhotoCornerFileRecord *msgphotoobject;
    if(![obj.avatar isEqualToString:@""]){
        NSString *strURL=[NSString stringWithFormat:@"%@productimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.avatar];
        NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        NSData *data=[[NSData alloc]initWithContentsOfURL:url];
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.image=[[UIImage alloc] initWithData:data];
        
        msgphotoobject=[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:obj.avatar ImageView:imageview Width:imageview.image.size.width Height:imageview.image.size.height FileType:@"image" InternalURL:nil FileName:@"" ThumbnailURL:@"" Action:@"View" DownloadFileType:@"product" title:@""];
        
    }
    return msgphotoobject;
}

-(void) adjusttablesize
{
    tablebottomconstraint.constant=keyboardheight;
    
    float tableheight;
    float tablewidth=320;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showAutoRenew){
        tablewidth=popoverwidth+autorenewwidth;
    }else if (showProductPhoto){
        tablewidth=popoverwidth+productphotowidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showAutoRenew){
        AutoRenewTableMasterView.hidden=NO;
        MessagePhotoMasterView.hidden=YES;
    }else if (showProductPhoto){
        AutoRenewTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=NO;
    }else{
        AutoRenewTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
    }
}

-(void) deleteProduct:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Product"] message:[NSString stringWithFormat:@"%@ %@?",[MyClass returntitlewithtitle:@"Are you sure to delete"],ProductObject.englishname] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self retrieveSalesCountWithProductCode:workingProduct.code]) {
            if (productCanBeDeleted) {
                [self deleteProductwithProductkey:ProductObject.productkey];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Product cannot be deleted"] message:[MyClass returntitlewithtitle:@"There are sales records for this product"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }
        }
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)deleteProductwithProductkey:(NSString *)productkey
{
    //delete staff record in center db
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateproduct" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:productkey forKey:@"productkey"];
    [dictionary setValue:@"Delete" forKey:@"action"];
    
    __block BOOL result=FALSE;
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:nil completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
        }
    }];
    
//    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteproduct&productkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,productkey];
//
//    __block BOOL result=FALSE;
//    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//        if (succeeded) {
//            result=TRUE;
//        }
//    }];

    
    if (result) {
        [self.delegate dismissProductPopover];
    }
}

-(IBAction) doneButtonPressed:(id)sender
{
//    [self storeTmpField];
    
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    workingProduct.code=[MyClass leadingtrailingspacestrimmed:workingProduct.code];

    if ([workingProduct.category isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Please input Product category"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingProduct.englishname isEqualToString:@""] && [workingProduct.chinesename isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Please input product's english or chinese name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (![self codelengthok:workingProduct.code]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Product code length too long. Please select another one"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingProduct.code isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Please input Product code"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (![self checkcodeavailablityok:workingProduct.code]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]]  message:[MyClass returntitlewithtitle:@"Product code has been used. Please select another one"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingProduct.price isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Please input Product price"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
        
        
    }else if ([self invalidprice]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:ProductTableMode],[MyClass returntitlewithtitle:@"Product Information"]] message:[MyClass returntitlewithtitle:@"Invalid Product price input"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
        
    }else{
//        NSString *strURL;
        
        if ([workingProduct.chinesename isEqualToString:@""]) {
            workingProduct.chinesename=workingProduct.englishname;
        }else if ([workingProduct.englishname isEqualToString:@""]){
            workingProduct.englishname=workingProduct.chinesename;
        }
        
        if ([ProductTableMode isEqualToString:@"Edit"]) {
            
            //update product information
            NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateproduct" forKey:@"postaction"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:ProductObject.productkey forKey:@"productkey"];
            [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
            
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"category" NewValue:workingProduct.category OldValue:ProductObject.category Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"code" NewValue:workingProduct.code OldValue:ProductObject.code Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"englishname" NewValue:workingProduct.englishname OldValue:ProductObject.englishname Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"chinesename" NewValue:workingProduct.chinesename OldValue:ProductObject.chinesename Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"price" NewValue:workingProduct.price OldValue:ProductObject.price Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"remarks" NewValue:workingProduct.remarks OldValue:ProductObject.remarks Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"status" NewValue:workingProduct.status OldValue:ProductObject.status Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"autorenew" NewValue:workingProduct.autorenew OldValue:ProductObject.autorenew Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"stockcount" NewValue:workingProduct.stockcount OldValue:ProductObject.stockcount Action:@"Edit"];
            dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"alertthreshold" NewValue:workingProduct.alertthreshold OldValue:ProductObject.alertthreshold Action:@"Edit"];
            [dictionary setValue:photoimagechanged?@"Yes":@"No" forKey:@"deleteoldphoto"];

            [dictionary setValue:@"Edit" forKey:@"action"];
            
            __block BOOL result=FALSE;
            
            [MyClass callMultipartPOSTwithDict:dictionary photoArray:photoimagechanged?(photocornerobject?[[NSMutableArray alloc]initWithObjects:photocornerobject, nil]:nil):nil completionBlock:^(id responseObject, NSError *error) {
                if (!error) {
                    result=TRUE;
                }
            }];
            
            
            
//            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updateproduct&productkey=%@&category=%@&code=%@&englishname=%@&chinesename=%@&price=%@&remarks=%@&status=%@&oldcode=%@&autorenew=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, ProductObject.productkey,[MyClass enurlstring:workingProduct.category], [MyClass enurlstring:workingProduct.code],[MyClass enurlstring:workingProduct.englishname],[MyClass enurlstring:workingProduct.chinesename],workingProduct.price,workingProduct.remarks,workingProduct.status,ProductObject.code,workingProduct.autorenew];
//
//            __block BOOL result=FALSE;
//            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//                if (succeeded) {
//                    result=TRUE;
//                }
//            }];
            

            
            if (result) {
                [self.delegate dismissProductPopover];
            }
        }else{
            //add new product to db
            NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateproduct" forKey:@"postaction"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:workingProduct.category forKey:@"category"];
            [dictionary setValue:workingProduct.code forKey:@"code"];
            [dictionary setValue:workingProduct.englishname forKey:@"englishname"];
            [dictionary setValue:workingProduct.chinesename forKey:@"chinesename"];
            [dictionary setValue:workingProduct.price forKey:@"price"];
            [dictionary setValue:workingProduct.remarks forKey:@"remarks"];
            [dictionary setValue:workingProduct.status forKey:@"status"];
            [dictionary setValue:workingProduct.autorenew forKey:@"autorenew"];
            [dictionary setValue:workingProduct.stockcount forKey:@"stockcount"];
            [dictionary setValue:workingProduct.alertthreshold forKey:@"alertthreshold"];
            [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
            [dictionary setValue:@"Add" forKey:@"action"];
            
            __block BOOL result=FALSE;
            
            [MyClass callMultipartPOSTwithDict:dictionary photoArray:photocornerobject?[[NSMutableArray alloc]initWithObjects:photocornerobject, nil]:nil completionBlock:^(id responseObject, NSError *error) {
                if (!error) {
                    result=TRUE;
                }
            }];
            
            
            
//            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=insertproduct&category=%@&code=%@&englishname=%@&chinesename=%@&price=%@&remarks=%@&status=%@&autorenew=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[MyClass enurlstring:workingProduct.category], [MyClass enurlstring:workingProduct.code],[MyClass enurlstring:workingProduct.englishname],[MyClass enurlstring:workingProduct.chinesename],workingProduct.price,workingProduct.remarks,workingProduct.status,workingProduct.autorenew];
//
//
//            __block BOOL result=FALSE;
//            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//                if (succeeded) {
//                    result=TRUE;
//                }
//            }];
            
            
            
            if (result) {
                [self.delegate dismissProductPopover];
            }
        }
    }
}



-(BOOL) codelengthok:(NSString *)newshortname
{
    return [newshortname length]<=10 ? TRUE:FALSE;
}

-(BOOL) checkcodeavailablityok:(NSString *)code
{
    if (![code isEqualToString:ProductObject.code] || [ProductTableMode isEqualToString:@"Add"]) {
        for (int i=0; i<ProductCodeArray.count; i++) {
            if([[ProductCodeArray objectAtIndex:i] caseInsensitiveCompare:code]==NSOrderedSame){
                return FALSE;
            }
        }
    }
    return TRUE;
}


//-(void) validateinput:(UITextView *)sender
//{
//    if (![self checkvalidfeeinput:sender.text]) {
//        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Product Price"] message:[MyClass returntitlewithtitle:@"Invalid input. Please re-enter"] preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [erroralert dismissViewControllerAnimated:YES completion:nil];
//        }];
//
//        [erroralert addAction:OKAction];
//        [self presentViewController:erroralert animated:YES completion:nil];
//
//        sender.text=@"0";
//        sender.textColor=[UIColor redColor];
//    }else{
//        if ([sender.text intValue] !=[sender.text doubleValue]) {
//            sender.text=[NSString stringWithFormat:@"%.1f",[sender.text doubleValue]];
//            workingProduct.price=sender.text;
//        }
//        sender.textColor=[UIColor darkGrayColor];
//    }
//}

-(void) validateinventoryinput:(UITextView *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"EmptyInteger"]) {
        if(sender.tag==0){workingProduct.stockcount=sender.text;}
        if(sender.tag==1){workingProduct.alertthreshold=sender.text;}
    }else{
        if(sender.tag==0){sender.text=workingProduct.stockcount;}
        if(sender.tag==1){sender.text=workingProduct.alertthreshold;}
    }
}


-(BOOL) checkvalidfeeinput:(NSString *)input
{
    NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    
    if ([regexPredicate evaluateWithObject: input]){
        //Matches
        return TRUE;
    }else{
        return FALSE;
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:ProductPopoverTable];
        NSIndexPath *indexpath =[ProductPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [ProductPopoverTable rectForRowAtIndexPath:indexpath];
        
        [ProductPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-ProductPopoverTable.frame.size.height) animated:YES];
    }

}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==0) {
        workingProduct.remarks=textView.text;
        CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:ProductPopoverTable];
        NSIndexPath *indexPath = [ProductPopoverTable indexPathForRowAtPoint:rootViewPoint];
        
        MyTableViewCell *newcell=[ProductPopoverTable cellForRowAtIndexPath:indexPath];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>100) {
            newcell.layoutconstraint1.constant=100;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        

        [ProductPopoverTable beginUpdates];
        [ProductPopoverTable endUpdates];
    }
}

-(BOOL) invalidprice
{
    if (![self checkvalidfeeinput:workingProduct.price]) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void) updatetextfield:(UITextField *)sender
{
//    [self storeTmpField];
    if (sender.tag==0) {workingProduct.category=sender.text;}
    if (sender.tag==1) {workingProduct.englishname=sender.text;}
    if (sender.tag==2) {workingProduct.chinesename=sender.text;}
    if (sender.tag==3) {workingProduct.code=sender.text;}
//    if (sender.tag==4) {workingProduct.price=PriceText.text;}
//    if (RemarksText) {workingProduct.remarks=RemarksText.text;}
    if(sender.tag==4){
        if (![self checkvalidfeeinput:sender.text]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Product Price"] message:[MyClass returntitlewithtitle:@"Invalid input. Please re-enter"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            
            sender.text=@"0";
            sender.textColor=[UIColor redColor];
        }else{
            if ([sender.text intValue] !=[sender.text doubleValue]) {
                sender.text=[NSString stringWithFormat:@"%.1f",[sender.text doubleValue]];
            }
            workingProduct.price=sender.text;
            sender.textColor=[UIColor darkGrayColor];
        }
    }
}


-(void) selectStatus:(UISegmentedControl *)sender
{
    workingProduct.status=sender.selectedSegmentIndex==0?@"Active":@"Inactive";
}



- (BOOL) retrieveSalesCountWithProductCode:(NSString *)productcode
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievesalescount&productcode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,productcode];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                productCanBeDeleted=NO;
            }else{
                productCanBeDeleted=YES;
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                productCanBeDeleted=NO;
            }else{
                productCanBeDeleted=YES;
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component==0){
        return [autoRenewValuePickerViewMenu count];
    }else{// if (component==1){
        return [autoRenewTypePickerViewMenu count];
    }
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        tView.textAlignment=NSTextAlignmentCenter;
        [tView setFont:[UIFont systemFontOfSize:18]];
        tView.adjustsFontSizeToFitWidth=YES;
        tView.minimumScaleFactor=0.7;
        //[tView setTextAlignment:UITextAlignmentLeft];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    

    if (component==0){
        tView.text= [autoRenewValuePickerViewMenu objectAtIndex:row];
    }else{// if (component==1){
        tView.text= [MyClass returntitlewithtitle:[autoRenewTypePickerViewMenu objectAtIndex:row]];
    }

    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    workingProduct.autorenew=[NSString stringWithFormat:@"%@%@",[[autoRenewTypePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]] substringToIndex:1],[autoRenewValuePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]];
    [ProductPopoverTable reloadData];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    cell.layer.borderColor=[UIColor lightTextColor].CGColor;
    cell.layer.borderWidth=1;

    if ([ProductTableMode isEqualToString:@"View"]) {
        if(!photocornerobject){
            [cell.photoimageView setImage:[UIImage imageNamed:@"product_gray_small.png"]];
        }else{
            PhotoCornerFileRecord *obj=photocornerobject;
            [cell.photoimageView setImage:obj.imageview.image];
        }
        
//        [cell.photoimageView setImage:obj.imageview.image];
        cell.addimagebutton.hidden=YES;
        cell.deleteimagebutton.hidden=YES;
        cell.videoplayicon.hidden=YES;
    }else{
        if (!photocornerobject) {
            [cell.photoimageView setImage:nil];
            cell.addimagebutton.hidden=NO;
            cell.deleteimagebutton.hidden=YES;
            cell.videoplayicon.hidden=YES;
            [cell.addimagebutton addTarget:self action:@selector(addMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            PhotoCornerFileRecord *obj=photocornerobject;
            [cell.photoimageView setImage:obj.imageview.image];
            cell.addimagebutton.hidden=YES;
            cell.deleteimagebutton.hidden=NO;
            cell.deleteimagebutton.tag=indexPath.item;
            cell.videoplayicon.hidden=YES;
            [cell.deleteimagebutton addTarget:self action:@selector(deleteMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==workingMessage.photoarray.count || workingMessage.photoarray.count<2) {
//        return NO;
//    }
//    return YES;
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (photocornerobject) {
        [self showsidewindowwithwindow:@"showProductPhoto"];
        [self showFullScreenMessagePhoto];
        [self adjusttablesize];
    }
}

-(void) addMessagePhoto:(UIButton *)sender
{
    [self addphotobuttonpressed:sender];
}

-(void) deleteMessagePhoto:(UIButton *)sender
{

    photoimagechanged=TRUE;
    photocornerobject=nil;
    if(showProductPhoto){
        [self showsidewindowwithwindow:@"none"];
        [self adjusttablesize];
    }
    [ProductPopoverTable reloadData];

}

-(void) addphotobuttonpressed:(UIButton *)sender
{
    addphotobutton=sender;
    [self popupaddphotodialoguebox];
}

-(void) popupaddphotodialoguebox
{
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSMutableArray *ItemsArray=[[NSMutableArray alloc]init];
    if (hasCamera) {

            [ItemsArray addObject:@"Take Photo"];
            [ItemsArray addObject:@"Photo Library"];
    }else{
            [ItemsArray addObject:@"Photo Library"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addphotobutton ItemsArray:ItemsArray Title:nil];

}

-(void) takephotobuttonpressed
{
   [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"camera"];
}

-(void) photolibrarybuttonpressed
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"library"];
}

-(void) addclassphotofromsource:(NSString *)source
{

        imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.allowsEditing=NO;
        
        if ([source isEqualToString:@"photocamera"]) {
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
            imagepicker.view.tag=0;
            [MyClass presentViewController:imagepicker View:self];
        }else if ([source isEqualToString:@"photolibrary"]){
            //imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            if ([mypopovercontroller presentingViewController].isBeingPresented) {
                [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            }
            
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            imagepicker.modalPresentationStyle=UIModalPresentationPopover;
            mypopovercontroller=imagepicker.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionLeft;
            mypopovercontroller.sourceView=addphotobutton;
            mypopovercontroller.sourceRect=addphotobutton.bounds;
            
            [self presentViewController:imagepicker animated:YES completion:nil];
   
        }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    photoimagechanged=TRUE;
    [self.delegate donotrunviewdidappear];
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image=info[UIImagePickerControllerOriginalImage];
    NSData *imageData;
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    } else {
        if (@available(iOS 11.0, *)) {
            imageData = [NSData dataWithContentsOfURL:info[UIImagePickerControllerImageURL]];
        } else {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
        [picker dismissViewControllerAnimated:NO completion:^{
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }];
    }else{
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //UIImage *image=info[UIImagePickerControllerOriginalImage];
            //image=[MyClass resizeImageWithImage:image ForSize:image.size];
            NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
            
            photocornerobject=[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"product" title:@""];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            NSRange range = NSMakeRange(1,1);
            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
            [ProductPopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
            [MyClass loadingindicatorwithoption:@"stop" color:@""];
        });
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate donotrunviewdidappear];
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) showFullScreenMessagePhoto
{
    [fullscreen_messageimageview setImage:photocornerobject.imageview.image];
    
    float imageheight;
    float imagewidth;
    
    if (fullscreen_messageimageview.image.size.height/fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.width>fullscreen_scrollview.frame.size.height) {
        imageheight=fullscreen_scrollview.frame.size.height;
        imagewidth=fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.height/fullscreen_messageimageview.image.size.height;
        fullscreen_messageimageview.frame=CGRectMake((fullscreen_scrollview.frame.size.width-imagewidth)/2, 0, imagewidth, imageheight);
    }else{
        imageheight=fullscreen_messageimageview.image.size.height*fullscreen_scrollview.frame.size.width/fullscreen_messageimageview.image.size.width;
        imagewidth=fullscreen_scrollview.frame.size.width;;
        fullscreen_messageimageview.frame=CGRectMake(0, (fullscreen_scrollview.frame.size.height-imageheight)/2, imagewidth, imageheight);
    }
    fullscreen_scrollview.contentSize=CGSizeMake(fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    
}

-(void) closefullscreen
{
//    [avplayerviewcontroller.player pause];
    MessagePhotoMasterView.hidden=YES;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([ProductTableMode isEqualToString:@"View"] || [ProductTableMode isEqualToString:@"Add"] || [ProductTableMode isEqualToString:@"Edit"]) {
        return fullscreen_messageimageview;
    }
    return nil;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    if (fullscreen_messageimageview.frame.size.width<MessagePhotoMasterView.frame.size.width) {
        fullscreen_messageimageview.frame=CGRectMake((MessagePhotoMasterView.frame.size.width-fullscreen_messageimageview.frame.size.width)/2, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(0, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    if (fullscreen_messageimageview.frame.size.height<MessagePhotoMasterView.frame.size.height-44) {
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, (MessagePhotoMasterView.frame.size.height-44-fullscreen_messageimageview.frame.size.height)/2, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, 0, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    //fullscreen_messageimageview.transform = CGAffineTransformMakeRotation(messagephotoobject.imagerotation90angle*M_PI_2);

}

-(void) rotateimage
{
    photoimagechanged=TRUE;
    [photocornerobject.imageview setImage:[MyClass imageRotatedOnDegrees:90 Image:photocornerobject.imageview.image]];
    photocornerobject.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(photocornerobject.imageview.image, 0.7) Filename:@"image"];
    [self showFullScreenMessagePhoto];
    [ProductPopoverTable reloadData];
}


-(void) shareimage:(UIButton *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *strURL=[NSString stringWithFormat:@"%@productimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,photocornerobject.fileurl];
            
        NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        

            UIImage *imagetoshare = [[SDImageCache sharedImageCache] imageFromCacheForKey:[url absoluteString]];
            NSArray *activityItems = @[imagetoshare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityVC.modalPresentationStyle=UIModalPresentationPopover;
            mypopovercontroller=activityVC.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=sender;
            mypopovercontroller.sourceRect=sender.bounds;
              
            [self presentViewController:activityVC animated:YES completion:nil];
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"attachment"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Take Photo"]) {
            [self addclassphotofromsource:@"photocamera"];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self addclassphotofromsource:@"photolibrary"];
        }
    }
}


@end
