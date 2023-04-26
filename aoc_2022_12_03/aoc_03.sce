function txt=loadFile(fn)
    tic();
    
    fd = mopen(fn);
    txt=mgetl(fd);
    mclose(fd);
    
    mprintf('%0.1fms to load data\n', toc()*1e3);
endfunction


function priority=itemToPriority(item)
    if ascii(item)>=ascii('a') then
        priority = ascii(item) - ascii('a') + 1;
    else
        priority = ascii(item) - ascii('A') + 27;
    end
endfunction


function p_common=priorityOfCommonItem(str)
    str = strsplit(str);
    
    numItems = size(str,'*');
    
    setA = str(1:numItems/2);
    setB = str((numItems/2+1):numItems);
    
    common_item = intersect(setA, setB);
    
    p_common = itemToPriority(common_item);
endfunction


function commonItemPriorities=priorityOfCommonItems(M)
    tic();
    
    numOfRucksacks = size(M,'r');
    
    commonItemPriorities = zeros(numOfRucksacks,1);
    for i=1:numOfRucksacks
        commonItemPriorities(i) = priorityOfCommonItem(M(i));
    end
    
    mprintf('%0.1fms to determine common items\n', toc()*1e3);
endfunction

function item=identifyBadgeItemPriority(M3)
    setA = strsplit(M3(1));
    setB = strsplit(M3(2));
    setC = strsplit(M3(3));
    
    item = itemToPriority(intersect(intersect(setA, setB),setC));
endfunction

function badgePriorities=identifyBadgeItemPriorities(M)
    tic();
    
    numOfRucksacks = size(M,'r');
    
    badgePriorities=zeros(numOfRucksacks/3,1);
    
    for i=1:size(badgePriorities,'*')
        badgePriorities(i)=identifyBadgeItemPriority(  M( (3*i-2):(3*i) )  );
    end
    
    mprintf('%0.1fms to find badges\n', toc()*1e3);
endfunction


function processInput(fn)
    strLn = emptystr(length(fn),1); strLn(:)='='; strLn=strcat(strLn);
    mprintf('%s\n%s\n',fn,strLn);
    
    M=loadFile(fn);
    
    priorities=priorityOfCommonItems(M);
    badgePriorities=identifyBadgeItemPriorities(M);
    
    mprintf('Sum of duplicate rucksack item priorities = %d\n', sum(priorities));
    mprintf('Sum of badge priorities = %d\n', sum(badgePriorities));
    
    mprintf('\n\n');
endfunction


function main()
    processInput('example_rucksacks.txt');
    processInput('puzzle_input_1.txt');
endfunction

clear all;
clc;

chdir(get_absolute_file_path('aoc_03.sce'));

main();
