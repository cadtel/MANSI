N = 101;
t = 0:N-1;
% %p_sys = [0.0; 0.8];
% %p_sys = [0.3; 0.5];
% %p_sys = [0.3; 0.9];
% p_sys = [0.6];
% %p_sys = [-0.5 + 0.5j, -0.5 - 0.5j, 0.7];
% 
% b = [1];
% %b = [length(p_sys) sum(p_sys)]
% %b = [1 0.5];
% %b = [1 0];
% a = poly(p_sys);
% Fs = 1;
% sysd = tf(b, a, Fs);
% h = impulse(sysd, N-1);

%% pole grid
%radius = 4;
radius = 10;
%radius = 30;
%radius = 40;
%radius = 200;
Npoles = 2*radius + 1;

rho = 1;

%poles on unit circle will ring forever, are excluded.
[poles_xx, poles_yy] = meshgrid(linspace(-rho, rho, Npoles));
poles = poles_xx + 1.0j*poles_yy;
poles_circ = poles(abs(poles) <= 1);
poles_circ = reshape(poles_circ, [1, length(poles_circ)]);
p = poles_circ;

%% arc for testing
%real interval
%p = linspace(-rho, rho, 5*Npoles);

%arc_radius = 1/2;
%arc_radius = 1/sqrt(2);
%arc_radius = 0.99;
%arc_radius = 0.9999;

%%upper arc (cos)
%p = exp(1.0j*linspace(0, pi, 2*radius+1))*arc_radius;
%p = exp(1.0j*linspace(0, pi, radius))*arc_radius;


%%lower arc (sin)
%p = exp(1.0j*linspace(-pi, 0, 2*Npoles+1))/sqrt(2);

%full circle
%p = exp(1.0j*linspace(-pi, pi, 4*Npoles+1))*arc_radius;

%p = [0.7+0.5j, 0.7-0.5j];

%p = [0.995*exp(0.5j), 0.995*exp(-0.5j)];
%p = [arc_radius*exp(0.5j), arc_radius*exp(-0.5j)];
p(abs(imag(p)) < 1e-15) = real(p(abs(imag(p)) < 1e-15));
p(abs(real(p)) < 1e-15) = 1.0j * imag(p(abs(real(p)) < 1e-15));


%% matrix stuff
complex = 0;
A = pole_matrix(p, N, complex);
scale = pole_scales(p, N, complex);
%scale = pole_scales(p, Inf, complex);
A_s = bsxfun(@times, A, scale);

%scale_true = 1./sqrt(sum(A.*conj(A), 1));
%A_s = bsxfun(@times, A, scale_true);

B = A_s;

K = B'*B;
%grad0 = B'*h;

figure
subplot(3, 1, 1)
plot(diag(K))
title('diag(K)')

subplot(3, 1, [2, 3])
if complex
    plot3(0:N-1, real(A_s), imag(A_s));
    xlabel('time')
    ylabel('Re(\rho^n)')
    zlabel('Im(\rho^n)')
    title('A_s entries')
else
    plot(0:N-1, A_s);
    xlabel('time')
    ylabel('r^n cos(n \theta), r^n sin(n \theta)')
    title('A_s entries')
end