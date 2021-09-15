clear all
close all
clc

% Load system
run('load_model.m');

% (dest, traj, u) noise parameters
noise_options = {[false, false, true]};
noise_devvals = {0.5};
noise_names = {'u'};

n = length(noise_options);

n_sim = 50;
field_avgs = [];

wb_sims = my_waitbar('Loading instances');

for j = 1:n_sim
    field_avg = struct();
    
    for i = 1:n
        noise_option = noise_options{i};
        noise_devval = noise_devvals{i}; 
        noise_name = noise_names{i};

        run('load_parameters.m');

        options.abs_tol = '1e-3';
        options.rel_tol = '1e-3';

        simOut = sim_block_diagram(model_name, x0, options);
        
        fields = simOut.who;

        if(isempty(fieldnames(field_avg)))
            n_f = length(fields);
            for i = 1:n_f
                field = fields{i};
                
                for i = 1:n_f
                    field = fields{i};

                    if(~strcmp(field, 'tout') && ~strcmp(field, 'xoutNew'))
                        field_avg.(field) = 0;
                    end
                end
            end
        end
        
        n_f = length(fields);
        for i = 1:n_f
            field = fields{i};
            
            if(~strcmp(field, 'tout') && ~strcmp(field, 'xoutNew'))
                field_avg.(field) = field_avg.(field) + ...
                                    simOut.(field).signals.values;
            end
        end
        
    %     run('./plot_simulation.m');
    end
    
    field_avgs = [field_avgs, field_avg];
    
    wb_sims.update_waitbar(j, n_sim);
end

