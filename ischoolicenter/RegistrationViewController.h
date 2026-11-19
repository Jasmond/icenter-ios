//
//  RegistrationViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 26/11/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"


@protocol myRegistrationViewControllerDelegate <NSObject>

-(void) appliedTrialAccountWithUsername:(NSString *)username statusmessage:(NSString *)statusmessage;

@end

@interface RegistrationViewController : UIViewController
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UITableView *registrationTable;
    
    NSMutableArray *tableRowDataArray;
    
    NSString *companyName;
    NSString *companyAddress;
    NSString *brNumber;
    NSString *contactName;
    NSString *username;
    NSString *countryCode;
    NSString *isoCode;
    NSString *mobileNumber;
    NSString *centerName;
    NSString *centerAddress;
    NSString *centerWebsite;
    BOOL enableSubmitButton;
}

@property (nonatomic,weak) id<myRegistrationViewControllerDelegate>delegate;

@end

