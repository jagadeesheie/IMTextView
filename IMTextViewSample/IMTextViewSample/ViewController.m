//
//  ViewController.m
//  IMTextViewSample
//
//  Created by Jagadeesh on 8/5/15.
//  Copyright (c) 2015 Jagadeesh. All rights reserved.
//

#import "ViewController.h"
#import "IMTextView.h"
@interface ViewController ()
@property(weak,nonatomic) IBOutlet IMTextView *textView;

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


-(IBAction)setImage:(UIButton*)btn {
    
    [self.textView insertICON:[NSString stringWithFormat:@"icon%ld",(long)[btn tag]]];
    
}


@end
