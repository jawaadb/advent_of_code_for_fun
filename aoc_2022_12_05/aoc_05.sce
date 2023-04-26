function strStacks=extractStacks(str)
    strNums = strsplit(str($),' ');
    strNums(strNums=='')=[];
    
    numOfStacks = size(strNums,'*');
    mprintf('%d stacks', numOfStacks);
    
    lineLen = length(str(1));
    
    // Remove brackets from stacks
    stackLines = part(str(1:($-1)),[2:4:lineLen]);
    
    // Form each stack as string
    strStacks=emptystr(numOfStacks,1);
    for i=1:numOfStacks
        strStacks(i) = stripblanks(strrev(strcat(part(stackLines,i))));
    end
endfunction


function res=extractMoves(str)
    res = csvTextScan(str, ' ');
    res(:,[1 3 5]) = [];
endfunction

function [stacks,moves]=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    idxMid = find(txt=='');
    
    strCrates = txt(1:(idxMid-1));
    strMoves  = txt((idxMid+1):$);
    
    stacks = extractStacks(strCrates);
    moves  = extractMoves(strMoves);
    
    mprintf('\n%0.1fms to load data\n', toc()*1e3);
endfunction


function stacks=applyMove(stacks, aMove)
    cCount = aMove(1);
    cFrom  = aMove(2);
    cTo    = aMove(3);
    
    // Take copy of crates to move
    movedPart = part(stacks(cFrom),($-cCount+1):$);
    
    // Remove moved crates from 'from' stack
    stacks(cFrom) = part(stacks(cFrom),1:($-cCount));
    
    // Reverse crate order if part 1
    if PART==1 then
        movedPart = strrev(movedPart);
    elseif PART==2 then
        // do nothing
    else
        error('PART not set.');
    end
    
    // Place picked up crates on 'to' stack
    stacks(cTo) = strcat([stacks(cTo), movedPart]);
endfunction


function stacks=applyMoves(stacks, moves)
    tic();
    
    for i=1:size(moves,'r')
        stacks=applyMove(stacks, moves(i,:));
    end
    
    mprintf('\n%0.1fms to run simulation\n', toc()*1e3);
endfunction

function str=topCrates(stacks)
    str = strcat(part(stacks,$));
endfunction

function processInput(fn)
    strLn = emptystr(length(fn),1); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    [stacks,moves]=loadFile(fn);
    
    stacks_final=applyMoves(stacks, moves);
    
    mprintf('Top crates of stacks = %s\n' ..
        , topCrates(stacks_final));
    
    mprintf('\n\n');
endfunction


function main()
    PART = 1;
    processInput('example_crates.txt');
    processInput('puzzle_input_1.txt');
    
    PART = 2;
    processInput('example_crates.txt');
    processInput('puzzle_input_1.txt');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_05.sce'));

main();
