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
#import <FBGlowLabel/FBGlowLabel.h>

@interface KTViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *brasilFlagImgView;
@property (strong, nonatomic) IBOutlet UIImageView *jpnFlagImgView;
@property (strong, nonatomic) IBOutlet UIImageView *euroFlagImgView;
@property (strong, nonatomic) IBOutlet UIImageView *britImgView;
@property (strong, nonatomic) IBOutlet UILabel *realLabelView;
@property (strong, nonatomic) IBOutlet UIImageView *yenSymbolImgView;
@property (strong, nonatomic) IBOutlet UIImageView *euroSymbolImgView;
@property (strong, nonatomic) IBOutlet UIImageView *poundSymbolImgView;
@property (strong, nonatomic) IBOutlet UILabel *hugeLabel;

@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    [self makeBarGraph];
    [self setupLabel];
    _dollarInputTextField.delegate = self;
    _hugeLabel.alpha = 0.0f;
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
         NSString *hugeString = dollarAmount;
         if (hugeString.length > 3) {
             [self flashy];
         }
         [self updateRatesForDollar:dollarAmount];
     }];
}

-(void)flashy{
    _brlLabel.alpha = 0.0f;
    _jpyLabel.alpha = 0.0f;
    _eurLabel.alpha = 0.0f;
    _ukLabel.alpha = 0.0f;
    _britImgView.alpha = 0.0f;
    _jpnFlagImgView.alpha = 0.0f;
    _euroFlagImgView.alpha = 0.0f;
    _brasilFlagImgView.alpha = 0.0f;
    self.barGraph.alpha = 0.0f;
    _realLabelView.alpha = 0.0f;
    _yenSymbolImgView.alpha = 0.0f;
    _euroSymbolImgView.alpha = 0.0f;
    _poundSymbolImgView.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
      //  self.view.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        self.view.backgroundColor = [UIColor blackColor];
        _hugeLabel.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0f animations:^{
            _hugeLabel.alpha = 0.0f;
            self.view.backgroundColor = [UIColor whiteColor];
            _brlLabel.alpha = 1.0f;
            _jpyLabel.alpha = 1.0f;
            _eurLabel.alpha = 1.0f;
            _ukLabel.alpha = 1.0f;
            _britImgView.alpha = 1.0f;
            _jpnFlagImgView.alpha = 1.0f;
            _euroFlagImgView.alpha = 1.0f;
            _brasilFlagImgView.alpha = 1.0f;
            _realLabelView.alpha = 1.0f;
            _yenSymbolImgView.alpha = 1.0f;
            _euroSymbolImgView.alpha = 1.0f;
            _poundSymbolImgView.alpha = 1.0f;
            self.barGraph.alpha = 1.0f;
        }];
        self.view.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)setupLabel
{
    CGRect hugeFrame = _hugeLabel.frame;
    FBGlowLabel *v = [[FBGlowLabel alloc] initWithFrame:hugeFrame];
    v.text = @"HUGE";
    v.textAlignment = NSTextAlignmentCenter;
    v.clipsToBounds = YES;
    v.backgroundColor = [UIColor clearColor];
    v.font = [UIFont fontWithName:@"Helvetica-Bold" size:66];
    v.alpha = 1.0;
    v.textColor = [UIColor colorWithRed:235.0f/255.0f green:39.0f/255.0f blue:220.0f/255.0f alpha:1.0];
    v.glowSize = 9;
    v.glowColor = [UIColor colorWithRed:245.0f/255.0f green:168.0f/255.0f blue:239.0f/255.0f alpha:1.0];
    v.innerGlowSize = 4;
    v.innerGlowColor = [UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.hugeLabel = v;
    [self.view addSubview:v];
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
