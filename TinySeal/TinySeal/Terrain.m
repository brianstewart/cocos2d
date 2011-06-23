#import "Terrain.h"
#import "HelloWorldLayer.h"

@implementation Terrain
@synthesize stripes = _stripes;

- (void)generateHills {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float x = 0;
    float y = winSize.width / 2;
    for (int i = 0; i < kMaxHillKeyPoints; ++i) {
        _hillKeyPoints[i] = CGPointMake(x, y);
        x += winSize.width / 2;
        y = random() % (int) winSize.height;
    }
}

- (void)resetHillVertices {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
//    static int prevFromKeyPointI = -1;
//    static int prevToKeyPointI = -1;
    
    // key points interval for drawing
    while (_hillKeyPoints[_fromKeyPointI+1].x < _offsetX-winSize.width/8/self.scale) {
        _fromKeyPointI++;
    }
    while (_hillKeyPoints[_toKeyPointI].x < _offsetX+winSize.width*9/8/self.scale) {
        _toKeyPointI++;
    }
    
}

- (id)init {
    if ((self = [super init])) {
        [self generateHills];
        [self resetHillVertices];
    }
    return self;
}

- (void)draw {
    
    for(int i = MAX(_fromKeyPointI, 1); i <= _toKeyPointI; ++i) {
        glColor4f(1.0, 0, 0, 1.0); 
        ccDrawLine(_hillKeyPoints[i-1], _hillKeyPoints[i]);
        
        glColor4f(1.0, 1.0, 1.0, 1.0);
        
        CGPoint p0 = _hillKeyPoints[i-1];
        CGPoint p1 = _hillKeyPoints[i];
        int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
        float dx = (p1.x - p0.x) / hSegments;
        float da = M_PI / hSegments;
        float ymid = (p0.y + p1.y) / 2;
        float ampl = (p0.y - p1.y) / 2;
        
        CGPoint pt0, pt1;
        pt0 = p0;
        for (int j = 0; j < hSegments+1; ++j) {
            
            pt1.x = p0.x + j*dx;
            pt1.y = ymid + ampl * cosf(da*j);
            
            ccDrawLine(pt0, pt1);
            
            pt0 = pt1;
            
        }
    }
    
}

- (void)setoffsetX:(float)newOffsetX {
    _offsetX = newOffsetX;
    self.position = CGPointMake(-_offsetX * self.scale, 0);
    [self resetHillVertices];
}

- (void)dealloc {
    [_stripes release];
    _stripes = nil;
    [super dealloc];
}

@end
