//
//  ProfileViewController.m
//  
//
//  Created by Iru on 10/1/14.
//
//

#import "ProfileViewController.h"

#import "KeyChainWrapper.h"

@interface ProfileViewController ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@end

@implementation ProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProfileUI];
    [self initiateCreateQuizViewController];
    [self initiatePostsViewController];
    [self setNavbarTitle];
//    [self setNavigationAttributes];
    // Do any additional setup after loading the view.
    [_statusBtn addTarget:self action:@selector(sendStatusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // test for GET /status
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = nil;
    if (standardUserDefaults){
        name = [standardUserDefaults objectForKey:@"userName"];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"name = %@", name]];
    
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser]]
                                   forKeys:@[@"auth_token"]];

    // Execute the fetch.
    NSError *error;
    NSArray *matches = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    [[RKObjectManager sharedManager]
     getObject:[matches firstObject]
     path:@"status"
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         MBDebug(@"status result: %@", [mappingResult array]);
        
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         MBDebug(@"failed to get status");
    }];

}

//-(void)setNavigationAttributes{
//    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"yes" style:UIBarButtonItemStylePlain target:nil action:nil];
//}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
//    [[myNavBar topItem] setTitle:@"YOUR PROFILE"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleBlue]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleBlue]];
}

-(void) initiatePostsViewController{
    _postsViewController = [[PostsViewController alloc] init];
    [_postsViewController.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, 200)];
    [self.view addSubview:_postsViewController.view];
    _postsViewController.delegate = self;
}


-(void) initiateCreateQuizViewController{
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    [_createQuizViewController.view setFrame:CGRectMake(0, 150, self.view.frame.size.width, 200)];
    [self.view addSubview:_createQuizViewController.view];
    [_createQuizViewController setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addProfileUI{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 30)];
    [_nameLabel setText:@"Hello"];
    if(_name){
        [_nameLabel setText:[Utility getNameToDisplay:_name]];
    }
    [self.view addSubview:_nameLabel];
}

-(void) setName:(NSString *)name{
    _name = [name copy];
    [_nameLabel setText:[Utility getNameToDisplay:name]];
}

-(void) postSelected:(NSString *)name{
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:name];
}

-(void) sendStatusBtnClicked
{
    NSString *status = _statusTextField.text;
    MBDebug(@"To send status: %@", status);
    [Utility sendThroughRKRoute:@"send_status" withParams:@{@"status": status}];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in self.view.subviews){
        if([view tag] == 100){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 150,
                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}


#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
//- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
//    [self prepareSelectPeopleViewController];
//    [_selectPeopleViewController setPeopleArray:people];
//    [self.view addSubview:_selectPeopleViewController.view];
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
//                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
//    
//}
//
//- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
//                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *viewController =[segue destinationViewController];
        [viewController setName:(NSString *)sender];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
