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
    %   pose(1:3) = [cx, cy, cz] | coordinates of position in mm
    %   pose(4:6) = [ax, ay, az] | angles of orientation in Radians
    %   -------------------------------------------------------------------
    %   order = 'xyz' | string representing the angle convention
    %   +   Proper Euler angles ('xyz', 'xzy', 'yxz', 'yzx', 'zxy', 'zyx')
    %   +   Tait�Bryan angles   ('xyx', 'xzx', 'yxy', 'yzy', 'zxz', 'zyz')
    %   "Tait�Bryan angles are also called Cardan angles; nautical angles; 
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
    
    % Transformation matrix in x, y and z-axes
    T = [ 1 0 0 pose(1); ...
          0 1 0 pose(2) ; ...
          0 0 1 pose(3) ; ...
          0 0 0 1 ];
    
    % Transformation matrix about x-axis
    Rx = [ 1 0 0 0 ; ...
           0 cos(pose(4)) -sin(pose(4)) 0 ; ...
           0 sin(pose(4))  cos(pose(4)) 0 ; ...
           0 0 0 1 ];
      
    % Transformation matrix about y-axis  
    Ry = [ cos(pose(5)) 0 sin(pose(5)) 0 ; ...
           0 1 0 0 ; ...
          -sin(pose(5)) 0 cos(pose(5)) 0 ; ...
           0 0 0 1 ];
    
    % Transformation matrix about z-axis  
    Rz = [ cos(pose(6)) -sin(pose(6)) 0 0 ; ...
           sin(pose(6))  cos(pose(6)) 0 0 ; ...
           0 0 1 0 ; ...
           0 0 0 1 ];
    
    % Apply order of angle convention and shaping frame
    switch order
        % Tait-Bryan Angles
        case 'xyz'; frm = T*Rx*Ry*Rz;   %Default
        case 'xzy'; frm = T*Rx*Rz*Ry;
        case 'yxz'; frm = T*Ry*Rx*Rz;
        case 'yzx'; frm = T*Ry*Rz*Rx;
        case 'zxy'; frm = T*Rz*Rx*Ry;
        case 'zyx'; frm = T*Rz*Ry*Rx;
        % Proper Euler Angles
        case 'xyx'; frm = T*Rx*Ry*Rx;
        case 'xzx'; frm = T*Rx*Rz*Rx;
        case 'yxy'; frm = T*Ry*Rx*Ry;
        case 'yzy'; frm = T*Ry*Rz*Ry;
        case 'zxz'; frm = T*Rz*Rx*Rz;
        case 'zyz'; frm = T*Rz*Ry*Rz;
        otherwise
            error('Undefined case ''%s''',order);
    end
end