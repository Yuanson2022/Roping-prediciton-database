%
%
% Codes attached to the article:
% An artificial neural network-based model for roping prediction in aluminum alloy sheet
% Developer: Yuanzhe,Hu
% Affiliation: State Key Laboratory of Mechanical Systems and Vibration, Shanghai Jiao Tong University
% Contact Info: zgw99@sjtu.edu.cn
%
%
%%

% Definition of texture components
Copper_ratio = 0.08;
Brass_ratio = 0.08;
S_ratio = 0.16;
Cube_ratio = 0.075;
Goss_ratio = 0.075;

% in-plain dimension
M = 240; N = 120;
%The concentrated portion of characteristic texture components
concen_proportion = 0.25;

% Characteristic grain allocation
% Cube and Goss are taken for example
target = Characteristic_grain_allocation(concen_proportion, Cube_ratio, Goss_ratio, N ,M);
target = target';
imshow(target,[]);colorbar;

% Read the generated orientations for typical texture components 
[alpha1, beta1, gamma1, d] = textread('Goss.txt','%f%f%f%f','headerlines',4);
[alpha2, beta2, gamma2, d] = textread('Cube.txt','%f%f%f%f','headerlines',4);
[alpha3, beta3, gamma3, d] = textread('Brass1.txt','%f%f%f%f','headerlines',4);
[alpha4, beta4, gamma4, d] = textread('Brass2.txt','%f%f%f%f','headerlines',4);
[alpha5, beta5, gamma5, d] = textread('s1.txt','%f%f%f%f','headerlines',4);
[alpha6, beta6, gamma6, d] = textread('s2.txt','%f%f%f%f','headerlines',4);
[alpha7, beta7, gamma7, d] = textread('s3.txt','%f%f%f%f','headerlines',4);
[alpha8, beta8, gamma8, d] = textread('Copper1.txt','%f%f%f%f','headerlines',4);
[alpha9, beta9, gamma9, d] = textread('Copper2.txt','%f%f%f%f','headerlines',4);

% Generation of random orientations
Rand_Number = int16(M*N*(1-Copper_ratio-Brass_ratio-S_ratio));
CS = crystalSymmetry('m-3m', [4 4 4], 'mineral', 'Aluminum');
ori = orientation.rand(Rand_Number,CS);
alpha_random = ori.phi1/pi*180;
beta_random = ori.Phi/pi*180;
gamma_random = ori.phi2/pi*180;

% Stochastically assign non-characteristic orientations
% data sample
alpha_Copper = datasample([alpha8;alpha9], floor(M*N*Copper_ratio));
beta_Copper = datasample([beta8;beta9], floor(M*N*Copper_ratio));
gamma_Copper = datasample([gamma8;gamma9], floor(M*N*Copper_ratio));

alpha_Brass = datasample([alpha3;alpha4], floor(M*N*Brass_ratio));
beta_Brass = datasample([beta3;beta4], floor(M*N*Brass_ratio));
gamma_Brass = datasample([gamma3;gamma4], floor(M*N*Brass_ratio));

alpha_S = datasample([alpha5;alpha6;alpha7], floor(M*N*S_ratio));
beta_S = datasample([beta5;beta6;beta7], floor(M*N*S_ratio));
gamma_S = datasample([gamma5;gamma6;gamma7], floor(M*N*S_ratio));

% Randomly sort
alpha0 = [alpha_random;alpha_Copper;alpha_Brass;alpha_S];
beta0 = [beta_random;beta_Copper;beta_Brass;alpha_S];
gamma0 = [gamma_random;gamma_Copper;gamma_Brass;gamma_S];
rand_index = randperm(size(alpha0,1));
alpha0 = alpha0(rand_index,:);
beta0 = beta0(rand_index,:);
gamma0 = gamma0(rand_index,:);

% Orientation assignment 
map = zeros(M, N, 3);
map(:,:,1) = reshape(alpha0, [M,N]);
map(:,:,2) = reshape(beta0,[M,N]);
map(:,:,3) = reshape(gamma0,[M,N]);

[Goss_x, Goss_y] = find(target == 2);
[Cube_x, Cube_y] = find(target == 1);
rand_index = randperm(size(alpha1,1));
alpha1 = alpha1(rand_index,:);
beta1 = beta1(rand_index,:);
gamma1 = gamma1(rand_index,:);

rand_index = randperm(size(alpha2,1));
alpha2 = alpha2(rand_index,:);
beta2 = beta2(rand_index,:);
gamma2 = gamma2(rand_index,:);

for i = 1:length(Goss_x)
    map(Goss_x(i), Goss_y(i),:) = [alpha1(i),beta1(i),gamma1(i)];
end
for i = 1:length(Cube_x)
    map(Cube_x(i), Cube_y(i),:) = [alpha2(i),beta2(i),gamma2(i)];
end

% Matrix map contains the generated in-plane artificial orientations
