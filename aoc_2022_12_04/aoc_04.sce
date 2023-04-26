function [RngA, RngB]=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    scan = csvTextScan(txt, ',', [], 'string');
    
    strA = scan(:,1);
    strB = scan(:,2);
    
    RngA = csvTextScan(strA, '-');
    RngB = csvTextScan(strB, '-');
    
    mprintf('%0.1fms to load data\n', toc()*1e3);
endfunction


function idxs=findFullyOverlappingRanges(RngA, RngB)
    // A fully contained within B
    res1 = (RngA(:,1)>=RngB(:,1)) & (RngA(:,2)<=RngB(:,2));
    
    // B fully contained within A
    res2 = (RngB(:,1)>=RngA(:,1)) & (RngB(:,2)<=RngA(:,2));
    
    idxs = find(res1 | res2);
endfunction

function idxs=findOverlappingRanges(RngA, RngB)
    idxs = [];
    
    B_is_fully_right = RngB(:,1)>RngA(:,2);
    B_is_fully_left  = RngB(:,2)<RngA(:,1);
    
    NoOverlap = B_is_fully_right | B_is_fully_left;
    
    idxs = find(~NoOverlap);
endfunction


function processInput(fn)
    strLn = emptystr(length(fn),1); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    [RngA,RngB]=loadFile(fn);
    
    idxFullOverlap = findFullyOverlappingRanges(RngA, RngB);
    idxOverlap = findOverlappingRanges(RngA, RngB);
    
    mprintf('Number of fully overlapping ranges = %d\n' ..
        , size(idxFullOverlap,'*'));
    
    mprintf('Number of overlapping pairs = %d\n' ..
        , size(idxOverlap,'*'));
    
    mprintf('\n\n');
endfunction


function main()
    processInput('example_ranges.txt');
    processInput('puzzle_input_1.txt');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_04.sce'));

main();
