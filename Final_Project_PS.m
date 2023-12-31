clc
clear 
disp(' ---------------------" T.L inputs "- --------------------- ');
f = input('Enter the system frequency: ');
Length = input ('Enter the length of transmition line in Km: ');
Row = input ('Enter the Resistivity of transmition line material: ');
r1 = input('Enter the radius of conductor in cm: ');
Spiraling_factor = input('Enter Spiralling Factor: ');
Skin_factor = input('Enter Skin Factor: ');
Area = pi*r1^2*1e-04;
R_cond = Row * 1e3/ Area*(1+Spiraling_factor)*(1+Skin_factor);    % Ohm per Km.
T1 = input('Enter the temperature at the giving Resistivity: ');
T2 = input('Enter new temperature: ');
Rnew = R_cond * (228 + T2)/(228 + T1);
r = r1 * 0.01;
r_dash = r1 * 0.01 * exp(-0.25);
I = input('Enter 1 in case of single phase two wires and 3 for three phase: ');
K = 1;

while ~(I == 1 || I == 3)
           I = input('Enter 1 in case of single phase two wires and 3 for three phase: ');
end

if(I == 1)
    D = input ('Enter the distance between phases in meter: ');
    K = input('Enter number of bundles: ');
     while (K > 4 || K <= 0)
        K = input('Enter A valid number of bundles -> 1, 2, 3, or 4: ');   
    end
    if K == 1
        GMD = D;
        GMR_L = r_dash;
        GMR_C =r ;
        
    elseif K == 2
        d = input('Enter the distance between two bundles in meter: ');
        x = input('if Phases and Bundles have the same direction both horizontal or vertical type 1 else type 2: ');
        while ~(x == 1 || x == 2)
           x = input('Enter 1 for same position or 2 for opposite position: ');
        end   
        if(x == 1)
            GMD = (D^2*(D-d)*(D+d))^0.25;
            GMR_L = sqrt(r_dash*d);
            GMR_C = sqrt(r*d);
        elseif(x == 2)
            GMD = (D^2*(D^2+d^2))^0.25;
            GMR_L = sqrt(r_dash*d);
            GMR_C = sqrt(r*d);
        end
        
    elseif K == 3  
        x = input('Choose 1 in case of horizontal phases and 2 for Vertical phases: ');
        while ~(x == 1 || x == 2)
           x = input('Enter 1 in case of horizontal phases and 2 for Vertical phases: ');
        end        
        if x == 1
            d = input('Enter the Distance between any two bundles in meter: ');
            GMD = (D^3*(D-d)*(D+d)*((D-d/2)^2+3/4*d^2)*((D+d/2)^2+3/4*d^2))^(1/9);
            GMR_L = (r_dash^3*d^6)^(1/9);
            GMR_C = (r^3*d^6)^(1/9);
        else
            d = input('Enter the Distance between any two bundles in meter: ');
            GMD = (D^3*(D^2+d^2)*(0.25*d^2+(D-sqrt(3)*0.5*d^2))*(0.25*d^2+(D+sqrt(3)*0.5*d)^2))^(1/9);
            GMR_L = (r_dash^3*d^6)^(1/9);
            GMR_C = (r^3*d^6)^(1/9);
        end
        
    else
        d = input('Enter the Distance between any two bundles in meter: ');
        GMD = (D^4*(D-d)^2*(D+d)^2*(D^2+d^2)^2*((D-d)^2+d^2)*((D+d)^2+d^2))^(1/16);
        GMR_L = 1.09*(r_dash * d^3 )^0.25;
        GMR_C = 1.09*(r*d^3)^0.25;
        
    end
    
elseif I == 3
    D1 = input('Enter Distance between first and second phase: ');
    D2 = input('Enter Distance between second and Third phase: ');
    D3 = input('Enter Distance between Third and First  phase: ');
while ~(D1+D2-D3 == 0 || isequal(D1, D2, D3))
    disp('Enter a valid numbers!');
    D1 = input('Enter Distance between first and second phase: ');
    D2 = input('Enter Distance between second and Third phase: ');
    D3 = input('Enter Distance between Third and First  phase: ');
end
    K = input('Enter number of bundles: ');
    while (K > 4 || K <= 0)
        K = input('Enter A valid number of bundles -> 1, 2, 3, or 4: ');   
    end
    GMD = (D1*D2*D3)^(1/3);
    
    if K == 1
        GMR_L = r_dash;
        GMR_C = r;
        
    elseif K == 2
        d = input('Enter the Distance between any two bundles in m: ');
        GMR_L = (r_dash*d)^0.5;
        GMR_C = (r*d)^0.5;
        
    elseif K == 3
        d = input('Enter the Distance between any two bundles in m: ');
        GMR_L = (r_dash*d^2)^(1/3);
        GMR_C = (r*d^2)^(1/3);
        
    else
        d = input('Enter the Distance between any two bundles in m: ');
        GMR_L = 1.091*(r_dash*d^3)^(1/4);
        GMR_C = 1.091*(r*d^3)^(1/4);
        
    end
end

L = 2*(10)^-7 * log(GMD / GMR_L)*1e6;     
C = 2*pi*8.8542*(10^-12)/log(GMD/GMR_C)*1e6;    
R_ph = Rnew / K;

Z = (R_ph + 2 * pi * f * L * 1e-3 * 1i) * Length;
Y = (2 * pi * f * C * 1e-3 * 1i) * Length;
        % Get A B C D %
A = 1 + Z * Y / 2;
B = Z;
c = Y * (1 + Z * Y / 4);
D = A;
As = abs(A);
fprintf('\n')
disp('------------------------------------------------------------');
disp(['The Inductance of cable = ' num2str(L)  ' mH/km per phase.']);
disp(['The Capacitance of cable = ' num2str(C) ' mF/km per phase.']);
disp(['The Resistance of cable = ' num2str(R_ph) ' ohm/km per phase.']);
disp('------------------------------------------------------------');
fprintf('\n')
disp(' --------------------" Load inputs "----------------------- ');
Vr = input('Enter the receiving-end line voltage in KV: ') * 1000;
Pr = input('Enter the receiving-end power in MW: ') * 1e6;
PF = input('Enter the power factor: ');
m = input('Enter 1 for -> lag --- 2 for -> lead: ');
QL = 0;Qc = 0;
if(m == 1)
    QL = Pr * tan(acos(PF));
else
    Qc = 1 * Pr * tan(acos(PF));
end

Vr_ph = Vr / sqrt(3);
Sr_ph = (Pr + QL * 1i + Qc * 1i) / 3;
Ir = conj(Sr_ph / Vr_ph);
Vs = abs((A * Vr_ph + B * Ir) * sqrt(3));
Is = c * Vr + D * Ir;
