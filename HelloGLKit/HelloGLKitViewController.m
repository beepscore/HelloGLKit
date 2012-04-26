//
//  HelloGLKitViewController.m
//  HelloGLKit
//
//  Created by Steve Baker on 4/25/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "HelloGLKitViewController.h"

@interface HelloGLKitViewController () {
    float curRed;
    BOOL increasing;
}
@property (strong, nonatomic) EAGLContext *context;

@end


@implementation HelloGLKitViewController

@synthesize context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}


#pragma mark - GLKViewControllerDelegate

- (void)update {
    if (increasing) {
        curRed += 1.0 * self.timeSinceLastUpdate;
    } else {
        curRed -= 1.0 * self.timeSinceLastUpdate;
    }
    if (curRed >= 1.0) {
        curRed = 1.0;
        increasing = NO;
    }
    if (curRed <= 0.0) {
        curRed = 0.0;
        increasing = YES;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // toggle paused. This stops calls to update and draw
    self.paused = !self.paused;
}

@end
