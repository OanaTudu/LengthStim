function line_length(varargin)

%%LINE_LENGTH() function to draw horizontal lines of different 
%%              length and random thickness
%%
%%the function may receive up to 6 parameters
%%PATTERNS -> number of randomly positioned lines per given length
%%MSIZE -> size of the image in pixels
%%RAY -> ray of the inner gray background circle
%%MIN_LENGTH -> minimum length of the lines (first length pattern)
%%RATIO -> ratio for increasing length of the lines
%%NO_L -> number of different lengths to be created
%%
%%
%%output -> bmp files with lines of random thickness, well defined lengths, randomly positioned 
%%on the background circle, saved under the name lxxx.bmp in the "c:\monkey\WCortex directory", where
%%xxx is a 3 digit number with the first digit expressing the length number (first length is min_length)
%% and the latter two digits expressing the pattern number.
%%
%%(created May 2004, O.Tudusciuc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%e


if nargin>=1
    patterns = varargin{1};
else
    patterns = 100;
end
if nargin>=2
    msize = varargin{2};
else
    msize = 250;
end
if nargin>=3
    ray = varargin{3};
else
    ray = msize/2-29;
end
if nargin>=4
    min_length = varargin{4};
else
    min_length = 28;
end

if nargin>=5
    ratio = varargin{5};
else
    ratio = 1.00;
end
if nargin>=6
    no_l = varargin{6};
else
    no_l = 7;
end


colordef none;  %set the color defaults to their MATLAB values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number = 1;

r = msize;
rand('state',sum(100*clock));
thick_min = 2;  %3
thick_max = 12;  %4
coef = 3; %for controlled area
br_min = 0.0;
br_max = 0.0;
bcg = 0.5;
fgr = .001;    

while(number < no_l)
    %%Create the image as a square
    %if number < 2 thick_max = 6;
    %end;
    if number > 1 
        length = number*min_length*power(ratio,number);
    else
        length = min_length;
    end

    thick_pos = rand(patterns,3);
    for i=1:patterns
        %for random thickness
        %thick_pos(i,1) = thick_pos(i,1)*(thick_max-thick_min)+thick_min;
        %for controlled area:
        if number <= 4 & i >= 75
            thick_pos(i,1) = 4*coef/number;
        else
            thick_pos(i,1) = thick_pos(i,1)*(thick_max-thick_min)+thick_min;
        end;
        thick_pos(i,2) = thick_pos(i,2)*.4*ray + 1.2*ray;
        thick_pos(i,3) = thick_pos(i,3)*2*ray;
    end
    
    for i=1:patterns
        x=ceil(thick_pos(i,2));
        y=ceil(thick_pos(i,3));
        t=ceil(thick_pos(i,1));
        
        xf = ceil (x+t);
        yf = ceil (y+length);
        d1 = sqrt((r/2-xf)^2+(r/2-yf)^2);
        d2 = sqrt((r/2-x)^2+(r/2-y)^2);
        while d1>=ray-5 | d2>=ray-5 | d1<=3 | d2<=3 
            swap = rand(2,1);
            x = floor(swap(1,1)*.4*ray + 1.2*ray);
            y = floor(swap(2,1)*2*ray);
            xf = floor (x+t);
            yf = floor (y+length);
            d1 = sqrt((r/2-xf)^2+(r/2-yf)^2);
            d2 = sqrt((r/2-x)^2+(r/2-y)^2);
        end
        thick_pos(i,2) = x;
        thick_pos(i,3) = y;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       for i=1:msize
            for j=1:msize
                if (sqrt((msize/2-i)^2+(msize/2-j)^2) > ray)
                    A(i,j) = 0;
                else
                    A(i,j) = 1;
                end;
            end;
        end;

blank = ones(r,r)*bcg.*A;
imwrite(blank,strcat('C:\monkey\WCortex\','lblank.bmp'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat=1:patterns
        %create an array of MSIZE 
        im = ones(r,r)*bcg;
       
        x=ceil(thick_pos(pat,2));
        y=ceil(thick_pos(pat,3));
        t=floor(thick_pos(pat,1));
        
        xf = ceil (x+t);
        yf = ceil (y+length);
        d1 = sqrt((r/2-xf)^2+(r/2-yf)^2);
        d2 = sqrt((r/2-x)^2+(r/2-y)^2);
    
        fgr = rand*(br_max-br_min);
        while (fgr < br_min | fgr > br_max)         
            fgr = rand*(br_max-br_min);
        end;
        fgr
         for j=x:xf
            for k=y:yf
                if(j<r & k<r)
                    im(j,k) = fgr;
                end;
            end;
         end;
      
    size(im)

        %%Apply the black background outside a circle of a given radius -> ray

        

        image = im .* A ;
        %imshow(image);
        %save the image thus created:
        filename=strcat ('l',num2str(100*number+pat-1),'.bmp');
        imwrite(image,strcat('C:\monkey\WCortex\',filename));
    end
    number = number+1;
end