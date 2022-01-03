disp('Source seeking started!');
ts = tic();

% noise_options = {[true, false, false], ...
%                  [false, true, false], ...
%                  [false, false, true]};
% noise_devvals = {[0.5, 0, 0], ...
%                  [0, 0.5, 0], ... 
%                  [0, 0, 0.5]};
% noise_names = {'dest', 'traj', 'u'};

noise_options = {[false, false, false]};
noise_devvals = {[0.5, 0, 0]};
noise_names = {'dest'};

n_scenes = length(noise_options);
clear field_avg;
n_sims = 2;

disp('Loading simulation blocks...');
t_b = tic();

run('load_simulink_blocks.m');

dt = toc(t_b);
fprintf('Simulation blocks loaded in %.2fs\n', dt);

wb_j_sims = my_waitbar('Loading instances');
for i_sim = 1:n_scenes
    field_avg = struct();
    instances = {};
    
    for j_sim = 1:n_sims
        rng('shuffle');
        run('simulate_source_seek.m');
        
        idx = (i_sim-1)*n_sims+j_sim;
        idf = n_sims*n_scenes;
        wb_j_sims.update_waitbar(idx, idf);
    end
    
    run('plot_trajs.m');
end

wb_j_sims.close_window();

dt = toc(ts);
fprintf('Source seeking finished in %.2fs\n', dt);
