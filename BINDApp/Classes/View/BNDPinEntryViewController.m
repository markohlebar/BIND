//
//  BNDPinEntryViewController.m
//  BIND
//
//  Created by Marko Hlebar on 20/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDPinEntryViewController.h"
#import "BNDPinEntryViewModel.h"

@interface BNDPinEntryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation BNDPinEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewModel = [BNDPinEntryViewModel new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
