function frm = frame(pose, order)
    %FRAME returns the frame of a given pose
    %   =================================================================== 
    %   FRAME() returns the 4-by-4 unity-matrix 
    %   -------------------------------------------------------------------
    %   FRAME(pose) returns the 4-by-4 matrix whose elements are computated
    %   by the pose values of the 1-by-6 pose vector
    %   -------------------------------------------------------------------
    %   FRAME(pose, order) returns the 4-by-4 matrix whose elements are 
    %   computed with a specific angle convention
    %   ===================================================================        
    %   pose(1:3) = [x, y, z] | coordinates of position in mm
    %   pose(4:6) = [alpha, beta, gamma] | angles of orientation in Radians
    %   -------------------------------------------------------------------
    %   order = 'xyz' | string representing the angle convention
    %   +   Proper Euler angles ('xyz', 'xzy', 'yxz', 'yzx', 'zxy', 'zyx')
    %   +   Tait-Bryan angles   ('xyx', 'xzx', 'yxy', 'yzy', 'zxz', 'zyz')
    %   "Tait-Bryan angles are also called Cardan angles; nautical angles; 
    %   heading, elevation, and bank; or yaw, pitch, and roll. Sometimes, 
    %   both kinds of sequences are called "Euler angles". In that case, 
    %   the sequences of the first group are called proper or classic 
    %   Euler angles." - https://en.wikipedia.org/wiki/Euler_angles
    %   ===================================================================
    
    % Validating input arguments
    if nargin < 1 || isempty(pose); pose = zeros(1,6); end
    if nargin < 2 || isempty(order); order = 'xyz'; end
    validateattributes(pose,{'numeric'},{'size',[1,6]})
    validStrings = {'xyz', 'xzy', 'yxz', 'yzx', 'zxy', 'zyx',...
                    'xyx', 'xzx', 'yxy', 'yzy', 'zxz', 'zyz'};
    validatestring(order,validStrings);
    t = num2cell(pose);
    [x,y,z] = deal(t{1:3});
    [alpha,beta,gamma] = deal(t{4:6});
    
    % Transformation matrix in x, y and z-axes
    T = [ 1 0 0 x; ...
          0 1 0 y ; ...
          0 0 1 z ; ...
          0 0 0 1 ];
    
    % Apply order of angle convention and shaping frame
    switch order
        % Tait-Bryan Angles
        case 'xyz'; frm = T*rotx(alpha)*roty(beta)*rotz(gamma);   %Default
        case 'xzy'; frm = T*rotx(alpha)*rotz(beta)*roty(gamma);
        case 'yxz'; frm = T*roty(alpha)*rotx(beta)*rotz(gamma);
        case 'yzx'; frm = T*roty(alpha)*rotz(beta)*rotx(gamma);
        case 'zxy'; frm = T*rotz(alpha)*rotx(beta)*roty(gamma);
        case 'zyx'; frm = T*rotz(alpha)*roty(beta)*rotx(gamma);
        % Proper Euler Angles
        case 'xyx'; frm = T*rotx(alpha)*roty(beta)*rotx(gamma);
        case 'xzx'; frm = T*rotx(alpha)*rotz(beta)*rotx(gamma);
        case 'yxy'; frm = T*roty(alpha)*rotx(beta)*roty(gamma);
        case 'yzy'; frm = T*roty(alpha)*rotz(beta)*roty(gamma);
        case 'zxz'; frm = T*rotz(alpha)*rotx(beta)*rotz(gamma);
        case 'zyz'; frm = T*rotz(alpha)*roty(beta)*rotz(gamma);
        otherwise
            error('Undefined case ''%s''',order);
    end
    
    function Rx = rotx(angle)
        %ROTX rotate about x-axis in Radians
        % ROTX(ang) returns the 4-by-4rotation matrix about the x-axis
        Rx = [ 1 0 0 0 ; ...
               0 cos(angle) -sin(angle) 0 ; ...
               0 sin(angle)  cos(angle) 0 ; ...
               0 0 0 1 ];
    end
    function Ry = roty(angle)
        %ROTY rotate about x-axis in Radians
        % ROTY(ang) returns the 4-by-4rotation matrix about the x-axis
        Ry = [ cos(angle) 0 sin(angle) 0 ; ...
               0 1 0 0 ; ...
              -sin(angle) 0 cos(angle) 0 ; ...
               0 0 0 1 ];
    end
    function Rz = rotz(angle)
        %ROTZ rotate about x-axis in Radians
        % ROTZ(angle) returns the 4-by-4rotation matrix about the x-axis
        Rz = [ cos(angle) -sin(angle) 0 0 ; ...
               sin(angle)  cos(angle) 0 0 ; ...
               0 0 1 0 ; ...
               0 0 0 1 ];
    end
end