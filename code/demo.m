function demo(varargin) 
   %
   % runs through the Plates directory and performs segmentation
   % and recognition, by making calls to 'classify', and checking
   % the output. prints the output of the neural network to 
   % console, and grades whether the answer is correct or not.
   % 
   % usage: demo(0.0) will pause for user input after every image
   %        demo() will pause for 0.2 seconds after every image.
   %        
   %
   %
   phome();
   load('Data/test.mat');
   load('Data/net.mat');
   
   showme = true;
   lenient = true;
   wait = false;
   waitlength = 0.2;
   
    for i=1:nargin
       arg = varargin{i};
       if ischar(arg) && strcmpi(arg,'noshow')
           showme = false;
       elseif ischar(arg) && strcmpi(arg,'strict')
          lenient = false;
       elseif ischar(arg) && strcmpi(arg,'test')
           cd('Demo');
           files = dir('*.jpg');
           
           for j=1:length(files)
               classify(imread(files(j).name),net)
               drawnow
               pause
               close
           end
           phome();
           return
       elseif isfloat(arg)
          if arg == 0
              wait = true;
          else
              waitlength = arg;
          end
       end
    end

    phome();
    warning('off','images:initSize:adjustingMag');



    N = length(test);

    glyphs_correct = 0;
    glyphs_total = 0;
    plates_correct = 0;
    figure
    for i=1:N
       [output,partition] = classify(test{i,1},net,false);
       truth = test{i,2};
       
       orig_truth = truth;
       orig_output = output;
       
       if lenient % replace I -> 1, O -> 0, 2 -> Z, 5 -> S
           
           repl = {'I1','O0','2Z','5S'};
           for k=1:length(repl)
               truth = strrep(truth,repl{k}(1),repl{k}(2));
               output = strrep(output,repl{k}(1),repl{k}(2));
           end 
       end

       glyphs_correct = glyphs_correct + length(truth) - editdistance(truth,output);
       glyphs_total = glyphs_total + length(truth);

       plates_correct = plates_correct + strcmpi(output,truth);
       if showme
           M = length(partition);
           subplot(2,M,1:M)
           imshow(test{i,1});
           for j=1:M
                subplot(2,M,M+j)
                imshow(partition{j});  
           end
           drawnow
       end
       disp(['Output: ',orig_output]);
       line2 = ['Truth:  ',orig_truth];
       if strcmpi(output,truth)
          line2 = [line2,'     Correct!']; 
       end
       disp(line2);
       disp('------------');
       if showme
          if wait
              pause
          else
              pause(waitlength)
          end
           
       end
    end

    disp(['Glyph accuracy: ', num2str(glyphs_correct/glyphs_total)]);
    disp(['Plate accuracy: ', num2str(plates_correct/N)]);
    close all
end