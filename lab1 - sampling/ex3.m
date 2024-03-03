% Wczytanie sygnału z pliku adsl_x.mat
load('adsl_x.mat');

% Parametry
M = 32;  % Długość prefiksu
N = 512; % Długość bloku
k = 4;
% Tworzenie sekwencji prefiksu (ostatnie M próbek)
prefix_sequence1 = x(512-32:512);
prefix_sequence2 = x(512*2-32:512*2);
prefix_sequence3 = x(512*3-32:512*3);
prefix_sequence4 = x(512*4-32:512*4);
prefix_sequence = [prefix_sequence1, prefix_sequence2, prefix_sequence3, prefix_sequence4];
prefix_starts = zeros(1, k);

for k = 1:4
    [R, lag] = xcorr(x, prefix_sequence(:,k));
    [~, max_index] = max(R);
    prefix_starts(k) = lag(max_index);
end


disp('Początkowe próbki każdego prefiksu:');
disp(prefix_starts);