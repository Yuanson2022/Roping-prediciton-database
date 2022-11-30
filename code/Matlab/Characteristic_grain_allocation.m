%
%
% Codes attached to the article:
% An artificial neural network-based model for roping prediction in aluminum alloy sheet
% Developer: Yuanzhe,Hu
% Affiliation: State Key Laboratory of Mechanical Systems and Vibration, Shanghai Jiao Tong University
% Contact Info: zgw99@sjtu.edu.cn
%
%

function target = Characteristic_grain_allocation(ratio_fixed, Cube_ratio, Goss_ratio, M, N)
    target = zeros(M, N);
    % number of region n_r
    n_r = floor(1 * rand) + 15;
    Total_ratio = Cube_ratio + Goss_ratio;
    Goss_number = M*N*Total_ratio;
    fixed_point = floor(Goss_number*ratio_fixed);
    flex_point = Goss_number - fixed_point;
    flex_rand = rand(1,n_r)+ 2.25;
    flex_rand = floor(flex_rand/sum(flex_rand)*flex_point);
    
    
    for i = 1: n_r
        % number of bands for each region n_b
        n_b = floor(rand*3)+1;
        sigmay_c = randi(80,[1,n_b])+ 100;
        sigmax_c = randi(2000,[1,n_b])+2000;
        sigmay_f = randi(20,[1,n_b])+ 20;
        sigmax_f = randi(200,[1,n_b])+200;
        dimention2 = floor(N/n_r*i) - floor(N/n_r*(i-1));
        tmp = zeros(M,dimention2);
        
        % Randomly generate the texture band centers for each region
        % set a distance threshold for each center 
        dist_thresh = 0;
        while(dist_thresh == 0)
            center_x = randi(round(M/9*7),[n_b,1]) + round(M/9);
            for k = 1:length(n_b)
               dist = abs(center_x-center_x(k));
               sq = dist>0;
               dist = dist(sq);
               if ~isempty(dist) 
                   if min(dist)>(M/15) && k == length(n_b)
                        dist_thresh = 1;
                        break;
                   end
               else
                   dist_thresh = 1;
                   break;
               end
            end
        end  
        center_y = randi(round(dimention2/3),[n_b,1])+ round(dimention2/3);

        
        center_class = rand([n_b,1]);
        classify = (center_class > (Cube_ratio/(Total_ratio)));
        center_class(classify) = 2; % Goss
        center_class(~classify) = 1; % Cube

        % The number of characteristic grains allocated to each band
        center_ratio = rand([n_b,1]) + 0.2;
        center_ratio = center_ratio/sum(center_ratio);       
        rand_p = rand(M,dimention2);
        % allocate concentrated grains for each center
        for j = 1:n_b
            possi_y = exp(-abs(ones(M,1)*(1:dimention2)-center_y(j))/sigmay_c(j));
            possi_x = exp(-abs((1:M)'*ones(1,dimention2)-center_x(j))/sigmax_c(j));
            possi = rand_p.*possi_y.*possi_x;
            non_occupied = (tmp ==0);
            possi = possi.*non_occupied;
            thresh = sort(possi(:),'descend');
            ind = (possi>=thresh(round(flex_rand(i)*center_ratio(j))));
            tmp(ind) = center_class(j);
        end        
        % allocate sparse grains for each center
        rand_p2 = rand(M,dimention2) + 1;  
        for j = 1:n_b
            possi_y = exp(-abs(ones(M,1)*(1:dimention2)-center_y(j))/sigmay_f(j));
            possi_x = exp(-abs((1:M)'*ones(1,dimention2)-center_x(j))/sigmax_f(j));
            possi = rand_p2.*possi_y.*possi_x;
            non_occupied = (tmp ==0);
            possi = possi.*non_occupied;
            thresh = sort(possi(:),'descend');
            ind = (possi>=thresh(1 + floor(flex_rand(i)/(1-ratio_fixed)*ratio_fixed*center_ratio(j))));
            tmp(ind) = center_class(j);
        end        
        target(:, floor(N/n_r*(i-1))+1:floor(N/n_r*i)) = tmp;
    end
end


