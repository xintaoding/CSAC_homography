function h=plotmatches(I1,I2,P1,P2,matches_after_RANSAC,true_matches,intersection,varargin)
% PLOTMATCHES  Plot keypoint matches
%   PLOTMATCHES(I1,I2,P1,P2,MATCHES) plots the two images I1 and I2
%   and lines connecting the frames (keypoints) P1 and P2 as specified
%   by MATCHES.
%
%   P1 and P2 specify two sets of frames, one per column. The first
%   two elements of each column specify the X,Y coordinates of the
%   corresponding frame. Any other element is ignored.
%
%   MATCHES specifies a set of matches, one per column. The two
%   elementes of each column are two indexes in the sets P1 and P2
%   respectively.
%
%   The images I1 and I2 might be either both grayscale or both color
%   and must have DOUBLE storage class. If they are color the range
%   must be normalized in [0,1].
%
%   The function accepts the following option-value pairs:
%
%   'Stacking' ['h']
%      Stacking of images: horizontal [h], vertical [v], diagonal
%      [h], overlap ['o']
%rect_in_im1=[row0;row1;column0;column1];
%----------|------|--------------->
% |      column0  column1 
% |row0    --------
% |        |image |
% |        |      |
% |row1    --------
% |
% V
%gt: 1 plot with red lines; 0: plot with green lines.
%   See also PLOTSIFTDESCRIPTOR(), PLOTSIFTFRAME(), PLOTSS().

% --------------------------------------------------------------------
%                                                  Check the arguments
% --------------------------------------------------------------------

stack='h' ;

for k=1:2:length(varargin)
  switch varargin{k}
    case 'Stacking'
      stack=varargin{k+1} ;
  end
end
 
% --------------------------------------------------------------------
%                                                           Do the job
% --------------------------------------------------------------------

[M1,N1,K1]=size(I1) ;
[M2,N2,K2]=size(I2) ;
%===============
if K1==1
    temp(:,:,1)=I1;
    temp(:,:,2)=I1;
    temp(:,:,3)=I1;
    I1=temp;
    K1=3;
    temp=[];
end
if K2==1
    temp(:,:,1)=I2;
    temp(:,:,2)=I2;
    temp(:,:,3)=I2;
    I2=temp;
    K2=3;
    temp=[];
end

switch stack
  case 'h'
    N3=N1+N2 ;
    M3=max(M1,M2) ;
    oj=N1 ;
    oi=0 ;
  case 'v'
    M3=M1+M2 ;
    N3=max(N1,N2) ;
    oj=0 ;
    oi=M1 ;    
  case 'd'
    M3=M1+M2 ;
    N3=N1+N2 ;
    oj=N1 ;
    oi=M1 ;
  case 'o'
    M3=max(M1,M2) ;
    N3=max(N1,N2) ;
    oj=0;
    oi=0;
end

I=zeros(M3,N3,K1) ;
I(1:M1,1:N1,:) = I1 ;

%rect=rectangle('position',[rect_in_im1(3),rect_in_im1(1),rect_in_im1(4)-rect_in_im1(3),rect_in_im1(2)-rect_in_im1(1)]);
I(oi+(1:M2),oj+(1:N2),:) = I2 ;
set (gcf,'Position',[1,1,N1+N2,max(M1,M2)], 'color','w')
axes('Position', [0 0 1 1]) ;
xlim([1 M1+M2])
ylim([1 N1+N2])
if K1==3
    imshow(uint8(I))
   % image(uint8(I));
   % axis image;
else
    imagesc(I) ; colormap gray ; hold on ; axis image ; axis off ;
end
drawnow ;
%%%%%%%%%%%%%%%%%Added by Xintao Ding. Designed for indication of the right match.
%if nargin==7
%p1=[rect_in_im1(3),rect_in_im1(4),rect_in_im1(4),rect_in_im1(3),rect_in_im1(3)];
%p2=[rect_in_im1(1),rect_in_im1(1),rect_in_im1(2),rect_in_im1(2),rect_in_im1(1)];
%plot(p1,p2,'r');
%end
if nargin==5
K = size(matches_after_RANSAC, 2) ;
nans = NaN * ones(1,K) ;
if isempty(matches_after_RANSAC)%%%%%%%%%%%%%%%%%Added by Xintao Ding. Designed for no matches between the input two images.
    return;
end
x = [ P1(1,matches_after_RANSAC(1,:)) ; P2(1,matches_after_RANSAC(2,:))+oj ; nans ] ;
y = [ P1(2,matches_after_RANSAC(1,:)) ; P2(2,matches_after_RANSAC(2,:))+oi ; nans ] ;
h = line(x(:)', y(:)','Marker','.','Color','g') ;
hold on
plot(x,y,'oy','MarkerFaceColor','yellow','MarkerEdgeColor','y')
set(h,'LineWidth',2,'Color','g') ;
%for i=1:length(matches(1,:))
%x = [ P1(1,matches(1,i)) ; P2(1,matches(2,i))+oj ] ;
%y = [ P1(2,matches(1,i)) ; P2(2,matches(2,i))+oi ] ;
%h = line(x, y) ;
end

if nargin==6
hold on
K = size(matches_after_RANSAC, 2) ;
nans = NaN * ones(1,K) ;
x = [ P1(1,matches_after_RANSAC(1,:)) ; P2(1,matches_after_RANSAC(2,:))+oj ; nans ] ;
y = [ P1(2,matches_after_RANSAC(1,:)) ; P2(2,matches_after_RANSAC(2,:))+oi ; nans ] ;
h = line(x(:)', y(:)','Marker','.','Color','g') ;
plot(x,y,'ob','MarkerFaceColor','blue','MarkerEdgeColor','blue')
set(h,'LineWidth',2,'Color','r') ;
K = size(true_matches, 2) ;
nans = NaN * ones(1,K) ;
if isempty(true_matches)%%%%%%%%%%%%%%%%%Added by Xintao Ding. Designed for no matches between the input two images.
    return;
end
x = [ P1(1,true_matches(1,:)) ; P2(1,true_matches(2,:))+oj ; nans ] ;
y = [ P1(2,true_matches(1,:)) ; P2(2,true_matches(2,:))+oi ; nans ] ;
h = line(x(:)', y(:)','Marker','.','Color','g') ;
hold on
plot(x,y,'oy','MarkerFaceColor','yellow','MarkerEdgeColor','y')
set(h,'LineWidth',2,'Color','g') ;
end
if nargin==7
hold on
%    set(h,'Marker','.','Color','r') ;
K = size(true_matches, 2) ;
nans = NaN * ones(1,K) ;
if isempty(matches_after_RANSAC)%%%%%%%%%%%%%%%%%Added by Xintao Ding. Designed for no matches between the input two images.
    return;
end
x = [ P1(1,true_matches(1,:)) ; P2(1,true_matches(2,:))+oj ; nans ] ;
y = [ P1(2,true_matches(1,:)) ; P2(2,true_matches(2,:))+oi ; nans ] ;
h = line(x(:)', y(:)','Marker','.','Color','r') ;
K = size(intersection, 2) ;
nans = NaN * ones(1,K) ;
if intersection==0%%%%%%%%%%%%%%%%%Added by Xintao Ding. Designed for no matches between the input two images.
    return;
end
x = [ P1(1,intersection(1,:)) ; P2(1,intersection(2,:))+oj ; nans ] ;
y = [ P1(2,intersection(1,:)) ; P2(2,intersection(2,:))+oi ; nans ] ;
h = line(x(:)', y(:)','Marker','.','Color','c') ;
end
%    set(h,'Marker','.','Color','g') ;


%set(h,'LineWidth',2, 'MarkerSize',20,'Marker','.','Color','g') ;
%F=getframe(gcf);
%imwrite(F.cdata,'aa.png')%%%�൱�ڽ���
