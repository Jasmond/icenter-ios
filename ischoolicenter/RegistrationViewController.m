//
//  RegistrationViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 26/11/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MyTableViewCell.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    tableRowDataArray=[[NSMutableArray alloc]init];
    //[tableRowDataArray addObject:@"sxn_Please fill in the information"];
    [tableRowDataArray addObject:@"companyname"];
    [tableRowDataArray addObject:@"companyaddress"];
    [tableRowDataArray addObject:@"contactname"];
    [tableRowDataArray addObject:@"brnumber"];
    [tableRowDataArray addObject:@"username"];
    [tableRowDataArray addObject:@"mobilenumber"];
    [tableRowDataArray addObject:@"centername"];
    [tableRowDataArray addObject:@"centeraddress"];
    [tableRowDataArray addObject:@"centerwebsite"];
    //tableRowDataArray addObject:@"sxn_empty"];
    [tableRowDataArray addObject:@"term"];
    [tableRowDataArray addObject:@"agreementlink"];
    [tableRowDataArray addObject:@"agreement"];
    [tableRowDataArray addObject:@"buttons"];
    
    companyName=@"";
    companyAddress=@"";
    contactName=@"";
    brNumber=@"";
    username=@"";
    isoCode=@"HK";
    mobileNumber=@"852";
    centerName=@"";
    centerAddress=@"";
    centerWebsite=@"";
    enableSubmitButton=FALSE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return tableRowDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"sxn_Please fill in the information"]) {
        //cellView = [tableView makeViewWithIdentifier:@"headerCell" owner:self];
        //cellView.headerText.stringValue=[MyClass returnlogintitlewithtitle:@"Please fill in the information"];
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"sxn_Empty"]) {
        //cellView = [tableView makeViewWithIdentifier:@"headerCell" owner:self];
        //cellView.headerText.stringValue=@"";
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"companyname"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=companyName;
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Company name"];
        cell.label2.text=@"";
        cell.label2.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"companyaddress"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=companyAddress;
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Company address"];
        cell.label2.text=@"";
        cell.label2.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"contactname"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=contactName;
        cell.label2.text=@"";
        cell.label2.hidden=YES;
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Contact name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"brnumber"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=brNumber;
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Business registration number"];
        cell.label2.text=@"";
        cell.label2.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"username"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=username;
        cell.label2.text=[MyClass returnlogintitlewithtitle:@"Please input a valid email address"];
        cell.label2.hidden=![username isEqualToString:@""];
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Username"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"centername"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=centerName;
        cell.label2.text=[MyClass returnlogintitlewithtitle:@"If different from above company name"];
        cell.label2.hidden=![centerName isEqualToString:@""];
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Center name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"centeraddress"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=centerAddress;
        cell.label2.text=[MyClass returnlogintitlewithtitle:@"If different from above company address"];
        cell.label2.hidden=![centerName isEqualToString:@""];
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Center address"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"centerwebsite"]) {
        static NSString *CellIdentifier = @"remarkscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=centerWebsite;
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Center website"];
        cell.label2.text=@"";
        cell.label2.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"mobilenumber"]) {
        static NSString *CellIdentifier = @"mobilenumbercell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textview1.tag=indexPath.row;
        cell.textview1.text=[MyClass returnLocalNumberWithContact:mobileNumber ISOCode:isoCode];
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"Mobile number"];
        cell.label2.text=[MyClass returnlogintitlewithtitle:@"Initial password will be sent via SMS"];
        cell.label2.hidden=![centerName isEqualToString:@""];
        cell.label3.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:isoCode]];
        [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"flag" typekey:isoCode image:@"Yes" async:YES];
        [cell.button1 addTarget:self action:@selector(ccButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"term"]) {
        static NSString *CellIdentifier = @"termcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"trial_application_term"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"agreement"]) {
        static NSString *CellIdentifier = @"agreementcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label1.text=[MyClass returnlogintitlewithtitle:@"I agree with the terms of iSchool Trial Agreement"];
        cell.imageview1.layer.opacity=enableSubmitButton?1.0:0.2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"agreementlink"]) {
        static NSString *CellIdentifier = @"agreementlinkcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.button1 setTitle:[MyClass returnlogintitlewithtitle:@"View iSchool Trial Agreement"] forState:UIControlStateNormal];
        [cell.button1 addTarget:self action:@selector(agreementLinkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"buttons"]) {
        static NSString *CellIdentifier = @"buttoncell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.button1 setTitle:[MyClass returnlogintitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
        [cell.button2 setTitle:[MyClass returnlogintitlewithtitle:@"Submit"] forState:UIControlStateNormal];
        
        cell.button1.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        cell.button1.backgroundColor=[UIColor whiteColor];
        cell.button1.layer.borderWidth=1;
        cell.button1.layer.cornerRadius=4;
        cell.button1.layer.masksToBounds=YES;

        
        cell.button2.backgroundColor=[UIColor whiteColor];
        cell.button2.layer.borderWidth=1;
        cell.button2.layer.cornerRadius=4;
        cell.button2.layer.masksToBounds=YES;
        if (enableSubmitButton) {
            //cell.button2.enabled=YES;
            cell.button2.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
            [cell.button2 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            //cell.button2.enabled=NO;
            cell.button2.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [cell.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        [cell.button1 addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [MyClass returnlogintitlewithtitle:@"Trial Application"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"agreement"]){
        enableSubmitButton=!enableSubmitButton;
        [registrationTable reloadData];
    }
}

-(void) agreementLinkButtonPressed:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"https://dreamware.com.hk/chi/?page_id=418"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}



-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) submitButtonPressed:(id)button
{
    if (!enableSubmitButton) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"Apply Trial Account"] message:[MyClass returnlogintitlewithtitle:@"Please click to agree the terms first"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (![self missingInputField]) {
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self submitApplication];
            });
        }
    }
    
}

- (void) cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) submitApplication
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"applytrialaccount" forKey:@"postaction"];
    [dictionary setValue:companyName forKey:@"companyname"];
    [dictionary setValue:companyAddress forKey:@"companyaddress"];
    [dictionary setValue:contactName forKey:@"contactname"];
    [dictionary setValue:brNumber forKey:@"brnumber"];
    [dictionary setValue:username forKey:@"username"];
    [dictionary setValue:mobileNumber forKey:@"mobilenumber"];
    [dictionary setValue:[centerName isEqualToString:@""]?companyName:centerName forKey:@"centername"];
    [dictionary setValue:[centerAddress isEqualToString:@""]?companyAddress:centerAddress forKey:@"centeraddress"];
    [dictionary setValue:centerWebsite forKey:@"centerwebsite"];
    [dictionary setValue:globalvariables.language forKey:@"language"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            returndata=data;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:returndata options:(kNilOptions) error:nil];
        NSArray *JSONArray = jsonreturned[@"content"];
        
        NSString * statuscode=[[JSONArray objectAtIndex:0] objectForKey:@"statuscode"];
        NSString * statusmessage=[[JSONArray objectAtIndex:0] objectForKey:@"statusmessage"];

        if ([statuscode isEqualToString:@"1"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate appliedTrialAccountWithUsername:username statusmessage:statusmessage];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"Apply Trial Account"] message:[MyClass returnlogintitlewithtitle:statusmessage] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:OKAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

-(BOOL) missingInputField
{
    NSString *errormessage=@"";
    if ([companyName isEqualToString:@""]) {
        errormessage = @"Missing company name";
    }else if ([companyAddress isEqualToString:@""]){
        errormessage = @"Missing company address";
    }else if ([contactName isEqualToString:@""]){
        errormessage = @"Missing contact name";
    }else if ([username isEqualToString:@""]){
        errormessage = @"Missing username";
    }else if ([[MyClass returnLocalNumberWithContact:mobileNumber ISOCode:isoCode] isEqualToString:@""]){
        errormessage = @"Missing mobile number";
    }else if (![self NSStringIsValidEmail:username]){
        errormessage = @"Username should be an valid email address";
    }
    
    if (![errormessage isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"Apply Trial Account"] message:[MyClass returnlogintitlewithtitle:errormessage] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];

        return TRUE;
    }

    return FALSE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)textViewDidChange:(UITextView *)textView
{
    MyTableViewCell *newcell=[registrationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:0]];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        newcell.layoutconstraint1.constant=100;
        textView.scrollEnabled=YES;
    }else{
        newcell.layoutconstraint1.constant=size.height;
        textView.scrollEnabled=NO;
    }
    
    if (textView.tag==[tableRowDataArray indexOfObject:@"companyname"]) {
        companyName=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"companyaddress"]) {
        companyAddress=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"contactname"]) {
        contactName=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"brnumber"]) {
        brNumber=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"username"]) {
        username=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"centername"]) {
        centerName=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"mobilenumber"]) {

        textView.text=[MyClass allspacestrimmed:textView.text];
        if (![MyClass checkValidInput:textView.text Type:@"EmptyInteger"]){
            textView.text=[MyClass returnLocalNumberWithContact:mobileNumber ISOCode:isoCode];
        }else{
            mobileNumber=[NSString stringWithFormat:@"%@%@", [MyClass returnCountryCodeWithISOCode:isoCode], textView.text];
        }
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"centeraddress"]) {
        centerAddress=textView.text;
    }else if (textView.tag==[tableRowDataArray indexOfObject:@"centerwebsite"]) {
        centerWebsite=textView.text;
    }
    
    [registrationTable beginUpdates];
    [registrationTable endUpdates];
    
}

-(void) ccButtonPressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:isoCode, nil] DataType:@"countrycode" DataIndex:0 ShowSearchBar:YES BottomMode:nil PreferredContentSize:CGSizeMake(220, 200) View:self Button:sender ItemsArray:nil Title:nil];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"countrycode"]) {
        NSString *item=[selecteditems firstObject];
        CountryCodeRecord *object=[MyClass returnCountryCodeRecordWithISOCode:item];
        mobileNumber=[NSString stringWithFormat:@"%@%@",object.country_code,[MyClass returnLocalNumberWithContact:mobileNumber ISOCode:isoCode]];
        isoCode=item;
        [registrationTable reloadData];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self highlightRemarksCellWithRow:textView.tag];
}

-(void) highlightRemarksCellWithRow:(NSInteger)row
{
    for (int i=0; i<tableRowDataArray.count; i++) {
        MyTableViewCell *cell=[registrationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i==row) {
            cell.label2.hidden=YES;
        }else{
            if (cell.label2.hidden && ![cell.label2.text isEqualToString:@""] && [cell.textview1.text isEqualToString:@""]) {
                cell.label2.hidden=NO;
            }
        }
    }
}


@end
