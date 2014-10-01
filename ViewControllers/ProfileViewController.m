//
//  ProfileViewController.m
//  
//
//  Created by Iru on 10/1/14.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) CreateQuizViewController *CreateQuizViewController;

@end

@implementation ProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProfileUI];
    _CreateQuizViewController = [[CreateQuizViewController alloc] init];
    [_CreateQuizViewController.view setFrame:CGRectMake(0, 150, self.view.frame.size.width, 100)];
    [self.view addSubview:_CreateQuizViewController.view];
    [_CreateQuizViewController setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addProfileUI{
    _name = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
    [self.view addSubview:_name];
}

-(void) setPerson:(NSString *)person{
    [_name setText:person];
    _person = person;
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
