//
//  ViewController.m
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import "SidebarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeftSideBarViewController.h"

@interface SidebarViewController ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    BOOL sideBarShowing;
    CGFloat currentTranslate;
}
@property (strong,nonatomic)LeftSideBarViewController *leftSideBarViewController;
@end

@implementation SidebarViewController
@synthesize leftSideBarViewController,contentView,navBackView;

static SidebarViewController *rootViewCon;
const int ContentOffset = 217;
const int ContentMinOffset = 50;
const float MoveAnimationDuration = 0.35;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+ (id)share
{
    return rootViewCon;
}

- (BOOL) isShowMenu
{
    return sideBarShowing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (rootViewCon) {
        rootViewCon = nil;
    }
	rootViewCon = self;
    
    sideBarShowing = NO;
    currentTranslate = 0;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LeftSideBarViewController *_leftCon = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideBarViewController"];
    _leftCon.delegate = self;
    
    self.leftSideBarViewController = _leftCon;
    
    [self addChildViewController:self.leftSideBarViewController];
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.leftSideBarViewController.view];
    
//    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
//    [self.contentView addGestureRecognizer:_panGestureReconginzer];
}

#pragma mark logout
- (void) logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"email"];
    [defaults setObject:nil forKey:@"password"];
    [defaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark add gesture
- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)hideMenu
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{

	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        if (translation < 0 && sideBarShowing == false) {
            return;
        }
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view ;
        if (translation+currentTranslate>0)
        {
            view = self.leftSideBarViewController.view;
            [self.navBackView bringSubviewToFront:view];
        }
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded) {
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            } else if(currentTranslate>ContentMinOffset)   {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        } else {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            } else if(currentTranslate>ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            } else {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
	}
}

#pragma mark - nav con delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    } else {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }
}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
        }
    }
}

#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{

    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    [leftSideBarViewController updateUserPhoto];
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        if (direction == SideBarShowDirectionLeft)
        {
            view = self.leftSideBarViewController.view;
            [self.navBackView bringSubviewToFront:view];
        }
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}

#pragma animation
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
           
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            
        }else
        {
            [self contentViewAddTapGestures];
             sideBarShowing = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

@end
