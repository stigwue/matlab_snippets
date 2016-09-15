
%% read data from file
data = load('Box Jenkins data file.csv');

%% select data to cluster
%note that cluster is an x*1*3 array
cluster = zeros(size(data, 1), 1, 3);
%first inputs in 1st dimension
cluster(:, 1) = data(:, 1);
%second inputs in 2nd dimension
cluster(:, 2) = data(:, 2);
%3rd dimension holds the cluster index

%% randomly set data into 3 clusters
cluster_size = 3;
cluster_index = 1;
for x = 1:size(cluster, 1)
    cluster(x, 3) = cluster_index;
    cluster_index = cluster_index + 1;
    if (cluster_index > cluster_size)
        cluster_index = 1;
    end
end

%% plot initial cluster distribution
[r1,c1] = find(cluster(:,3) == 1);
[r2,c2] = find(cluster(:,3) == 2);
[r3,c3] = find(cluster(:,3) == 3);

figure
plot(cluster(r1, 1), cluster(r1, 2),'.r');
hold on
plot(cluster(r2, 1), cluster(r2, 2),'.g');
hold on
plot(cluster(r3, 1), cluster(r3, 2),'.b');
xlabel('Input 1');
ylabel('Input 2');
legend('Cluster 1', 'Cluster 2', 'Cluster 3');
title(['Iteration ' num2str(0)]);

%% move points to clusters they are closer to
iterations = 0; %iteration count
%minimum eucl dist for each point and the index
euclidean_distances = zeros(size(cluster, 1), 2);
euclidean_distances(:,1) = 1000000000; %sum random very large distance
euclidean_distances(:,2) = cluster_size + 1;
while (true) %do iterations forever, break out inside the loop
    iterations = iterations + 1;
    %cluster average is saved in a 3*1*3 matrix
    cluster_avg = zeros(cluster_size, 1);
    
    [r1,c1] = find(cluster(:,3) == 1);
    [r2,c2] = find(cluster(:,3) == 2);
    [r3,c3] = find(cluster(:,3) == 3);
    
    %find the 3 cluster averages
    cluster_avg(1,1) = mean(cluster(r1, 1));
    cluster_avg(1,2) = mean(cluster(r1, 2));
    
    cluster_avg(2,1) = mean(cluster(r2, 1));
    cluster_avg(2,2) = mean(cluster(r2, 2));
    
    cluster_avg(3,1) = mean(cluster(r3, 1));
    cluster_avg(3,2) = mean(cluster(r3, 2));
    
    %compare points to averages and move
    points_not_moved = 0;
    for point = 1:size(cluster, 1)
        %initialize euclidean dist for this point
        euclidean_dist = zeros(cluster_size, 1);
        %calculate distance from each cluster
        for c = 1:cluster_size
            euclidean_dist(c) = eucl_dist(cluster_avg(c, 1), cluster_avg(c,2)...
                , cluster(point, 1), cluster(point, 2));
        end
        %find the minimum distance
        [min_value, min_cluster_index] = min(euclidean_dist);
        
        %test if the minimum distance has decreased for the same cluster
        if (min_cluster_index == euclidean_distances(point, 2))
            %point is in the same cluster, ignore
            %why calculate euclidean distance if the new cluster is the
            %same as old?
            points_not_moved = points_not_moved + 1;
        else
            %point is changing its cluster
            cluster(point, 3) = min_cluster_index;
            
            euclidean_distances(point, 1) = min_value;
            euclidean_distances(point, 2) = min_cluster_index;
        end
    end
    
    %plot the current iteration
    figure
    [r1,c1] = find(cluster(:,3) == 1);
    plot(cluster(r1, 1), cluster(r1, 2),'.r');
    hold on
    [r2,c2] = find(cluster(:,3) == 2);
    plot(cluster(r2, 1), cluster(r2, 2),'.g');
    hold on
    [r3,c3] = find(cluster(:,3) == 3);
    plot(cluster(r3, 1), cluster(r3, 2),'.b');
    xlabel('Input 1');
    ylabel('Input 2');
    legend('Cluster 1', 'Cluster 2', 'Cluster 3');
    title(['Iteration ' num2str(iterations)]);

    %plot cluster centers
    hold on
    plot(cluster_avg(1,1), cluster_avg(1,2),'*r');

    hold on
    plot(cluster_avg(2,1), cluster_avg(2,2),'*g');

    hold on
    plot(cluster_avg(3,1), cluster_avg(3,2),'*b');
    
    %check if iteration is enough
    %if (iterations == 15) 
    if (points_not_moved == size(cluster, 1))
        %none of the points moved,
        break;
    else
        %some points still move
    end
end

disp(['Finished clustering after ', num2str(iterations), ' iterations']);