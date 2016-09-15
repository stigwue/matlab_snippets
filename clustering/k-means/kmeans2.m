
%% load data
%Sepal length 	Sepal width 	Petal length 	Petal width 	Species
load fisheriris;
% fisher(:, 5) = species;
fisher(:, 1:4) = meas;

%% cluster, ignoring the species info i.e type
cluster_size = 3;
cosine = 0; %or 1
distance = 'Euclidean';
replicates = 1; %or some value > 1
if (cosine == 1)
    fisher_cluster = kmeans(fisher(:, 1:4), cluster_size, 'Distance', 'cosine', 'display', 'iter');
    distance = 'Cosine';
else
    if (replicates == 1)
        fisher_cluster = kmeans(fisher(:, 1:4), cluster_size, 'display', 'iter');
    else
        fisher_cluster = kmeans(fisher(:, 1:4), cluster_size, 'Replicates', replicates, 'display', 'iter');
    end
end

%% plot the clusters gotten from kmeans
figure
for i = 1:cluster_size 
    [indices] = find(fisher_cluster(:) == i);
    switch (i)
        case 1
            plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3), 'or');
            hold on
        case 2
            plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3), 'og');
            hold on
        case 3
            plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3), 'ob');
            hold on
    end
end
xlabel('Sepal length'); 	 	
ylabel('Sepal width');
zlabel('Petal length');
if (cluster_size == 2)
    legend('Cluster 1', 'Cluster 2');
else
    legend('Cluster 1', 'Cluster 2', 'Cluster 3');
end
if (replicates == 1)
    title(['Clusters: ' num2str(cluster_size) ', Distance: ' distance]);
else
    title(['Clusters: ' num2str(cluster_size) ', Distance: ' distance ', Replicates: ' num2str(replicates)]);
end

%% plot the clusters by specie
if (cluster_size == 3)
%get all species
types = unique(species(:, 1));
specie_diff = zeros(150, 2); %0=setosa, 1=versicolor, 2=virginica
specie_diff(:, 2) = fisher_cluster;
figure
for i = 1:size(types, 1)
    [indices] = find(strcmp(species(:), types(i)));
    if (strcmp(types(i), 'setosa'))
        specie_diff(indices) = 0;
        plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'or');
        hold on
    elseif (strcmp(types(i), 'versicolor'))
        specie_diff(indices) = 1;
        plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'og')
        hold on
    elseif (strcmp(types(i), 'virginica'))
        specie_diff(indices) = 2;
        plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'ob')
        hold on
    end
end
xlabel('Sepal length'); 	 	
ylabel('Sepal width');
zlabel('Petal length');
%legend('setosa', 'versicolor', 'virginica');
title(['Clusters by Specie ']);

% plot wrongly clustered points
%we notice from data stored in specie_diff that
%data 1 = setosa(0) and properly clustered
specie_0_cluster = specie_diff(1, 2);
%data 56 = versicolor(1) and properly clustered
specie_1_cluster = specie_diff(56, 2);
%data 110 = virginica(2) and properly clustered
specie_2_cluster = specie_diff(110, 2);

%get which cluster represents which
[specie_0_indices] = find(specie_diff(:, 2) ==  specie_0_cluster);
[specie_1_indices] = find(specie_diff(:, 2) ==  specie_1_cluster);
[specie_2_indices] = find(specie_diff(:, 2) ==  specie_2_cluster);

%set cluster index to specie type
specie_diff(specie_0_indices, 2) = 0;
specie_diff(specie_1_indices, 2) = 1;
specie_diff(specie_2_indices, 2) = 2;

%plot
hold on
%setosa(0)
[indices] = find(specie_diff(:,1) == 0 & specie_diff(:,1) ~= specie_diff(:,2));
plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'diamondk');
hold on
%versicolor(1)
[indices] = find(specie_diff(:,1) == 1 & specie_diff(:,1) ~= specie_diff(:,2));
plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'diamondk')
hold on
%virginica(2)
[indices] = find(specie_diff(:,1) == 2 & specie_diff(:,1) ~= specie_diff(:,2));
plot3(fisher(indices, 1), fisher(indices, 2), fisher(indices, 3),'diamondk')
hold on

legend('setosa', 'versicolor', 'virginica', 'misclassified');
end