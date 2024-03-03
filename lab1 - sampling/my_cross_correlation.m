function Rxy = my_cross_correlation(x, y)
    % Długości sygnałów
    Nx = length(x);
    Ny = length(y);
    
    % Inicjalizacja wynikowej macierzy korelacji wzajemnej
    Rxy = zeros(1, Nx + Ny - 1);
    
    % Obliczenie korelacji wzajemnej
    for n = 1:Nx + Ny - 1
        start = max(1, n - Ny + 1);
        stop = min(n, Nx);
        Rxy(n) = sum(x(start:stop) .* y(start - n + stop:stop - n + start));
    end
end

