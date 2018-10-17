settings.outformat = "png";
settings.render = 8;
settings.prc = false;
size(10cm);
defaultpen(fontsize(12pt));

import three;
import graph3;
import solids;

triple CAMERA = (1,1,0.25);
currentprojection=orthographic(CAMERA);
/* currentprojection=obliqueZ; */

// Set Direction of a point toward the camera.
triple cameradirection(triple pt, projection P=currentprojection) {
	if (P.infinity) {
		return unit(P.camera);
	} else {
		return unit(P.camera - pt);
	}
}

// Move a point closer to the camera.
triple towardcamera(triple pt, real distance=1, projection P=currentprojection) {
	return pt + distance * cameradirection(pt, P);
}

// draw the primary source center at the origin point
draw(scale3(0.04)*unitsphere, red);

// radius of the secondary sources
real radSec = 1;

// draw the surface where the secondary sources lie in 
surface surfSec = scale3(radSec) * unitsphere;
draw(surfSec, lightgreen+opacity(0.3));
draw(circle(O,radSec,normal=Z), palegray);
/* draw(circle(O,radSec,normal=Z), palegray); */
/* draw(circle(O,radSec,normal=Y), palegray); */
/* draw(circle(O,radSec,normal=X), palegray); */
/* draw(shift(Z/sqrt(2))*circle(O,sqrt(2)/2*radSec,normal=Z),lightgray+ dotted); */
/* draw(shift(-Z/sqrt(2))*circle(O,sqrt(2)/2*radSec,normal=Z), lightgray+dotted); */

// Set the xyz coordinates of the Secondary sources
// Tetrahedron
real PHI = 1.618;
real PHI1 = sqrt(1+PHI^2);
real PHI2 = sqrt(3);
triple[] secLoc1 = {(1,0,0)};
triple[] secLoc2 = {(-1,0,0), (1,0,0)};
triple[] secLoc3 = {(0.5*sqrt(3),-0.5,0), (0,1,0), (-0.5*sqrt(3),-0.5,0)};
triple[] secLoc4 = {(-0.5,-sqrt(3)/6,-0.25*sqrt(2/3))/0.61237, (0.5,-sqrt(3)/6,-0.25*sqrt(2/3))/0.61237, (0,sqrt(3)/3,-0.25*sqrt(2/3))/0.61237, (0,0,0.75*sqrt(2/3))/0.61237};
triple[] secLoc6 = {(-1,0,0), (1,0,0), (0,-1,0), (0,1,0), (0,0,-1), (0,0,1)};
triple[] secLoc8 = {(-1,-1,-1)/sqrt(3), (-1,-1,1)/sqrt(3), (-1,1,-1)/sqrt(3), (-1,1,1)/sqrt(3),(1,-1,-1)/sqrt(3), (1,-1,1)/sqrt(3), (1,1,-1)/sqrt(3), (1,1,1)/sqrt(3)};
triple[] secLoc12 = {(0,-1,-PHI)/PHI1, (0,-1,PHI)/PHI1, (0,1,-PHI)/PHI1, (0,1,PHI)/PHI1, (-1,-PHI,0)/PHI1, (-1,PHI,0)/PHI1, (1,-PHI,0)/PHI1, (1,PHI,0)/PHI1, (-PHI,0,-1)/PHI1, (-PHI,0,1)/PHI1, (PHI,0,-1)/PHI1, (PHI,0,1)/PHI1};
triple[] secLoc20 = {(-1,-1,-1)/sqrt(3), (-1,-1,1)/sqrt(3), (-1,1,-1)/sqrt(3), (-1,1,1)/sqrt(3),(1,-1,-1)/sqrt(3), (1,-1,1)/sqrt(3), (1,1,-1)/sqrt(3), (1,1,1)/sqrt(3), (0,-1/PHI,-PHI)/PHI2, (0,-1/PHI,PHI)/PHI2, (0,1/PHI,-PHI)/PHI2, (0,1/PHI,PHI)/PHI2, (-1/PHI,-PHI,0)/PHI2, (-1/PHI,PHI,0)/PHI2, (1/PHI,-PHI,0)/PHI2, (1/PHI,PHI,0)/PHI2, (-PHI,0,-1/PHI)/PHI2, (-PHI,0,1/PHI)/PHI2, (PHI,0,-1/PHI)/PHI2, (PHI,0,1/PHI)/PHI2};


// Choose the scheme
triple[] secLoc = secLoc6;

// Make the loudspeakers sketch
real heightSpkr = 0.06;
real widthSpkr = 0.1;
real lenSpkr = 0.1;
surface spkr= shift(-lenSpkr/2*X-widthSpkr/2*Y)*zscale3(heightSpkr)*yscale3(widthSpkr)*xscale3(lenSpkr)*unitcube;
surface spkrBottom = shift(heightSpkr*Z)*shift(-lenSpkr/2*X-widthSpkr/2*Y)*yscale3(widthSpkr)*xscale3(lenSpkr)*unitplane;
path3[] spkrFrame = shift(-lenSpkr/2*X-widthSpkr/2*Y)*box(O,lenSpkr*X+widthSpkr*Y+heightSpkr*Z);

// Draw the secondary sources
/* draw(spkr, lightblue+opacity(0.5),nolight); */
/* draw(spkrFrame); */
/* draw(rotate(9,Y)*spkr, lightblue+opacity(0.5),nolight); */
for (int iSec = 0; iSec < secLoc.length; ++iSec)
{
	real theTheta = aCos(secLoc[iSec].z);
	real thePhi = Degrees(atan2(secLoc[iSec].y,secLoc[iSec].x));
	if (isnan(theTheta)){
		theTheta = 0;
	}
	/* write(theTheta); */
	/* write(thePhi); */
	dot(secLoc[iSec]);
	draw(shift(secLoc[iSec])*rotate(thePhi,Z)*rotate(theTheta,Y)*spkr, lightblue+opacity(0.5),nolight);
	draw(shift(secLoc[iSec])*rotate(thePhi,Z)*rotate(theTheta,Y)*spkrBottom, darkolive+opacity(0.5),nolight);
	draw(shift(secLoc[iSec])*rotate(thePhi,Z)*rotate(theTheta,Y)*spkrFrame);
	draw(O--secLoc[iSec], dashed);
	/* label(string(iSec+1), secLoc[iSec], align=unit(Z+Y)); */
}

// The location of error points
real ratioErr = 0.5;
real radErr = ratioErr*radSec;
triple[] errLoc = ratioErr * secLoc;

// draw the surface where the error microphones lie in 
surface surfErr = scale3(ratioErr*radSec) * unitsphere;
draw(surfErr, lightgray+opacity(0.3));
draw(circle(O,radErr,normal=Z), palegray); 
/* draw(circle(O,radErr,normal=Z), palegray); */
/* draw(circle(O,radErr,normal=X), palegray); */
/* draw(circle(O,radErr,normal=Y), palegray); */
/* draw(shift(radErr*Z/sqrt(2))*circle(O,sqrt(2)/2*radErr,normal=Z),palegray+dotted); */
/* draw(shift(-radErr*Z/sqrt(2))*circle(O,sqrt(2)/2*radErr,normal=Z), palegray+dotted); */

// Make the sketch of microphones
real radSph = 0.2;
real radCyl = 0.1;
path micFrame2 = (0,1){right} -- (radCyl,1) -- (radCyl,2*radSph){right} .. (radSph,radSph){down} .. (0,0);
/* path micFrame2 = (0,1){right} .. (radMic,1-radMic){down} .. (radCyl,1-2*radMic){right} -- (radCyl,0); */
path3 theP = path3(micFrame2, YZplane);
revolution theR = revolution(theP);
surface micModel = scale3(0.1)*surface(theR);
/* draw(micModel); */
/* draw(rotate(59.3,Y)*micModel); */
/* draw(rotate(157.5,Z)*rotate(59.3,Y)*micModel); */

// Draw the error microphones 
for (int iErr = 0; iErr < errLoc.length; ++iErr)
{
	real theTheta = aCos(secLoc[iErr].z);
	real thePhi = Degrees(atan2(secLoc[iErr].y,secLoc[iErr].x));
	/* write(theTheta); */
	/* write(thePhi); */
	if (isnan(theTheta)){
		theTheta = 0;
	}
	draw(shift(errLoc[iErr])*rotate(thePhi,Z)*rotate(theTheta,Y)*micModel);
	/* dot(errLoc[iErr]); */
	/* draw(O--errLoc[iSec], dotted); */
	/* label(string(iErr+1), errLoc[iErr], align=unit(Z+Y)); */
}

// Draw the frame of secondary sources and microphones
/* if (secLoc.length == 4){ */
	/* draw(secLoc[0]--secLoc[1], dashed); */
	/* draw(secLoc[0]--secLoc[2], dashed); */
	/* draw(secLoc[0]--secLoc[3], dashed); */
	/* draw(secLoc[1]--secLoc[2], dashed); */
	/* draw(secLoc[1]--secLoc[3], dashed); */
	/* draw(secLoc[2]--secLoc[3], dashed); */
/* } */



// Draw the xy plane
/* draw(scale3(3)*shift(-0.5*X-0.5*Y)*unitplane, mediumgray+opacity(0.2)); */

xaxis3("$x$",0,1.5,linewidth(0.6pt), arrow=Arrow3(DefaultHead2(normal=Y)));
yaxis3("$y$",0,1.5,linewidth(0.6pt), arrow=Arrow3(DefaultHead2(normal=X)));
zaxis3("$z$",0,1.2,linewidth(0.6pt), arrow=Arrow3(DefaultHead2(normal=X+Y)));

// Draw the label for the primary source
triple dirPriLabel = (1.14,-1.14,1);
triple offsetPriLabel = (0.04,-0.04,0.04);
draw(scale3(0.3)*shift(offsetPriLabel)*(O--dirPriLabel), L = Label('primary source',position=EndPoint,p=fontsize(10.5pt)));

// Draw the label for the ith microphone
triple dirIErrLabel = (1.75,-1.75,0.5);
triple offsetIErrLabel = errLoc[5]+0.05Z;
draw(shift(offsetIErrLabel)*scale3(0.1)*(O--dirIErrLabel), L=Label('$i$th error microphone', position=EndPoint,p=fontsize(10.5pt)));

// Draw the label for the ith secondary loudspeaker
triple dirISecLabel = (0.48,-0.48,-1);
triple offsetISecLabel = secLoc[5]+0.05X-0.05Y+0.025Z;
draw(shift(offsetISecLabel)*scale3(0.2)*(O--dirISecLabel), L=Label('$i$th secondary loudspeaker', position=EndPoint,p=fontsize(10.5pt)));

// Draw the label for the jth error microphone
triple dirJErrLabel = (-0.28,0.28,-1.2);
triple offsetJErrLabel = errLoc[3]+0.05Y;
draw(shift(offsetJErrLabel)*scale3(0.4)*(O--dirJErrLabel), L=Label('$j$th error microphone', position=EndPoint,p=fontsize(10.5pt)));

// Draw the label for the jth secondary loudspeaker
/* triple dirJSecLabel = (-0.2,0.25,1.9); */
triple dirJSecLabel = (-0.2,0.25,0.6);
triple offsetJSecLabel = secLoc[3]-0.05X+0.05Y+0.025Z;
draw(shift(offsetJSecLabel)*scale3(0.6)*(O--dirJSecLabel));
/* draw(shift(offsetJSecLabel)*scale3(0.6)*(O--dirJSecLabel), L=Label('$j$th secondary loudspeaker', position=EndPoint,p=fontsize(10.5pt))); */
/* label("$j$th secondary loudspeaker", position=towardcamera(-0.52X+0.32Y+1.05Z), fontsize(10.5pt)); */
label(minipage("$j$th secondary\\ loudspeaker"), position=towardcamera(-0.7X+0.5Y+0.32Z), fontsize(10.5pt));

// Draw the bars of the ith and jth 
/* triple dirBarISec = unit(X-0.2Z); */
/* draw(shift(secLoc[5])*scale3(0.2)*(O--dirBarISec)); */
/* draw(shift(errLoc[3])*scale3(0.2)*(O--dirBarISec)); */


// Connect the ith secondary loudspkear and the jth error microphone
draw(shift(0.05X)*(secLoc[5]-0.02Z--errLoc[3]-0.02Z), linewidth(0.8pt), arrow=Arrows3(TeXHead2(normal=CAMERA)),bar=Bars3(dir=0.5Z+Y));
	  /* L=Label('$d_{\mathrm{se},ij}$', position=Relative(0.7)),align=-X+Y);  */
label('$d_{\mathrm{se},ij}$', position=towardcamera(0.45Y+0.3Z)); 
/* draw(shift(0.05X)*(secLoc[5]-0.02Z--errLoc[3]-0.02Z), linewidth(0.8pt), arrow=Arrows3(TeXHead2(normal=CAMERA)), bar=Bars3(dir=0.5Z+Y), */
	/* L=Label('$d_{\mathrm{se},ij}$', position=Relative(0.4)),align=-X+Y); */
/*draw(secLoc[5]--errLoc[3], linewidth(0.8pt), arrow=Arrows3(TeXHead2(normal=CAMERA)));*/
	/* L=Label('$d_{\mathrm{se},ij}$', position=Relative(0.7)),align=0.9*unit(-X+Y)); */
/*label("$d_{\mathrm{se},ij}$", position=towardcamera(0.53Y+0.25Z));*/

// Connect the ith secondary loudspkear and the jth secondary microphone
draw(shift(-0X+0Y)*(secLoc[5]+0.08Y--secLoc[3]+0.05Z-0.02Y), linewidth(0.8pt), Arrows3(TeXHead2(normal=CAMERA)), 
	   L=Label('$d_{\mathrm{ss},ij}$', position=Relative(0.4)), align=-X+Y, bar=Bars3(dir=0.5Z+Y)); 
/* draw(shift(-0.1X+0.05Y)*(secLoc[5]+0.02Z--secLoc[3]+0.05Z-0.02Y), linewidth(0.8pt), Arrows3(TeXHead2(normal=CAMERA)), */
	/* L=Label('$d_{\mathrm{ss},ij}$', position=Relative(0.4)), align=-X+Y, bar=Bars3(dir=0.5Z+Y)); */
/*draw(secLoc[5]--secLoc[3], linewidth(0.8pt), Arrows3(TeXHead2(normal=CAMERA)),*/
	/*L=Label('$d_{\mathrm{ss},ij}$', position=Relative(0.4)), align=-X+Y);*/

// Draw the label of dpe 
draw(shift(-0.05X+0.05Y)*(O-- -0.5Z), linewidth(0.8pt),arrow=Arrows3(TeXHead2(normal=CAMERA)), bar=Bars3, L=Label('$d_\mathrm{pe}$', position=MidPoint), align=Y);
// Draw the label of dps
draw(shift(+0.05X-0.05Y)*(O-- -Z), linewidth(0.8pt),arrow=Arrows3(TeXHead2(normal=CAMERA)), bar=Bars3, L=Label('$d_\mathrm{ps}$', position=MidPoint), align=-Y);
/* shipout(scale(4.0)*currentpicture.fit()); */
