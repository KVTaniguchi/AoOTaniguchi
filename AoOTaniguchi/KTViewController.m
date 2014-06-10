//
//  KTViewController.m
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "Currency.h"
#import "KTCurrencyStore.h"

@interface KTViewController ()
@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_dataLoader setUpDataLoader];
        [_dataLoader grabRateData];
    });
    @weakify(self)
    [[_dollarInputTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 0;
    }]
     subscribeNext:^(id dollarAmount) {
         @strongify(self)
         _dollarInputTextField.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:15.0f/255.0f blue:148.0f/255.0f alpha:1.0];
         [self updateRatesForDollar:dollarAmount];
     }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_dollarInputTextField isFirstResponder]) {
        [_dollarInputTextField resignFirstResponder];
        _dollarInputTextField.backgroundColor = [UIColor whiteColor];
    }
}

-(void)updateRatesForDollar:(NSString*)amount{
    NSArray *denominations = [NSArray arrayWithObjects:@"BRL", @"JPY", @"EUR", @"GBP", nil];
    NSMutableArray *convertedValues = [NSMutableArray new];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    for (NSString *denomination in denominations) {
        [formatter setCurrencyCode:denomination];
        [formatter setInternationalCurrencySymbol:denomination];
        NSString *convertedValue = [formatter stringFromNumber:[[KTCurrencyStore sharedStore]convertDollarAmount:amount ForDenom:denomination]];
        [convertedValues addObject:convertedValue];
        NSLog(@"converted value %@", convertedValue);
    }
    _brlLabel.text = [convertedValues objectAtIndex:0];
    _jpyLabel.text = [convertedValues objectAtIndex:1];;
    _eurLabel.text = [convertedValues objectAtIndex:2];
    _ukLabel.text = [convertedValues objectAtIndex:3];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
