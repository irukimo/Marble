//
//  HomeViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "QuizViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *quizView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QuizViewController *quizViewController = [self.childViewControllers firstObject];
    [quizViewController setDelegate:self];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:quizViewController.view action:@selector(endEditing:)]];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
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
#pragma mark -
#pragma mark QuizViewController Delegate Methods
- (void)shouldDisplayPeople:(QuizViewController *)viewController withPeople:(NSArray *)people{
    _quizView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
               self.view.bounds.size.width, _quizView.frame.size.height);
}

- (void)shouldDisplayKeywords:(QuizViewController *)viewController withKeywords:(NSArray *)keywords{
    _quizView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                 self.view.bounds.size.width, _quizView.frame.size.height);
}

- (void)backToNormal:(QuizViewController *)viewController{
    _quizView.frame = CGRectMake(self.view.frame.origin.x, 150,
                                 self.view.bounds.size.width, _quizView.frame.size.height);
}



@end
