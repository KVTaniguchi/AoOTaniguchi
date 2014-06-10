//
//  KTViewController.h
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"
#import <GKBarGraph.h>
@interface KTViewController : UIViewController <UITextFieldDelegate, GKBarGraphDataSource>
@property (strong, nonatomic) IBOutlet UILabel *eurLabel;
@property (strong, nonatomic) IBOutlet UILabel *brlLabel;
@property (strong, nonatomic) IBOutlet UILabel *jpyLabel;
@property (strong, nonatomic) IBOutlet UILabel *ukLabel;
@property (strong, nonatomic) IBOutlet UITextField *dollarInputTextField;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraph;
@property (strong, nonatomic) KTDataLoader *dataLoader;
@property (strong, nonatomic) NSMutableArray *convertedValues;
@property (strong, nonatomic) NSMutableArray *convertedValuesText;
@end
