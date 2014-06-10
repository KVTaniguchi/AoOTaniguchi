//
//  KTViewController.h
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"

@interface KTViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *eurLabel;
@property (strong, nonatomic) IBOutlet UILabel *brlLabel;
@property (strong, nonatomic) IBOutlet UILabel *jpyLabel;
@property (strong, nonatomic) IBOutlet UILabel *ukLabel;
@property (strong, nonatomic) IBOutlet UITextField *dollarInputTextField;
@property (strong, nonatomic) KTDataLoader *dataLoader;
@end
