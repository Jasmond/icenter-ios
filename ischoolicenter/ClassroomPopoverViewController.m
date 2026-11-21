//
//  ClassroomPopoverViewController.m
//  
//
//  Created by Jasmond Luk on 16/6/2015.
//
//

#import "ClassroomPopoverViewController.h"
#import "MyClass.h"

@implementation ClassroomPopoverViewController
@synthesize ClassroomTableMode,ClassroomRecordObject;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define colorcodetablewidth 320
#define popoverwidth 320
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //globalvariables=[GlobalVariables singleObj];
    
    //initialize field
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    
    capacityArray=[[NSMutableArray alloc]init];
    [capacityArray addObject:@""]; // for unlimited option
    for (int i=0; i<=50; i++) {
        [capacityArray addObject:[@(i) stringValue]];
    }
    
    workingClassroom=[[ClassroomRecord alloc]init];
    
    
    [self InitializeField];
    
    keyboardshow=FALSE;
    
    ClassroomPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    ClassroomPopoverTable.dataSource=self;
    ClassroomPopoverTable.delegate=self;
    ClassroomToolbar.clipsToBounds=YES;
    
    [ClassroomPopoverTable reloadData];
    
    [self adjusttablesize];
    
    [self.view addSubview:ClassroomPopoverTable];
    [self createtables];
    
    //AssigneeListArray=[[NSMutableArray alloc]init];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    classroomstatusarray=[[NSArray alloc]initWithObjects:@"In Service",@"Not In Service", nil];
    
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];

    
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[MessagePopoverTable reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    [self adjusttablesize];
    
}

-(void) createtables
{
    UILabel *label;
    UIView *headerView;
    UILabel *separator;
    
    //color color table
    ColorCodeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, colorcodetablewidth, self.view.frame.size.height)];
    [self.view addSubview:ColorCodeTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ColorCodeTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ColorCodeTableMasterView addSubview:headerView];
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Staff Color"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    ColorCodeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, colorcodetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    ColorCodeTable.dataSource=self;
    ColorCodeTable.delegate=self;
    ColorCodeTable.sectionHeaderHeight=0;
    [ColorCodeTableMasterView addSubview:ColorCodeTable];
    
    ColorCodeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, colorcodetablewidth, 44)];
    ColorCodeTableToolBar.clipsToBounds = YES;
    [ColorCodeTableMasterView addSubview:ColorCodeTableToolBar];
    [self createColorCodeTableToolBar];
    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.bounds.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
}

-(void) createColorCodeTableToolBar
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
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [ColorCodeTableToolBar setItems:barItems];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ColorCodeTableMasterView addSubview:button];
}

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [ClassroomPopoverTable deselectRowAtIndexPath:[ClassroomPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) createViewBarButton{
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//    [ClassroomToolbar setItems:buttons animated:NO];
    
    doneButton.hidden=YES;
    deleteButton.hidden=YES;
    editButton.hidden=NO;
    
    editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editclassroom;
}

-(void) createEditBarButton{
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [ClassroomToolbar setItems:buttons animated:NO];
    
    doneButton.hidden=NO;
    deleteButton.hidden=NO;
    editButton.hidden=YES;
    
}

-(void) createAddBarButton{
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [ClassroomToolbar setItems:buttons animated:NO];
 
    doneButton.hidden=NO;
    deleteButton.hidden=YES;
    editButton.hidden=YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==RemarksText) {
        workingClassroom.remarks=textView.text;
    }else if (textView==ClassroomText){
        workingClassroom.classroom=textView.text;
    }
}


-(BOOL) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    showCapacityPicker=NO;
    
    //initialize field
    
    if ([ClassroomTableMode isEqualToString:@"Add"]) {
        
        workingClassroom.classroom=@"";
        workingClassroom.status=@"In Service";
        workingClassroom.remarks=@"";
        workingClassroom.capacity=@"";
        workingClassroom.colorcode=[MyClass returnFreeColorCodewithType:@"classroom"];
        
        [self createAddBarButton];
    }else if ([ClassroomTableMode isEqualToString:@"View"]){
        
        workingClassroom.classroomkey=ClassroomRecordObject.classroomkey;
        workingClassroom.classroom=ClassroomRecordObject.classroom;
        workingClassroom.status=ClassroomRecordObject.status;
        workingClassroom.remarks=ClassroomRecordObject.remarks;
        workingClassroom.capacity=ClassroomRecordObject.capacity;
        workingClassroom.colorcode=ClassroomRecordObject.colorcode;
        
        [self createViewBarButton];
    }else if ([ClassroomTableMode isEqualToString:@"Edit"]){
        
        workingClassroom.classroomkey=ClassroomRecordObject.classroomkey;
        workingClassroom.classroom=ClassroomRecordObject.classroom;
        workingClassroom.status=ClassroomRecordObject.status;
        workingClassroom.remarks=ClassroomRecordObject.remarks;
        workingClassroom.capacity=ClassroomRecordObject.capacity;
        workingClassroom.colorcode=ClassroomRecordObject.colorcode;
        
        [self createEditBarButton];
    }
    return YES;
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==ClassroomPopoverTable){
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==ClassroomPopoverTable) {
        if (section==0){
            return 1;
        }else if (section==1) {
            return [ClassroomTableMode isEqualToString:@"View"]?3:4;
        }
        return 1;
    }else{
        return globalvariables.colorcodearray.count;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==ClassroomPopoverTable) {
        if(section==0){
            return [MyClass returntitlewithtitle:@"Classroom"];
        }else if(section==1){
            return [MyClass returntitlewithtitle:@"Details"];
        }else{
            return [MyClass returntitlewithtitle:@"Remarks"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==ClassroomPopoverTable){
        if (indexPath.section==0) {
            return 80;
        }else if (indexPath.section==1){
            if (indexPath.row==3) {
                return showCapacityPicker?150:CGFLOAT_MIN;
            }
            return 38;
        }else{
            return 150;
        }
    }else{
        return 35;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==ClassroomPopoverTable){
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (tableView==ClassroomPopoverTable) {
        if ([ClassroomTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0){
                ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 280, 80)];
                ClassroomLabel.font=[UIFont systemFontOfSize:13];
                ClassroomLabel.textColor=[UIColor darkGrayColor];
                ClassroomLabel.textAlignment=NSTextAlignmentLeft;
                ClassroomLabel.text=workingClassroom.classroom;
                ClassroomLabel.numberOfLines=0;
                ClassroomLabel.tag=309;
                [cell.contentView addSubview:ClassroomLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [ClassroomLabel sizeToFit];
                CGRect myFrame=ClassroomLabel.frame;
                myFrame=CGRectMake(myFrame.origin.x, 8, 280, myFrame.size.height);
                ClassroomLabel.frame=myFrame;
                
            }else if (indexPath.section==1) {
                
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Status"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 8, 127, 21)];
                    StatusLabel.font=[UIFont systemFontOfSize:15];
                    StatusLabel.textColor=[UIColor darkGrayColor];
                    StatusLabel.textAlignment=NSTextAlignmentRight;
                    StatusLabel.text=[MyClass returntitlewithtitle:workingClassroom.status];
                    StatusLabel.tag=302;
                    [cell.contentView addSubview:StatusLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Room Color"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.layer.masksToBounds=YES;
                    GeneralLabel.layer.cornerRadius=4;
                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingClassroom.colorcode];
                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Capacity"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 8, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[workingClassroom.capacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingClassroom.capacity;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }else{
                RemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 280, 140)];
                RemarksLabel.font=[UIFont systemFontOfSize:13];
                RemarksLabel.textColor=[UIColor darkGrayColor];
                RemarksLabel.textAlignment=NSTextAlignmentLeft;
                RemarksLabel.text=workingClassroom.remarks;
                RemarksLabel.numberOfLines=0;
                RemarksLabel.tag=309;
                [cell.contentView addSubview:RemarksLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [RemarksLabel sizeToFit];
                CGRect myFrame=RemarksLabel.frame;
                myFrame=CGRectMake(myFrame.origin.x, 8, 280, myFrame.size.height);
                RemarksLabel.frame=myFrame;
            }
        }else{// if([ClassTableMode isEqualToString:@"Edit"]){
            
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0){
                ClassroomText = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 0, 280, 80)];
                ClassroomText.font=[UIFont systemFontOfSize:13];
                ClassroomText.textColor=[UIColor darkGrayColor];
                ClassroomText.delegate=self;
                ClassroomText.text=workingClassroom.classroom;
                ClassroomText.tag=303;
                ClassroomText.placeholder=[MyClass returntitlewithtitle:@"Enter Classroom"];
                ClassroomText.placeholderColor=[UIColor lightGrayColor];
                [cell.contentView addSubview:ClassroomText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }else if (indexPath.section==1) {
                
                if(indexPath.row==0){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 157, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Status"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"In Service"],[MyClass returntitlewithtitle:@"Not In Service"],nil]];
                    scStatus.frame = CGRectMake(90, 4, 215, 29);
                    [scStatus addTarget:self action:@selector(selectStatus:) forControlEvents: UIControlEventValueChanged];
                    scStatus.tintColor=themecolor;
                    
                    scStatus.selectedSegmentIndex=[workingClassroom.status isEqualToString:@"In Service"] ? 0:1;
                    [cell.contentView addSubview:scStatus];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Room Color"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.layer.masksToBounds=YES;
                    GeneralLabel.layer.cornerRadius=4;
                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingClassroom.colorcode];
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==2){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Capacity"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 8, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[workingClassroom.capacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingClassroom.capacity;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==3){
                    if(showCapacityPicker){
                        pickerViewmenu =capacityArray;
                        int presetRow;
                        
                        if ([pickerViewmenu containsObject:workingClassroom.capacity]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingClassroom.capacity];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
                
                
            }else{// if (indexPath.section==3){
                RemarksText = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 0, 280, 140)];
                RemarksText.font=[UIFont systemFontOfSize:13];
                RemarksText.textColor=[UIColor darkGrayColor];
                RemarksText.delegate=self;
                RemarksText.text=workingClassroom.remarks;
                RemarksText.tag=303;
                RemarksText.placeholder=[MyClass returntitlewithtitle:@"Enter Remarks"];
                RemarksText.placeholderColor=[UIColor lightGrayColor];
                [cell.contentView addSubview:RemarksText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }else if (tableView==ColorCodeTable){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *titlelabel;
        UIImageView *titleselected;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 24, 16)];
            titlelabel.layer.masksToBounds=YES;
            titlelabel.layer.cornerRadius=4;
            titlelabel.tag=1301;
            [cell.contentView addSubview:titlelabel];
            
            titleselected = [[UIImageView alloc]initWithFrame:CGRectMake(colorcodetablewidth-45, 7, 24, 24)];
            [titleselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            titleselected.tag=1302;
            [cell.contentView addSubview:titleselected];
        }else{
            titlelabel=(UILabel *)[cell.contentView viewWithTag:1301];
            titleselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        
        titlelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:indexPath.row];
        titleselected.hidden=(workingClassroom.colorcode!=indexPath.row);
        
    }
    
    return cell;
}

-(void) selectStatus:(UISegmentedControl *)sender
{
    workingClassroom.status=[classroomstatusarray objectAtIndex:sender.selectedSegmentIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ClassroomPopoverTable) {
        if (![ClassroomTableMode isEqualToString:@"View"]) {
            if (indexPath.section==1 && indexPath.row==2) {
                if (showCapacityPicker==YES) {
                    showCapacityPicker=NO;
                }else{
                    showCapacityPicker=YES;
                }
                
                [ClassroomPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==1 && indexPath.row==1) {
                //pickerview for date/time
                
                
                if (showColorCodeTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [ClassroomPopoverTable reloadData];
                }else{
                    //showRolePicker=NO;
                    [self showsidewindowwithwindow:@"showColorCode"];
                    [self adjusttablesize];
                    [ClassroomPopoverTable reloadData];
                    [ClassroomPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [ColorCodeTable reloadData];
            }
        }
    }else if(tableView==ColorCodeTable){
        if (workingClassroom.colorcode !=indexPath.row) {
            workingClassroom.colorcode=indexPath.row;
            [ColorCodeTable reloadData];
            [ClassroomPopoverTable reloadData];
            [self adjusttablesize];
        }
    }
}

-(void) deleteclassroom
{
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteclassroom&classroomkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,ClassroomRecordObject.classroomkey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self.delegate dismissClassroomPopover];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(IBAction) deleteButtonPressed:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Classroom"] message:[NSString stringWithFormat:[MyClass returntitlewithtitle:@"%@ %@?"],[MyClass returntitlewithtitle:@"Are you sure to delete"],ClassroomRecordObject.classroom] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *result=[self checkifclassroomoccupied:ClassroomRecordObject.classroom];
        if (result) {
            if ([result isEqualToString:@"No"]) {
                [self deleteclassroom];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Classroom cannot be deleted"] message:[MyClass returntitlewithtitle:@"The classroom is associated to the class record(s)"] preferredStyle:UIAlertControllerStyleAlert];
                
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

-(IBAction) editButtonPressed:(id)sender{
    
    ClassroomTableMode=@"Edit";
    [self InitializeField];
    [ClassroomPopoverTable reloadData];
    [self adjusttablesize];
    
}

-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    workingClassroom.classroom=[MyClass leadingtrailingspacestrimmed:workingClassroom.classroom];
    
    [ClassroomPopoverTable reloadData];

    if ([workingClassroom.classroom isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Classroom"] message:[MyClass returntitlewithtitle:@"Please input the classroom's name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        NSString *classroomavailable=[self checkclassroomavailablityok:workingClassroom.classroom];
        if (classroomavailable) {
            if ([classroomavailable isEqualToString:@"NOK"]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Classroom's name already being used"] message:[MyClass returntitlewithtitle:@"Please select another name"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }else{
                [self updateclassroom];
            }
        }
    }
}

-(void) updateclassroom
{
    __block BOOL result=FALSE;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateclassroom" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:ClassroomTableMode forKey:@"action"];
    if ([ClassroomTableMode isEqualToString:@"Edit"]) {
        [dictionary setValue:ClassroomRecordObject.classroomkey forKey:@"classroomkey"];
        [dictionary setValue:ClassroomRecordObject.classroom forKey:@"oldclassroom"];
    }
    
    [dictionary setValue:workingClassroom.status forKey:@"status"];
    [dictionary setValue:workingClassroom.classroom forKey:@"classroom"];
    [dictionary setValue:workingClassroom.remarks forKey:@"remarks"];
    [dictionary setValue:workingClassroom.capacity forKey:@"capacity"];
    [dictionary setValue:[@(workingClassroom.colorcode) stringValue] forKey:@"colorcode"];
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (result) {
        [self.delegate dismissClassroomPopover];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    

}

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:ClassroomPopoverTable];
        NSIndexPath *indexpath =[ClassroomPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [ClassroomPopoverTable rectForRowAtIndexPath:indexpath];
        
        if (rectInTableView.origin.y+rectInTableView.size.height>[MyClass keyboardVisibleHeightForTableView:ClassroomPopoverTable]) {
            [ClassroomPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-[MyClass keyboardVisibleHeightForTableView:ClassroomPopoverTable]) animated:YES];
        }
    }
}

/*
-(void) textViewDidEndEditing:(UITextView *)textView
{
    if (textView==ClassroomText) {
        tmpClassroom=ClassroomText.text;
    }else if (textView==RemarksText) {
        tmpRemarks=RemarksText.text;
    }
}*/

-(NSString *) checkifclassroomoccupied:(NSString *)classroom
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveclassroomcount&classroom=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classroom];
    
    __block BOOL result=FALSE;
    __block NSString *classroomCanBeDeleted;
    

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                classroomCanBeDeleted=@"Yes";
            }else{
                classroomCanBeDeleted=@"No";
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
                classroomCanBeDeleted=@"Yes";
            }else{
                classroomCanBeDeleted=@"No";
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
         
    
    if(result){
        return classroomCanBeDeleted;
    }else{
        //[MyClass showconnectionlostdialogbox];
        return nil;
    }
}

-(NSString *) checkclassroomavailablityok:(NSString *)classroom
{
    if ([classroom caseInsensitiveCompare:ClassroomRecordObject.classroom]==NSOrderedSame) {
        return @"OK";
    }else{
        //create string contains url address for php file
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=checkclassroomavailability&classroom=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classroom];
        
        __block BOOL result=FALSE;
        __block NSString *available;
        

        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                if (JSONArray.count>0) {
                    available= @"NOK";
                }else{
                    available= @"OK";
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
                JSONArray = jsonreturned[@"content"];
                if (JSONArray.count>0) {
                    available= @"NOK";
                }else{
                    available= @"OK";
                }
            }
                    
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if (result) {
            return available;
        }else{
            //[MyClass showconnectionlostdialogbox];
            return nil;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [pickerViewmenu count];
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
    
    if ([[pickerViewmenu objectAtIndex:row] isEqualToString:@""]) {
        tView.text= [MyClass returntitlewithtitle:@"Unlimited"];
    }else{
        tView.text= [pickerViewmenu objectAtIndex:row];
    }
    
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 260;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (![workingClassroom.capacity isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
        workingClassroom.capacity=[pickerViewmenu objectAtIndex:row];
        
        showCapacityPicker=NO;
        
        //[self storeTmpField];
        [ClassroomPopoverTable reloadData];
        [self adjusttablesize];
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    showColorCodeTable=[windowname isEqualToString:@"showColorCode"];
}



-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight;
    
    if (showColorCodeTable){
        tablewidth=popoverwidth+colorcodetablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    [ClassroomPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    [MyClass applyKeyboardContentInset:keyboardheight toView:ClassroomPopoverTable];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showColorCodeTable){
        [ColorCodeTable setFrame:CGRectMake(0, 44+44+20, colorcodetablewidth, tableheight-44-20)];
        [MyClass applyKeyboardContentInset:keyboardheight toView:ColorCodeTable];
        ColorCodeTableMasterView.hidden=NO;
    }else{
        ColorCodeTableMasterView.hidden=YES;
    }
    
}


@end

