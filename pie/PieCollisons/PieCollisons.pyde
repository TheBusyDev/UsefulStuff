WIDTH = 1500
HEIGHT = 800
BG_COLOR = 255 # background color
FG_COLOR = 0 # foreground color
Y_POS = HEIGHT/1.2; # y-component of squares position

class Square:
    def __init__(self, n, l, pos, sp): # set mass, length, initial position and initial speed
        if n == 0:
            self.txt = '1 kg '
        else:
            self.txt = '100^%d kg ' % n
            
        self.n = n
        self.m = float(pow(100, n))
        self.sp = float(sp)
        self.l = float(l)
        self.x_pos = float(pos) - self.l/2 # x-component of initial position
        self.y_pos = float(Y_POS) - self.l # y-component of initial position
        
    def updateSketch(self):
        fill(FG_COLOR)
        square(self.x_pos, self.y_pos, self.l)
        fill(BG_COLOR)
        text(self.txt, self.x_pos + self.l, self.y_pos)

sq1 = Square(0, HEIGHT/9, WIDTH/2, 0) # first square
sq2 = Square(2, HEIGHT/4, WIDTH, -5) # second square (THE BIGGER ONE)

# useful coefficients used to calculate speeds after a collision between the two blocks
a11 = (sq1.m - sq2.m) / (sq1.m + sq2.m)
a12 = 2*sq2.m / (sq1.m + sq2.m)
a21 = 2*sq1.m / (sq1.m + sq2.m)
a22 = (sq2.m - sq1.m) / (sq1.m + sq2.m)

collision = False # True: check for collision between two blocks. False: check for collision between first block and left edge
pie_counter = -1

def setup():
    size(WIDTH, HEIGHT)
    background(BG_COLOR)
    frameRate(30)
    stroke("#939393")
    rectMode(CORNER)
    textAlign(RIGHT, TOP)
    textFont(createFont ('UbuntuMono-Regular.ttf', HEIGHT*0.04))
    
    global time
    time = checkForCollisions() # compute time for a new collision

def draw():
    background(BG_COLOR)
    
    global time
    
    if time > frameCount or (sq1.sp >= 0 and sq2.sp > 0 and sq2.sp > sq1.sp):
        sq1.x_pos += sq1.sp
        sq2.x_pos += sq2.sp 
    else:
        delta_time_1 = time % 1
        sq1.x_pos += sq1.sp * delta_time_1
        sq2.x_pos += sq2.sp * delta_time_1
        
        while time <= frameCount:
            delta_time_2 = checkForCollisions()
            
            if delta_time_2 <= 0: break
            
            delta_time = min(1 - delta_time_1, delta_time_2)
            sq1.x_pos += sq1.sp * delta_time
            sq2.x_pos += sq2.sp * delta_time
            
            delta_time_1 += delta_time_2
            time += delta_time_2
                        
    # draw squares
    sq1.updateSketch()
    sq2.updateSketch()
    
    # draw counter
    fill(FG_COLOR)
    text('Speeds: %+012.6f %+012.6f   Pi: %0*d' % (sq1.sp, sq2.sp, sq2.n+1, pie_counter), WIDTH*0.99, 0)
    
    # save frame to create a video later
    #saveFrame('./frames_%d/frame_%05d.tif' % (sq2.n, frameCount))
        
def checkForCollisions():
    global collision
    global pie_counter
    
    if collision:
        # update speed
        [sq1.sp, sq2.sp] = speed(sq1.sp, sq2.sp)
        # compute time for new collision
        if sq1.sp == 0:
            delta_time = 0
        else:
            delta_time = - sq1.x_pos / sq1.sp
    else:
        # update speed
        sq1.sp *= -1
        # compute time for new collision
        if sq1.sp == sq2.sp:
            delta_time = 0
        else:
            delta_time = (sq2.x_pos - (sq1.x_pos + sq1.l)) / (sq1.sp - sq2.sp)
    
    collision = not collision
    pie_counter += 1
    
    return delta_time
        
def speed(sp1, sp2):
    new_sp1 = a11*sp1 + a12*sp2
    new_sp2 = a21*sp1 + a22*sp2
    
    return [new_sp1, new_sp2]
