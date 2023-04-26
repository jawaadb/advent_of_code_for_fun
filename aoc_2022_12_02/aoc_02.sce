function txt=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    mprintf('%0.1fms to load data\n', toc()*1e3);
endfunction

function score=scoreForOutcome_obsolete(outcome)
    oppPlay = find(part(outcome,1)==['A' 'B' 'C'],1);
    myPlay  = find(part(outcome,3)==['X' 'Y' 'Z'],1);
    
    shapeScore = myPlay;
    outcomeScore = [3 6 0](modulo(myPlay-oppPlay+3, 3)+1);
    
    score = shapeScore + outcomeScore;
endfunction

function score=scoreForOutcome(outcome)
    oppPlay = find(part(outcome,1)==['A' 'B' 'C'],1);
    desiredResult  = find(part(outcome,3)==['X' 'Y' 'Z'],1);
    
    myPlay = (modulo([oppPlay+2, oppPlay, oppPlay+1]-1,3)+1)(desiredResult);
    
    shapeScore = myPlay;
    outcomeScore = [3 6 0](modulo(myPlay-oppPlay+3, 3)+1);
    
    score = shapeScore + outcomeScore;
endfunction

function [outcomes,scores]=generateOutcomesLUT(version)
    assert_checktrue(or(version==['part1', 'part2']));
    
    tic();
    
    pos1 = ['A', 'B', 'C'];
    pos2 = ['X', 'Y', 'Z'];
    
    outcomes = string(zeros(size(pos1,'*')*size(pos2,'*'),1));
    scores = zeros(size(outcomes,'*'),1);
    
    for i=1:size(outcomes,'*')
        idx1 = floor((i-1) / size(pos2,'*')) + 1;
        idx2 = modulo(i-1, size(pos2,'*')) + 1;
        
        outcomes(i) = msprintf('%s %s', pos1(idx1), pos2(idx2));
        
        if version=='part1' then
            scores(i) = scoreForOutcome_obsolete(outcomes(i));
        elseif version=='part2' then
            scores(i) = scoreForOutcome(outcomes(i));
        else
            error('Unexpected version.');
        end
    end
    
    assert_checkequal(size(outcomes), size(scores));
    
    mprintf('%0.1fms to gen LUT\n', toc()*1e3);
endfunction

function score=calcScore(M, lut_outcomes, lut_scores)
    tic();
    
    idxOutcomes = zeros(M);
    
    for i=1:size(lut_outcomes,'*')
        idxOutcomes(M==lut_outcomes(i))=i;
    end
    
    scores = lut_scores(idxOutcomes);
    
    score = sum(scores);
    
    mprintf('%0.1fms to calc score\n', toc()*1e3);
endfunction

function processInput(fn, puzzlePart)
    strLn = string(zeros(length(fn),1)); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    M=loadFile(fn);
    
    [lut_outcomes,lut_scores]=generateOutcomesLUT(puzzlePart);
    
    score = calcScore(M, lut_outcomes, lut_scores);
    
    mprintf('Score = %d\n', score);
    mprintf('\n\n');
endfunction


function main()
    disp('Part 1');
    processInput('example_rps.txt', 'part1');
    processInput('puzzle_input_1.txt', 'part1');
    
    disp('Part 2');
    processInput('example_rps.txt', 'part2');
    processInput('puzzle_input_1.txt', 'part2');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_02.sce'));

main();
