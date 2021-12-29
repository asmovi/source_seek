disp('Source seeking started!');
ts = tic();

% (dest, traj, u) noise parameters
% noise_options = {[true, false, false], ...
%                  [false, true, false], ...
%                  [false, false, true]};
% noise_devvals = {[0.5, 0, 0], ...
%                  [0, 0.5, 0], ...
%                  [0, 0, 0.5]};
% noise_names = {'dest', 'traj', 'u'};

noise_options = {[true, false, false]};
noise_devvals = {[0.5, 0, 0]};
noise_names = {'dest'};

n = length(noise_options);
clear field_avg;
instances = {};
n_sim = 5;

disp('Loading simulation blocks...');
t_b = tic();

run('load_simulink_blocks.m');

dt = toc(t_b);
fprintf('Simulation blocks loaded in %.2fs\n', dt);

wb_j_sims = my_waitbar('Loading instances');
for i_sim = 1:n
    field_avg = struct();
    
    for j_sim = 1:n_sim
        run('simulate_source_seek.m');
    end
    
    idx = i_sim+(j_sim-1)*n;
    idf = n_sim*n;
    wb_j_sims.update_waitbar(idx, idf);
end

wb_j_sims.close_window();

run('plot_trajs.m');

dt = toc(ts);
fprintf('Source seeking finished in %.2fs\n', dt);
