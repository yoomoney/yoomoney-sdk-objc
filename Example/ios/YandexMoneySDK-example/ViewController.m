//
//  ViewController.m
//  ios-example
//
//  Created by mertvetcov on 07.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "ViewController.h"
#import <ymcpssdk.h>

@interface ViewController ()

@property(nonatomic, strong) UIButton *doPaymentButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.doPaymentButton setTitle: @"test payment" forState:UIControlStateNormal];
    [self.doPaymentButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.doPaymentButton];
    
    [self.doPaymentButton addTarget:self action:@selector(doTestPayment) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doTestPayment {
    
}

- (UIButton *)doPaymentButton {
    if (!_doPaymentButton) {
        CGRect buttonRect = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 44);
        
        _doPaymentButton = [[UIButton alloc] initWithFrame:buttonRect];
        _doPaymentButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _doPaymentButton;
}

- (void)dealloc {
    [_doPaymentButton release];

    [super dealloc];
}

@end
