//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initStaticView{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 500)];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    [self.view addSubview:_backgroundImageView];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    self.titleLabel.text = self.titleText;
    [self.view addSubview:_titleLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initStaticView];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
