//
//  ClassPhotoPopoverViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 18/6/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import "ClassPhotoPopoverViewController.h"
#import "MessagePhotoCollectionViewCell.h"

#define maxphotoheight self.view.bounds.size.height*0.7
#define messagephotowidth 550
#define centerwidth 375

@import Photos;

@import BSImagePicker;

@interface ClassPhotoPopoverViewController ()

@end

@implementation ClassPhotoPopoverViewController
@synthesize classphotoobject,mode;

#define popoverwidth 320
#define expirydatewidth 375

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    globalvariables=[GlobalVariables singleObj];
    
    workingClassPhoto=[[ClassPhotoRecord alloc]init];
    [self.view layoutIfNeeded];
    
    
    
    keyboardshow=FALSE;
    
    [self createsidetables];
    [self InitializeField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

-(void) createsidetables
{
    expirydatecalendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, expirydateview.frame.size.width, expirydateview.frame.size.height) Theme:3 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    expirydatecalendarview.delegate=self;
    [expirydateview addSubview:expirydatecalendarview];
    
    [noneButton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
    expirydatetitle.text=[MyClass returntitlewithtitle:@"Expiry Date"];
    
    //Message Photo
    MessagePhotoMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, messagephotowidth, self.view.frame.size.height)];
    [self.view addSubview:MessagePhotoMasterView];
    //MessagePhotoMasterView.backgroundColor=[UIColor blackColor];
    
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
    
    //add webview
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:fullscreen_scrollview.frame configuration:theConfiguration];
    webView.backgroundColor=[UIColor whiteColor];
    [MessagePhotoMasterView addSubview:webView];
    
    //add videoview
    videoView = [[UIView alloc]initWithFrame:fullscreen_scrollview.frame];
    [MessagePhotoMasterView addSubview:videoView];
    avplayerviewcontroller=[[AVPlayerViewController alloc]init];
    avplayerviewcontroller.view.frame=videoView.bounds;
    [videoView addSubview:avplayerviewcontroller.view];
    [self addChildViewController:avplayerviewcontroller];
    [avplayerviewcontroller didMoveToParentViewController:self];

    
    MessagePhotoToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, messagephotowidth, 44)];
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
    photorotateButton.frame = CGRectMake(messagephotowidth-40, 33, 20, 20);
    [photorotateButton setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
    [photorotateButton addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
    [photorotateButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photorotateButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photorotateButton];
    
    
    //center table view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, centerwidth,81)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [CenterMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Center"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    centersearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 36, centerwidth, 42)];
    centersearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    centersearchbar.delegate=self;
    centersearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:centersearchbar];
    centertable.sectionHeaderHeight=0;
    
    [CenterMasterView bringSubviewToFront:centertableseparator];
    
}

- (void)keyboardDidShow: (NSNotification *) notif{
    
    // Do something here
    keyboardshow=TRUE;
}

- (void)keyboardDidHide: (NSNotification *) notif{

    keyboardshow=FALSE;
    keyboardheight=0;
    [self adjusttablesize];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif
{
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = keyboardSize.height;
    [self adjusttablesize];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = keyboardSize.height;
    [self adjusttablesize];
}


-(void) InitializeField
{
    if ([mode isEqualToString:@"edit"]) {
        workingClassPhoto.centerkey=classphotoobject.centerkey;
        workingClassPhoto.classphotokey=classphotoobject.classphotokey;
        workingClassPhoto.title=classphotoobject.title;
        workingClassPhoto.tag=classphotoobject.tag;
        workingClassPhoto.hotnews=classphotoobject.hotnews;
        workingClassPhoto.hn_expiry_date=classphotoobject.hn_expiry_date;
        workingClassPhoto.filearray=[MyClass copyPhotoCornerFileArrayWithPhotoArray:classphotoobject.filearray LoadInternalURL:NO];
        [self createEditBarButton];
    }else if ([mode isEqualToString:@"add"]){
        workingClassPhoto.centerkey=globalvariables.centerrecord.centerkey;
        workingClassPhoto.classphotokey=@"";
        workingClassPhoto.title=@"";
        workingClassPhoto.tag=@"";
        workingClassPhoto.hotnews=YES;
        workingClassPhoto.hn_expiry_date=[MyClass convertToNSStringWithNSDate:[[NSDate date] dateByAddingTimeInterval:14*24*60*60] DateFormat:@"yyyy-MM-dd"];
        if (classphotoobject) {
            workingClassPhoto.filearray=classphotoobject.filearray;
        }else{
            workingClassPhoto.filearray=[[NSMutableArray alloc]init];
        }
        [self createAddBarButton];
        [self returnAvailableCenterArray];
    }
    selectedCenters=[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.centerkey, nil];
    [editTable reloadData];

}

-(void) createEditBarButton{
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    
//    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,flexibleSpaceBarButton,saveButton,nil];
//    [ClassPhotoToolBar setItems:buttons animated:NO];
    
    deleteButton.hidden=NO;
    saveButton.hidden=NO;

}

-(void) createAddBarButton{
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    //retakeButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Retake"] style:UIBarButtonItemStylePlain target:self action:@selector(retakeButtonPressed)];
////    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    button.bounds = CGRectMake( 0, 0, 20, 20 );
////    [button addTarget:self action:@selector(rotateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
////    [button setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
////    [button.heightAnchor constraintEqualToConstant:20].active = true;
////    [button.widthAnchor constraintEqualToConstant:20].active = true;
////    UIBarButtonItem *rotateButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,saveButton,nil];
//    [ClassPhotoToolBar setItems:buttons animated:NO];
    
    deleteButton.hidden=YES;
    saveButton.hidden=NO;
    
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
//    
    

    photorotateButton.hidden=YES;
    
    if ([photocornerfileobject.filetype isEqualToString:@"image"]) {
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,rotateButton, nil];
        photorotateButton.hidden=NO;
    }

//    [MessagePhotoToolBar setItems:barItems];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView==fullscreen_scrollview) {
        return fullscreen_messageimageview;
    }
    return [scrollView viewWithTag:100];
}

//-(void) rotateButtonPressed
//{
//    edit_ClassImage=[MyClass imageRotatedOnDegrees:90 Image:edit_ClassImage];
//    workingClassPhoto.width=[@(edit_ClassImage.size.width) stringValue];
//    workingClassPhoto.height=[@(edit_ClassImage.size.height) stringValue];
//
//    [editTable reloadData];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==centertable){
        return 1;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==editTable){
        if (section==0){
            return [mode isEqualToString:@"add"] && allcenterarray.count>1?1:0;
        }else if (section==1){
            return 1;
        }else if (section==1){
            return 1;
        }else if (section==2){
            return 1;
        }else if (section==3){
            return 1;
        }else if (section==4){
            return workingClassPhoto.hotnews?2:1;
        }
    }else if(tableView==centertable){
        return filteredCenterArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        return 38;
    }else if (indexPath.section==3){
        return ((workingClassPhoto.filearray.count)/4+1)*80;
    }
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView==editTable){
        if (section==3) {
            return [MyClass returntitlewithtitle:@"Attachments"];
        }else if(section==1){
            return [MyClass returntitlewithtitle:@"Title"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Tag"];
        }else if (section==4){
            return [MyClass returntitlewithtitle:@"Hot News"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Center"];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==centertable) {
        return CGFLOAT_MIN;
    }else if (tableView==editTable){
        if (section==0) {
            return [mode isEqualToString:@"add"] && allcenterarray.count>1?44:CGFLOAT_MIN;
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==centertable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"centercell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CenterRecord *centerobject=[filteredCenterArray objectAtIndex:indexPath.row];
        [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"centerimage" typekey:centerobject.launchimage_landscape image:@"Yes" async:YES];
        
        myCell.label1.text=[MyClass returncentershortnamewithcenterkey:centerobject.centerkey];
        myCell.imageview2.hidden=!([selectedCenters containsObject:centerobject.centerkey] || (selectedCenters && selectedCenters.count==0));
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
        
    }else if (tableView==editTable) {
        MyTableViewCell *cell;
        
        if(indexPath.section==0){
            static NSString *CellIdentifier = @"labellabelcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.label1.text=[MyClass returntitlewithtitle:@"Center"];
            cell.label2.text=[MyClass returncenternamewithcenterkeys:selectedCenters];;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            //        cell.hidden=[workingMarketing.subcategory isEqualToString:@"Sales"];
            return cell;
        }else if (indexPath.section==1){
            static NSString *CellIdentifier = @"textviewcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.gctextview1.tag=0;
            cell.gctextview1.delegate=self;
            cell.gctextview1.text=workingClassPhoto.title;
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Enter Title (Optional)"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==2){
            static NSString *CellIdentifier = @"textviewcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.gctextview1.tag=1;
            cell.gctextview1.delegate=self;
            cell.gctextview1.text=workingClassPhoto.tag;
            cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Enter Tag (Optional)"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==4){
            if (indexPath.row==0) {
                static NSString *CellIdentifier = @"switchcell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.label1.text=[MyClass returntitlewithtitle:@"Post in Hot News"];
                cell.switch1.on=workingClassPhoto.hotnews;
                [cell.switch1 addTarget:self action:@selector(hotnewsswitched:) forControlEvents:UIControlEventValueChanged];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.row==1){
                static NSString *CellIdentifier = @"disclosurecell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                cell.label2.text=[workingClassPhoto.hn_expiry_date isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingClassPhoto.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                
                cell.hidden=!workingClassPhoto.hotnews;
                
                return cell;
            }
            
        }else if (indexPath.section==3){
            static NSString *CellIdentifier = @"collectionviewcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.collectionview1.tag=100;
            
            //UICollectionViewFlowLayout *vfl=[[UICollectionViewFlowLayout alloc]init];
            //myCell.collectionview1.collectionViewLayout=vfl;
            UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
            [cell.collectionview1 addGestureRecognizer:longPressGesture];
            cell.collectionview1.backgroundColor=[UIColor clearColor];
            [cell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            [cell.collectionview1 reloadData];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==editTable) {
        if(indexPath.section==0){
            [centerNoneButton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
            [centertAllButton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showCenterTable"];

            [editTable reloadData];
            
            [self adjusttablesize];
        }else if (indexPath.section==4 && indexPath.row==1) {
            [self showsidewindowwithwindow:@"showExpiryDate"];
            
            [expirydatecalendarview scrollToSelectedDateWithSelectedDateArray:[workingClassPhoto.hn_expiry_date isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingClassPhoto.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingClassPhoto.hn_expiry_date isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
        }
    }else if (tableView==centertable){
        
        NSString *selecteditem=((CenterRecord *)[filteredCenterArray objectAtIndex:indexPath.row]).centerkey;
        if (selectedCenters && selectedCenters.count==0) {
            for (int i=0; i<allcenterarray.count; i++) {
                if (![selecteditem isEqualToString:((CenterRecord *)[allcenterarray objectAtIndex:i]).centerkey]) {
                    [selectedCenters addObject:((CenterRecord *)[allcenterarray objectAtIndex:i]).centerkey];
                }
            }
        }else{
            if(!selectedCenters){
                selectedCenters=[[NSMutableArray alloc]init];
            }
            if ([selectedCenters containsObject:selecteditem]) {
                [selectedCenters removeObject:selecteditem];
                if(selectedCenters.count==0){
                    selectedCenters=nil;
                }
            }else{
                [selectedCenters addObject:selecteditem];
                if(selectedCenters.count==allcenterarray.count){
                    selectedCenters=[[NSMutableArray alloc]init];
                }
            }
        }
        
        [centertable reloadData];
        [editTable reloadData];
    }
    
}

-(void) hotnewsswitched:(UISwitch *)sender
{
    workingClassPhoto.hotnews=sender.on;
    [editTable reloadData];
}

-(void) adjusttablesize
{
    addclassphotoviewbottomconstraint.constant=keyboardheight;
    float tablewidth = 0;
    if (showExpiryDate) {
        tablewidth+=expirydatewidth;
        MessagePhotoMasterView.hidden=YES;
        expirydateview.hidden=NO;
        CenterMasterView.hidden=YES;
    }else if (showMessagePhoto){
        tablewidth+=messagephotowidth;
        MessagePhotoMasterView.hidden=NO;
        expirydateview.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showCenterTable){
        tablewidth+=centerwidth;
        MessagePhotoMasterView.hidden=YES;
        expirydateview.hidden=YES;
        CenterMasterView.hidden=NO;
        [centertable reloadData];
    }else{
        MessagePhotoMasterView.hidden=YES;
        expirydateview.hidden=YES;
        CenterMasterView.hidden=YES;
    }
    tablewidth+=popoverwidth;
    
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
//    if(showMessagePhoto){
//        MessagePhotoMasterView.hidden=NO;
//        expirydateview.hidden=YES;
//    }else if (showExpiryDate){
//        MessagePhotoMasterView.hidden=YES;
//        expirydateview.hidden=NO;
//    }else{
//        MessagePhotoMasterView.hidden=YES;
//        expirydateview.hidden=YES;
//    }
    
    //self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint point = [textView.superview convertPoint:CGPointZero toView:editTable];
    NSIndexPath *indexpath =[editTable indexPathForRowAtPoint:point];
    CGRect rectInTableView = [editTable rectForRowAtIndexPath:indexpath];
    CGFloat offset=rectInTableView.origin.y+rectInTableView.size.height-editTable.frame.size.height+(keyboardshow?0:keyboardheight);
    
    
    if(offset>0){
        [editTable setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

-(void) returnAvailableCenterArray
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveavailablecenterkeys&privilegetype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"publishinphotocorner"];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSMutableArray *JSONArray=[[NSMutableArray alloc]init];
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            
            //loop through our jsonArray
            allcenterarray=[[NSMutableArray alloc]init];
            for (int i=0; i<JSONArray.count; i++) {
                NSString * ccenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                [allcenterarray addObject:[MyClass returncenterrecordwithcenterkey:ccenterkey]];
            }
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:allcenterarray];
            [self sortFilteredCenterArray];
        }
    }];
}

-(void) sortFilteredCenterArray
{
    NSSortDescriptor *sortByCenterName;
    if ([globalvariables.language isEqualToString:@"English"]) {
        sortByCenterName = [NSSortDescriptor sortDescriptorWithKey:@"centershortname_english" ascending:YES selector:@selector(localizedStandardCompare:)];
    }else{
        sortByCenterName = [NSSortDescriptor sortDescriptorWithKey:@"centershortname_chinese" ascending:YES selector:@selector(localizedStandardCompare:)];
    }
    
    NSArray *sortDescriptors = @[sortByCenterName];
    filteredCenterArray = [NSMutableArray arrayWithArray:[filteredCenterArray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(void) textViewDidChange:(UITextView *)textView
{
    if (textView.tag==0) {
        workingClassPhoto.title=textView.text;
    }else{
        workingClassPhoto.tag=textView.text;
    }
}

-(IBAction) deleteButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    UIAlertController *deleteclassphoto = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Class Photo"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updateclassphoto" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];
        [dictionary setValue:@"Delete" forKey:@"action"];
        [dictionary setValue:classphotoobject.classphotokey forKey:@"classphotokey"];

        __block BOOL result=FALSE;
        __block NSData *returndata;
        
        [MyClass callMultipartPOSTwithDict:dictionary photoCornerFileArray:nil completionBlock:^(id responseObject, NSError *error) {
            if (!error) {
                result=TRUE;
                returndata=responseObject;
            }
        }];
        
        if (result) {
            [self.delegate dismissClassPhotoPopoverVCWithReload:YES ScrollToTop:NO];
        }
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deleteclassphoto dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteclassphoto addAction:OKAction];
    [deleteclassphoto addAction:CancelAction];
    
    [MyClass presentViewController:deleteclassphoto View:self];
    
}

- (void)updatefavouritewithfilename:(NSString *)filename action:(NSString *)action {
    NSString *sql;
    if ([action isEqualToString:@"add"]) {
        sql=[NSString stringWithFormat:@"insert or ignore into classphoto ('filename','centerkey') values ('%@','%@')",filename,globalvariables.centerrecord.centerkey];
    }else{
        sql=[NSString stringWithFormat:@"delete from classphoto where filename='%@' and centerkey='%@'",filename,globalvariables.centerrecord.centerkey];
    }
    sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
}

-(IBAction) saveButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    if (selectedCenters.count==0) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Photo Corner"] message:[MyClass returntitlewithtitle:@"Please select at least one center"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([self returnUndeletedPhotoCornerCount]==0) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Attachments"] message:[MyClass returntitlewithtitle:@"Please select at least one attachment"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if(selectedCenters.count>1 && ![self isAllUploadFilesNotExceedSize]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(minMaxUploadFileSize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([mode isEqualToString:@"add"]) {
                [self updateclassphotowithaction:@"Add"];
            }else{
                [self updateclassphotowithaction:@"Edit"];
            }
            
            [self.delegate dismissClassPhotoPopoverVCWithReload:YES ScrollToTop:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }
}



-(NSInteger) returnUndeletedPhotoCornerCount
{
    NSInteger count=0;
    for (int i=0; i<workingClassPhoto.filearray.count; i++) {
        PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:i];
        if (![obj.action isEqualToString:@"Delete"]) {
            count++;
        }
    }
    return count;
}


-(void) updateclassphotowithaction:(NSString *)action
{
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateclassphoto" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
//    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:[selectedCenters componentsJoinedByString:@","] forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.username forKey:@"takenby"];
    [dictionary setValue:action forKey:@"action"];
    if([action isEqualToString:@"Edit"]){
        [dictionary setValue:classphotoobject.classphotokey forKey:@"classphotokey"];
    }

    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"title" NewValue:workingClassPhoto.title OldValue:classphotoobject.title Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"takenby" NewValue:workingClassPhoto.takenby OldValue:classphotoobject.takenby Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"tag" NewValue:workingClassPhoto.tag OldValue:classphotoobject.tag Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"hotnews" NewValue:workingClassPhoto.hotnews?@"Yes":@"No" OldValue:classphotoobject.hotnews?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"hn_expiry_date" NewValue:workingClassPhoto.hn_expiry_date OldValue:classphotoobject.hn_expiry_date Action:action];

    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    [MyClass callMultipartPOSTwithDict:dictionary photoCornerFileArray:[self returnChangedPhotoCornerFileArray] completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
            returndata=responseObject;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(NSMutableArray *) returnChangedPhotoCornerFileArray
{
    NSMutableArray *filearray=[[NSMutableArray alloc]init];
    for (int i=0; i<workingClassPhoto.filearray.count; i++) {
        PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:i];
        if (![obj.action isEqualToString:@""]) {
            [filearray addObject:obj];
        }
    }
    
    return filearray;
}

//-(void) retakeButtonPressed
//{
//    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    if (hasCamera) {
//        [self popupaddphotodialogueboxwithoption:@"retake"];
//    }else{
//        [self addclassphotofromsource:@"library"];
//    }
//}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"attachment"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Take Photo"]) {
            [self addclassphotofromsource:@"photocamera"];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self addclassphotofromsource:@"photolibrary"];
        }else if ([result isEqualToString:@"Document"]){
            [self addclassphotofromsource:@"document"];
        }else if ([result isEqualToString:@"Record Video"]) {
            [self addclassphotofromsource:@"videocamera"];
        }else if ([result isEqualToString:@"Video Library"]){
            [self addclassphotofromsource:@"videolibrary"];
        }
    }
}



//-(void) popupaddphotodialogueboxwithoption:(NSString *)option
//{
//    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"PhotoSource" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self BarButtonItem:retakeButton ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Take Photo",@"Photo Library", nil] Title:nil];
    
    /*
    UIView *dialogueview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    UIButton *TakePhotobutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [TakePhotobutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    TakePhotobutton.titleLabel.font=[UIFont systemFontOfSize:17];
    [TakePhotobutton setTitle:[MyClass returntitlewithtitle:@"Take Photo"] forState:UIControlStateNormal];
    [TakePhotobutton addTarget:self action:@selector(takephotobuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:TakePhotobutton];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [dialogueview addSubview:separator];
    
    UIButton *PhotoLibrarybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [PhotoLibrarybutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    PhotoLibrarybutton.titleLabel.font=[UIFont systemFontOfSize:17];
    [PhotoLibrarybutton setTitle:[MyClass returntitlewithtitle:@"Photo Library"] forState:UIControlStateNormal];
    [PhotoLibrarybutton addTarget:self action:@selector(photolibrarybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:PhotoLibrarybutton];
    
    UIViewController *dialoguevc=[[UIViewController alloc]init];
    dialoguevc.preferredContentSize=CGSizeMake(dialogueview.frame.size.width, dialogueview.frame.size.height);
    dialoguevc.view=dialogueview;
    dialoguevc.modalPresentationStyle=UIModalPresentationPopover;
    mypopovercontroller=dialoguevc.popoverPresentationController;
    //mypopovercontroller.delegate=self;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionUp;
    mypopovercontroller.barButtonItem=retakeButton;
    
    [self presentViewController:dialoguevc animated:YES completion:nil];

    if ([option isEqualToString:@"add"]) {
        [self presentViewController:dialoguevc animated:YES completion:nil];
    }*/
//}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gr
{
    UICollectionView *photocollectionview = (UICollectionView *) [gr view];
    switch(gr.state){
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [photocollectionview indexPathForItemAtPoint:[gr locationInView:photocollectionview]];
            if(selectedIndexPath == nil) break;
            [photocollectionview beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [photocollectionview updateInteractiveMovementTargetPosition:[gr locationInView:gr.view]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [photocollectionview endInteractiveMovement];
            break;
        }
        default:
        {
            [photocollectionview cancelInteractiveMovement];
            break;
        }
    }
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
            [ItemsArray addObject:@"Record Video"];
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
    }else{
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addphotobutton ItemsArray:ItemsArray Title:nil];

}

//-(void) takephotobuttonpressed
//{
//   [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    [self addclassphotofromsource:@"camera"];
//}
//
//-(void) photolibrarybuttonpressed
//{
//    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    [self addclassphotofromsource:@"library"];
//}


-(void) addclassphotofromsource:(NSString *)source
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([source isEqualToString:@"document"]) {
            //        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[UTTypePDF] asCopy:YES];
            documentPicker.delegate = self;
            documentPicker.modalPresentationStyle = UIModalPresentationPopover;
            mypopovercontroller=documentPicker.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=addphotobutton;
            mypopovercontroller.sourceRect=addphotobutton.bounds;
            
            [self presentViewController:documentPicker animated:YES completion:^{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }];
            
            
        }else{
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
                
                BSImagePickerViewController *bspicker=[[BSImagePickerViewController alloc]init];
                bspicker.modalPresentationStyle=UIModalPresentationPopover;
                mypopovercontroller=bspicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addphotobutton;
                mypopovercontroller.sourceRect=addphotobutton.bounds;
                
                [self bs_presentImagePickerController:bspicker animated:YES select:nil deselect:nil cancel:^(NSArray<PHAsset *> * array) {
                    [bspicker dismissViewControllerAnimated:YES completion:nil];
                } finish:^(NSArray<PHAsset *> * array) {
                    
                    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __block BOOL fileexceedsize=FALSE;
                        for (int i=0;i<array.count;i++) {
                            PHAsset *asset=[array objectAtIndex:i];
                            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                            options.synchronous = YES;
                            options.networkAccessAllowed=YES;
                            [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                                if (imageData) {
                                    if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
                                        fileexceedsize=TRUE;
                                    }else{
                                        UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        imageData = UIImageJPEGRepresentation(image, 1.0);
                                        NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                                        [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:workingClassPhoto.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                                    }
                                }
                            }];
                        }
                        
                        
                        NSRange range = NSMakeRange(3,1);
                        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                        [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                        [MyClass loadingindicatorwithoption:@"stop" color:@""];
                        
                        [bspicker dismissViewControllerAnimated:YES completion:^{
                            if (fileexceedsize) {
                                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                                }];
                                
                                [erroralert addAction:OKAction];
                                [self presentViewController:erroralert animated:YES completion:nil];
                            }
                        }];
                    });
                } completion:^{
                    [MyClass loadingindicatorwithoption:@"stop" color:@""];
                } selectLimitReached:nil];
                
            }else if ([source isEqualToString:@"videocamera"]) {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
                //            imagepicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                imagepicker.mediaTypes = @[
                    @"public.movie"
                ];
                imagepicker.view.tag=1;
                [MyClass presentViewController:imagepicker View:self];
            }else if ([source isEqualToString:@"videolibrary"]){
                //            imagepicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
                imagepicker.mediaTypes = @[
                    @"public.movie",
                    @"public.video",
                    @"com.apple.quicktime-movie" // or @"public.mpeg" depending on your exact needs
                ];
                imagepicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
                
                if ([mypopovercontroller presentingViewController].isBeingPresented) {
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                
                imagepicker.modalPresentationStyle=UIModalPresentationPopover;
                imagepicker.view.tag=1;
                mypopovercontroller=imagepicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addphotobutton;
                mypopovercontroller.sourceRect=addphotobutton.bounds;
                
                [self presentViewController:imagepicker animated:YES completion:nil];
            }
        }
    });
}

-(BOOL) isAllUploadFilesNotExceedSize
{
    BOOL result=YES;
    NSData *videoData;
    NSInteger maxUploadFileSize;
    minMaxUploadFileSize=0;
    for (int p=0; p<workingClassPhoto.filearray.count; p++) {
        PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:p];
        if (![obj.action isEqualToString:@""] && ![obj.action isEqualToString:@"Delete"]) {
            for (int c=0; c<selectedCenters.count; c++) {
                maxUploadFileSize=[MyClass getMaxUploadFileSizeWithCenterkey:selectedCenters[c]];
                if (maxUploadFileSize<minMaxUploadFileSize) {
                    minMaxUploadFileSize=maxUploadFileSize;
                }
                
                if (result) {
                    videoData = [[NSData alloc]initWithContentsOfURL:obj.internalurl];
                    if (videoData.length>maxUploadFileSize) {
                        result=NO;
                    }
                }
            }
        }
    }
    return result;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.delegate donotrunviewdidappear];
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];
    
    
    if (picker.view.tag==1) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSData *videoData = [[NSData alloc]initWithContentsOfURL:videoURL];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *videoData=[MyClass compressVideoSynchronouslyWithURL:videoURL error:nil];
        if (![MyClass isPDFSizeNotExceedLimitWithData:videoData]) {
            [picker dismissViewControllerAnimated:NO completion:^{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Video"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }];
        }else{
            
                UIImage *image=[MyClass getThumbnailImageFromVideo:videoURL];
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:workingClassPhoto.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"video" InternalURL:videoURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];

                
                [picker dismissViewControllerAnimated:YES completion:nil];
                NSRange range = NSMakeRange(3,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
        }
            [MyClass loadingindicatorwithoption:@"stop" color:@""];
        });
    }else{
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
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:workingClassPhoto.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                NSRange range = NSMakeRange(3,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
            });
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate donotrunviewdidappear];
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    [self.delegate donotrunviewdidappear];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        if (controller.documentPickerMode == UIDocumentPickerModeImport) {
            NSData *chosendata=[[NSData alloc]initWithContentsOfURL:url];
            
            if (![MyClass isValidPDFWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returntitlewithtitle:@"Invalid PDF file"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else if (![MyClass isPDFSizeNotExceedLimitWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                UIImage *chosenImage=[MyClass returnPDFFirstPageImageWithPDFData:chosendata];
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:workingClassPhoto.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:chosenImage] Width:chosenImage.size.width Height:chosenImage.size.height FileType:@"pdf" InternalURL:url FileName:[url lastPathComponent] ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                
                NSRange range = NSMakeRange(3,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


-(void) returnCalendarYear:(NSString *)year
{
    [backButton setTitle:year forState:UIControlStateNormal];
}

- (IBAction)backbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [editTable deselectRowAtIndexPath:[editTable indexPathForSelectedRow] animated:YES];
    
}

- (IBAction)nonebuttonpressed:(id)sender {
    workingClassPhoto.hn_expiry_date=@"";
    [editTable reloadData];
    [self showsidewindowwithwindow:@""];
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    showExpiryDate=[windowname isEqualToString:@"showExpiryDate"];
    showMessagePhoto=[windowname isEqualToString:@"ClassPhoto"];
    showCenterTable=[windowname isEqualToString:@"showCenterTable"];
    if (showMessagePhoto) {
        [self createMessagePhotoToolBar];
    }
    [self adjusttablesize];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    workingClassPhoto.hn_expiry_date=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
    [editTable reloadData];
    [self showsidewindowwithwindow:@""];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [workingClassPhoto.filearray count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    cell.layer.borderColor=[UIColor lightTextColor].CGColor;
    cell.layer.borderWidth=1;

    if (indexPath.item==workingClassPhoto.filearray.count) {
        [cell.photoimageView setImage:nil];
        cell.addimagebutton.hidden=NO;
        cell.deleteimagebutton.hidden=YES;
        cell.videoplayicon.hidden=YES;
        [cell.addimagebutton addTarget:self action:@selector(addMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        MessagePhotoRecord *obj=[workingClassPhoto.filearray objectAtIndex:indexPath.item];
        [cell.photoimageView setImage:obj.imageview.image];
        cell.addimagebutton.hidden=YES;
        cell.deleteimagebutton.hidden=NO;
        cell.deleteimagebutton.tag=indexPath.item;
        cell.videoplayicon.hidden=![obj.filetype isEqualToString:@"video"];
        [cell.deleteimagebutton addTarget:self action:@selector(deleteMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==workingClassPhoto.filearray.count || workingClassPhoto.filearray.count<2) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    long count=workingClassPhoto.filearray.count;
    NSData *sourceImage = [workingClassPhoto.filearray objectAtIndex:sourceIndexPath.item];
    [workingClassPhoto.filearray removeObjectAtIndex:sourceIndexPath.item];
    
    if (destinationIndexPath.item==count) {
        [workingClassPhoto.filearray insertObject:sourceImage atIndex:count-1];
        [collectionView reloadData];
    }else{
        [workingClassPhoto.filearray insertObject:sourceImage atIndex:destinationIndexPath.row];
    }
    
    //changed to Updated
    NSInteger start;
    NSInteger end;
    if (sourceIndexPath.item>destinationIndexPath.item) {
        start=destinationIndexPath.item;
        end=sourceIndexPath.item;
    }else{
        start=sourceIndexPath.item;
        end=destinationIndexPath.item;
    }
    for (NSInteger i=start; i<=end; i++) {
        PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:i];
        if ([obj.action isEqualToString:@""]) {
            obj.action=@"Update";
            NSData *data=[[NSData alloc]initWithContentsOfURL:[MyClass returndownloadImageURLwithType:@"class" typekey:obj.fileurl]];
            obj.internalurl=[MyClass returnInternalURLforNSData:data Filename:obj.filename];
        }
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item<workingClassPhoto.filearray.count){
        PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:indexPath.item];
        if ([obj.action isEqualToString:@"Delete"]) {
            return CGSizeMake(0, 80);
        }
    }
    
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
    if (indexPath.row<workingClassPhoto.filearray.count) {
        photocornerfileobject=[workingClassPhoto.filearray objectAtIndex:indexPath.row];
        [self showsidewindowwithwindow:@"ClassPhoto"];
        [self showFullScreenMessagePhoto];
        [self adjusttablesize];
    }
}

-(void) showFullScreenMessagePhoto
{
    if ([photocornerfileobject.filetype isEqualToString:@"image"]) {
        webView.hidden=YES;
        videoView.hidden=YES;
        [avplayerviewcontroller.player pause];
        [fullscreen_messageimageview setImage:photocornerfileobject.imageview.image];
        
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
    }else if ([photocornerfileobject.filetype isEqualToString:@"pdf"]){
        webView.hidden=NO;
        videoView.hidden=YES;
        [avplayerviewcontroller.player pause];
        
        NSURL *pdfURL;
        if ([photocornerfileobject.action isEqualToString:@"Add"]) {
            pdfURL=photocornerfileobject.internalurl;
        }else{
            pdfURL=[MyClass returndownloadImageURLwithType:@"class" typekey:photocornerfileobject.fileurl];
        }


        [webView loadRequest:[NSURLRequest requestWithURL:pdfURL]];

    }else if ([photocornerfileobject.filetype isEqualToString:@"video"]){
        webView.hidden=YES;
        videoView.hidden=NO;
        
        NSURL *videoURL;
        if ([photocornerfileobject.action isEqualToString:@"Add"]) {
            videoURL=photocornerfileobject.internalurl;
        }else{
            videoURL=[MyClass returndownloadImageURLwithType:@"class" typekey:photocornerfileobject.fileurl];
        }
        
        avplayerviewcontroller.player=[AVPlayer playerWithURL:videoURL];
    }
}

-(void) closefullscreen
{
    [avplayerviewcontroller.player pause];
    MessagePhotoMasterView.hidden=YES;
}

-(void) closesidewindow
{
    [avplayerviewcontroller.player pause];
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [editTable deselectRowAtIndexPath:[editTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
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
    [photocornerfileobject.imageview setImage:[MyClass imageRotatedOnDegrees:90 Image:photocornerfileobject.imageview.image]];
    photocornerfileobject.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(photocornerfileobject.imageview.image, 0.7) Filename:@"image"];
    
    if ([photocornerfileobject.action isEqualToString:@""]) {
        photocornerfileobject.action=@"Update";
    }
    
    [self showFullScreenMessagePhoto];
    [editTable reloadData];
}

-(void) deleteMessagePhoto:(UIButton *)sender
{
    if ([[workingClassPhoto.filearray objectAtIndex:sender.tag] isEqual:photocornerfileobject]) {
        [avplayerviewcontroller.player pause];
        [self showsidewindowwithwindow:@"none"];
        [self adjusttablesize];
    }
    
    PhotoCornerFileRecord *obj=[workingClassPhoto.filearray objectAtIndex:sender.tag];
    if ([obj.action isEqualToString:@"Add"]) {
        [workingClassPhoto.filearray removeObjectAtIndex:sender.tag];
    }else{
        obj.action=@"Delete";
    }
 
    NSRange range = NSMakeRange(3,1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) addMessagePhoto:(UIButton *)sender
{
    [self addphotobuttonpressed:sender];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==centersearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:allcenterarray];
            [self sortFilteredCenterArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centershortname_english contains[c] %@ or self.centershortname_chinese contains[c] %@ or self.centerkey contains[c] %@",searchText,searchText,searchText];
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:[allcenterarray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredCenterArray];
        }
        [centertable reloadData];
        [centertable setContentOffset:CGPointZero animated:YES];
    }
}

- (IBAction)centernonebuttonpressed:(id)sender {
    selectedCenters=nil;
    [self backbuttonpressed:nil];
    [editTable reloadData];
}

- (IBAction)centerallbuttonpressed:(id)sender {
    selectedCenters=[[NSMutableArray alloc]init];
    [self backbuttonpressed:nil];
    [editTable reloadData];
}


@end
