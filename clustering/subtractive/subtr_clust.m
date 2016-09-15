
%% load data
tripdata;

%input = datin = 75 * 5
%output = datout = 75 * 1

%% cluster data
%[C,S] = subclust(X,radii,xBounds,options)
%c = cluster centers per row
%s = cluster radii
%radii=[0.5 0.25]
[c, s] = subclust([datin datout], 0.20);

%% extract centers and radii
%input cluster
total_employment = c(:, 5);
x_radius = s(5);

%output cluster
num_of_trips = c(:, 6);
y_radius = s(6);

%% plot data of the 1st cluster
figure
plot(datin(:, 5), datout(:,1), 'diamondblack');
%plot(datin, datout, 'diamond');

cluster_by_x = 1; %or 0 to use y

if (cluster_by_x == 1)
    ci = 1;
    hold on
    circle(total_employment(ci), num_of_trips(ci), x_radius, 'm');
    ci = 2;
    hold on
    circle(total_employment(ci), num_of_trips(ci), x_radius, 'c');
    ci = 3;
    hold on
    circle(total_employment(ci), num_of_trips(ci), x_radius, 'g');
    title('Total employment clusters');
else
    ci = 1;
    hold on
    circle(total_employment(ci), num_of_trips(ci), y_radius, 'm');
    ci = 2;
    hold on
    circle(total_employment(ci), num_of_trips(ci), y_radius, 'c');
    ci = 3;
    hold on
    circle(total_employment(ci), num_of_trips(ci), y_radius, 'g');
    title('Number of trips clusters');
end
xlabel('total employment');
ylabel('number of trips');

%% plot data of the 1st cluster
figure
ci = 1;
% %find cluster of total employment
% x_center = total_employment(ci);
% x_indices = find(abs...
%     (datin(:,5) - x_center)...
%     <= x_radius);
y_center = num_of_trips(ci);
y_indices = find(abs...
    (datout(:,1) - y_center)...
    <= y_radius);
plot(datin(y_indices, 5), datout(y_indices), 'diamondm');
xlabel('total employment');
ylabel('number of trips');
title('First cluster of number of trips');


%% plot data of the 2nd cluster
figure
ci = 2;
% %find cluster of total employment
% x_center = total_employment(ci);
% x_indices = find(abs...
%     (datin(:,5) - x_center)...
%     <= x_radius);

%cluster for number of trips
y_center = num_of_trips(ci);
y_indices = find(abs...
    (datout(:,1) - y_center)...
    <= y_radius);

plot(datin(y_indices, 5), datout(y_indices), 'diamondm');
xlabel('total employment');
ylabel('number of trips');
title('Second cluster of number of trips');

%% plot data of the 3rd cluster
figure
ci = 3;
% %find cluster of total employment
% x_center = total_employment(ci);
% x_indices = find(abs...
%     (datin(:,5) - x_center)...
%     <= x_radius);

%cluster for number of trips
y_center = num_of_trips(ci);
y_indices = find(abs...
    (datout(:,1) - y_center)...
    <= y_radius);

plot(datin(y_indices, 5), datout(y_indices), 'diamondm');
xlabel('total employment');
ylabel('number of trips');
title('Third cluster of number of trips');