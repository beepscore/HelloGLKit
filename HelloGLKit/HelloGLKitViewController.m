//
//  HelloGLKitViewController.m
//  HelloGLKit
//
//  Created by Steve Baker on 4/25/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "HelloGLKitViewController.h"

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

// array of per-vertex data
const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

// 3 indices per triangle
const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};


@interface HelloGLKitViewController () {
    float curRed;
    BOOL increasing;
    
    GLuint vertexBuffer;
    GLuint indexBuffer;
    float rotation;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@end


@implementation HelloGLKitViewController

@synthesize context;
@synthesize effect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[GLKBaseEffect alloc] init];
    
    // create new vertex buffer
    glGenBuffers(1, &vertexBuffer);
    // associate GL_ARRAY_BUFFER with vertexBuffer
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}


- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteBuffers(1, &indexBuffer);
    self.effect = nil;
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
    [self setupGL];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self tearDownGL];
    
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
    
    // must call prepareToDraw after changing any GLKBaseEffect property
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);        
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    // send values to shader
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
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
    
    // configure projectionMatrix to project 3D onto 2D
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    float nearPlane = 4.0f;
    float farPlane = 10.0f;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f),
                                                            aspect, nearPlane, farPlane);    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // configure modelViewMatrix with any geometry transformations
    // translate geometry from 0 plane to between near and far plane so that it will be visible
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);   
    rotation += 90 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
    
    // toggle paused. This stops calls to update and draw
    self.paused = !self.paused;
}

@end
