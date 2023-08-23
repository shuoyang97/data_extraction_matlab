% root of files
root = '/Volumes/ShuoYang/fem_data/datenmatlab';

% create waitbar 
bar = waitbar(0, 'Generating...');

% names of dataset file
dataset_name = 'dataset_11_33.csv';
filesOfroot = dir(root);
filenames = [];
pat = "Daten";

for k = 1:length(filesOfroot)
    name = convertCharsToStrings(filesOfroot(k).name);
    TF = startsWith(name,pat);
    filenames = [filenames; name(TF)];
end

input = [];
output = [];

for i = 1:length(filenames)
% path of fileToRead and read data
    name = filenames(i);
    disp("Processing " + name + "!");
    fileToRead = strcat(root, '/', name);
    newData = load('-mat', fileToRead);
    Daten = newData.Daten;

% implement create_data_set script   
    [in_tmp, out_tmp] = create_dataset(Daten);
    input = cat(1, input, in_tmp);
    output = cat(1, output, out_tmp);
    waitbar((i - st + 1)/(en - st + 1), bar);
end

% make csv file
dataset = cat(2, input, output);
writematrix(dataset, dataset_name);

close(bar);
disp('Finished!')