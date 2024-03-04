function Rxy = my_cross_correlation(x, y)
    % Długości sygnałów
    Nx = length(x);
    Ny = length(y);
    
    % Wypełnienie macierzy y zerami na początku
    y2 = zeros(1, Nx - Ny);
    y2 = [y2, y];
    Ny2 = length(y2);
    
    % Inicjalizacja wynikowej macierzy korelacji wzajemnej
    Rxy = zeros(1, Nx + Ny2 - 1);
    
    % Obliczenie korelacji wzajemnej - własna implementacja
    for n = 1:Nx + Ny2 - 1
        if n <= Nx
            Rxy(n) = sum(x(1:n) .* y2(Ny2-n+1:Ny2));
        else
            
            Rxy(n) = sum(x(n-Nx+1:Nx) .* y2(1:Ny2+Ny2-n));
    end
end
