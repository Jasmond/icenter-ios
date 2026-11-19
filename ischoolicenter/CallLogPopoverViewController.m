//
//  CallLogPopoverViewController.m
//  
//
//  Created by Jasmond Luk on 14/5/15.
//
//

#import "CallLogPopoverViewController.h"
#import "MyClass.h"

@implementation CallLogPopoverViewController
@synthesize CallLogRecordObject,CallLogTableMode,studentkey,CallingSource;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380

//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"isdb.sql"];
}

/*
//open the db
-(void) openDB{
    if (sqlite3_open([[self filePath] UTF8String], &isdb)!=SQLITE_OK){
        sqlite3_close(isdb);
        NSAssert(0,@"Database failed to open");
    }else{
        NSLog(@"Database opened");
    }
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    // Do any additional setup after loading the view.
    
    //globalvariables=[GlobalVariables singleObj];
    
    //initialize field
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    
    [self InitializeField];
    
    keyboardshow=FALSE;
    
    CallLogPopoverTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, 320, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    CallLogPopoverTable.dataSource=self;
    CallLogPopoverTable.delegate=self;
    CallLogToolbar.clipsToBounds=YES;
    
    [CallLogPopoverTable reloadData];
    
    [self adjusttablesize];
    
    [self.view addSubview:CallLogPopoverTable];
    
    
    //AssigneeListArray=[[NSMutableArray alloc]init];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
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
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

-(void) createViewBarButton{
  
    editButton.hidden=NO;
    deleteButton.hidden=YES;
    doneButton.hidden=YES;
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//    [CallLogToolbar setItems:buttons animated:NO];
}

-(void) createEditBarButton{
    editButton.hidden=YES;
    deleteButton.hidden=NO;
    doneButton.hidden=NO;
    
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [CallLogToolbar setItems:buttons animated:NO];
    
}

-(void) createAddBarButton{
    editButton.hidden=YES;
    deleteButton.hidden=YES;
    doneButton.hidden=NO;
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [CallLogToolbar setItems:buttons animated:NO];
    
}

-(void) adjusttablesize
{
    float tableheight;
    float tablewidth=320;
    
    tableheight=maxPopupHeight-keyboardheight;

    [CallLogPopoverTable setFrame:CGRectMake(0, 44+20, tablewidth, tableheight-44-20)];

    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
}



-(BOOL) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    showCalledByPicker=NO;
    showCalledOnPicker=NO;
    
    //initialize field
    
    if ([CallLogTableMode isEqualToString:@"Add"]) {
        //[self performSelector:@selector(loadcalendar) withObject:nil afterDelay:0];
        
        if (![self retrieveUserList]) {
            return NO;
        }
        tmpCalledBy=[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"];
        tmpCalledByUsername=globalvariables.username;
        [df setDateFormat:@"dd-MMM-yyyy"];
        tmpCalledOn=[df stringFromDate:[NSDate date]];
        tmpDetails=@"";
        
        [self createAddBarButton];
    }else if ([CallLogTableMode isEqualToString:@"View"]){
        if (![self retrieveUserList]) {
            return NO;
        }
        tmpCalledBy=[MyClass returnstaffnamewithusername:CallLogRecordObject.calledby firstorfullname:@"full"];
        //tmpCalledBy=[MyClass returnfullnamewithusername:CallLogRecordObject.calledby userlistarray:userListArray];
        tmpCalledOn=CallLogRecordObject.calledon;
        tmpDetails=CallLogRecordObject.details;
        [self createViewBarButton];
    }else if ([CallLogTableMode isEqualToString:@"Edit"]){
        //[self performSelector:@selector(loadcalendar) withObject:nil afterDelay:0];

        
        if (![self retrieveUserList]) {
            return NO;
        }
        
        tmpCalledByUsername=CallLogRecordObject.calledby;
        tmpCalledBy=[MyClass returnstaffnamewithusername:tmpCalledByUsername firstorfullname:@"full"];
        //tmpCalledBy=[MyClass returnfullnamewithusername:tmpCalledByUsername userlistarray:userListArray];
        tmpCalledOn=CallLogRecordObject.calledon;
        tmpDetails=CallLogRecordObject.details;
        
        [self createEditBarButton];
    }
    return YES;
    
    
}



-(BOOL) retrieveUserList
{
    userListArray=[MyClass retrieveStaffListwithvalid:@"Yes" role:@"All" flushcachedata:NO];
    userListArray=[MyClass returnsortedstafflistarraywithstafflistarray:userListArray];
    
    
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([CallLogTableMode isEqualToString:@"View"]) {
        if(section==0){
            return 2;
        }else{
            return 1;
        }
        
    }else{ //ClassTableMode isEqualToString:@"Edit"
        if (section==0) {
            return 4;
        }else{
            return 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return [MyClass returntitlewithtitle:@"General"];
    }else{
        return [MyClass returntitlewithtitle:@"Log Details"];
    }
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
    if ([CallLogTableMode isEqualToString:@"View"]) {
        if (indexPath.section==1){
            if ([CallLogRecordObject.details isEqualToString:@""]) {
                return 50;
            }else{
                UILabel *calllogdetails=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, 100)];
                calllogdetails.text= CallLogRecordObject.details;
                calllogdetails.numberOfLines=0;
                calllogdetails.font=[UIFont systemFontOfSize:13];
                
                [calllogdetails sizeToFit];
                CGRect myFrame=calllogdetails.frame;
                myFrame=CGRectMake(myFrame.origin.x, 5, 280, myFrame.size.height);
                calllogdetails.frame=myFrame;
                return calllogdetails.frame.size.height+10>50 ? calllogdetails.frame.size.height+10:50 ;
            }
        }else{
            return 38;
        }
    }else{
        if (indexPath.section==0) {
            if (indexPath.row==1) {
                if (showCalledByPicker) {
                    return 160;
                }else{
                    return 0;
                }
            }else if (indexPath.row==3) {
                if (showCalledOnPicker) {
                    return 200;
                }else{
                    return 0;
                }
            }else{
                return 38;
            }
        }else{
            return 180;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([CallLogTableMode isEqualToString:@"View"]) {
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        
        if (indexPath.section==0 ) {
            if (indexPath.row==0) {
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Called By"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                CalledByLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 8, 127, 21)];
                CalledByLabel.font=[UIFont systemFontOfSize:15];
                CalledByLabel.textColor=[UIColor darkGrayColor];
                CalledByLabel.textAlignment=NSTextAlignmentRight;
                CalledByLabel.text=tmpCalledBy;
                CalledByLabel.tag=302;
                [cell.contentView addSubview:CalledByLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 157, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Called On"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                CalledOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 8, 167, 21)];
                CalledOnLabel.font=[UIFont systemFontOfSize:15];
                CalledOnLabel.textColor=[UIColor darkGrayColor];
                CalledOnLabel.textAlignment=NSTextAlignmentRight;
                CalledOnLabel.minimumScaleFactor=0.7;
                CalledOnLabel.adjustsFontSizeToFitWidth=YES;
                CalledOnLabel.text=[MyClass returndateformatwithdate:tmpCalledOn];
                CalledOnLabel.tag=303;
                [cell.contentView addSubview:CalledOnLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else{
            
            DetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
            DetailsLabel.font=[UIFont systemFontOfSize:13];
            DetailsLabel.textColor=[UIColor darkGrayColor];
            DetailsLabel.textAlignment=NSTextAlignmentLeft;
            DetailsLabel.text=tmpDetails;
            DetailsLabel.numberOfLines=0;
            DetailsLabel.tag=309;
            [cell.contentView addSubview:DetailsLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [DetailsLabel sizeToFit];
            CGRect myFrame=DetailsLabel.frame;
            myFrame=CGRectMake(myFrame.origin.x, 5, 280, myFrame.size.height);
            DetailsLabel.frame=myFrame;
            
            
        }
    }else{// if([ClassTableMode isEqualToString:@"Edit"]){
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.section==0 ) {
            if (indexPath.row==0){
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 157, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Called By"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                CalledByLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 8, 167, 21)];
                CalledByLabel.font=[UIFont systemFontOfSize:15];
                CalledByLabel.textColor=[UIColor darkGrayColor];
                CalledByLabel.minimumScaleFactor=0.7;
                CalledByLabel.adjustsFontSizeToFitWidth=YES;
                CalledByLabel.textAlignment=NSTextAlignmentRight;
                CalledByLabel.text=tmpCalledBy;
                CalledByLabel.tag=303;
                [cell.contentView addSubview:CalledByLabel];
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row==1){
                if (showCalledByPicker==YES) {
                    
                    UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(45, 0, 240, 150)];
                    [myPicker setDataSource:self];
                    [myPicker setDelegate:self];
                    myPicker.tag=805;
                    

                    presetRow=[self returnuserlistindexwithcalledbyusername:tmpCalledByUsername];
                    
                    [myPicker selectRow:presetRow inComponent:0 animated:NO];
                    [myPicker setShowsSelectionIndicator:YES];
                    [cell.contentView addSubview:myPicker];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if  (indexPath.row==2){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 160, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Called On"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                CalledOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 8, 152, 21)];
                CalledOnLabel.font=[UIFont systemFontOfSize:15];
                CalledOnLabel.textColor=[UIColor darkGrayColor];
                CalledOnLabel.textAlignment=NSTextAlignmentRight;
                
                CalledOnLabel.text=[MyClass returndateformatwithdate:tmpCalledOn];
                CalledOnLabel.tag=312;
                [cell.contentView addSubview:CalledOnLabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==3){
                if (showCalledOnPicker==YES) {
                    
                    CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                    [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:tmpCalledOn, nil] ScrollToDate:nil instructorselected:nil];
                    calendarview.delegate=self;
                    

                    [cell.contentView addSubview:calendarview];
                    
                    

                }else{
                    cell.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }

        }else{// if (indexPath.section==3){
            DetailsText = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, 280, 170)];
            DetailsText.font=[UIFont systemFontOfSize:13];
            DetailsText.textColor=[UIColor darkGrayColor];
            DetailsText.delegate=self;
            DetailsText.text=tmpDetails;
            DetailsText.tag=303;
            [cell.contentView addSubview:DetailsText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0) {
        
        selectedItem=@"CalledBy";
        if (showCalledByPicker==YES) {
            showCalledByPicker=NO;
        }else{
            showCalledByPicker=YES;
            showCalledOnPicker=NO;
        }
        
        
        if ([CalledByLabel.text isEqualToString:@""]) {
            tmpCalledBy=[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"];
        }
        
        
        //[self storeTmpField];
        [CallLogPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if (indexPath.section==0 && indexPath.row==2) {
        //pickerview for assignto
        
        selectedItem=@"CalledOn";
        if (showCalledOnPicker==YES) {
            showCalledOnPicker=NO;
        }else{
            showCalledByPicker=NO;
            showCalledOnPicker=YES;
        }
        
        if ([CalledOnLabel.text isEqualToString:@""]) {
            [df setDateFormat:@"dd-MMM-yyyy"];
            tmpCalledOn=[df stringFromDate:[NSDate date]];
        }
        
        //[self storeTmpField];
        [CallLogPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"CalledOn"]){
        return 10000;
    }else{
        return [userListArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"CalledOn"]){
        return [MyClass returndateformatEEEDDMMMYYYYwithdateDDMMMYYYY:[MyClass returnDateFromBaseDateWithOffset:row]];
    }else{
        return [MyClass returnstaffnamewithusername:((UserRecord *)[userListArray objectAtIndex:row]).username firstorfullname:@"full"];
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 250;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*if([selectedItem isEqualToString:@"CalledOn"]){
        if (![tmpCalledOn isEqualToString:[MyClass returnDateFromBaseDateWithOffset:row]]){
            
            tmpCalledOn=[MyClass returnDateFromBaseDateWithOffset:row];
            showCalledOnPicker=NO;
            
            //[self storeTmpField];
            [CallLogPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }
    }else */if ([selectedItem isEqualToString:@"CalledBy"]){
        if (![tmpCalledByUsername isEqualToString:((UserRecord *)[userListArray objectAtIndex:row]).username]) {
            
            tmpCalledBy=[MyClass returnstaffnamewithusername:((UserRecord *)[userListArray objectAtIndex:row]).username firstorfullname:@"full"];
            tmpCalledByUsername=((UserRecord *)[userListArray objectAtIndex:row]).username;
            
            showCalledByPicker=NO;
            
            //[self storeTmpField];
            [CallLogPopoverTable reloadData];
            
            [self adjusttablesize];
        }
    }
}


-(void) deletecalllog
{
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletecalllog&calllogkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,CallLogRecordObject.calllogkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    
    if (result) {
        [self.delegate dismissCallLogPopoverVC];
    }
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
}


-(IBAction) deleteButtonPressed:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Call Log Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the call log record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deletecalllog];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction) editButtonPressed:(id)sender{
    
    CallLogTableMode=@"Edit";
    if (![self InitializeField]) {
        CallLogTableMode=@"View";
        return;
    }

    [CallLogPopoverTable reloadData];
    [self adjusttablesize];

}


-(IBAction) doneButtonPressed:(id)sender
{

    [self.view endEditing:YES];

    if ([CalledByLabel.text isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Call Log Record"] message:[MyClass returntitlewithtitle:@"Please select person who made the call"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([CalledOnLabel.text isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Call Log Record"] message:[MyClass returntitlewithtitle:@"Please select the date that the call was made"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([DetailsText.text isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Call Log Record"] message:[MyClass returntitlewithtitle:@"Please input call log details"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatecalllog];
        });
    }
}


-(void) updatecalllog
{
    
    __block BOOL result=FALSE;
    
    
    NSDictionary *dictionary = @{@"postaction" : @"updatecalllog",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"action" : CallLogTableMode,
                                 @"type"  : CallingSource,
                                 @"typekey" : studentkey,
                                 @"calllogkey" : [CallLogTableMode isEqualToString:@"Edit"]?CallLogRecordObject.calllogkey:@"",
                                 @"calledby" : tmpCalledByUsername,
                                 @"calledon" : [MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:tmpCalledOn],
                                 @"details" : tmpDetails};
    

    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        [self.delegate dismissCallLogPopoverVC];
    }
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:CallLogPopoverTable];
        NSIndexPath *indexpath =[CallLogPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [CallLogPopoverTable rectForRowAtIndexPath:indexpath];
        
        CGFloat yoffset=rectInTableView.origin.y+rectInTableView.size.height-CallLogPopoverTable.frame.size.height;
        if(yoffset>0){
            [CallLogPopoverTable setContentOffset:CGPointMake(0, yoffset) animated:YES];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==DetailsText) {
        tmpDetails=DetailsText.text;
    }
}


-(int) returnuserlistindexwithcalledbyusername:(NSString *)calledbyusername
{
    UserRecord *userrecordobject=[[UserRecord alloc]init];
    for (int i=0; i<userListArray.count; i++) {
        userrecordobject=[userListArray objectAtIndex:i];
        if ([calledbyusername isEqualToString:userrecordobject.username]) {
            return i;
        }
    }
    return 0;
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if([selectedItem isEqualToString:@"CalledOn"]){
        if (![tmpCalledOn isEqualToString:selecteddatestring]){
            
            tmpCalledOn=selecteddatestring;
            showCalledOnPicker=NO;
            
            [CallLogPopoverTable reloadData];
            [self adjusttablesize];
            
        }
    }
}

-(void) returnCalendarYear:(NSString *)year
{
    
}

@end
