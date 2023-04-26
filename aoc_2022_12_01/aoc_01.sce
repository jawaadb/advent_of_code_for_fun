function M=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    M=strtod(txt);
    
    assert_checkequal(isnan(M($)),%f); // Check last line not blank
    
    mprintf('%0.1fms to load data\n', toc()*1e3);
endfunction

function elfCals=calcCalsPerElf(M)
    tic();
    
    numEntries = size(M,'r');
    idxSection = [0, find(isnan(M)), numEntries+1];
    numElves = size(idxSection,'*')-1;
    
    // Init vector to hold calculated calories held by each elf
    elfCals = zeros(numElves,1);
    
    // Calculate calories held by each elf
    for i=1:(size(idxSection,'*')-1)
        idxStart = idxSection(i)+1;
        idxEnd = idxSection(i+1)-1;
        
        elfCals(i) = sum(M(idxStart:idxEnd));
    end
    
    mprintf('%0.1fms to calculate calories per elf\n', toc()*1e3);
endfunction

function res=sumTop3(M)
    tic();
    res=sum(gsort(M)(1:3));
    msprintf('%0.1fms to sum top 3\n', toc()*1e3);
endfunction


function processInput(fn)
    strLn = string(zeros(length(fn),1)); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    data = loadFile(fn);
    
    M=calcCalsPerElf(data);
    
    // Find top elf
    idxTop=find(M==max(M),1);
    
    // Find top 3 elves
    sumForTop3=sumTop3(M);
    
    mprintf('Calories held by top elf: %d\n', M(idxTop));
    mprintf('Calories held by top 3 elves: %d\n',sumForTop3);
    mprintf('\n\n');
endfunction


function main()
    processInput('example_elf_calories.txt');
    processInput('puzzle_input_1.txt');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_01.sce'));

main();
