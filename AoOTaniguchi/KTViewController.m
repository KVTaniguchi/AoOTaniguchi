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
#import <GKBarGraph.h>
#import "GraphKit.h"

@interface KTViewController ()
@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    [self makeBarGraph];
    _dollarInputTextField.delegate = self;
    _dataLoader = [KTDataLoader new];
    _convertedValues = [NSMutableArray new];
    _convertedValuesText = [NSMutableArray new];
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

-(void)makeBarGraph{
    _barGraph.dataSource = self;
    _barGraph.barWidth = 30;
    _barGraph.barHeight = 200;
    _barGraph.marginBar = 50;
    _barGraph.animationDuration = .5;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_dollarInputTextField isFirstResponder]) {
        [_dollarInputTextField resignFirstResponder];
        _dollarInputTextField.backgroundColor = [UIColor whiteColor];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _brlLabel.text = @"";
    _jpyLabel.text = @"";
    _eurLabel.text = @"";
    _ukLabel.text = @"";
}

-(void)updateRatesForDollar:(NSString*)amount{
    NSArray *denominations = [NSArray arrayWithObjects:@"BRL", @"JPY", @"EUR", @"GBP", nil];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    for (NSString *denomination in denominations) {
        NSNumber *tempNumber = [[KTCurrencyStore sharedStore]convertDollarAmount:amount ForDenom:denomination];
        NSString *convertedValue = [formatter stringFromNumber:tempNumber];
        [_convertedValuesText addObject:convertedValue];
        [_convertedValues addObject:tempNumber];
    }
    _brlLabel.text = [_convertedValuesText objectAtIndex:0];
    _jpyLabel.text = [_convertedValuesText objectAtIndex:1];;
    _eurLabel.text = [_convertedValuesText objectAtIndex:2];
    _ukLabel.text = [_convertedValuesText objectAtIndex:3];
    [_barGraph draw];
    [_convertedValuesText removeAllObjects];
    [_convertedValues removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GKBarGraphDataSource

-(NSInteger)numberOfBars{
    return _convertedValues.count;
}

-(NSNumber*)valueForBarAtIndex:(NSInteger)index{
    if (index == 1) {
        NSInteger x = [[_convertedValues objectAtIndex:index] integerValue] / 10;
        return [NSNumber numberWithInteger:x];
    }
    return [_convertedValues objectAtIndex:index];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_amethystColor],
                  ];
    return [colors objectAtIndex:index];
}


- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
    return [UIColor whiteColor];
}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (_barGraph.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return @"";
}

@end
