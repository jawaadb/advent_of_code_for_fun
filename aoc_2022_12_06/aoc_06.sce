function txt=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    mprintf('\n%0.1fms to load data\n', toc()*1e3);
endfunction


function idx=findNUnique(str, windowSize)
    idx = [];
    
    buffLen = length(str);
    
    for i=windowSize:buffLen
        str_sub = strsplit(part(str, (i-windowSize+1):i));
        
        if (size(unique(str_sub),'*')==windowSize) then
            idx = i;
            return;
        end
    end
endfunction


function processInput(fn)
    strLn = emptystr(length(fn),1); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    str=loadFile(fn);
    
    for i=1:size(str,'r')
        tic();
        markerIndex = findNUnique(str(i), 14);
        mprintf('\n%0.1fms to find marker\n', toc()*1e3);
        mprintf('Index of marker = %d\n', markerIndex);
    end
    
    mprintf('\n\n');
endfunction


function main()
    processInput('examples_buffers.txt');
    processInput('puzzle_input_1.txt');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_06.sce'));

main();
