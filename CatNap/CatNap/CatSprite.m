#import "CatSprite.h"

@implementation CatSprite

- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location {
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"cat_sleepy.png"])) {
        canBeDestroyed = NO;        
    }
    return self;
}

- (void)createBodyAtLocation:(CGPoint)location {
    
    // Add your vertices from Vertex Helper here
    int num = 4;
    CGPoint verts[] = {
        cpv(-31.5f/2, 69.5f/2),
        cpv(41.5f/2, 66.5f/2),
        cpv(40.5f/2, -69.5f/2),
        cpv(-55.5f/2, -70.5f/2)
    };
    
    float mass = 1.0;
    float moment = cpMomentForPoly(mass, num, verts, CGPointZero);
    body = cpBodyNew(mass, moment);
    body->p = location;
    cpSpaceAddBody(space, body);
    
    shape = cpPolyShapeNew(body, num, verts, CGPointZero);
    shape->e = 0.3; 
    shape->u = 0.5;
    cpSpaceAddShape(space, shape);
    
}

@end