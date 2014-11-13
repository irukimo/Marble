//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property(strong,nonatomic) UIImageView *iphoneView;
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
//    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 500)];
//    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
//    [self.view addSubview:_backgroundImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width, 30)];
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:self.titleText attributes:[Utility getWalkThroughFontDictionary]];
    [_titleLabel setAttributedText:titleString];
    [self.view addSubview:_titleLabel];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIImage *iphone = [UIImage imageNamed:@"iphone.png"];
    CGFloat ratio = iphone.size.height/iphone.size.width;
    CGFloat imageWidth = 260.f;
    _iphoneView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, imageWidth, imageWidth*ratio)];
    [_iphoneView setImage:iphone];
    [self.view addSubview:_iphoneView];
    
    UIImage *screen = [UIImage imageNamed:self.imageFile];
    CGFloat screenRatio = screen.size.height/screen.size.width;
    CGFloat screenWidth = 164.f;
    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(_iphoneView.frame.origin.x + 45,  _iphoneView.frame.origin.y + 61, screenWidth, screenWidth*screenRatio)];
    [screenView setImage:screen];
    [self.view addSubview:screenView];
    switch (_pageIndex) {
        case 0:
//            [self addSwipeIcon];
            break;
        case 1:
            [self addTapIcon];
            break;
        case 3:
            [self addLikeTapIcon];
            break;
        default:
            break;
    }
    
}

-(void)addSwipeIcon{
    UIImage *image = [UIImage imageNamed:@"swipe.png"];
    CGFloat ratio = image.size.height/image.size.width;
    CGFloat width = 120.f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_iphoneView.frame.origin.x + 45 + 20,  _iphoneView.frame.origin.y + 180, width, width*ratio)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
}

-(void)addTapIcon{
    UIImage *image = [UIImage imageNamed:@"tap.png"];
    CGFloat ratio = image.size.height/image.size.width;
    CGFloat width = 100.f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_iphoneView.frame.origin.x + 45 + 108,  _iphoneView.frame.origin.y + 150, width, width*ratio)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
}

-(void)addLikeTapIcon{
    UIImage *image = [UIImage imageNamed:@"tap.png"];
    CGFloat ratio = image.size.height/image.size.width;
    CGFloat width = 100.f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_iphoneView.frame.origin.x + 45 + 110,  _iphoneView.frame.origin.y + 100, width, width*ratio)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initStaticView];
//    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
//    self.titleLabel.text = self.titleText;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
