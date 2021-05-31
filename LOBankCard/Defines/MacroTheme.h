//
//  Macro_Theme.h
//  Demo
//
//  Created by Lion on 2021/5/27.
//

#ifndef Macro_Theme_h
#define Macro_Theme_h

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define CGRGB(r,g,b) [RGBA(r,g,b,1.0f) CGColor]

#endif /* Macro_Theme_h */
