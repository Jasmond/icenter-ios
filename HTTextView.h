//
//  GCPlaceholderTextView.h
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SOTextViewDelegate;

@interface SOTextView : UITextView

@property (nonatomic, weak) id<SOTextViewDelegate> soDelegate;

@end

@protocol SOTextViewDelegate <NSObject>
@optional
- (void)soTextViewWasTapped:(SOTextView *)soTextview;

@end