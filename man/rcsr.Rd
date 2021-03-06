\name{rcsr}
\alias{rcsr}
\title{
Compute the details of a 3D spline for a hive plot edge
}
\description{
This is a wild bit of trigonometry!  Three points in 3D space, two ends and an control point, are rotated into 2D space.  Then a spline curve is computed.  This is necessary because spline curves are only defined in \code{R} as 2D objects.  The new collection of points, which is the complete spline curve and when drawn will be the edge of a hive plot, is rotated back into the original 3D space. \code{rcsr} stands for rotate, compute spline, rotate back.
}
\usage{
rcsr(p0, cp, p1)
}
\arguments{
  \item{p0}{
A triple representing one end of the final curve (x, y, z).
}
  \item{cp}{
A triple representing the control point used to compute the final curve (x, y, z).
}
  \item{p1}{
A triple representing the other end of the final curve (x, y, z).
}
}
\details{
See the code for exactly how the function works.  Based upon the process described at \url{http://www.fundza.com/mel/axis_to_vector/align_axis_to_vector.html}  Timing tests show this function is fast and scales linearly (i.e. 10x more splines to draw takes 10x more time).  Roughly 3 seconds were required to draw 1,000 spline curves in my testing.
}
\value{
A 3 column matrix with the x, y and z coordinates to be plotted to create a hive plot edge.
}
\references{
\url{http://academic.depauw.edu/~hanson/HiveR/HiveR.html}
}
\author{
Bryan A. Hanson, DePauw University. \email{hanson@depauw.edu}
}

\examples{
# This is a lengthy example to prove it works.
# Read it and then copy the whole thing to a blank script.
# Parts of it require rgl and are interactive.
# So none of the below is run during package build/check.

### First, a helper function
\dontrun{

drawUnitCoord <- function() {
	
	# Simple function to draw a unit 3D coordinate system
	
	# Draw a Coordinate System
	
	r <- c(0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1) # in polar coordinates
	theta <- c(0, 0, 0, 90, 0, 180, 0, 270, 0, 0, 0, 0)  # start, end, start, end
	phi <- c(0, 90, 0, 90, 0, 90, 0, 90, 0, 0, 0, 180)
	cs <- data.frame(radius = r, theta, phi)
	ax.coord <- sph2cart(cs)
	
	segments3d(ax.coord, col = "gray", line_antialias = TRUE)
	points3d(x = 0, y = 0, z = 0, color = "black", size = 4,
		point_antialias = TRUE) # plot origin
	
	# Label the axes

	r <- c(1.1, 1.1, 1.1, 1.1, 1.1, 1.1) # in polar coordinates
	theta <- c(0, 90, 180, 270, 0, 0)
	phi <- c(90, 90, 90, 90, 0, 180)
	l <- data.frame(radius = r, theta, phi)
	lab.coord <- sph2cart(l)
	text3d(lab.coord, texts = c("+x", "+y", "-x", "-y", "+z", "-z"))
	
	}

###  Now, draw a reference coordinate system and demo the function in it.

drawUnitCoord()

### Draw a bounding box

box <- data.frame( 
	x = c(1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 1, -1, -1, -1, -1, -1, -1, -1),
	y = c(1, 1, 1, 1, 1, -1, 1, -1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, -1, 1),
	z = c(1, 1, 1, -1, 1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1))

segments3d(box$x, box$y, box$z, line_antialias = TRUE, col = "red")

### Draw the midlines defining planes

mid <- data.frame( 
	x = c(0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, 1, 1),
	y = c(-1, -1, -1, 1, 1, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, 1, 1, 1, 1, -1),
	z = c(-1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0))

segments3d(mid$x, mid$y, mid$z, line_antialias = TRUE, col = "blue")

### Generate two random points

p <- runif(6, -1, 1)

# Special case where p1 is on z axis
# Uncomment line below to demo
#p[4:5] <- 0

p0 <- c(p[1], p[2], p[3])
p1 <- c(p[4], p[5], p[6])

### Draw the pts, label them, draw vectors to those pts from origin

segments3d(x = c(0, p[1], 0, p[4]),
	y = c(0, p[2], 0, p[5]),
	z = c(0, p[3], 0, p[6]),
	line_antialias = TRUE, col = "black", lwd = 3)

points3d(x = c(p[1], p[4]),
	y = c(p[2], p[5]),
	z = c(p[3], p[6]),
	point_antialias = TRUE, col = "black", size = 8)
	
text3d(x = c(p[1], p[4]),
	y = c(p[2], p[5]),
	z = c(p[3], p[6]),
	col = "black", texts = c("p0", "p1"), adj = c(1,1))

### Locate control point
### Compute and draw net vector from origin thru cp
### Connect p0 and p1

s <- p0 + p1 
segments3d(x = c(0, s[1]), y = c(0, s[2]), z = c(0, s[3]),
	line_antialias = TRUE, col = "grey", lwd = 3)

segments3d(x = c(p[1], p[4]), # connect p0 & p1
	y = c(p[2], p[5]),
	z = c(p[3], p[6]),
	line_antialias = TRUE, col = "grey", lwd = 3)

cp <- 0.6*s # Now for the control point

points3d(x = cp[1], # Plot the control point
	y = cp[2],
	z = cp[3],
	point_antialias = TRUE, col = "black", size = 8)

text3d(x = cp[1], # Label the control point
	y = cp[2],
	z = cp[3],
	texts = c("cp"), col = "black", adj = c(1,1))

### Now ready to work on the spline curve

n2 <- rcsr(p0, cp, p1) # Compute the spline

lines3d(x = n2[,1], y = n2[,2], z = n2[,3],
	line_antialias = TRUE, col = "blue", lwd = 3)

### Ta-Da!!!!!
}
}
\keyword{ utilities }
\keyword{ 3D spline }
