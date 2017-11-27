//
//  ViewController.m
//  RunloopSource
//
//  Created by 华润策 on 16/6/27.
//  Copyright © 2016年 hrc. All rights reserved.
//

#import "ViewController.h"
#import "HRCRunLoopInputSourceThread.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *sources;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBtnAction:(UIButton *)sender {
    NSLog(@"click");
    AppDelegate *del = [UIApplication  sharedApplication].delegate;
    [del fireInputSource:sender];
}

@end
