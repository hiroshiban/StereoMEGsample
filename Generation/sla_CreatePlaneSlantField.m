function field=sla_CreatePlaneSlantField(fieldSize,theta_deg,orient_deg,pix_per_deg,fine_coefficient)

% function field=sla_CreatePlaneSlantField(fieldSize,theta_deg,orient_deg,pix_per_deg,fine_coefficient)
%
% Creates oriented slant with ciruclar aperture
% This function is different from CreateApartureSlantField in that
% the shape of the generated slant is adjusted as to look a perfect circle.
%
% [input]
% fieldSize   : the size of the field in degrees, [row,col]
% theta_deg   : an angle measured fromh the vertical, [deg]
% orient_deg  : an angle (orientation) of slant,
%               from horizontal meridian, clockwise [deg]
% pix_per_deg : pixels per degree, [pixels]
% fine_coefficient : (optional) if larger, the generated oval become finer,
%                    but comsumes much CPU power. [val]
%                    (default=1, as is, no tuning)
%
%
% [output]
% field       : grating image, double format, [row,col]
%
% !!! NOTICE !!!
% for speeding up image generation process,
% I will not put codes for nargin checks.
% Please be careful.
%
% Created    : "2011-06-13 10:29:05 ban"
% Last Update: "2018-09-27 17:05:35 ban"

% convert to pixels and radians
fieldSize=round(fieldSize.*pix_per_deg);
theta_deg=theta_deg*pi/180;
orient_deg=orient_deg*pi/180;

% create base image
step=1/fine_coefficient;
[x,y]=meshgrid(0:step:fieldSize(2),0:1:fieldSize(1)); % oversampling along x-axis
x=x-fieldSize(2)/2; y=y-fieldSize(1)/2;
if mod(size(x,1),2), x=x(1:end-1,:); y=y(1:end-1,:); end
if mod(size(x,2),2), x=x(:,1:end-1); y=y(:,1:end-1); end
z=x*cos(orient_deg)-y*sin(orient_deg);

% slant field
field=z*tan(theta_deg);

return
