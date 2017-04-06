%%% Stroop Experiment %%%

% Create figure window
f = figure();
set(f, 'NumberTitle', 'off', ...
       'Name', 'Stroop Experiment', ...
       'Color', 'white', ...
       'MenuBar','none', ...
       'ToolBar', 'none'); 
movegui(f, 'center');
   
% Display instructions
stroop = struct();
stroop.instruction = {'You will be shown words, one at a time, printed in various colors.',...
                      'Press 1 for word printed in red, 2 for green, 3 for blue.',...
                      'Try to be as fast as possible but correct.',...
                      ' ',...
                      '[Press any key to start the experiment]'};

text_instructions = uicontrol(f,'Style','text',...
    'Position',[5,30,550,250],...
    'BackgroundColor',[1 1 1],...
    'ForegroundColor',[0 0 0],...
    'FontSize',14);
set(text_instructions,'String',stroop.instruction);

% Wait for user input to start experiment
waitforbuttonpress;
delete(text_instructions)

% Trial variable list and counters
total_trials = 10;  % Number of trials to be performed. Can be changed if time consuming 
c_trial = 0;
i_trial = 0;
num_trials = 0;
reaction_time = [];

% Word Box
stroop.words = {'red','green','blue'};

% Start experiment
while num_trials < total_trials
    
    % Random generator to choose either congruent or incongruent trial
    % Congruent trials = 0, Incongruent trials = 1
    
    rand_trial = round(rand(1));   % Trial probability may be uneven 
    
    % Word and Colour random generator
    rand_colour = randi(3);
    rand_word = randi(3);
    
    % Create Congruent Trial
    if rand_trial == 0
         % Pause for 200ms and display
         pause(2);
         text_box = uicontrol(f,'Style','text',...
                'Position',[5,30,550,250],...
                'BackgroundColor',[1 1 1],...
                'ForegroundColor', stroop.words {rand_colour},...
                'FontSize', 40);
         set(text_box,'String',stroop.words {rand_colour});
         c_trial = c_trial + 1;
         tic;

    % Create Incongruent Trial
    else 
         % Pause for 200ms and display
         pause(2);
         text_box = uicontrol(f,'Style','text',...
                'Position',[5,30,550,250],...
                'BackgroundColor',[1 1 1],...
                'ForegroundColor', stroop.words {rand_colour},...
                'FontSize', 40);
         set(text_box,'String',stroop.words {rand_word});
         i_trial = i_trial + 1;
         tic;
    end
    
    % Wait for user response
    waitforbuttonpress;
    delete(text_box)

    % Store reaction time 
        if rand_trial == 0
            % Reaction time for congruent trials
            reaction_time(1,end+1) = toc;   
            num_trials = num_trials + 1;
        else
            % Reaction time for incongruent trials
            reaction_time(2,end+1) = toc;
            num_trials = num_trials + 1;
        end
        
        save('latency.mat','reaction_time')
        
   
end
% Store all participant time
p = reaction_time(1,:);
o = reaction_time(2,:);
all_time = [p;o];
save('latency.mat','all_time','-append')

% Evaluate results
load('psyc58.mat')
x = (sum(reaction_time(1,:))/c_trial)*1000;
y = (sum(reaction_time(2,:))/i_trial)*1000;
your_time = [x y]; 
sample_time = [a b];
label = {'Congruent', 'Incongruent'};

% Show results and compare 
h = figure();
set(h, 'Name', 'Stroop Results', ...
       'Color', 'white');    
movegui(h,[-100,100]);

    % Participant results
    subplot(2,1,1);
    barh(your_time,'red')
    title('Your Response Latency (MS)')
    set(gca,'YTickLabel',label);
            
    % PSYC58 Results
    subplot(2,1,2);
    barh(sample_time)
    title('PSYC58 Response Latency (MS)')
    set(gca,'YTickLabel',label);

% Debrief experiment
stroop.debrief = {'You have just completed the Stroop experiment.',...
                  'This experiment measures the response latency difference',...
                  'between words displayed in the same colour versus words',...
                  'displayed in different colours. Results from this experiment',... 
                  'have been compared to a sample from PSYC58H3.',...
                  'Accuracy rate was not recorded in this particular experiment.'};
    
text_instructions = uicontrol(f,'Style','text',...
    'Position',[5,40,550,250],...
    'BackgroundColor',[1 1 1],...
    'ForegroundColor',[0 0 0],...
    'FontSize',14);
set(text_instructions,'String',stroop.debrief);


