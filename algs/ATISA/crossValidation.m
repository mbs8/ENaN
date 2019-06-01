BASE = ['magic04.data'];

[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, classe] = textread(BASE, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%c');

base = [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, double(classe)];

contador_classe_g = 0;
contador_classe_h = 0;

base_g = [];
base_h = [];

for i = 1:size(classe,1)
    if base(i, 11) == 'g'
        base_g = [base_g; base(i, :)];
        contador_classe_g = contador_classe_g + 1;
    else
        base_h = [base_h; base(i, :)];
        contador_classe_h = contador_classe_h + 1;
    end
end
        
base_g = shuffle (base_g, 1);
base_g = shuffle (base_g, 1);
base_g = shuffle (base_g, 1);
base_g = shuffle (base_g, 1);


base_h = shuffle (base_h, 1);
base_h = shuffle (base_h, 1);
base_h = shuffle (base_h, 1);
base_h = shuffle (base_h, 1);

passo_g = floor(contador_classe_g/5);
fold1_g = base_g(1:passo_g, :);
fold2_g = base_g(passo_g+1:2*passo_g,:);
fold3_g = base_g(2*passo_g+1:3*passo_g,:);
fold4_g = base_g(3*passo_g+1:4*passo_g,:);
fold5_g = base_g(4*passo_g+1:contador_classe_g,:);

passo_h = floor(contador_classe_h/5);
fold1_h = base_h(1:passo_h, :);
fold2_h = base_h(passo_h+1:2*passo_h,:);
fold3_h = base_h(2*passo_h+1:3*passo_h,:);
fold4_h = base_h(3*passo_h+1:4*passo_h,:);
fold5_h = base_h(4*passo_h+1:contador_classe_h,:);


folds = {};

folds{1} = [fold1_g; fold1_h];
folds{2} = [fold2_g; fold2_h];
folds{3} = [fold3_g; fold3_h];
folds{4} = [fold4_g; fold4_h];
folds{5} = [fold5_g; fold5_h];



for i = 1:5
    fold = ['fold', num2str(i), '.data'];
    
    file = fopen (fold, 'w');
    
    base = folds{i};
    
    base = shuffle (base, 1);
    base = shuffle (base, 1);
    base = shuffle (base, 1);
    base = shuffle (base, 1);
    
    
    
    
    
    for z = 1:size(base, 1)    
 
        
        fprintf (file, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d\n', base(z, 1),base(z, 2),base(z, 3), base(z, 4), base(z, 5), base(z, 6), base(z, 7), base(z, 8), base(z, 9), base(z, 10), base(z, 11));
    end
    
    fclose(file);

end

i=0;