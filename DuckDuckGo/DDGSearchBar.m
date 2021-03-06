//
//  DDGSearchBar.m
//  DuckDuckGo
//
//  Created by Johnnie Walker on 04/04/2013.
//
//

#import "DDGSearchBar.h"

@interface DDGSearchBar ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonXConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftButtonXConstraint;

@end

@implementation DDGSearchBar

- (void)commonInit {
    self.buttonSpacing = 5.0;
    
    [self setNeedsLayout];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)setShowsCancelButton:(BOOL)show {
    [self setShowsCancelButton:show animated:TRUE];
}

- (void)setShowsLeftButton:(BOOL)show {
    [self setShowsLeftButton:show animated:TRUE];
}

- (void)setShowsBangButton:(BOOL)show {
    [self setShowsBangButton:show animated:FALSE];
}

- (void)setShowsBangButton:(BOOL)show animated:(BOOL)animated {
    self.searchField.additionalLeftSideInset = show ? 39 : 0;
    [self layoutIfNeeded];
    _showsBangButton = show;
    [self setNeedsLayout];
    [self layoutIfNeeded:(animated ? 0.2 : 0)];
}

- (void)layoutIfNeeded:(NSTimeInterval)animationDuration {
    if(animationDuration<=0) {
        [self layoutIfNeeded];
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)setShowsCancelButton:(BOOL)show animated:(BOOL)animated {
    _showsCancelButton = show;
    
    void(^makeChanges)() = ^() {
        if(show) {
            self.cancelButtonXConstraint.constant = - (self.cancelButton.frame.size.width + 12);
            self.cancelButton.alpha = 1;
        } else {
            self.cancelButtonXConstraint.constant = 4;
            self.cancelButton.alpha = 0;
        }
        if(animated) {
            [self layoutIfNeeded];
        } else {
            [self setNeedsLayout];
        }
    };
    if(animated) {
        [UIView animateWithDuration:0.2f animations:makeChanges];
    } else {
        makeChanges();
    }

}

- (void)setShowsLeftButton:(BOOL)show animated:(BOOL)animated {
    _showsLeftButton = show;
    if(show) {
        self.leftButtonXConstraint.constant = self.leftButton.frame.size.width + 10;
        self.leftButton.alpha = 1;
    } else {
        self.leftButtonXConstraint.constant = 0;
        self.leftButton.alpha = 0;
    }
    [self layoutIfNeeded:((animated) ? 0.2 : 0.0)];
}

- (void)layoutSubviews {
    self.leftButton.hidden = !self.showsLeftButton;
    //self.bangButton.hidden = !self.showsBangButton;
    self.bangButton.alpha = self.showsBangButton ? 1 : 0;
    self.cancelButton.hidden = !self.showsCancelButton;

    [self setNeedsDisplay];
    [self setNeedsUpdateConstraints];
    [super layoutSubviews];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.searchField updateConstraints];
}


#pragma mark - Showing and hiding progress

-(void)cancel {
    self.progressView.percentCompleted = 100;
}

-(void)finish {
    self.progressView.percentCompleted = 100;
}

#pragma mark - Progress bar

-(void)setProgress:(CGFloat)newProgress {
    self.progressView.percentCompleted = ceill(newProgress*100);
    
}

-(void)setProgress:(CGFloat)newProgress animationDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self setProgress:newProgress];
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                             [self setProgress:newProgress+0.1
                             animationDuration:duration*4];
                     }];
}


@end
