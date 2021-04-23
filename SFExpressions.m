 function [W,dFdWdP,SFPVec2Mat,Mat2SFPVec,StopCrit]=SFExpressions(SFOrder)
	 switch SFOrder
	 case 0 % Zero order SF
		 W=@(dX,dY,P) [P(1)+dX,P(7)+dY]; % Equation (14)
		 dFdWdP=@(dX,dY,dfdx,dfdy) [dfdx,dfdy];
		 SFPVec2Mat=@(P) reshape([1,0,0,0,1,0,P(1),P(7),1],[3,3]); % Equation (22)
		 Mat2SFPVec=@(W) [W(7),0,0,0,0,0,W(8),0,0,0,0,0];
		 StopCrit=@(dP,Zeta) sqrt(sum((dP'.*[1,0,0,0,0,0,1,0,0,0,0,0]).^2)); % Equation (23)
	 case 1 % First order SF
		 W=@(dX,dY,P) [P(1)+P(3).*dY+dX.*(P(2)+1),P(7)+P(8).*dX+dY.*(P(9)+1)]; % Equation (14)
		 dFdWdP=@(dX,dY,dfdx,dfdy) [dfdx,dfdx.*dX,dfdx.*dY, dfdy,dfdy.*dX,dfdy.*dY];
		 SFPVec2Mat=@(P) reshape([P(2)+1,P(8),0,P(3),P(9)+1,0,P(1),P(7),1],[3,3]); % Equation (22)
		 Mat2SFPVec=@(W) [W(7),W(1)-1.0,W(4),0,0,0,W(8),W(2),W(5)-1.0,0,0,0];
		 StopCrit=@(dP,Zeta) sqrt(sum((dP'.*[1,Zeta,Zeta,0,0,0,1,Zeta,Zeta,0,0,0]).^2)); % Equation (23)
	 case 2 % Second order SF
		 W=@(dX,dY,P) [P(1)+P(3).*dY+P(4).*dX.^2.*(1/2)+P(6).*dY.^2.*(1/2)+dX.*(P(2)+1)+P(5).*dX.*dY,P(7)+P(8).*dX+P(10).*dX.^2.*(1/2)+P(12).*dY.^2.*(1/2)+dY.*(P(9)+1)+P(11).*dX.*dY]; % Equation (14)
		 dFdWdP=@(dX,dY,dfdx,dfdy) [dfdx,dfdx.*dX,dfdx.*dY,(dfdx.*dX.^2)/2,dfdx.*dX.*dY,(dfdx.*dY.^2)/2,dfdy,dfdy.*dX,dfdy.*dY,(dfdy.*dX.^2)/2,dfdy.*dX.*dY,(dfdy.*dY.^2)/2];
		 SFPVec2Mat=@(P) reshape([P(2)*2+P(1)*P(4)+P(2)^2+1,P(1)*P(10)*1/2+P(4)*P(7)*(1/2)+P(8)*(P(2)*2+2)*1/2,P(7)*P(10)+P(8)^2,P(4)*1/2,P(10)*1/2,0,P(1)*P(5)*2+P(3)*(P(2)*2+2),P(2)+P(9)+P(2)*P(9)+P(3)*P(8)+P(1)*P(11)+P(5)*P(7)+1,P(7)*P(11)*2.0+P(8)*(P(9)+1)*2,P(5),P(11),0,P(1)*P(6)+P(3)^2,P(1)*P(12)*1/2+P(6)*P(7)*1/2+P(3)*(P(9)+1),P(9)*2+P(7)*P(12)+P(9)^2+1,P(6)*1/2,P(12)*1/2,0,P(1)*(P(2)+1)*2,P(7)+P(1)*P(8)+P(2)*P(7),P(7)*P(8)*2,P(2)+1,P(8),0,P(1)*P(3)*2,P(1)+P(1)*P(9)+P(3)*P(7),P(7)*(P(9)+1)*2,P(3),P(9)+1,0,P(1)^2,P(1)*P(7),P(7)^2,P(1),P(7),1],[6,6]); % Equation (22)
		 Mat2SFPVec=@(W) [W(34),W(22)-1,W(28),W(4).*2,W(10),W(16).*2,W(35),W(23),W(29)-1,W(5).*2,W(11),W(17).*2];
		 StopCrit=@(dP,Zeta) sqrt(sum((dP'.*[1,Zeta,Zeta,0.5*Zeta^2,Zeta^2,0.5*Zeta^2,1,Zeta,Zeta,0.5*Zeta^2,Zeta^2,0.5*Zeta^2]).^2)); % Equation (23)
	 end